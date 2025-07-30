# Accessibility Requirements (A11y) — WCAG 2.1 AA

- **Alt Text**: Provide appropriate `alt` for all non-decorative images.  
- **Keyboard Navigation**: All interactive elements must be accessible via keyboard. Focus indicators must be visible.  
- **Headings**: Use semantic heading levels (`<h1>` to `<h6>`) based on structure.  
- **Forms**: Use `<label>` for all fields and set `aria-invalid="true"` for errors.  
- **WAI-ARIA**: Use ARIA roles and properties as needed to support screen readers.  
- **Skip Links**: Include a skip link at the top for direct access to main content.

# Performance Requirements

- **File Compression**:
  - CSS should be minified.
  - JS should be uglified.

- **DOM Structure**: Keep tag nesting shallow and markup simple.  
- **Fonts**: Do not use Japanese web fonts; limit to basic Western fonts.  
- **Rendering**:
  - Load CSS in `<head>`.
  - Load JS at end of `<body>` with `async` or `defer`.

- **Remove Unused Code**: Do not include unused scripts or styles.