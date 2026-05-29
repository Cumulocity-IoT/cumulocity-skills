---
name: internationalization
description: |
  Complete guide to internationalizing a Cumulocity Web SDK application. Covers all
  approaches to annotating and translating text (gettext, translate pipe, translate
  directive, TranslateService), extracting strings, creating and updating .po files,
  overriding existing translations, and adding brand-new languages. Triggers: i18n,
  internationalization, add language, translate, translation, localization, l10n,
  new language, po file, gettext, TranslateService, language switcher.
version: 1.0.0
category: internationalization
triggers:
  - i18n
  - internationalization
  - add language
  - translate
  - translation
  - localization
  - l10n
  - new language
  - po file
  - gettext
  - TranslateService
  - language switcher
  - locale
tags:
  - angular
  - cumulocity
  - i18n
  - localization
  - translation
  - websdk
---

# Cumulocity Internationalization (i18n) Skill

## Overview

Cumulocity Web SDK uses the [gettext](https://en.wikipedia.org/wiki/Gettext) `.po` file
format for translations. There are two distinct problems to solve:

1. **Annotating & pushing text through the translation pipeline** in source code
2. **Providing the translated strings** via `.po` files and wiring them into the app

This skill covers both, plus the complete workflow for adding a brand-new language.

---

## Built-in Languages

The `@c8y/ngx-components` package ships ready-made `.po` files for these locales:

| Code | Language |
|---|---|
| `de` | German |
| `en` | English |
| `en_US` | English (US) |
| `es` | Spanish |
| `fr` | French |
| `ja_JP` | Japanese |
| `ko` | Korean |
| `nl` | Dutch |
| `pl` | Polish |
| `pt_BR` | Brazilian Portuguese |
| `zh_CN` | Simplified Chinese |
| `zh_TW` | Traditional Chinese |

To **activate** any of these, only Steps 5 and 6 of the "Adding a New Language" section
below are required — no translation work needed.

---

## Step 1 — Annotating Text in Source Code

Four mechanisms are available. They can be combined freely.

### `gettext(string)`

Annotates a **static** string literal for extraction. Does **not** translate at runtime —
use it to mark strings defined in TypeScript that are translated elsewhere (e.g. via pipe
or `TranslateService`).

```ts
import { gettext } from '@c8y/ngx-components';

const label = gettext('Remove Device');
```

> **Rules:**
> - Must be a string **literal** — not a variable or template literal.
> - ✅ `gettext('Remove Device')`
> - ❌ `gettext(myVar)`
> - ❌ `` gettext(`Remove ${condition ? 'Device' : 'Group'}`) ``

### `translate` Pipe

Translates the string at runtime inside templates. When applied to a static string
literal it also annotates it for extraction — no separate `gettext()` call needed.

```html
<!-- Simple -->
{{ 'Device' | translate }}

<!-- With interpolated placeholders — use @let to pre-resolve -->
@let removeLabel = 'Remove Device' | translate;
@let cancelLabel = 'Cancel' | translate;
{{ confirmed ? removeLabel : cancelLabel }}

<!-- Or expose gettext on the component class and use it inline -->
{{ (confirmed ? gettext('Remove Device') : gettext('Cancel')) | translate }}
```

> **Note:** Text extraction from the `translate` pipe does **not** work inside complex
> template expressions. Use `@let`, `gettext()`, or define labels in the component class.

### `translate` Directive

Translates the element's **text content** in place. Also annotates it for extraction.

```html
<span translate>Device</span>

<!-- Interpolated placeholders: add ngNonBindable to prevent Angular from
     processing {{ }} before the translation module can handle them -->
<span translate ngNonBindable>{{ filteredCount }} of {{ total }} items.</span>
```

### `TranslateService`

Use for imperative translation inside TypeScript. The string **must** be separately
annotated with `gettext()`.

```ts
import { TranslateService } from '@ngx-translate/core';
import { gettext } from '@c8y/ngx-components';

@Injectable()
export class MyService {
  constructor(private translate: TranslateService) {}

  getLabel(): string {
    const key = gettext('Remove Device'); // annotate for extraction
    return this.translate.instant(key);   // translate at runtime
  }
}
```

### Adding Translator Context

Append context in backticks inside the string to guide translators (and AI translation
tools). Context is **stripped at runtime** — users never see it.

```ts
gettext('Next`page`')
gettext('Set as latest`version`')
gettext('Cover`verb, image fitting option`')
```

Special context `KEEP_ORIGINAL` marks a string as intentionally untranslated:

```ts
gettext('MyBrand`KEEP_ORIGINAL`')
```

---

## Step 2 — Extracting Strings to `locales.pot`

Run this command from the project root to extract all annotated strings into
`./locales/locales.pot`:

```bash
ng extract-i18n
```

The `.pot` file is the **master template** used to create or update per-language `.po`
files. Re-run this command every time strings are added or changed.

---

## Step 3 — Creating / Updating `.po` Files

### Using Poedit (GUI — recommended for translators)

1. Open Poedit → **Translate file** → select the `.pot` file.
2. Choose the target language.
3. Translate each string.
4. Save as `./src/locales/<lang>.po`.

### Using gettext CLI tools

```bash
# Create a new .po from a .pot
msginit --input=./locales/locales.pot --locale=fr --output=./src/locales/fr.po

# Update an existing .po with new/changed strings from .pot
msgmerge --update ./src/locales/fr.po ./locales/locales.pot
```

### Minimum `.po` file structure

```po
msgid ""
msgstr ""
"Project-Id-Version: c8yui.core\n"
"Content-Type: text/plain; charset=UTF-8\n"
"Content-Transfer-Encoding: 8bit\n"
"Plural-Forms: nplurals=2; plural=(n != 1);\n"
"Language: fr\n"

msgid "Remove Device"
msgstr "Supprimer l'appareil"

msgid "{{ filteredCount }} of {{ total }} items."
msgstr "{{ filteredCount }} sur {{ total }} éléments."
```

> The `msgid` must **exactly** match the source string (including any backtick context
> if present).

---

## Step 4 — Overriding an Existing Translation

To change a translation that already exists in a built-in language pack (e.g. change
German "Geräte" → "Maschinen"):

1. Create `./src/locales/de.po` with only the entries you want to override:

```po
msgid ""
msgstr ""
"Project-Id-Version: c8yui.core\n"
"Content-Type: text/plain; charset=UTF-8\n"
"Content-Transfer-Encoding: 8bit\n"
"Plural-Forms: nplurals=2; plural=(n != 1);\n"
"Language: de\n"

msgid "Devices"
msgstr "Maschinen"
```

2. Import it **after** the built-in pack in `./src/i18n.ts`:

```ts
import '@c8y/ngx-components/locales/de.po'; // built-in (base)
import './locales/de.po';                    // your overrides (wins)
```

---

## Step 5 — Wiring `.po` Files into the App (`i18n.ts`)

Every `.po` file — built-in or custom — must be imported in `./src/i18n.ts`:

```ts
// Built-in language packs from the framework
import '@c8y/ngx-components/locales/de.po';
import '@c8y/ngx-components/locales/en.po';
import '@c8y/ngx-components/locales/fr.po';
// … add more as needed

// Custom / override translations
import './locales/fr.po';   // your custom French strings
import './locales/it.po';   // Italian (new language)
```

> Import order matters for overrides: the **last** import for a given `msgid` wins.

---

## Step 6 — Adding a Completely New Language (Full Workflow)

Use this when the language is **not** in the built-in list (e.g. Italian, Arabic, Hindi).

### 6a — Download the framework's master `.pot`

```bash
mkdir -p ./locales
curl -o ./locales/framework.pot https://unpkg.com/@c8y/ngx-components@latest/locales/locales.pot
# For a specific version (>= 1004.0.6):
curl -o ./locales/framework.pot https://unpkg.com/@c8y/ngx-components@1023.0.0/locales/locales.pot
```

### 6b — Extract app-specific strings

```bash
ng extract-i18n
# Output: ./locales/locales.pot
```

### 6c — Merge both `.pot` files

```bash
msgcat -o ./locales/merged.pot ./locales/framework.pot ./locales/locales.pot
```

### 6d — Create the `.po` file for the new language

```bash
msginit --input=./locales/merged.pot --locale=it --output=./src/locales/it.po
# Then open in Poedit or a text editor and fill in the msgstr values
```

### 6e — Import the `.po` file in `i18n.ts`

```ts
// src/i18n.ts
import './locales/it.po';
```

### 6f — Declare the language in `cumulocity.config.ts`

Without this step the language **will not appear** in the language switcher, even if the
`.po` file is imported.

```ts
// cumulocity.config.ts
export default {
  runTime: {
    languages: {
      it: {
        name: 'Italian',
        nativeName: 'Italiano'
      }
    }
  }
};
```

### 6g — Verify

```bash
ng serve -u https://<yourTenant>.cumulocity.com/
```

Open the app → User menu → Language picker. The new language should be listed. Switch to
it and confirm strings render correctly.

---

## Date Translation

### Using the C8Y pipe (recommended — respects platform date format settings)

```html
{{ myDate | c8yDate }}
```

### Using the Angular pipe (locale-aware)

```html
{{ myDate | date:'fullDate' }}
```

The Angular `date` pipe automatically uses the active locale set by the translation
module — no extra configuration needed.

---

## Dynamic Forms

`DynamicFormsModule` has i18n built in. Simply annotate the label strings in the schema
definition with `gettext()` and they will be extracted and translated automatically:

```ts
import { gettext } from '@c8y/ngx-components';

const schema = {
  properties: {
    name: {
      title: gettext('Device name'),
      type: 'string'
    }
  }
};
```

---

## Common Pitfalls

| Pitfall | Fix |
|---|---|
| Language imported in `i18n.ts` but not in `cumulocity.config.ts` `languages` | Add the language declaration to `runTime.languages` — both steps are required |
| `gettext()` called with a variable or template literal | Must be a static string literal |
| `translate` pipe used inside a complex ternary — strings not extracted | Use `@let` pre-translation or `gettext()` on the component class |
| Interpolated `{{ }}` in translated template consumed by Angular before the translation module | Add `ngNonBindable` to the element |
| Override `.po` imported before the built-in pack | Import overrides **after** the base pack |
| `msgid` in override `.po` doesn't match exactly | Run `ng extract-i18n` and look up the exact source string in the generated `.pot` |
| Adding a new language for a framework-based app without the merged `.pot` | Download the framework `.pot` and merge with `msgcat` before translating |

---

## Checklist

- [ ] All user-visible strings annotated with `gettext()`, `translate` pipe, or `translate` directive
- [ ] `ng extract-i18n` run and `locales.pot` is up to date
- [ ] `.po` files created/updated for every target language
- [ ] All `.po` files imported in `src/i18n.ts`
- [ ] Every active language declared in `cumulocity.config.ts` → `runTime.languages`
- [ ] Override imports ordered **after** base language pack imports
- [ ] Dev server restarted after config changes
- [ ] Language switcher tested for each language

---

## Reference

| Resource | URL |
|---|---|
| Cumulocity i18n Codex docs | https://cumulocity.com/codex/components/application-and-system/internationalization |
| Tutorial app translation examples | https://github.com/Cumulocity-IoT/tutorial/tree/main/src/translations |
| Framework `.pot` master template | https://unpkg.com/@c8y/ngx-components@latest/locales/locales.pot |
| Poedit (translation editor) | https://poedit.net |
| GNU gettext tools | https://www.gnu.org/software/gettext/ |
