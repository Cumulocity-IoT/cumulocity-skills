---
name: websdk-1022-upgrade
description: Step-by-step guide for migrating a Cumulocity Web SDK project from 1021 to 1022 (Angular 19). Covers Angular 19 ng update, standalone-by-default breaking change, @c8y dependency updates, ngx-bootstrap and CDK upgrades, main.ts/bootstrap.ts adjustments, dashboard route rootContext requirement, login app separation, and removed deprecated Angular widget modules.
---

# Migrate from Web SDK 1021 to Web SDK 1022 (Angular 19)

Angular 19 support is introduced from **Web SDK version 1022.0.0**.

---

## When to Use This Skill

Use this skill when the project:

- Uses Web SDK packages (`@c8y/*`) at version `1021.x`.
- Builds with `@angular/cli` (`ng`).
- Needs to upgrade to Angular 19.

---

## Step 1 – Run `ng update` for Angular 19

```bash
ng update @angular/core@19 @angular/cli@19
```

This applies automated migration schematics from the Angular team. Review and commit the diff separately.

> **Critical breaking change — standalone by default:**
> Starting with Angular 19, all directives, components, and pipes are **standalone by default** (`standalone: true` is implied). Any declaration that is currently declared inside an `NgModule` **must** explicitly opt out by setting `standalone: false`.
>
> This applies to **every** `@Component`, `@Directive`, and `@Pipe` declared in an `NgModule`, including **module federation plugins** that use earlier versions of Angular but are loaded inside an application migrated to Angular 19.

### Fix: Add `standalone: false` to all NgModule-declared declarations

```typescript
// Before
@Component({
  selector: 'app-my-widget',
  templateUrl: './my-widget.component.html',
})
export class MyWidgetComponent {}

// After
@Component({
  selector: 'app-my-widget',
  templateUrl: './my-widget.component.html',
  standalone: false,
})
export class MyWidgetComponent {}
```

Apply the same change to every `@Directive` and `@Pipe` that is listed in an `NgModule`'s `declarations` array.

The `ng update` schematics may handle some of these automatically. Always verify the output and run a type check afterwards:

```bash
# Find declarations that may still be missing standalone: false
grep -rn "@Component\|@Directive\|@Pipe" src/ --include="*.ts" | grep -v "standalone"
```

Refer to the [Angular 19 update guide](https://angular.dev/update-guide?v=18.0-19.0&l=2) for the full list of breaking changes.

---

## Step 2 – Update `@c8y` Dependencies

In `package.json`, update every `@c8y/*` package to the target `1022.x.x` release:

```json
{
  "@c8y/cli": "1022.0.0",
  "@c8y/client": "1022.0.0",
  "@c8y/ngx-components": "1022.0.0",
  "@c8y/options": "1022.0.0",
  "@c8y/style": "1022.0.0",
  "@c8y/websdk": "1022.0.0"
}
```

Replace `1022.0.0` with the exact patch version you are targeting.

---

## Step 3 – Update `ngx-bootstrap`

```bash
npm install ngx-bootstrap@19.0.2
# or with yarn
yarn add ngx-bootstrap@19.0.2
```

---

## Step 4 – Update `@angular/cdk` (and Material)

```bash
npm install @angular/cdk@19
# or with yarn
yarn add @angular/cdk@19
```

If `@angular/material` is also used, update it to the same major version:

```bash
npm install @angular/material@19
```

---

## Step 5 – Check Node.js, TypeScript, and RxJS Compatibility

Verify compatibility against the [Angular actively supported versions table](https://angular.dev/reference/versions#actively-supported-versions). Key ranges for Angular 19:

| Dependency | Supported range |
|---|---|
| Node.js | `^18.19.0 \|\| ^20.11.0 \|\| ^22.0.0` |
| TypeScript | `>=5.5.0 <5.8.0` |
| RxJS | `^6.5.3 \|\| ^7.4.0` |

Update `.nvmrc` / `.node-version` and `package.json` accordingly.

---

## Step 6 – Adjust `main.ts` and `bootstrap.ts`

The Web SDK 1022 introduces changes to how application bootstrapping works (driven by the login separation described in the breaking changes section). Align your `src/main.ts` and `src/bootstrap.ts` (if present) with the patterns provided in the latest Web SDK starter templates or your project's migration diff.

Key things to check:

- Remove any manual `loginOptions()` calls that were not already removed in the 1020 migration.
- Ensure `loadOptions()` is still used as the outer wrapper before `bootstrapModule()` or `bootstrapApplication()`.
- If the project uses a `bootstrap.ts` separate from `main.ts`, verify the import path and that it does not duplicate the options-loading logic.

---

## Breaking Changes

### 1 – Standalone by Default (Angular 19)

Covered in Step 1. Every `@Component`, `@Directive`, and `@Pipe` declared in an `NgModule` must have `standalone: false` added explicitly.

---

### 2 – Dashboard Setting Component: `rootContext: ViewContext.Dashboard` Required

The dashboard settings view has been refactored to use a **secondary router outlet**. As a result, every route that renders a context dashboard component must now include `rootContext: ViewContext.Dashboard`.

**Before:**

```typescript
hookRoute({
  path: 'home',
  component: CockpitDashboardComponent,
});
```

**After:**

```typescript
import { ViewContext } from '@c8y/ngx-components';

hookRoute({
  path: 'home',
  component: CockpitDashboardComponent,
  rootContext: ViewContext.Dashboard,
});
```

Without this property, the dashboard settings panel (including the new Import/Export tab) will not be visible.

#### Adding tabs to the dashboard settings (optional)

If you want to add custom tabs to the dashboard settings, use the new `tabsOutlet` pattern:

```typescript
hookTab([
  {
    label: gettext('My Custom Tab'),
    icon: 'settings',
    priority: 5,
    path: [{ outlets: { 'dashboard-details': 'my-tab' } }],
    tabsOutlet: 'dashboardTabs',
  },
]),
hookRoute([
  {
    path: 'my-tab',
    loadComponent: () => import('./my-tab/my-tab.component').then(m => m.MyTabComponent),
    outlet: 'dashboard-details',
    context: ViewContext.Dashboard,
  },
])
```

#### Find all routes that need updating

```bash
grep -rn "CockpitDashboardComponent\|ViewContext.Dashboard\|hookRoute" src/ --include="*.ts"
```

---

### 3 – Login is Now a Separate Application

The Web SDK no longer ships built-in login functionality inside each application. A standalone login application now handles all authentication flows. Applications built on Web SDK 1022+ automatically redirect unauthenticated users to this login app.

**Action required:**

- Remove any custom login-related route definitions or components that replicated the built-in login flow.
- If your application is **embedded in an iframe** and requires in-iframe login, review and update your implementation to support the redirect-based login flow.
- No code change is required for standard browser-based applications — the redirect is handled automatically.

---

### 4 – Deprecated Angular Widget Modules Removed

The following `NgModule`-based widget modules have been removed. They were previously deprecated when the underlying widgets were migrated to standalone components.

| Removed module | Replacement |
|---|---|
| `CockpitLegacyWelcomeWidgetModule` | Use the standalone component directly |
| `CockpitWelcomeWidgetModule` | Use the standalone component directly |
| `DeviceControlMessageWidgetModule` | Use the standalone component directly |
| `HelpAndServiceModule` | Use the standalone component directly |
| `ImageWidgetModule` | Use the standalone component directly |
| `InfoGaugeWidgetModule` | Use the standalone component directly |
| `KpiWidgetModule` | Use the standalone component directly |
| `LinearGaugeModule` | Use the standalone component directly |
| `MarkdownWidgetModule` | Use the standalone component directly |
| `ThreeDRotationWidgetModule` | Use the standalone component directly |

**Action:** Remove any imports of these modules from your `NgModule` `imports` arrays. Import the standalone component class directly where needed, or rely on the c8y plugin system to register them.

Find all usages to migrate:

```bash
grep -rn "CockpitLegacyWelcomeWidgetModule\|CockpitWelcomeWidgetModule\|DeviceControlMessageWidgetModule\|HelpAndServiceModule\|ImageWidgetModule\|InfoGaugeWidgetModule\|KpiWidgetModule\|LinearGaugeModule\|MarkdownWidgetModule\|ThreeDRotationWidgetModule" src/ --include="*.ts"
```

---

## Step 7 – Install and Verify

```bash
rm -rf node_modules
npm install
npm ls --depth=0
```

---

## Step 8 – Start and Validate

```bash
npm start
```

Fix any remaining compilation errors. After resolving the `standalone: false` additions, the most common remaining errors will be:

- Missing `rootContext: ViewContext.Dashboard` on dashboard routes.
- Imports of removed widget modules.
- TypeScript version incompatibilities with `tsconfig.json` strict settings.

---

## Quick Reference

| Concern | Before (1021) | After (1022) |
|---|---|---|
| Angular version | 18.x | 19.x |
| Node.js | ^18.13 \| ^20.9 | ^18.19 \| ^20.11 \| ^22.0 |
| TypeScript | >=5.0 <5.5 | >=5.5 <5.8 |
| `ngx-bootstrap` | 18.0.0 | 19.0.2 |
| `@angular/cdk` | 18.x | 19.x |
| Components in NgModule | `standalone` omitted = `false` | Must set `standalone: false` explicitly |
| Dashboard routes | No `rootContext` needed | `rootContext: ViewContext.Dashboard` required |
| Login | Built into each app | Separate login application (auto-redirect) |
| Deprecated widget modules | Still importable | **Removed** — delete from `imports` arrays |
