---
name: websdk-1018-upgrade
description: Step-by-step guide for upgrading a Cumulocity Web SDK project from a version below 1018 to 1018 (Angular 15). Covers dependency updates, TypeScript version, Node version requirements, and the migration from deprecated HOOK token providers to function hooks.
---

# Upgrade to Web SDK 1018 (Angular 15)

Angular 15 support is introduced from **Web SDK version 1018.157.0**. This skill walks through all required changes to migrate a frontend project from Web SDK <1018.

---

## When to Use This Skill

Use this skill when the project:

- Uses `@c8y/ngx-components`, `@c8y/cli`, or `@c8y/client` with a version below `1018.x`.
- Needs to upgrade Angular from 14 to 15.
- Contains deprecated `HOOK_*` token providers that must be replaced with function hooks.

---

## Step 1 – Update Node Version

Angular 15 requires one of the following Node versions:

```
^14.20.0 || ^16.13.0 || ^18.10.0
```

Verify the active Node version and switch via `nvm` (or your version manager of choice) if needed:

```bash
node --version
nvm install 18
nvm use 18
```

Update `.nvmrc` or `.node-version` in the repository if present.

---

## Step 2 – Update Dependencies in `package.json`

### Angular packages

Bump **every** `@angular/*` package to exactly `15.2.7`:

```json
{
  "@angular/animations": "15.2.7",
  "@angular/common": "15.2.7",
  "@angular/compiler": "15.2.7",
  "@angular/core": "15.2.7",
  "@angular/forms": "15.2.7",
  "@angular/platform-browser": "15.2.7",
  "@angular/platform-browser-dynamic": "15.2.7",
  "@angular/router": "15.2.7",
  "@angular/upgrade": "15.2.7",
  "@angular-devkit/build-angular": "15.2.7",
  "@angular/compiler-cli": "15.2.7",
  "@angular/language-service": "15.2.7"
}
```

> Include `@angular/cdk` and `@angular/material` if used, also at `15.2.7`.

### TypeScript

```json
{
  "typescript": "4.9.5"
}
```

### Web SDK packages

Update all `@c8y/*` packages to the target `1018.x` release (e.g. `1018.157.0`):

```json
{
  "@c8y/cli": "1018.157.0",
  "@c8y/client": "1018.157.0",
  "@c8y/ngx-components": "1018.157.0",
  "@c8y/style": "1018.157.0"
}
```

---

## Step 3 – Follow the Official Angular 15 Upgrade Guide

Run the Angular update schematics for any third-party libraries that provide them:

```bash
npx ng update @angular/core@15 @angular/cli@15
```

Refer to the [official Angular upgrade guide](https://update.angular.io/?v=14.0-15.0) for a full checklist of breaking changes between Angular 14 and Angular 15, including:

- `ENVIRONMENT_INITIALIZER` token changes.
- Removal of `DefaultTitleStrategy` in favour of `TitleStrategy`.
- Standalone components API changes (if used).
- `RouterModule` and `RouterLink` directive changes.

---

## Step 4 – Reinstall Dependencies

Delete `node_modules` and any lock files, then reinstall cleanly:

```bash
# Yarn (used by this project)
rm -rf node_modules
yarn install

# npm alternative
rm -rf node_modules package-lock.json
npm install
```

---

## Step 5 – Migrate Deprecated `HOOK_*` Token Providers

Token-based hooks were deprecated in favour of **function hooks**. Replace every occurrence in `NgModule` `providers` arrays.

### Replacement table

| Deprecated token | New function hook |
|---|---|
| `HOOK_TABS` | `hookTab` |
| `HOOK_NAVIGATOR_NODES` | `hookNavigator` |
| `HOOK_ACTION` | `hookAction` |
| `HOOK_BREADCRUMB` | `hookBreadcrumb` |
| `HOOK_SEARCH` | `hookSearch` |
| `HOOK_ONCE_ROUTE` | `hookRoute` |
| `HOOK_COMPONENTS` | `hookComponent` |
| `HOOK_WIZARD` | `hookWizard` |
| `HOOK_STEPPER` | `hookStepper` |

### Migration pattern

**Before (token-based):**

```typescript
import { HOOK_NAVIGATOR_NODES } from '@c8y/ngx-components';
import { MyNavigatorFactory } from './my-navigator.factory';

@NgModule({
  providers: [
    {
      provide: HOOK_NAVIGATOR_NODES,
      useClass: MyNavigatorFactory,
      multi: true,
    },
  ],
})
export class MyModule {}
```

**After (function hook):**

```typescript
import { hookNavigator } from '@c8y/ngx-components';
import { MyNavigatorFactory } from './my-navigator.factory';

@NgModule({
  providers: [
    hookNavigator(MyNavigatorFactory),
  ],
})
export class MyModule {}
```

### Find all usages to migrate

Run the following to locate every file that still uses a deprecated token:

```bash
grep -rn "HOOK_TABS\|HOOK_NAVIGATOR_NODES\|HOOK_ACTION\|HOOK_BREADCRUMB\|HOOK_SEARCH\|HOOK_ONCE_ROUTE\|HOOK_COMPONENTS\|HOOK_WIZARD\|HOOK_STEPPER" src/
```

Apply the replacement pattern shown above to each result.

---

## Step 6 – Verify

```bash
# Type-check the project
yarn lint

# Run unit tests
yarn jest

# Start the dev server against a tenant
yarn start
```

Fix any remaining TypeScript or Angular compilation errors surfaced by the stricter Angular 15 / TypeScript 4.9 checks.

---

## Quick Reference

| Concern | Before | After |
|---|---|---|
| Angular version | 14.x | 15.2.7 |
| TypeScript | 4.8.x | 4.9.5 |
| Node | ^14.15 \| ^16.10 | ^14.20 \| ^16.13 \| ^18.10 |
| Web SDK | <1018.x | 1018.157.0+ |
| Hook providers | `HOOK_*` tokens | `hook*()` functions |
