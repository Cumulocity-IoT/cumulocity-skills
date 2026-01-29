# Cumulocity Codex – Icons

This document defines the **authoritative guidance for using icons**
in Cumulocity UI applications.

All rules and principles in this document are derived from the official
Cumulocity Codex design system.

---

## Purpose of Icons

Icons in Cumulocity are used to:
- help guiding users through complex systems and simplifying interactions

---

## Displaying Icons

### Using the `c8yIcon` directive

Icons must be rendered using the **`c8yIcon` directive**, e.g.:
<i
  c8yIcon="c8y-cockpit"
  class="icon-14"
></i>

This ensures:
- Consistent rendering
- Correct sizing and alignment
- Compatibility with the Codex icon system

Icons should not be embedded as:
- Custom SVGs
- Image files
- Icon fonts outside the Codex system

---

## Finding Available Icons

**Codex reference**
- Icon overview and search:
  https://cumulocity.com/codex/design-system/icons/overview#search-icons

### Guidelines

- Always choose icons from the official Codex icon set
- Use the search to find icons by name or intent
- Prefer well-known, semantically clear icons
- Do not introduce custom icons if a Codex icon already exists

Icons should match:
- The meaning of the action or entity
- The surrounding UI context
- Established Codex usage patterns

---

## Icon Sizes

**Codex reference**
- Icon sizes:
  https://cumulocity.com/codex/design-system/icons/overview#icon-sizes

### Available sizes

Codex defines a fixed set of icon sizes which can be applied by adding it to the class attribute of the <i> tag.

Rules:
- Use only the predefined Codex icon sizes
- Do not scale icons arbitrarily
- Do not override icon size with custom CSS
- Icon size should match the surrounding UI element (e.g. button, list item)

### Sizing principles

- Icons must align visually with text baselines
- Larger icons indicate higher visual emphasis
- Consistency is more important than exact visual fit

---

## Accessibility

### Rules

- Icons must not be the sole means of conveying critical information
- Interactive icons must have accessible labels
- Decorative icons should not distract from content

### Guidelines

- Pair icons with text where clarity is required
- Ensure icon usage supports screen readers and assistive technologies
- Avoid overusing icons in dense layouts

---

## Common Mistakes to Avoid

- Using custom SVGs instead of `c8yIcon`
- Scaling icons with CSS transforms
- Using icons without clear meaning
- Relying on icons alone for important actions
- Mixing icon sizes inconsistently within the same UI context

---

## General Guidance

- Prefer clarity over decoration
- Use icons intentionally and sparingly
- Follow Codex rules even if a custom solution “looks better”
- When in doubt, consult the official Codex icon documentation

Codex icon rules take precedence over personal preference or external icon libraries.