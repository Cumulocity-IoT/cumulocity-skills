---
name: websdk-1019-upgrade
description: Step-by-step guide for migrating a Cumulocity Web SDK project from 1018 to 1019 (Angular 16). Covers the mandatory switch from c8ycli to ng-cli, project scaffolding, source file migration, package.json alignment, cumulocity.config.ts setup, tsconfig review, and common pitfalls.
---

# Migrate from Web SDK 1018 to Web SDK 1019 (Angular 16)

Angular 16 support is introduced from **Web SDK version 1019.0.0**.

> **Important:** Version 1019.0.0 marks the end of active development for `c8ycli`. The Web SDK now uses `@angular/cli` (`ng-cli`) as its build toolchain. Migration to `ng-cli` is required.

---

## When to Use This Skill

Use this skill when the project:

- Currently builds with `c8ycli` and `@c8y/cli`.
- Uses Web SDK packages at version `1018.x`.
- Needs to upgrade to Angular 16 and `ng-cli`.

---

## Step 1 – Create an ng-cli Project

Install Angular CLI 16 globally and scaffold a new project using the **same name** as your existing application:

```bash
npm install -g @angular/cli@16
ng new <your-app-name>
```

Follow the prompts. Choose your preferred stylesheet format and routing options.

---

## Step 2 – Add `@c8y/websdk`

Inside the newly scaffolded project, add the Cumulocity Web SDK integration:

```bash
ng add @c8y/websdk
```

When prompted, select the correct project type:

- **application** – for a standard single-page app.
- **hybrid** – for a project that also loads AngularJS (Angular 1.x) modules.

This command installs the required `@c8y/*` packages at `1019.x` and generates a `cumulocity.config.ts` file.

---

## Step 3 – Copy Over Source Files

Copy your existing source code into the new project:

- All Angular modules, components, directives, pipes, and services (`src/modules/`, `src/plugins/`, `src/services/`, etc.)
- Spec files (`*.spec.ts`)
- Non-standard assets (images, LESS/CSS theme files, locales, etc.)

Keep the new project's `src/main.ts`, `src/index.html`, and `angular.json` as generated — do not overwrite them with the old files.

---

## Step 4 – Align `package.json`

Open both the old and new `package.json` files side by side and:

1. **Retain** all new dependencies introduced by `ng add @c8y/websdk`.
2. **Add** any custom dependencies from the old project (e.g. `leaflet`, `lodash-es`, `jszip`).
3. **Update** metadata fields (`description`, `version`, `author`, etc.) from the old project, but **exclude** the `"c8y"` property block — that configuration moves to `cumulocity.config.ts` (see Step 5).
4. **Update scripts** — replace every `c8ycli` invocation with `ng` and rename `"server"` to `"serve"`:

```json
{
  "scripts": {
    "start": "ng serve",
    "build": "ng build",
    "test": "ng test",
    "lint": "ng lint"
  }
}
```

---

## Step 5 – Align `cumulocity.config.ts`

Transfer all properties from the old `"c8y.application"` block in `package.json` into the `runTime` object of the generated `cumulocity.config.ts`. Write it as JavaScript/TypeScript (not JSON):

```typescript
import type { ApplicationOptions } from '@c8y/devkit/dist/options';

export const runTime: ApplicationOptions = {
  name: 'My App',
  contextPath: 'my-app',
  key: 'my-app-key',
  // ... other former package.json "c8y.application" fields
};

export const buildTime: ApplicationOptions = {
  // build-only options (e.g. federation sharing config)
};
```

> **Important:** Import `ApplicationOptions` using `import type` to avoid pulling the entire `@c8y/devkit` package into your runtime bundle.

Check federation/module-federation sharing settings. If the defaults provided by `ng add @c8y/websdk` are insufficient, add or adjust entries in `buildTime`.

---

## Step 6 – Verify `tsconfig` Files

Review `tsconfig.json` and `tsconfig.app.json` (and `tsconfig.spec.json` for tests). Angular 16's defaults enable stricter options that may cause compilation errors in existing code. Disable the ones that don't apply to your project:

```json
{
  "compilerOptions": {
    "noPropertyAccessFromIndexSignature": false,
    "noImplicitReturns": false
  }
}
```

Adjust rather than blanket-disabling — only turn off rules that the existing codebase legitimately cannot satisfy.

---

## Step 7 – Install Dependencies and Verify Peer Dependencies

```bash
npm install
```

Check for peer dependency warnings and resolve them:

```bash
npm ls --depth=0
```

Update any third-party libraries (e.g. `ngx-bootstrap`, `@angular/material`, `@ngrx/*`) to versions that declare Angular 16 as a peer dependency.

---

## Step 8 – Check the Angular Update Guide

Because this migration spans Angular 14 → 15 → 16, review the full Angular update guide for any additional breaking changes:

[https://update.angular.io/?v=15.0-16.0](https://update.angular.io/?v=15.0-16.0)

Key Angular 16 changes to be aware of:

- `entryComponents` arrays are **removed** (they were deprecated in Angular 15). Delete every `entryComponents: [...]` entry from all `@NgModule` decorators.
- Standalone components API is stable — consider adopting if greenfielding new features.
- `@angular/router` now exports `RouterLink` as a standalone directive.

---

## Step 9 – Start the Application

Run the application and fix compilation errors iteratively:

```bash
npm start
# or
npx ng serve <your-app-name>
```

---

## Common Pitfalls

| Pitfall | Fix |
|---|---|
| `Subject` type errors | Type subjects that emit no value as `Subject<void>`, e.g. `new Subject<void>()`. |
| `entryComponents` not removed | Delete all `entryComponents: [...]` arrays from every `@NgModule`. They are unsupported in Angular 16. |
| `ApplicationOptions` import causes bundle bloat | Use `import type { ApplicationOptions } from '@c8y/devkit/dist/options'` (type-only import). |
| `c8ycli` commands not found | Replace all `c8ycli` usages in scripts and CI pipelines with `ng`. Rename `"server"` script to `"serve"`. |
| Old `"c8y"` block still in `package.json` | Move all those properties to `cumulocity.config.ts` `runTime`/`buildTime` and remove the `"c8y"` block entirely. |
| Peer dependency mismatches | Upgrade third-party Angular libraries (e.g. `ngx-bootstrap`, Material) to Angular 16-compatible versions. |

---

## Quick Reference

| Concern | Before (1018) | After (1019) |
|---|---|---|
| Build tool | `c8ycli` | `@angular/cli` (`ng`) |
| Angular version | 15.2.7 | 16.x |
| TypeScript | 4.9.5 | 5.0.x (Angular 16 default) |
| App config | `package.json` `"c8y"` block | `cumulocity.config.ts` |
| `entryComponents` | Allowed (deprecated) | **Removed** — must be deleted |
| Start command | `c8ycli server` | `ng serve` |
