# Cumulocity Codex – Forms

This document defines the **authoritative guidance for building forms**
in Cumulocity applications.

Cumulocity forms are built using **Codex components** that are themed on
top of **Bootstrap**, providing consistent styling, behavior, and
accessibility patterns. Developers should rely on Codex components
instead of raw HTML or Bootstrap classes.

All guidance is based on the official **Cumulocity Codex design system**
and accessibility standards.

---

## Form

**Codex reference:**
https://cumulocity.com/codex/components/forms/form/overview

A **form** is a container for input controls, labels, help text, and
actions (submit/cancel). Forms are used to collect data from users in a
structured and accessible way.

### Key principles

- Forms should be **logical and grouped** for clarity.
- All inputs must have a **label**.
- Help text, validation messages, and errors must be **programmatically associated**.
- Forms must be **keyboard navigable**.
- Color should not be the sole means to convey meaning.

---

## Form Group

**Codex reference:**
https://cumulocity.com/codex/components/forms/form-group/overview

A **form group** is a container that wraps a single input control along
with its label, help text, and error messages. It ensures consistent
spacing, alignment, and accessibility across form elements.

### Key principles

- Group each label and input together in a **form group**.
- Include any **help text or validation messages** within the form group.
- Use form groups to organize inputs for **better readability** and **logical focus order**.

---

## Form Elements

After defining the structure with **form** and **form groups**, you can
add the following **form elements**.

---

### Input Fields

**Codex reference:**
https://cumulocity.com/codex/components/forms/input-fields/overview

Use input fields for **short, single-line text input**, such as names,
IDs, or numeric values.

**Accessibility tips**

- Always associate a `<label>` with the input
- Use `aria-describedby` for help and validation messages
- Never use placeholder text as a replacement for the label

---

### Textarea

**Codex reference:**
https://cumulocity.com/codex/components/forms/textarea/overview

Use textareas for **multi-line or free-form input**.

**Accessibility tips**

- Avoid fixed heights that clip content
- Ensure the label clearly describes expected input

---

### Select

**Codex reference:**
https://cumulocity.com/codex/components/forms/select/overview

Use select components for **choosing from a predefined list**.

**Accessibility tips**

- Include a neutral, non-selected default option
- Keep option labels clear and meaningful

---

### Checkboxes and Radio Buttons

**Codex reference:**
https://cumulocity.com/codex/components/forms/checkboxes-and-radio-buttons/overview

- **Checkboxes** allow multiple selections
- **Radio buttons** allow only one selection from a group

**Accessibility tips**

- Group related controls using `<fieldset>` and `<legend>`
- Ensure the legend clearly describes the purpose of the group

---

### Toggle Switch

**Codex reference:**
https://cumulocity.com/codex/components/forms/toggle-switch/overview

Use toggle switches for **binary on/off states**.

**Accessibility tips**

- Must be keyboard accessible
- Clearly indicate what “on” and “off” mean

---

### Date and Time

**Codex reference:**
https://cumulocity.com/codex/components/forms/date-time/overview

Use date and time inputs for **temporal values**.

**Accessibility tips**

- Allow manual keyboard input as well as picker selection
- Clearly communicate expected date/time formats

---

### Range Input

**Codex reference:**
https://cumulocity.com/codex/components/forms/range-input/overview

Use range inputs for **bounded numeric values**.

**Accessibility tips**

- Always communicate minimum, maximum, and current values
- Do not rely on color alone

---

### Drop Area

**Codex reference:**
https://cumulocity.com/codex/components/forms/drop-area/overview

Use drop areas for **drag-and-drop file uploads**.

**Accessibility tips**

- Must be keyboard focusable
- Provide a click-based fallback

---

### Editor

**Codex reference:**
https://cumulocity.com/codex/components/forms/editor/overview

Use editors for **structured or formatted text input**.

**Accessibility tips**

- Ensure assistive technologies recognize the editor role
- Provide clear instructions for usage

---

### File Picker

**Codex reference:**
https://cumulocity.com/codex/components/forms/file-picker/overview

Use file pickers for **explicit file selection**.

**Accessibility tips**

- Clearly describe accepted file types
- Do not auto-submit on selection

---

### Input Groups

**Codex reference:**
https://cumulocity.com/codex/components/forms/input-group/overview

Use input groups to **provide context**, e.g., units or symbols, for an input.

**Accessibility tips**

- Ensure screen readers announce the full input context
- Avoid purely decorative addons

---

### Extendable Input List

**Codex reference:**
https://cumulocity.com/codex/components/forms/extendable-input-list/overview

Use extendable input lists for **dynamic collections of inputs**.

**Accessibility tips**

- Add/remove actions must be keyboard accessible
- Announce dynamic changes when possible

---

## Final Guidance

- Always use **Codex components** instead of raw HTML controls
- Bootstrap is only an implementation detail
- Accessibility rules are **mandatory for all inputs**
- Use **form** and **form-group** as the foundation before adding individual inputs
- When in doubt, refer to the **Codex links** above
