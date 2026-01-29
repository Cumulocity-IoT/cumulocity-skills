# Cumulocity Codex – Foundations

This document defines the **authoritative layout and design foundations**
for Cumulocity UI development.

All guidance in this document is derived from the official
Cumulocity Codex design system.

---

## Typography

**Codex reference**
- https://cumulocity.com/codex/design-system/foundations/typography/

### Principles

- Typography must be consistent, readable, and hierarchical
- Semantic HTML elements define structure and meaning
- Visual styling must not replace semantic correctness

### Rules

- Use `h1–h6` to reflect document hierarchy, not visual size
- Do not skip heading levels
- Use `p`, `ul`, `li`, and `label` for text content
- Avoid using `div` or `span` for text semantics
- Avoid inline styles for font sizing or spacing

### Common violations

- Multiple `h1` elements in a single view
- `<br>` tags used for spacing
- Hard-coded font sizes
- Styling text visually instead of semantically

---

## Grid and Vertical Rhythm

**Codex reference**
- https://cumulocity.com/codex/design-system/foundations/grid/

### Principles

- Layouts must align to a consistent grid
- Vertical spacing should be predictable and repeatable
- Content should flow naturally without pixel-level fixes

### Rules

- Use structured containers and grid layouts
- Maintain consistent spacing between similar elements
- Avoid empty elements for spacing
- Avoid arbitrary margin values
- Do not rely on absolute positioning for layout

---

## Elevation and Shadows

**Codex reference**
- https://cumulocity.com/codex/design-system/foundations/elevation/

### Principles

- Elevation communicates hierarchy and interactivity
- Shadows must be subtle and intentional
- Flat layouts are preferred unless elevation adds meaning

### Allowed use cases

- Cards
- Modals
- Dropdowns
- Floating or interactive elements

### Rules

- Do not apply elevation to static layout containers
- Avoid dramatic or heavy shadows
- Keep elevation usage consistent across the UI

---

## Motion and Animation

**Codex references**
- Foundations overview:
  https://cumulocity.com/codex/design-system/foundations/motion/
- CSS utilities:
  https://cumulocity.com/codex/design-system/css-utilities/motion/overview/

### Principles

- Motion supports understanding and feedback
- Animations must be subtle and purposeful
- Prefer Codex motion utilities over custom animations

### Allowed use cases

- State changes
- Expanding and collapsing content
- User feedback after actions

### Rules

- Avoid continuous or looping animations
- Keep animation durations short
- Do not delay usability with motion
- Respect reduced-motion preferences
- Avoid large or distracting movements

---

## General Guidance

- Prefer clarity over cleverness
- Avoid over-engineering layouts
- Simplicity and consistency are more important than visual flair
- Codex rules take precedence over personal preference

When in doubt, always defer to the official Codex documentation linked above.