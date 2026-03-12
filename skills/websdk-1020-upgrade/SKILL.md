---
name: websdk-1020-upgrade
description: Step-by-step guide for migrating a Cumulocity Web SDK project from 1019 to 1020 (Angular 17). Covers @c8y dependency updates, zone.js import fix, angular.json buildTarget rename, Angular 17 ng update, ngx-bootstrap and CDK upgrades, loginOptions removal from main.ts, and adding the @c8y/options devDependency.
---

# Migrate from Web SDK 1019 to Web SDK 1020 (Angular 17)

Angular 17 support is introduced from **Web SDK version 1020.0.0**.

---

## When to Use This Skill

Use this skill when the project:

- Uses Web SDK packages (`@c8y/*`) at version `1019.x`.
- Builds with `@angular/cli` (migrated from `c8ycli` in the 1019 step).
- Needs to upgrade to Angular 17.

---

## Step 1 – Update `@c8y` Dependencies

In `package.json`, update every `@c8y/*` package to the target `1020.x.x` release:

```json
{
  "@c8y/cli": "1020.0.0",
  "@c8y/client": "1020.0.0",
  "@c8y/ngx-components": "1020.0.0",
  "@c8y/style": "1020.0.0",
  "@c8y/websdk": "1020.0.0"
}
```

Replace `1020.0.0` with the exact patch version you are targeting.

---

## Step 2 – Fix the `zone.js` Import in `src/polyfills.ts`

The `zone.js/dist/zone` sub-path entry was removed. Replace the old import:

**Before:**

```typescript
import 'zone.js/dist/zone';
```

**After:**

```typescript
import 'zone.js';
```

Find all occurrences across the project to be safe:

```bash
grep -rn "zone.js/dist/zone" src/
```

---

## Step 3 – Replace `browserTarget` with `buildTarget` in `angular.json`

Angular 17 renamed the `browserTarget` option to `buildTarget` in builder configurations. Update every occurrence in `angular.json`:

```bash
# Preview matches
grep -n "browserTarget" angular.json

# Replace all occurrences (macOS sed)
sed -i '' 's/"browserTarget"/"buildTarget"/g' angular.json
```

Verify the file afterwards to confirm no stray `browserTarget` keys remain.

---

## Step 4 – Run `ng update` for Angular 17

Use the Angular update schematics to migrate Angular core, CLI, and related packages in one step:

```bash
ng update @angular/core@17 @angular/cli@17
```

This runs any automated migration schematics provided by the Angular team (e.g. control flow syntax opt-in, standalone API changes). Review the diff and commit it separately for a clean history.

Refer to the [Angular 17 update guide](https://update.angular.io/?v=16.0-17.0) for a full list of breaking changes.

---

## Step 5 – Update `ngx-bootstrap`

Upgrade `ngx-bootstrap` to the Angular 17-compatible version:

```bash
npm install ngx-bootstrap@12.0.0
# or with yarn
yarn add ngx-bootstrap@12.0.0
```

Check the [ngx-bootstrap changelog](https://github.com/valor-software/ngx-bootstrap/blob/development/CHANGELOG.md) for any breaking API changes between your current version and 12.0.0.

---

## Step 6 – Update `@angular/cdk`

Update the Angular CDK to match Angular 17:

```bash
npm install @angular/cdk@17
# or with yarn
yarn add @angular/cdk@17
```

If `@angular/material` is also used, update it to the same major version:

```bash
npm install @angular/material@17
```

---

## Step 7 – Remove `loginOptions` from `src/main.ts`

The `loginOptions` function is now called internally as part of `loadOptions` and no longer needs to be invoked manually in the application bootstrap.

**Before:**

```typescript
import { loginOptions, loadOptions } from '@c8y/ngx-components';

loadOptions().then(() => {
  loginOptions();
  platformBrowserDynamic()
    .bootstrapModule(AppModule)
    .catch(err => console.error(err));
});
```

**After:**

```typescript
import { loadOptions } from '@c8y/ngx-components';

loadOptions().then(() => {
  platformBrowserDynamic()
    .bootstrapModule(AppModule)
    .catch(err => console.error(err));
});
```

Remove both the `loginOptions` import and any call to `loginOptions()`.

---

## Step 8 – Add `@c8y/options` as a `devDependency`

```bash
npm install --save-dev @c8y/options@1020.0.0
# or with yarn
yarn add --dev @c8y/options@1020.0.0
```

Confirm the entry appears under `devDependencies` in `package.json`:

```json
{
  "devDependencies": {
    "@c8y/options": "1020.0.0"
  }
}
```

---

## Step 9 – Install and Verify

Clean-install all dependencies and check for peer dependency issues:

```bash
rm -rf node_modules
npm install
npm ls --depth=0
```

Resolve any peer dependency warnings, particularly for third-party Angular libraries that may need a version bump to support Angular 17.

---

## Step 10 – Start and Validate

```bash
npm start
```

Fix any remaining compilation errors. Common issues after an Angular 17 upgrade:

- **Control flow syntax**: Angular 17 introduces `@if`, `@for`, `@switch` as the new built-in control flow. Existing `*ngIf` / `*ngFor` templates continue to work but can be migrated optionally via `ng generate @angular/core:control-flow`.
- **`ExperimentalDecorators`**: TypeScript 5.x may emit warnings about legacy decorators; ensure `experimentalDecorators: true` is set in `tsconfig.json`.

---

## Quick Reference

| Concern | Before (1019) | After (1020) |
|---|---|---|
| Angular version | 16.x | 17.x |
| `zone.js` import | `zone.js/dist/zone` | `zone.js` |
| Builder option key | `browserTarget` | `buildTarget` |
| `ngx-bootstrap` | <12 | 12.0.0 |
| `@angular/cdk` | 16.x | 17.x |
| `loginOptions` in `main.ts` | Called manually | Removed — handled by `loadOptions` |
| `@c8y/options` | Not required | Add as `devDependency` |
