# Skill: REST API Breaking Changes (API CHANGE log)

## Overview

Source: https://cumulocity.com/docs/change-logs/?component=.component-rest-api  
Only entries tagged **API CHANGE** are listed — these are breaking or behaviour-altering changes. Entries are newest-first.

---

### `history` field removed from the Alarm API
**Date:** December 4, 2025

The deprecated `history` field has been permanently removed from the Alarm API.  
It previously always returned an empty list and is no longer included in any response.

**Affected client methods:**
- `AlarmService.detail(id)` → `IAlarm.history` property no longer present in response
- `AlarmService.list(filter?)` → same

**Action required:** Remove any code that reads `alarm.history`. The field is now available as a custom fragment if needed.

---

### Enhanced security for encrypted tenant options (enforced default)
**Date:** October 30, 2025 (enabled by default; first announced April 3, 2025)

The `secure-tenant-options` feature is now **enabled by default** for all tenants. Encrypted tenant options with the `credentials.` prefix can only be decrypted by system/microservice users that **own** the option category (determined by `settingsCategory` in the manifest, then context path, then microservice name). Non-owning callers receive `<<Encrypted>>` as the value.

**Affected client methods:**
- `TenantOptionsService.detail({ category, key })` → may return `<<Encrypted>>` if the caller does not own the category
- `TenantOptionsService.list(filter?)` → same

**Action required:** Ensure microservices only read `credentials.*` options in categories they own (matching their `settingsCategory` or context path).

---

### Inventory API — `withChildren` default changed from `true` to `false`
**Date:** September 18, 2025

`GET /inventory/managedObjects` and `GET /inventory/managedObjects/{id}` no longer include child references (`childAssets`, `childDevices`, `childAdditions`) in the response by default. Controlled by feature toggle `core.inventory.without.children` (enabled for all tenants).

**Affected client methods:**
- `InventoryService.list(filter?)` → pass `{ withChildren: true }` to restore previous behaviour
- `InventoryService.detail(id, filter?)` → pass `{ withChildren: true }` to restore previous behaviour
- `InventoryService.listQuery(query, filter?)` → same second argument
- `InventoryService.listQueryDevices(query, filter?)` → same

**Action required:** Audit all `inventoryService.list()` and `inventoryService.detail()` call sites. Add `withChildren: true` explicitly where child references are needed.

---

### Inventory API — `withParents=true` now returns all ancestors (not just 3 levels)
**Date:** September 11, 2025

Using `withParents=true` now returns basic information (ID, type, name) for **all** ancestor managed objects up the hierarchy, not just the previous 3-level limit. Inventory roles are not considered when collecting ancestor info.

**Affected client methods:**
- `InventoryService.detail(id, { withParents: true })` → response shape expanded
- `InventoryService.list({ withParents: true })` → same

**Action required:** If code assumed a maximum depth of 3 for parent arrays, update accordingly. No action needed if the depth was unbounded.

---

### Measurement API — default sort order for time series changed (`revert` default → `true`)
**Date:** September 4, 2025

For **time series** measurements (not legacy), the default value of the `revert` parameter has changed from `false` to `true`. Results are now **newest-first** by default.  
Legacy measurement persistence is **not** affected (still oldest-first by default).

**Affected client methods:**
- `MeasurementService.list(filter?)` → time series results now come newest-first unless `revert: false` is explicitly set
- `MeasurementService.listSeries(params)` → same

**Action required:** Add `revert: false` to `IMeasurementFilter` wherever ascending (oldest-first) order is required for time series data.

---

### Inventory API — `c8y_PreviousMeasurements` is now a restricted property
**Date:** July 3, 2025

The `c8y_PreviousMeasurements` fragment is now reserved for internal platform use. Any request body that includes this fragment will have it **silently ignored** — it will not be saved.

**Affected client methods:**
- `InventoryService.create(mo)` → `c8y_PreviousMeasurements` in the body will be ignored
- `InventoryService.update(mo)` → same

**Action required:** Remove `c8y_PreviousMeasurements` from any managed object create/update payloads.

---

### Inventory search with wildcards becomes case-insensitive
**Date:** June 26, 2025

Query language wildcard searches (e.g. `name eq 'my-device*'`) are now **case-insensitive**. Exact-match queries (no wildcard) remain case-sensitive for performance.

**Affected client methods:**
- `InventoryService.listQuery(query, filter?)` — any query using `*` wildcards on string fields
- `InventoryService.listQueryDevices(query, filter?)` — same
- Any raw `query=` parameter passed to `InventoryService.list()` with wildcard values

**Action required:** If code relied on case-sensitive wildcard filtering, results may now include unexpected additional objects. Review queries and add explicit casing constraints if needed.

---

### Notifications 2.0 — wildcard API subscriptions now include operations
**Date:** January 30, 2025 (effective; announced December 6, 2023)

Tenant context subscriptions using the wildcard API selector (`"apis": ["*"]` or omitting the field) now also deliver `operations` updates in addition to alarms, events, and measurements.

**Affected client methods:**
- Not a direct `@c8y/client` service method, but any Realtime/Notifications 2.0 integration using `Client` or a custom fetch to `POST /notification2/subscriptions` with a wildcard selector.

**Action required:** Ensure subscribers handle operation update payloads or switch from the wildcard to an explicit list of APIs.

---

### Bulk DELETE now requires at least one filter parameter (Alarms, Events, Measurements)
**Date:** December 6, 2023 (enforced)

Bulk delete operations without at least one limiting parameter now fail. Minimum required parameters:
- `DELETE /alarm/alarms` → requires one of: `source`, `dateFrom`, `dateTo`, `createdFrom`, `createdTo`
- `DELETE /event/events` → requires one of: `source`, `dateFrom`, `dateTo`, `createdFrom`, `createdTo`
- `DELETE /measurement/measurements` → requires one of: `source`, `dateFrom`, `dateTo`

**Affected client methods:** Any custom delete calls made via `FetchClient` or lower-level HTTP wrappers targeting these endpoints without filter params. The typed service classes (`AlarmService`, `EventService`, `MeasurementService`) do not expose a bulk-delete method in the SDK, so this primarily affects raw API consumers.

**Action required:** Ensure all bulk delete calls include at least one scope-limiting parameter.

---

### Planned: Inventory `text` search restricted to id/name/type/owner/externalId
**Date:** Announced December 6, 2023 (exact enforcement date TBD, at least 3 months after announcement)

The `text` query parameter on `GET /inventory/managedObjects` will only search within `id`, `name`, `type`, `owner`, and `external id`. Currently it searches all properties.

**Affected client methods:**
- `InventoryService.list({ text: '...' })` → results will be narrower once enforced

**Action required:** If text search is used to locate objects by custom fragment values, migrate to `listQuery()` with explicit field predicates instead.
