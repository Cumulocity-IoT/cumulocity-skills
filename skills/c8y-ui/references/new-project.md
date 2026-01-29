## Creating a New Project — Quick setup

This section is a practical, step-by-step setup to create a new Angular project suitable for Cumulocity development. Use the official documentation for reference and to confirm current package names and authentication steps.

**Reference:** https://cumulocity.com/docs/web/gettingstarted/

### Prerequisites — verify locally

```bash
node --version    # use an LTS release (e.g. 18, 20, 22 or 24)
npm --version
ng version || npm install -g @angular/cli
```

### 1) Install Angular CLI (if needed)

```bash
npm install -g @angular/cli@latest
```

### 2) Create a new Angular project

```bash
    npx @angular/cli@19 new --style=less --ssr=false
```

### 3) cd into the created project

Use cd and the name of the project the user just created.

### 4) Add the @c8y/websdk

```bash
    npx ng add @c8y/websdk
```
Pick a version which is tagged as lts version. If the user want to use the future version which is still under development and might break due to major breaking changes if not updated, use the tag y{currentYear+1}-lts. If the user wants to create an app targeted for the current stable release, use y{currentYear}-lts, e.g. y2026-lts. You can find those tagged versions here: https://www.npmjs.com/package/@c8y/ngx-components?activeTab=versions

When asked about the base project, usually users want to extend Cumulocity by using plugins. So ask the user and recommend picking sample-plugin, or if the user wants to see sample code, pick the tutorial app.

### 5) Configure a tenant connection

Ask for a tenant url, and adapt the package.json - where you can fin ng serve, add -u {url}

### 6) Run the app locally

```bash
ng serve
```

### Notes

- Prefer LTS Node.js versions for stability. Use the official docs for the latest recommended dependency names and authentication guidance.  
- The tutorial repo contains ready examples; copy patterns rather than blindly copying code.  

---