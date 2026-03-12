# Skill: @c8y/client API Usage

## Overview

`@c8y/client` is the TypeScript SDK that wraps the **Cumulocity IoT REST API** (https://cumulocity.com/api/core/2025/). Every service class in the library corresponds to one API domain (inventory, alarms, events, measurements, …). The library handles authentication, base URL resolution, response parsing, and pagination — you never construct raw HTTP calls yourself.

The declaration files are at:
```
node_modules/@c8y/client/lib/src/
  alarm/
  event/
  inventory/
  measurement/
  operation/
  core/          ← shared types: IResult, IResultList, QueriesUtil, …
```

---

## `detail` vs `list` — the two read patterns

### `detail(id, filter?)`
Fetches **one** specific resource by its ID.  
Maps to a `GET /<resource>/{id}` endpoint.  
Returns `Promise<IResult<T>>` — destructure as `{ data, res }`.

```typescript
// GET /inventory/managedObjects/12345
const { data } = await inventoryService.detail(12345);

// GET /alarm/alarms/99
const { data } = await alarmService.detail(99);
```

### `list(filter?)`
Fetches a **collection** of resources, optionally filtered.  
Maps to `GET /<resource>/{collectionEndpoint}`.  
Returns `Promise<IResultList<T>>` — destructure as `{ data, res, paging }`.

```typescript
// GET /alarm/alarms?status=ACTIVE&source=12345&pageSize=100
const { data, paging } = await alarmService.list({
  status: 'ACTIVE',
  source: 12345,
  pageSize: 100,
});
```

The `paging` object lets you navigate pages:

```typescript
const nextPage = await paging?.next?.();
```

---

## Filter interfaces — typed query params

Every `list()` call accepts a plain object whose keys are the **exact query parameters** documented in the OpenAPI spec for that endpoint. The library provides typed `I*Filter` interfaces so editors autocomplete valid parameters and reject typos.

### Where to find them

```
node_modules/@c8y/client/lib/src/
  alarm/IAlarm.d.ts            → AlarmQueryFilter
  measurement/IMeasurementFilter.d.ts → IMeasurementFilter
  event/EventService.d.ts      → (inline filter type)
  inventory/InventoryService.d.ts → (generic object, extended by query variants)
```

### Example — `IMeasurementFilter`

```typescript
export interface IMeasurementFilter {
  currentPage?: number;
  source?: number | string;      // maps to ?source=<id>
  dateFrom?: string | Date;      // maps to ?dateFrom=<ISO>
  dateTo?: string | Date;        // maps to ?dateTo=<ISO>
  pageSize?: number;             // maps to ?pageSize=<n>
  revert?: boolean;              // maps to ?revert=true (newest first)
  type?: string;                 // maps to ?type=<type>
  valueFragmentSeries?: string;
  valueFragmentType?: string;
  withTotalPages?: boolean;
  withTotalElements?: boolean;
}
```

Usage:

```typescript
import { MeasurementService } from '@c8y/client';

const filter: IMeasurementFilter = {
  source: deviceId,
  dateFrom: '2025-01-01T00:00:00Z',
  dateTo: '2025-12-31T23:59:59Z',
  type: 'c8y_TemperatureMeasurement',
  pageSize: 200,
  withTotalPages: true,
};

const { data } = await measurementService.list(filter);
```

### Example — `AlarmQueryFilter`

```typescript
export interface AlarmQueryFilter {
  pageSize?: number;
  source?: string | number;
  status?: string;       // 'ACTIVE' | 'ACKNOWLEDGED' | 'CLEARED'
  severity?: string;     // 'CRITICAL' | 'MAJOR' | 'MINOR' | 'WARNING'
  type?: string;
  withSourceAssets?: boolean;
  withSourceDevices?: boolean;
  withTotalPages?: boolean;
  [key: string]: any;    // additional params supported
}
```

---

## Inventory `query` param and `QueriesUtil`

The inventory (managed objects) API supports a powerful OData-style `$filter`/`$orderby` query language documented at:  
https://cumulocity.com/api/core/2025/#tag/Query-language

The plain `list()` only allows simple equality matches on fixed fields (e.g., `type`, `owner`). For advanced filtering — wildcard names, AND/OR logic, checking fragment presence, comparing nested values — use **`listQuery()`** (or **`listQueryDevices()`** for the `/managedObjects?q=` variant).

### `InventoryService.listQuery(query, filter?)`

`query` is a structured object that `QueriesUtil.buildQuery()` compiles into the `q=` (or `query=`) parameter string. `filter` is the same paging/pagination object as `list()`.

```typescript
const { data } = await inventoryService.listQuery(
  {
    __filter: {
      'name': 'MyDevice*',                    // wildcard match
      'c8y_IsDevice': { __has: '' },          // fragment must exist
      'c8y_Availability.status': {
        __in: ['AVAILABLE', 'UNAVAILABLE'],   // one of several values
      },
    },
    __orderby: [{ name: 1 }],                // ascending by name
  },
  { pageSize: 50, withTotalPages: true },
);
```

### `QueriesUtil` — the query builder

Located at `node_modules/@c8y/client/lib/src/core/QueriesUtil.d.ts`.  
`InventoryService` exposes it as `inventoryService.queriesUtil`.

Key method: `buildQuery(query)` → returns the ready-to-send query string.

```typescript
const qs = inventoryService.queriesUtil.buildQuery({
  'c8y_IsDevice': { __has: '' },
  'name': 'Pump*',
});
// → "$filter=(has(c8y_IsDevice) and name eq 'Pump*')"
```

### Supported operators

| Operator | Description | Example |
|---|---|---|
| `__has` | Fragment must exist | `{ __has: 'c8y_IsDevice' }` |
| `__hasany` | At least one fragment exists | `{ __hasany: ['c8y_IsDevice', 'c8y_Dashboard'] }` |
| `__eq` | Equality (also plain string value) | `{ 'status': 'AVAILABLE' }` or `{ __eq: { status: 'AVAILABLE' } }` |
| `__lt` / `__gt` | Less than / greater than | `{ 'count': { __lt: 10 } }` |
| `__le` / `__ge` | Less-or-equal / greater-or-equal | `{ 'count': { __ge: 1 } }` |
| `__in` | Value in list | `{ 'status': { __in: ['ACTIVE', 'CLEARED'] } }` |
| `__and` | Logical AND of sub-conditions | `{ __and: [{ __has: 'c8y_IsDevice' }, { 'count': { __gt: 0 } }] }` |
| `__or` | Logical OR of sub-conditions | `{ __or: [{ __bygroupid: 100 }, { __bygroupid: 200 }] }` |
| `__not` | Negate condition | `{ __not: { 'status': 'CLEARED' } }` |
| `__bygroupid` | Object assigned to given group | `{ __bygroupid: 10300 }` |
| `__isinhierarchyof` | Object in hierarchy of MO | `{ __isinhierarchyof: '12345' }` |
| `__useFilterQueryString` | Pass raw OData filter string through | `{ __useFilterQueryString: "name eq 'RaspPi*'" }` |

### Ordering results

Ordering requires wrapping filters in `__filter` and providing `__orderby`:

```typescript
const query = {
  __filter: {
    __has: 'c8y_IsDevice',
    'c8y_Availability.status': 'AVAILABLE',
  },
  __orderby: [
    { name: 1 },            // 1 = ascending
    { creationTime: -1 },   // -1 = descending
  ],
};
```

### Helper methods on `QueriesUtil`

```typescript
// Merge additional AND conditions into an existing query
const extended = inventoryService.queriesUtil.addAndFilter(query, {
  'c8y_IsDevice': { __has: '' },
});

// Merge additional OR conditions
const extended = inventoryService.queriesUtil.addOrFilter(query, {
  __bygroupid: 999,
});

// Prepend / append sort fields
const sorted = inventoryService.queriesUtil.prependOrderbys(query, [{ name: -1 }]);
```

---

## Return types at a glance

| Method | Return type | Destructure |
|---|---|---|
| `detail(id)` | `Promise<IResult<T>>` | `const { data, res } = await …` |
| `list(filter?)` | `Promise<IResultList<T>>` | `const { data, res, paging } = await …` |
| `listQuery(query, filter?)` | `Promise<IResultList<T>>` | `const { data, res, paging } = await …` |
| `create(entity)` | `Promise<IResult<T>>` | `const { data, res } = await …` |
| `update(entity)` | `Promise<IResult<T>>` | `const { data, res } = await …` |
| `delete(id)` | `Promise<IResult<T>>` | `const { res } = await …` |

`IResult<T>` → `data` is the single object, `res` is the raw `IFetchResponse`.  
`IResultList<T>` → `data` is an array, `paging` lets you call `.next()` / `.previous()`.

---

## Quick reference: service → API domain

| Service class | API path | Docs tag |
|---|---|---|
| `InventoryService` | `/inventory/managedObjects` | Inventory API |
| `AlarmService` | `/alarm/alarms` | Alarm API |
| `EventService` | `/event/events` | Event API |
| `MeasurementService` | `/measurement/measurements` | Measurement API |
| `OperationService` | `/devicecontrol/operations` | Device control API |
| `AuditService` | `/audit/auditRecords` | Audit API |
| `UserService` | `/user/{tenant}/users` | User API |

Full API reference: https://cumulocity.com/api/core/2025/

---

## Complete method → endpoint mapping

### `AlarmService`

| Method | HTTP | Endpoint |
|---|---|---|
| `detail(id)` | `GET` | `/alarm/alarms/{id}` |
| `create(entity)` | `POST` | `/alarm/alarms` |
| `update(entity)` | `PUT` | `/alarm/alarms/{id}` |
| `updateBulk(entity, filters)` | `PUT` | `/alarm/alarms` (bulk update via query params) |
| `list(filter?)` | `GET` | `/alarm/alarms` |
| `count(filter?)` | `GET` | `/alarm/alarms` (with `withTotalElements=true`) |

---

### `EventService`

| Method | HTTP | Endpoint |
|---|---|---|
| `detail(id)` | `GET` | `/event/events/{id}` |
| `create(entity)` | `POST` | `/event/events` |
| `update(entity)` | `PUT` | `/event/events/{id}` |
| `list(filter?)` | `GET` | `/event/events` |
| `delete(id)` | `DELETE` | `/event/events/{id}` |

### `EventBinaryService`

| Method | HTTP | Endpoint |
|---|---|---|
| `upload(file, eventId)` | `POST` | `/event/events/{id}/binaries` |
| `download(eventId)` | `GET` | `/event/events/{id}/binaries` |
| `delete(eventId)` | `DELETE` | `/event/events/{id}/binaries` |

---

### `InventoryService`

| Method | HTTP | Endpoint |
|---|---|---|
| `detail(id, filter?)` | `GET` | `/inventory/managedObjects/{id}` |
| `create(mo)` | `POST` | `/inventory/managedObjects` |
| `update(mo)` | `PUT` | `/inventory/managedObjects/{id}` |
| `delete(id, params?)` | `DELETE` | `/inventory/managedObjects/{id}` |
| `list(filter?)` | `GET` | `/inventory/managedObjects` |
| `count(filter?)` | `GET` | `/inventory/managedObjects` (with `withTotalElements=true`) |
| `listQuery(query, filter?)` | `GET` | `/inventory/managedObjects?query=…` |
| `listQueryDevices(query, filter?)` | `GET` | `/inventory/managedObjects?q=…` |
| `getSupportedMeasurements(id)` | `GET` | `/inventory/managedObjects/{id}/supportedMeasurements` |
| `getSupportedSeries(id)` | `GET` | `/inventory/managedObjects/{id}/supportedSeries` |
| `getMeasurementsAndSeries(id)` | `GET` | `/inventory/managedObjects/{id}/supportedMeasurements` + `/supportedSeries` |
| `childAdditionsList(parentId, filter?)` | `GET` | `/inventory/managedObjects/{id}/childAdditions` |
| `childAdditionsCreate(mo, parentId)` | `POST` | `/inventory/managedObjects/{id}/childAdditions` (creates new MO and adds as child) |
| `childAdditionsAdd(childId, parentId)` | `POST` | `/inventory/managedObjects/{id}/childAdditions` (adds existing MO by reference) |
| `childAdditionsBulkAdd(childIds[], parentId)` | `POST` | `/inventory/managedObjects/{id}/childAdditions` (multiple references) |
| `childAdditionsRemove(childId, parentId)` | `DELETE` | `/inventory/managedObjects/{id}/childAdditions/{childId}` |
| `childAssetsList(parentId, filter?)` | `GET` | `/inventory/managedObjects/{id}/childAssets` |
| `childAssetsCreate(mo, parentId)` | `POST` | `/inventory/managedObjects/{id}/childAssets` (creates new MO) |
| `childAssetsAdd(childId, parentId)` | `POST` | `/inventory/managedObjects/{id}/childAssets` (adds existing MO) |
| `childAssetsBulkAdd(childIds[], parentId)` | `POST` | `/inventory/managedObjects/{id}/childAssets` (multiple references) |
| `childAssetsRemove(childId, parentId)` | `DELETE` | `/inventory/managedObjects/{id}/childAssets/{childId}` |
| `childDevicesList(parentId, filter?)` | `GET` | `/inventory/managedObjects/{id}/childDevices` |
| `childDevicesCreate(mo, parentId)` | `POST` | `/inventory/managedObjects/{id}/childDevices` (creates new MO) |
| `childDevicesAdd(childId, parentId)` | `POST` | `/inventory/managedObjects/{id}/childDevices` (adds existing MO) |
| `childDevicesBulkAdd(childIds[], parentId)` | `POST` | `/inventory/managedObjects/{id}/childDevices` (multiple references) |
| `childDevicesRemove(childId, parentId)` | `DELETE` | `/inventory/managedObjects/{id}/childDevices/{childId}` |
| `assetKPIsList(parentId, filter?)` | `GET` | `/inventory/managedObjects/{id}/childAssets` (with KPI-specific filter) |

### `InventoryBinaryService`

| Method | HTTP | Endpoint |
|---|---|---|
| `create(file, mo?)` | `POST` | `/inventory/binaries` |
| `list(filter?)` | `GET` | `/inventory/binaries` |
| `delete(id)` | `DELETE` | `/inventory/binaries/{id}` |
| `download(id, init?)` | `GET` | `/inventory/binaries/{id}` (streams binary content) |
| `createWithProgress(file, onProgress, mo?)` | `POST` | `/inventory/binaries` (via `XMLHttpRequest` for progress events) |

---

### `MeasurementService`

| Method | HTTP | Endpoint |
|---|---|---|
| `detail(id)` | `GET` | `/measurement/measurements/{id}` ⚠️ deprecated since 10.16 |
| `create(entity)` | `POST` | `/measurement/measurements` |
| `list(filter?)` | `GET` | `/measurement/measurements` |
| `delete(id)` | `DELETE` | `/measurement/measurements/{id}` |
| `listSeries(params)` | `GET` | `/measurement/measurements/series` |
| `getMeasurementsFile(params, headers)` | `GET` | `/measurement/measurements` (with `Accept: text/csv` or `application/vnd.ms-excel`) |

---

### `OperationService`

| Method | HTTP | Endpoint |
|---|---|---|
| `detail(id)` | `GET` | `/devicecontrol/operations/{id}` |
| `create(entity)` | `POST` | `/devicecontrol/operations` |
| `update(entity)` | `PUT` | `/devicecontrol/operations/{id}` |
| `list(filter?)` | `GET` | `/devicecontrol/operations` |

### `OperationBulkService`

| Method | HTTP | Endpoint |
|---|---|---|
| `detail(id)` | `GET` | `/devicecontrol/bulkoperations/{id}` |
| `create(op)` | `POST` | `/devicecontrol/bulkoperations` |
| `update(entity)` | `PUT` | `/devicecontrol/bulkoperations/{id}` |
| `list(filter?)` | `GET` | `/devicecontrol/bulkoperations` |
| `delete(id)` | `DELETE` | `/devicecontrol/bulkoperations/{id}` |

---

### `AuditService`

| Method | HTTP | Endpoint |
|---|---|---|
| `detail(id)` | `GET` | `/audit/auditRecords/{id}` |
| `create(entity)` | `POST` | `/audit/auditRecords` |
| `list(filter?)` | `GET` | `/audit/auditRecords` |

---

### `UserService`

| Method | HTTP | Endpoint |
|---|---|---|
| `detail(id, params?)` | `GET` | `/user/{tenant}/users/{userId}` |
| `create(entity)` | `POST` | `/user/{tenant}/users` |
| `update(entity)` | `PUT` | `/user/{tenant}/users/{userId}` |
| `list(filter?)` | `GET` | `/user/{tenant}/users` |
| `delete(id)` | `DELETE` | `/user/{tenant}/users/{userId}` |
| `current()` | `GET` | `/user/currentUser` |
| `currentWithEffectiveRoles()` | `GET` | `/user/currentUser` (expanded effective roles) |
| `updateCurrent(user)` | `PUT` | `/user/currentUser` |
| `sendPasswordResetMail(email)` | `POST` | `/user/passwordReset` |
| `resetPassword(newPassword)` | `PUT` | `/user/{tenant}/users/{userId}/password` |
| `changeCurrentUserPassword(newPw, curPw)` | `PUT` | `/user/currentUser/password` |
| `revokeTokens()` | `POST` | `/user/logout?revokeTokens=true` |
| `getActivityTotp()` | `GET` | `/user/currentUser/totpSecret/activity` |
| `generateTotpSecret()` | `POST` | `/user/currentUser/totpSecret` |
| `verifyTotpCode(code)` | `POST` | `/user/currentUser/totpSecret/verify` |
| `totpRevokeSecret(user)` | `DELETE` | `/user/{tenant}/users/{userId}/totpSecret` |
| `inventoryAssignment(userId)` | — | Returns `UserInventoryRoleService` scoped to that user |

### `UserInventoryRoleService` (accessed via `userService.inventoryAssignment(userId)`)

| Method | HTTP | Endpoint |
|---|---|---|
| `detail(id)` | `GET` | `/user/{tenant}/users/{userId}/roles/inventory/{id}` |
| `create(entity)` | `POST` | `/user/{tenant}/users/{userId}/roles/inventory` |
| `update(entity)` | `PUT` | `/user/{tenant}/users/{userId}/roles/inventory/{id}` |
| `list(filter?)` | `GET` | `/user/{tenant}/users/{userId}/roles/inventory` |
| `delete(id)` | `DELETE` | `/user/{tenant}/users/{userId}/roles/inventory/{id}` |

---

### `UserGroupService`

| Method | HTTP | Endpoint |
|---|---|---|
| `detail(id)` | `GET` | `/user/{tenant}/groups/{id}` |
| `create(entity)` | `POST` | `/user/{tenant}/groups` |
| `update(entity)` | `PUT` | `/user/{tenant}/groups/{id}` |
| `list(filter?)` | `GET` | `/user/{tenant}/groups` |
| `delete(id)` | `DELETE` | `/user/{tenant}/groups/{id}` |
| `addRoleToGroup(groupId, roleRef)` | `POST` | `/user/{tenant}/groups/{id}/roles` |
| `removeRoleFromGroup(groupId, roleRef)` | `DELETE` | `/user/{tenant}/groups/{id}/roles/{roleId}` |
| `addUserToGroup(groupId, userRef)` | `POST` | `/user/{tenant}/groups/{id}/users` |
| `removeUserFromGroup(groupId, userRef)` | `DELETE` | `/user/{tenant}/groups/{id}/users/{userId}` |

### `UserRoleService`

| Method | HTTP | Endpoint |
|---|---|---|
| `detail(id)` | `GET` | `/user/roles/{id}` |
| `list(filter?)` | `GET` | `/user/roles` |

---

### `TenantService`

| Method | HTTP | Endpoint |
|---|---|---|
| `detail(id)` | `GET` | `/tenant/tenants/{id}` |
| `create(entity)` | `POST` | `/tenant/tenants` |
| `update(entity)` | `PUT` | `/tenant/tenants/{id}` |
| `list(filter?)` | `GET` | `/tenant/tenants` |
| `delete(id)` | `DELETE` | `/tenant/tenants/{id}` |
| `current(filter?)` | `GET` | `/tenant/currentTenant` |
| `enableSupportUser()` | `POST` | `/tenant/currentTenant/supportUser/enable` |
| `disableSupportUser()` | `DELETE` | `/tenant/currentTenant/supportUser` |
| `subscribeApplication(tenant, app)` | `POST` | `/tenant/tenants/{id}/applications` |
| `unsubscribeApplication(tenant, app)` | `DELETE` | `/tenant/tenants/{id}/applications/{appId}` |
| `getTfaSettings(tenant)` | `GET` | `/tenant/tenants/{id}/tfa` |
| `updateTfaStrategy(tenant, strategy)` | `PUT` | `/tenant/tenants/{id}/tfa` |

---

### `TenantOptionsService`

| Method | HTTP | Endpoint |
|---|---|---|
| `detail(entity, params?)` | `GET` | `/tenant/options/{category}/{key}` |
| `create(entity)` | `POST` | `/tenant/options` |
| `update(entity)` | `PUT` | `/tenant/options/{category}/{key}` |
| `list(filter?)` | `GET` | `/tenant/options` |
| `delete(id)` | `DELETE` | `/tenant/options/{category}/{key}` |

### `SystemOptionsService`

| Method | HTTP | Endpoint |
|---|---|---|
| `detail(option)` | `GET` | `/tenant/system/options/{category}/{key}` |
| `list(filter?)` | `GET` | `/tenant/system/options` |

---

### `IdentityService`

| Method | HTTP | Endpoint |
|---|---|---|
| `list(managedObjectId)` | `GET` | `/identity/globalIds/{id}/externalIds` |
| `detail(identity)` | `GET` | `/identity/externalIds/{type}/{externalId}` |
| `create(identity)` | `POST` | `/identity/globalIds/{id}/externalIds` |
| `delete(identity)` | `DELETE` | `/identity/externalIds/{type}/{externalId}` |

---

### `DeviceRegistrationService`

| Method | HTTP | Endpoint |
|---|---|---|
| `detail(id)` | `GET` | `/devicecontrol/newDeviceRequests/{requestId}` |
| `create(entity)` | `POST` | `/devicecontrol/newDeviceRequests` |
| `list(filter?)` | `GET` | `/devicecontrol/newDeviceRequests` |
| `delete(id)` | `DELETE` | `/devicecontrol/newDeviceRequests/{requestId}` |
| `accept(id, securityToken?)` | `PUT` | `/devicecontrol/newDeviceRequests/{requestId}` (status → ACCEPTED) |
| `acceptAll()` | `PUT` | `/devicecontrol/newDeviceRequests` (bulk accept) |
| `limit()` | `GET` | `/devicecontrol/deviceCredentials/limit` |
| `bootstrap(id, options, securityToken?)` | `POST` | `/devicecontrol/deviceCredentials` |

### `DeviceRegistrationBulkService`

| Method | HTTP | Endpoint |
|---|---|---|
| `create(csvFile)` | `POST` | `/devicecontrol/bulkNewDeviceRequests` (multipart CSV upload) |

---

### `SmartRulesService`

| Method | HTTP | Endpoint |
|---|---|---|
| `isMicroserviceAvailable()` | `GET` | `/service/smartrules/health` (availability check) |
| `listByContext(entityOrId)` | `GET` | `/service/smartrules/smartrules?deviceId={id}` |
| `update(rule)` | `PUT` | `/service/smartrules/smartrules/{id}` |
| `bulkDeactivateEnabledSources(rule, ids[])` | `PUT` | `/service/smartrules/smartrules/{id}` (bulk enabledSources patch) |