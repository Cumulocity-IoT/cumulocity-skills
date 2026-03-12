---
name: websdk-breaking-changelog
description: Curated list of breaking changes, removals, and migration-critical announcements in the Cumulocity Web SDK, scraped from the official changelogs at https://cumulocity.com/docs/{year}/change-logs/ and mapped to LTS SDK versions from the websdk-version-map skill. Use this before upgrading to understand what will break and what action is required. Source URLs are provided per entry for traceability.
---

# Cumulocity Web SDK – Breaking Changelog

This skill lists **breaking changes, deprecation removals, and important announcements** that require developer action, mapped to the LTS Web SDK version line in which they were released.

Source: `https://cumulocity.com/docs/{year}/change-logs/?component=.component-web-sdk&change-type=.change-type-feature%2C.change-type-preview%2C.change-type-improvement%2C.change-type-fix%2C.change-type-announcement%2C.change-type-api-change`

> **Always consult the [websdk-version-map](../websdk-version-map/SKILL.md) skill to determine which LTS version and year corresponds to your current and target SDK.**

---

## Version Map (quick reference)

| Release Year | LTS Alias  | Primary SDK Version | Angular Version |
|--------------|------------|---------------------|-----------------|
| 2026         | 2026-lts   | 1023.14.x           | 20              |
| 2025         | 2025-lts   | 1021.22.x           | 18              |
| 2024         | 2024-lts   | 1018.x              | 15              |
| 2023         | 2023-lts   | 1017.x              | 14              |

---

## 2024 Release — Web SDK 1018.x (Angular 15)

Source: https://cumulocity.com/docs/2024/change-logs/?component=.component-web-sdk&change-type=.change-type-feature%2C.change-type-preview%2C.change-type-improvement%2C.change-type-fix%2C.change-type-announcement%2C.change-type-api-change

### BREAKING — Angular 15 Upgrade

**Type:** Feature  
**Introduced in:** 2024.0  

The Web SDK was upgraded to Angular 15. All custom applications, widgets, and plugins must be updated to Angular 15 (TypeScript 4.9.x, Node ≥ 14.20 / 16.13 / 18.10).

**Action required:** Follow the [websdk-1018-upgrade](../websdk-1018-upgrade/SKILL.md) skill for the full migration path.

---

### BREAKING — Removal of deprecated `device-grid` model classes, column implementations and services

**Type:** Announcement  
**Introduced in:** 2024.0  

Deprecated classes, components, and services from `@c8y/ngx-components/device-grid` have been removed. Previously announced in release 10.17.

**Action required:** Migrate any usage of the deprecated device-grid items to the new equivalents documented in the [WebSDK resources documentation for the device-grid service](http://resources.cumulocity.com/documentation/websdk/ngx-components/injectables/DeviceGridService.html).

---

### BREAKING — Removal of deprecated core data-grid implementations

**Type:** Announcement  
**Introduced in:** 2024.0  

Core re-usable data-grid-related components and services that were moved to `@c8y/ngx-components` in release 10.16.0.0 had their original (deprecated) implementations removed.

**Action required:** Ensure all imports refer to `@c8y/ngx-components` — remove any leftover imports from the old locations.

---

### BREAKING — Location view migrated to Angular; AngularJS module removed

**Type:** Improvement  
**Introduced in:** 2024.0  

The location view in Device Management and Cockpit was migrated to Angular. The AngularJS module `@c8y/ng1-modules/devicemanagement-location` was **removed**.

**Action required:** Remove any import of `@c8y/ng1-modules/devicemanagement-location` from your application. The map provider, location search, and map layers are now configurable via application options or tenant options.

---

### BREAKING — Removal of Impact connectivity feature

**Type:** Improvement  
**Introduced in:** 2024.0  

The Impact connectivity feature was removed from `@c8y/ngx-components` and `@c8y/ng1-modules`.

**Action required:** Remove any imports or references to the Impact connectivity module from your application.

---

### NOTABLE — Dashboard grid expanded from 12 to 24 columns

**Type:** Improvement  
**Introduced in:** 2024.0  

Dashboards now use a 24-column grid instead of 12. Widgets placed on shared dashboards between older and newer application versions may be positioned differently.

**Action required:** If you share dashboards between multiple app versions, upgrade all app versions to a version that includes the corresponding fix (MTM-55923) before deploying.

---

### NOTABLE — Removal of `ComponentFactory` and `ComponentFactoryResolver` references

**Type:** Improvement  
**Introduced in:** 2024.0  

References to the deprecated Angular classes `ComponentFactory` and `ComponentFactoryResolver` were removed from `@c8y/ngx-components`.

**Action required:** Replace any custom usage of `ComponentFactory` / `ComponentFactoryResolver` with the Angular 14+ `ViewContainerRef.createComponent()` API.

---

## 2025 Release — Web SDK 1021.22.x (Angular 18)

Source: https://cumulocity.com/docs/2025/change-logs/?component=.component-web-sdk&change-type=.change-type-feature%2C.change-type-preview%2C.change-type-improvement%2C.change-type-fix%2C.change-type-announcement%2C.change-type-api-change

### BREAKING — Angular 18 Upgrade

**Type:** Feature  
**Introduced in:** 2025.0  

The Web SDK was upgraded to Angular 18. Custom widgets, plugins, and applications must be compatible with Angular 18.

**Action required:** Follow the [websdk-1021-upgrade](../websdk-1021-upgrade/SKILL.md) skill (or the relevant intermediate upgrade skills) for the full migration path.

---

### BREAKING — `hookDeviceGridAction` has been removed

**Type:** Announcement  
**Introduced in:** 2025.0  

The deprecated `hookDeviceGridAction` hook has been **removed**. The replacement is `hookDataGridActionControls`, which gives more control over data grid actions (add actions to any data grid or override existing ones).

**Action required:** Replace every `hookDeviceGridAction` call with `hookDataGridActionControls`.

---

### BREAKING — `c8y-select` component interface changed

**Type:** Announcement  
**Introduced in:** 2025.0  

An entirely new `c8y-select` component was introduced with search, multi-select, chip-based display, and full keyboard support. The new interface is **not compatible** with the previous version.

**Action required:** Choose one of:
1. Migrate existing `c8y-select` components to the new interface.
2. Rename the selector to `c8y-legacy-select` to retain the existing behaviour without changes.

---

### BREAKING — Dashboard manager extracted into a separate plugin

**Type:** Announcement  
**Introduced in:** 2025.0  

The dashboard manager module is no longer part of `@c8y/ngx-components/context-dashboard`. It will be moved to `@c8y/ngx-components/dashboard-manager` and loaded lazily.

**Action required:** Update any direct imports from `@c8y/ngx-components/context-dashboard` that reference the dashboard manager to use `@c8y/ngx-components/dashboard-manager` instead.

---

### BREAKING — Reports page extracted into a separate plugin

**Type:** Announcement / Improvement  
**Introduced in:** 2025.0  

The reports module is no longer part of `@c8y/ngx-components/context-dashboard`. It is now in `@c8y/ngx-components/report-dashboard` and loaded lazily. This is a prerequisite for replacing Reports with the dashboard manager.

**Action required:** Update imports from `@c8y/ngx-components/context-dashboard` to `@c8y/ngx-components/report-dashboard` where the reports module is used.

---

### BREAKING — `ILabels` interface removed

**Type:** Feature (removal)  
**Introduced in:** 2025.0  

The deprecated `ILabels` interface was removed from the Web SDK. The replacement is `ModalLabels`.

**Action required:** Replace all usages of `ILabels` with `ModalLabels`.

---

### NOTABLE — Dynamic options now loaded from app-specific paths

**Type:** Feature  
**Introduced in:** 2025.0  

Each hosted application now loads its dynamic options from
`/apps/public/public-options@app-{contextPath}/options.json` instead of the generic `/apps/public/public-options/options.json`.

**Action required:** If you host custom `public-options` configurations, verify that the new per-application path is served correctly. This is a prerequisite for the 2025 branding manager changes.

---

### NOTABLE — SSO login: subdomain vs. domain-specific cookies conflict

**Type:** Fix  
**Introduced in:** 2025.3  

After upgrading from y2024 to y2025, SSO logins may fail due to conflicting authorization cookies (old subdomain format `.tenant.eu-latest.cumulocity.com` vs. new domain-specific format `tenant.eu-latest.cumulocity.com`).

**Action required:** The SDK now clears old cookies automatically on detecting the mismatch. Monitor for login failures after a y2024 → y2025 upgrade. Users may need to log out and back in once.

---

### NOTABLE — Security: CSS injection vulnerability fixed

**Type:** Fix  
**Introduced in:** 2025.20  

A CSS injection vulnerability was identified and fixed. Custom applications and plugins built with **affected versions** must be updated.

**Action required:** Rebuild and redeploy all custom applications using Web SDK **1021.22.145 or higher**.

---

## 2026 Release — Web SDK 1023.14.x (Angular 20)

Source: https://cumulocity.com/docs/2026/change-logs/?component=.component-web-sdk&change-type=.change-type-feature%2C.change-type-preview%2C.change-type-improvement%2C.change-type-fix%2C.change-type-announcement%2C.change-type-api-change

### BREAKING — Angular 20 Upgrade; `standalone` flag default changed

**Type:** Improvement  
**Introduced in:** 2026.0  

The Web SDK jumped directly from Angular 18 (y2025) to Angular 20 (y2026), skipping Angular 19. Angular 19 changed the default value of the `standalone` flag from `false` to `true` for components, pipes, and directives.

**Action required (critical):** Explicitly add `standalone: true` or `standalone: false` to **every** component, pipe, and directive in your plugins and custom applications. If the flag is absent, Angular 20 will default to `standalone: true`, which breaks existing non-standalone components. See the [Angular 20 upgrade documentation](https://cumulocity.com/docs/2026/web/upgrade/#upgrading-to-angular-20).

---

### BREAKING — Separate login application replaces built-in login

**Type:** Announcement  
**Introduced in:** 2026.0 (SDK 1022.0.0+)  

Starting with Web SDK 1022.0.0, built-in login functionality is no longer bundled inside each application. All authentication flows are delegated to a standalone login application. Applications built with 1022.0.0+ automatically redirect to this login app.

**Action required:**
- Remove any custom login-flow implementations that relied on the built-in login being embedded in the app.
- If you embed the Cumulocity UI in an `<iframe>` and require in-iframe login, adjust your implementation to support the new external login redirect flow.

---

### BREAKING — `OperationsListModule` removed

**Type:** Announcement  
**Introduced in:** 2026.0 (deprecated since 1021.50.0)  

`OperationsListModule` has been removed from the Web SDK.

**Action required:**
- Import `OperationsListComponent` and `OperationsListItemComponent` directly as standalone components.
- To provide the **Device control > Single operations** feature, use `deviceControlOverviewFeatureProviderFactory()`.
- To provide the **Device control section on the Device info tab**, use `deviceControlTabFeatureProviderFactory()`.
- If you already import `OperationsModule` from `@c8y/ngx-components/operations`, no change is needed — it has been refactored internally.

---

### BREAKING — `getNamedDashboardOrCreate` removed from context-dashboard service

**Type:** API Change  
**Introduced in:** 2026.0  

The deprecated `getNamedDashboardOrCreate` method was removed from the `context-dashboard` service in the Dashboard API.

**Action required:** Replace all calls to `getNamedDashboardOrCreate()` with `getDashboard()`.

---

### BREAKING — Routes that use context dashboards must define `rootContext: ViewContext.Dashboard`

**Type:** Announcement  
**Introduced in:** 2026.0  

As part of the dashboard import/export feature, the dashboard settings component now uses a secondary router outlet. Every component that uses context dashboards must declare `rootContext: ViewContext.Dashboard` in its route definition for setting tabs and views to be visible.

**Action required:** Add `rootContext: ViewContext.Dashboard` to every route that renders a context dashboard component, for example:
```ts
hookRoute({
  path: 'home',
  component: CockpitDashboardComponent,
  rootContext: ViewContext.Dashboard,
});
```

---

### BREAKING — `loadConfigComponent` deprecated; widget config sections changed

**Type:** Announcement  
**Introduced in:** 2026.0  

The `loadConfigComponent` method of `widgetHook` is deprecated in favour of a new hookable multi-section widget configuration (`hookWidgetSection`). `loadConfigComponent` still works short-term but will be removed in a future major release.

**Action required:** Migrate widget configuration to use `hookWidgetSection`. Multiple configuration sections can be displayed, providing greater flexibility.

---

### BREAKING — Wildcard search replaces full-text search; external IDs/descriptions/types no longer searchable

**Type:** Feature  
**Introduced in:** 2026.0  

The global asset/device search was changed from full-text to wildcard-based search. Searching by external IDs, descriptions, and types is **no longer supported** by default.

**Action required:** Review any custom search UIs or workflows that relied on full-text search covering external IDs, descriptions, or types. Contact support or disable the `ui.search.wildcard` feature flag if full-text search is required.

---

### BREAKING — LWM2M module will be removed from `@c8y/ngx-components`

**Type:** Announcement  
**Introduced in:** 2026.0 (future removal)  

The LWM2M module will be removed from `@c8y/ngx-components` in a future version. LWM2M will instead be available as a plugin in the Device Management application.

**Action required:** Audit all usage of the LWM2M module from `@c8y/ngx-components`. Plan migration to consume LWM2M as a plugin before the removal release.

---

### NOTABLE — HTML widget moved to GA; strict sanitization enabled by default

**Type:** Announcement  
**Introduced in:** 2026.0  

The HTML widget was migrated from AngularJS to Angular and is now generally available. Strict HTML sanitization is **enabled by default** (XSS protection). Advanced mode (custom web components) is restricted to Application administrators. Existing AngularJS HTML widgets are automatically migrated.

**Action required:**
- Widgets that relied on unsanitized HTML output will behave differently. Test existing HTML widgets after upgrade.
- To disable strict sanitization (only if necessary): clone the Cockpit application and adjust `Config > Application configuration`.

---

### NOTABLE — Security: XSS vulnerability fixed in custom tooltips (Echarts)

**Type:** Fix  
**Introduced in:** 2026.0  

A cross-site scripting (XSS) vulnerability was found and fixed in the Echarts charting library's custom tooltip feature used by the new data point graph / data explorer.

**Action required:** Update to **Web SDK 1023.14.60 or higher** and redeploy all affected applications.

---

### NOTABLE — Security: CSS injection vulnerability fixed

**Type:** Fix  
**Introduced in:** 2026.0  

Same class of vulnerability as in 2025.20. Custom applications and plugins built with affected versions must be updated.

**Action required:** Rebuild and redeploy all custom applications using Web SDK **1023.14.60 or higher**.

---

### NOTABLE — New data explorer and Data point graph widget — now GA (previously Plugin/Preview)

**Type:** Announcement  
**Introduced in:** 2026.0  

The new data explorer and the new data point graph widget are now generally available. They were previously Preview features installable as optional plugins.

**Action required:** No mandatory action, but note that the new widgets are Angular-based (replacing AngularJS). Review widget configuration compatibility if you programmatically manage widget configurations.

---

## Usage Pattern

When preparing an upgrade, consult this skill as follows:

1. Identify your **current** SDK version and LTS year using [websdk-version-map](../websdk-version-map/SKILL.md).
2. Identify your **target** SDK version.
3. Read **every breaking change section between your current year and target year** in sequence.
4. For each breaking entry, apply the "Action required" steps before building.
5. Use the corresponding `websdk-{version}-upgrade` skill for the full dependency-level migration steps.

---

## Changelog Source URLs

| Year | URL |
|------|-----|
| 2024 | https://cumulocity.com/docs/2024/change-logs/?component=.component-web-sdk&change-type=.change-type-feature%2C.change-type-preview%2C.change-type-improvement%2C.change-type-fix%2C.change-type-announcement%2C.change-type-api-change |
| 2025 | https://cumulocity.com/docs/2025/change-logs/?component=.component-web-sdk&change-type=.change-type-feature%2C.change-type-preview%2C.change-type-improvement%2C.change-type-fix%2C.change-type-announcement%2C.change-type-api-change |
| 2026 | https://cumulocity.com/docs/2026/change-logs/?component=.component-web-sdk&change-type=.change-type-feature%2C.change-type-preview%2C.change-type-improvement%2C.change-type-fix%2C.change-type-announcement%2C.change-type-api-change |
