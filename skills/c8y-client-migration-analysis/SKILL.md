# Skill: @c8y/client Migration Analysis Methodology

## Purpose

This skill describes the **correct, step-by-step process** for auditing a Cumulocity Angular codebase when preparing a Web SDK version upgrade. Following this order avoids incorrect assumptions, wasted searches, and inaccurate effort estimates.

---

## Step 1 — Read the Breaking Changelogs First

**Always start here before touching any source code.**

Read both skill files in full before analyzing the codebase:

1. `skills/c8y-client-breaking-changelog/SKILL.md` — REST API behavioural changes (e.g. default parameter changes, removed fields, enforced constraints)
2. `skills/websdk-breaking-changelog/SKILL.md` — Web SDK / `@c8y/ngx-components` breaking changes (renamed imports, removed modules, Angular version changes)
3. The specific upgrade skill for the target version (e.g. `skills/websdk-1023-upgrade/SKILL.md`)

> **Why first?** Default values, endpoint behaviour, and response shapes change between versions. If you read the source code before knowing the changelog, you will misread what the current code *intends* vs what it *produces*. For example: `MeasurementService.list({ pageSize: 1 })` without `revert` returns the **oldest** measurement in SDK 1021 but the **newest** in SDK 1023 — the code looks identical in both cases but behaves differently. Reading the changelog first prevents misdiagnosing this as a bug that needs a fix when it is actually a fix the upgrade itself delivers.

---

## Step 2 — Build the Service Import Map

Find every file in the codebase that imports a `@c8y/client` service class. **Do not search for method call strings** (e.g. `inventoryService.list`) — this is fragile and misses aliased instances. Instead, search for import statements.

### Pattern to use

Run separate searches for each service class name in import statements:

```
query: "from '@c8y/client'"  (broad — then filter by what is destructured)
```

Or search per service:

```
InventoryService|InventoryBinaryService|MeasurementService|OperationService|AlarmService|EventService|UserService|UserGroupService|ApplicationService|IdentityService|TenantService|TenantOptionsService|FetchClient
```

Restrict to `src/**/*.ts` (exclude `node_modules`).

### Record

For each service, note **every file** that imports it. This is your audit scope. Mark files where the service is injected in the constructor vs only type-imported — only constructor injections lead to actual HTTP calls.

---

## Step 3 — Read Each Import Site and Catalogue Method Calls

For each file in the import map, **read the source** and record:

| Column | What to capture |
|--------|----------------|
| **Method** | The exact method called (e.g. `list`, `detail`, `create`, `update`, `delete`) |
| **Filter/params** | The exact filter object or arguments passed |
| **REST endpoint** | Derived from `skills/c8y-client-api/SKILL.md` |
| **Downstream usage** | What properties of the response are accessed — critical for determining whether a default-change breaking change actually bites |

> **Key check at this step:** For every `InventoryService.list()` and `InventoryService.detail()` call, note whether `childDevices`, `childAssets`, or `childAdditions` are accessed on the result. Only those calls need `withChildren: true` explicitly after the Sept 2025 breaking change.

### Distinguish dead imports

If a service is injected but no methods are called in a file (common after refactoring), mark it as a **dead import** — it is a cleanup item, not a migration risk.

---

## Step 4 — Cross-Check Every Changelog Entry Against Your Findings

Go through each breaking change entry from Step 1 and ask:

1. **Does this codebase use the affected service/method?** (from the import map in Step 2)
2. **Are the specific parameters or response fields mentioned in the breaking change present?** (from the method catalogue in Step 3)
3. **What is the pre-upgrade behaviour, and what is the post-upgrade behaviour?** (read both from the changelog — do not assume)

> **Common mistake:** Assuming the pre-upgrade default is the "correct" or "intended" behaviour. Always verify by reading the changelog entry carefully. A code pattern that looks buggy under the old default may be intentionally auto-fixed by the new default, or vice versa.

For each entry, one of four outcomes applies:

| Outcome | Meaning |
|---------|---------|
| **Not applicable** | The service/method is not imported in this codebase at all |
| **✅ OK** | Method is used, but the specific change (field, param, default) doesn't affect the actual call or downstream usage |
| **⚠️ INFO** | Method is used and behaviour changes, but the change is benign or auto-beneficial — document it, no code fix required |
| **🔴 Action required** | Method is used, behaviour changes, and existing code will break or silently regress — estimate and schedule a fix |

---

## Step 5 — Verify "✅ OK" Calls Explicitly

Do not mark a call as ✅ OK without stating *why*. Common reasons:

- `detail()` call is ✅ OK for `withChildren` change → because the code only accesses non-child fragments on the result (`c8y_Firmware`, `c8y_IsBinary`, etc.)
- `list()` call is ✅ OK for `text` restriction → because the filter uses `fragmentType`/`type`/`query`, not `text`
- Wildcard query is ✅ OK for case-insensitivity change → because all object names and the query string use consistent casing

Always name the specific rationale, so it can be reviewed later.

---

## Step 6 — Write the Audit Output

Structure the findings as:

1. **Service Import Map** — table of service → files
2. **Per-service call tables** — one table per service, columns: File | Method | Filter/Params | REST Endpoint | Issues
3. **Breaking Change Coverage Matrix** — one row per changelog entry, verdict for this codebase
4. **Issues Summary** — actionable items with priority and three-point effort estimates (O/M/P)

### Three-point estimate formula

`Expected = (O + 4M + P) / 6` where O = optimistic, M = most likely, P = pessimistic (all in hours).

---

## Common Pitfalls to Avoid

| Pitfall | Correct approach |
|---------|-----------------|
| Searching for `inventoryService.list(` to find call sites | Search for `import ... InventoryService` instead — then read the files |
| Assuming a default value is stable across versions | Read the breaking changelog entry; defaults *do* change |
| Marking `detail()` calls as needing `withChildren:true` across the board | Only add `withChildren:true` if child refs (`childDevices`, `childAssets`, `childAdditions`) are accessed downstream |
| Treating a pre-existing bug as something the upgrade breaks | Distinguish: (a) code is currently broken and upgrade fixes it, (b) code works currently and upgrade breaks it |
| Claiming a breaking change has no impact without searching | Always search for the affected service/property name before concluding "not applicable" |
| Writing the audit before reading all changelog entries | Read changelog first (Step 1), then audit — never in parallel |
