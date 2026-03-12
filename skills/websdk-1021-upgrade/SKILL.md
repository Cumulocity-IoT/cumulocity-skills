---
name: websdk-1021-upgrade
description: Step-by-step guide for migrating a Cumulocity Web SDK project from 1020 to 1021 (Angular 18). Covers @c8y dependency updates, Angular 18 ng update, ngx-bootstrap and CDK upgrades, and the removal of brandingEntry in favour of angular.json styles arrays.
---

# Migrate from Web SDK 1020 to Web SDK 1021 (Angular 18)

Angular 18 support is introduced from **Web SDK version 1021.0.0**.

---

## When to Use This Skill

Use this skill when the project:

- Uses Web SDK packages (`@c8y/*`) at version `1020.x`.
- Builds with `@angular/cli` (`ng`).
- Needs to upgrade to Angular 18.

---

## Step 1 – Update `@c8y` Dependencies

In `package.json`, update every `@c8y/*` package to the target `1021.x.x` release:

```json
{
  "@c8y/cli": "1021.0.0",
  "@c8y/client": "1021.0.0",
  "@c8y/ngx-components": "1021.0.0",
  "@c8y/options": "1021.0.0",
  "@c8y/style": "1021.0.0",
  "@c8y/websdk": "1021.0.0"
}
```

Replace `1021.0.0` with the exact patch version you are targeting.

---

## Step 2 – Run `ng update` for Angular 18

Use the Angular update schematics to migrate Angular core and CLI in one step:

```bash
ng update @angular/core@18 @angular/cli@18
```

This applies any automated migration schematics provided by the Angular team. Review the diff and commit it as a dedicated step for a clean history.

Refer to the [Angular 18 update guide](https://angular.dev/update-guide?v=17.0-18.0&l=3) for the full list of breaking changes.

---

## Step 3 – Check Node.js, TypeScript, and RxJS Compatibility

Angular 18 has specific version requirements. Verify compatibility against the [Angular actively supported versions table](https://angular.dev/reference/versions#actively-supported-versions) and update accordingly. Key ranges for Angular 18:

| Dependency | Supported range |
|---|---|
| Node.js | `^18.13.0 \|\| ^20.9.0` |
| TypeScript | `>=5.0.0 <5.5.0` |
| RxJS | `^6.5.3 \|\| ^7.4.0` |

Update `package.json` and your `.nvmrc` / `.node-version` file as needed.

---

## Step 4 – Update `ngx-bootstrap`

Upgrade `ngx-bootstrap` to the Angular 18-compatible version:

```bash
npm install ngx-bootstrap@18.0.0
# or with yarn
yarn add ngx-bootstrap@18.0.0
```

Review the [ngx-bootstrap changelog](https://github.com/valor-software/ngx-bootstrap/blob/development/CHANGELOG.md) for any breaking API changes.

---

## Step 5 – Update `@angular/cdk` (and Material)

```bash
npm install @angular/cdk@18
# or with yarn
yarn add @angular/cdk@18
```

If `@angular/material` is also used, update it to the same major version:

```bash
npm install @angular/material@18
```

---

## Step 6 – Migrate Branding: Remove `brandingEntry` from `cumulocity.config.ts`

`brandingEntry` is no longer supported as a way to inject global styles. Global styles must now be declared in the `styles` array of `angular.json`, following the [Angular workspace styles configuration](https://angular.dev/reference/configs/workspace-config#styles-and-scripts-configuration).

### Case A – You did NOT previously use `brandingEntry`

Add the default `@c8y/style` stylesheet to the `styles` array in `angular.json`:

```json
{
  "projects": {
    "<your-app-name>": {
      "architect": {
        "build": {
          "options": {
            "styles": [
              "node_modules/@c8y/style/main.less"
            ]
          }
        }
      }
    }
  }
}
```

### Case B – You previously used `brandingEntry` in `cumulocity.config.ts`

Replace `brandingEntry` with a direct reference to the same file in `angular.json`'s `styles` array:

**`cumulocity.config.ts` — before:**

```typescript
export const runTime: ApplicationOptions = {
  name: 'My App',
  brandingEntry: 'src/branding/index-my-brand.less',
  // ...
};
```

**`cumulocity.config.ts` — after** (remove `brandingEntry`):

```typescript
export const runTime: ApplicationOptions = {
  name: 'My App',
  // brandingEntry removed
  // ...
};
```

**`angular.json` — add the branding file to `styles`:**

```json
{
  "options": {
    "styles": [
      "src/branding/index-my-brand.less"
    ]
  }
}
```

> If multiple build configurations (e.g. `production`, `development`) override the `styles` array, add the entry to each relevant configuration.

### Finding all `brandingEntry` occurrences

```bash
grep -rn "brandingEntry" .
```

---

## Step 7 – Install and Verify

Clean-install all dependencies and check for peer dependency issues:

```bash
rm -rf node_modules
npm install
npm ls --depth=0
```

Resolve any peer dependency warnings before proceeding.

---

## Step 8 – Start and Validate

```bash
npm start
```

Fix any remaining compilation errors. Common issues after an Angular 18 upgrade:

- **Zoneless change detection (opt-in)**: Angular 18 introduces experimental zoneless support. No action required unless you want to opt in.
- **`inject()` in constructors**: Angular 18 further promotes the `inject()` function API over constructor injection in some contexts. Existing constructor injection continues to work.
- **Deferred loading (`@defer`)**: Now stable in Angular 18. Existing `*ngIf`-based lazy patterns continue to work.

---

## Quick Reference

| Concern | Before (1020) | After (1021) |
|---|---|---|
| Angular version | 17.x | 18.x |
| Node.js | ^16.13 \| ^18.10 | ^18.13 \| ^20.9 |
| TypeScript | ~5.0 | >=5.0 <5.5 |
| `ngx-bootstrap` | 12.0.0 | 18.0.0 |
| `@angular/cdk` | 17.x | 18.x |
| Global styles config | `brandingEntry` in `cumulocity.config.ts` | `styles` array in `angular.json` |
| `brandingEntry` | Supported | **Removed** — must be deleted |
