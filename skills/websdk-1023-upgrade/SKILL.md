---
name: websdk-1023-upgrade
description: Step-by-step guide for migrating a Cumulocity Web SDK project from 1022 to 1023 (Angular 20). Covers Angular 20 ng update, @c8y dependency updates, ngx-bootstrap and CDK upgrades, TypeScript 5.9.3 requirement, and breaking changes including global time context API redesign, scoped TranslateService per plugin, QueriesUtil type additions, and removal of BulkSingleOperationsListModule.
---

# Migrate from Web SDK 1022 to Web SDK 1023 (Angular 20)

Angular 20 support is introduced from **Web SDK version 1023.0.0**.

---

## When to Use This Skill

Use this skill when the project:

- Uses Web SDK packages (`@c8y/*`) at version `1022.x`.
- Builds with `@angular/cli` (`ng`).
- Needs to upgrade to Angular 20.

---

## Step 1 – Run `ng update` for Angular 20

```bash
ng update @angular/core@20 @angular/cli@20
```

This applies automated migration schematics from the Angular team. Review and commit the diff separately.

Refer to the [Angular 20 update guide](https://angular.dev/update-guide?v=19.0-20.0&l=2) for the full list of breaking changes.

---

## Step 2 – Update `@c8y` Dependencies

In `package.json`, update every `@c8y/*` package to the target `1023.x.x` release:

```json
{
  "@c8y/cli": "1023.0.0",
  "@c8y/client": "1023.0.0",
  "@c8y/ngx-components": "1023.0.0",
  "@c8y/options": "1023.0.0",
  "@c8y/style": "1023.0.0",
  "@c8y/websdk": "1023.0.0"
}
```

Replace `1023.0.0` with the exact patch version you are targeting.

---

## Step 3 – Update TypeScript

Update TypeScript to version **5.9.3 or higher**:

```json
{
  "devDependencies": {
    "typescript": "5.9.3"
  }
}
```

---

## Step 4 – Update `ngx-bootstrap`

```bash
npm install ngx-bootstrap@20.0.2
# or with yarn
yarn add ngx-bootstrap@20.0.2
```

---

## Step 5 – Update `@angular/cdk` (and Material)

```bash
npm install @angular/cdk@20
# or with yarn
yarn add @angular/cdk@20
```

If `@angular/material` is also used, update it to the same major version:

```bash
npm install @angular/material@20
```

---

## Step 6 – Check Node.js, TypeScript, and RxJS Compatibility

Verify compatibility against the [Angular actively supported versions table](https://angular.dev/reference/versions#actively-supported-versions). Key ranges for Angular 20:

| Dependency | Supported range |
|---|---|
| Node.js | `^20.11.0 \|\| ^22.0.0` |
| TypeScript | `>=5.9.3` |
| RxJS | `^6.5.3 \|\| ^7.4.0` |

Update `.nvmrc` / `.node-version` and `package.json` accordingly.

---

## Step 7 – Install and Verify

```bash
rm -rf node_modules
npm install
npm ls --depth=0
```

Resolve any peer dependency warnings before proceeding.

---

## Breaking Changes

### 1 – Global Time Context API Changes

The global time context integration API has been **redesigned**. Custom widget implementations that interact with the global time context may require updates.

**Action:** Review any widget code that reads or subscribes to the global time context. Full migration details will be provided in upcoming Cumulocity documentation — check the official Web SDK changelog for updates before finalising this step.

Find usages to review:

```bash
grep -rn "TimeContext\|timeContext\|globalTime" src/ --include="*.ts"
```

---

### 2 – `@ngx-translate/core` Upgraded to v17 — Scoped `TranslateService`

`@ngx-translate/core` has been upgraded to **version 17.0.0**. A key behavioural change is that a **separate `TranslateService` instance is now provided per plugin**, rather than a single shared instance.

**Impact:** Code that directly injects and uses `TranslateService` across plugin or module boundaries may observe unexpected behaviour, as each plugin now receives its own scoped instance.

**Action:** Review all direct usages of `TranslateService` in plugins and ensure they do not rely on a shared singleton state (e.g. loaded translations, current language). Where cross-plugin translation sharing is needed, align with the new scoped service approach as documented by `@ngx-translate/core` v17.

Find all injection sites to review:

```bash
grep -rn "TranslateService" src/ --include="*.ts"
```

---

### 3 – `QueriesUtil` Now Has Type Definitions

The `QueriesUtil` class now includes TypeScript type definitions. Depending on how your code uses this class, you may encounter new **TypeScript compilation errors** where previously inferred or untyped usages are now strictly typed.

**Action:** Run a type check and fix any errors surfaced around `QueriesUtil`:

```bash
npx tsc --noEmit
```

Find all usages:

```bash
grep -rn "QueriesUtil" src/ --include="*.ts"
```

Add the appropriate type annotations as needed. For example, if a method now requires a specific generic parameter, provide it explicitly:

```typescript
// Before (was accepted without types)
const query = QueriesUtil.buildQuery(params);

// After (provide explicit types if required by the new signatures)
const query = QueriesUtil.buildQuery<MyFilter>(params);
```

---

### 4 – `BulkSingleOperationsListModule` Removed

`BulkSingleOperationsListModule` has been removed. Use `SingleOperationsListComponent` as a **standalone component** instead.

**Before:**

```typescript
import { BulkSingleOperationsListModule } from '@c8y/ngx-components';

@NgModule({
  imports: [
    BulkSingleOperationsListModule,
  ],
})
export class MyModule {}
```

**After:**

```typescript
import { SingleOperationsListComponent } from '@c8y/ngx-components';

@NgModule({
  imports: [
    SingleOperationsListComponent,
  ],
})
export class MyModule {}
```

Or, if your module has already been migrated to standalone:

```typescript
@Component({
  standalone: true,
  imports: [SingleOperationsListComponent],
})
export class MyComponent {}
```

Find all usages to migrate:

```bash
grep -rn "BulkSingleOperationsListModule" src/ --include="*.ts"
```

---

## Step 8 – Start and Validate

```bash
npm start
```

Fix any remaining compilation errors iteratively. After resolving the breaking changes above, the most common remaining issues will be TypeScript strict-mode errors introduced by `QueriesUtil` type additions and the `@ngx-translate/core` v17 API changes.

---

## Quick Reference

| Concern | Before (1022) | After (1023) |
|---|---|---|
| Angular version | 19.x | 20.x |
| Node.js | ^18.19 \| ^20.11 \| ^22.0 | ^20.11 \| ^22.0 |
| TypeScript | >=5.5 <5.8 | >=5.9.3 |
| `ngx-bootstrap` | 19.0.2 | 20.0.2 |
| `@angular/cdk` | 19.x | 20.x |
| `@ngx-translate/core` | Shared singleton | Scoped per plugin (v17) |
| `QueriesUtil` | Untyped | Type definitions added — may need annotations |
| `BulkSingleOperationsListModule` | Available | **Removed** — use `SingleOperationsListComponent` |
| Global time context API | Previous API | **Redesigned** — check upcoming docs |
