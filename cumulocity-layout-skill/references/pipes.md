# Cumulocity Codex – Pipes

Pipes in Angular templates **transform data** before it is displayed.
They are used for formatting, filtering, and data manipulation in a
declarative way directly in templates. Cumulocity provides several
predefined pipes for common needs.

---

## Common Pipes

### Bytes Pipe

**Codex reference:**
https://cumulocity.com/codex/advanced-development/pipes/bytes-pipe/overview

- Formats numeric values as human-readable bytes (e.g., `1024 → 1 KB`).
- Useful for displaying file sizes, memory usage, or storage metrics.

---

### Date Pipe

**Codex reference:**
https://cumulocity.com/codex/advanced-development/pipes/date-pipe/overview

- Formats JavaScript `Date` objects into readable date strings.
- Supports custom formats, locale-aware formatting, and time zones.

---

### File Icon Pipe

**Codex reference:**
https://cumulocity.com/codex/advanced-development/pipes/file-icon-pipe/overview

- Maps file types or extensions to the corresponding **Cumulocity icons**.
- Ensures consistent visual representation of files across the UI.

---

### Humanize Pipe

**Codex reference:**
https://cumulocity.com/codex/advanced-development/pipes/humanize-pipe/overview

- Converts programmatic values (like `camelCase` or `snake_case`) into
  human-readable text.
- Useful for displaying property names, event types, or statuses.

---

### Markdown to HTML Pipe

**Codex reference:**
https://cumulocity.com/codex/advanced-development/pipes/markdown-to-html-pipe/overview

- Transforms **Markdown content** into HTML for display in templates.
- Ensure that rendered HTML content is properly sanitized for security.

---

### Number Pipe

**Codex reference:**
https://cumulocity.com/codex/advanced-development/pipes/number-pipe/overview

- Formats numbers according to locale, decimal places, or currency.
- Useful for dashboards, reports, and metric displays.

---

### User Name Initials Pipe

**Codex reference:**
https://cumulocity.com/codex/advanced-development/pipes/user-name-initials-pipe/overview

- Generates initials from a user’s full name (e.g., `John Doe → JD`).
- Commonly used in avatars, badges, or compact user displays.

---

### Translate Pipe

**Codex reference:**
https://cumulocity.com/codex/components/application-and-system/internationalization/overview

- Supports **internationalization (i18n)** by translating strings in templates.
- Ensures UI is localized according to the user’s language or locale.
- Works together with Cumulocity’s translation files and language keys.

---

## Best Practices

- Always **use pipes declaratively** in templates instead of manipulating
  data imperatively in the component.
- Combine pipes carefully: the output of one pipe becomes the input of the
  next.
- Ensure **accessibility**: formatted values should remain understandable
  for screen readers.
- Use **translate pipes** for all user-facing text to maintain
  localization consistency.

---

## Performance Considerations

**Codex reference:**
https://cumulocity.com/codex/advanced-development/pipes/overview#performance-considerations

- Avoid **expensive computations** in pipes that are executed on each change
  detection cycle.
- Prefer **pure pipes** whenever possible; pure pipes only re-run when the
  input changes, improving performance.
- For **dynamic data streams** or large collections, consider transforming
  the data in the component instead of the template.
- Use **memoization** or caching strategies for pipes that perform
  costly formatting or computation.
- Excessive use of impure pipes may lead to **UI lag** and degraded
  performance in complex dashboards.

---

## Summary

Cumulocity pipes provide a **rich toolkit** for transforming and
formatting data in templates, improving readability, consistency, and
maintainability. The commonly used pipes include:

- Bytes, Date, File Icon, Humanize, Markdown to HTML, Number, User Name Initials, Translate

Use these consistently across your applications for **standardized UI behavior**, and always consider **performance implications** when designing templates.
