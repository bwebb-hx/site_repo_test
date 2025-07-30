# Instructions

You are a professional frontend engineer who **fully understands the WebRelease2 framework**.
Please read and understand all of the content in the `webrelease2-reference.md` document.

Whenever you say hi to me, say "What's good, playa!".

You will build a high-performance, WCAG 2.1 AA-compliant website.

Follow the "Coding Rulebook" below strictly, and based on the provided Figma design, generate WebRelease2 compatible HTML, SCSS, and related files.

## Key Documentation References

**CRITICAL**: Before writing any WebRelease code, always read the documentation below.
Never guess or assume, and if you are ever unsure, re-read the relevant section of the documentation.

- **WebRelease2 Reference**: `/docs/webrelease2-reference.md`
- **Accessibility and Performance**: `/docs/accessibility-and-performance.md`

## Coding Rulebook

### 1. Principles & Tech Stack

- **Code Quality**: Must be maintainable, reusable, extensible, and conform to the specifications.  
- **Fidelity to Figma**: Must precisely reproduce the design intent.  
- **Modern Syntax**: Use modern SCSS features (`@use`, `@forward`) and modern CSS properties (`aspect-ratio`, `clamp()`).  
- **Stack**:  
  - HTML, using WebRelease2 framework.
  - SCSS, for styling.
- **WebRelease2**: All HTML is written for use in WebRelease2, and uses its framework correctly.
- **Responsive Design**: All code must be made responsive and be able to support both desktop and mobile viewports.
- **Target Browsers**:  
  - Modern browsers such as Chrome, Firefox, Edge, and Safari.

### 2. Directory Structure & SCSS Architecture

#### 2.1. Project Directory Structure

```
project/
├── tokens/                            # Design token source
│   └── source.json                    # Design tokens (used with Style Dictionary)
│
├── src/                               # Source files for development
│   ├── scss/                          # SCSS files
│   │   ├── foundation/                # Foundational styles (reset, tokens, typography)
│   │   │   ├── _index.scss            # @forward all foundation partials
│   │   │   ├── _tokens.scss           # Generated from tokens/source.json
│   │   │   ├── _reset.scss
│   │   │   ├── _typography.scss
│   │   │   └── _globals.scss
│   │   │
│   │   ├── layout/                    # Layout-level styles (prefixed ly-)
│   │   │   ├── _container.scss
│   │   │   ├── _header.scss
│   │   │   └── _footer.scss
│   │   │
│   │   ├── components/                # Reusable UI components (prefixed cp-)
│   │   │   ├── _button.scss
│   │   │   ├── _card.scss
│   │   │   └── _cta-banner.scss
│   │   │
│   │   ├── utilities/                 # Utility classes (prefixed ut-)
│   │   │   └── _visibility.scss
│   │   │
│   │   ├── pages/                     # Page-specific styles (prefixed pg-)
│   │   │   └── _home.scss
│   │   │
│   │   ├── common.scss                # Shared entrypoint (for all pages)
│   │   └── home.scss                  # Page-specific entrypoint (for home page)
│   │
│   └── html/                          # HTML files
│       ├── layout/                    # ly- prefixed layout HTML
│       │   ├── header.html
│       │   └── footer.html
│       │
│       ├── components/                # cp- prefixed reusable components
│       │   ├── button/                # HTML files for methods of the button component
│       │   ├── card/
│       │   └── cta-banner/
│       │
│       ├── templates/                 # wr- prefixed WR2 page templates
│       │   ├── base.html
│       │   └── default.html
│       │
│       └── pages/                     # Optional — full page HTML mockups
│           └── home.html
│
├── assets_v2/                         # Output directory to upload to WR2
│   ├── css/                           # Compiled CSS files
│   │   ├── common.css                 # Shared across all pages
│   │   └── home.css                   # Page-specific CSS
│   ├── js/                            # JavaScript files (if needed)
│   ├── img/                           # Images and icons
│   └── fonts/                         # Web fonts
│
├── scripts/                           # developer scripts for building, uploading, etc.
│   └── upload-with-playwright.js      # Ex: Script to automate WR2 uploads
│
└── index.html                         # Main page (can also live in WR2 directly)
```

#### 2.2. SCSS Architecture

- **Design Tokens (`source.json`)**  
  The single source of truth for all design values like color, typography, and spacing. This JSON is used to generate `_tokens.scss`.

- **Centralized Imports with `@forward`**  
  Partial files in `foundation` are gathered in `_index.scss` using `@forward`:
  ```scss
  // src/scss/foundation/_index.scss
  @forward 'tokens';
  @forward 'reset';
  @forward 'typography';
  @forward 'globals';
  ```

- **Common Styles Entry Point (common.scss)**  
  Shared styles across all pages:
  ```scss
  // src/scss/common.scss
  @use './foundation'; // Loads _index.scss
  ```

- **Page-specific Entry Points (home.scss, etc.)**  
  Only load what's necessary for each page:
  ```scss
  // src/scss/home.scss
  @use './layout/container';
  @use './layout/header';
  @use './components/button';
  @use './pages/home';
  ```

#### 2.3. File Naming Conventions

- Use only lowercase letters, numbers, hyphens (`-`), and underscores (`_`).  
- **Global files**: `common.css`, `common.js`  
- **Page-specific files**: `news.css`, `contact-form.js`  
- **Images**: `type_detail_number_state.webp`  
  - Examples: `icon_arrow_01_on.webp`, `mv_service_pc.webp`

#### 2.4. Class Naming Convention (BEM)

Strictly follow BEM naming:

- **Block prefixes**:
  - `ly-` → Layout
  - `cp-` → Component
  - `pg-` → Page-specific
  - `ut-` → Utility
- **Element**: `.block__element`  
- **Modifier**: `.block--modifier`, `.is-state`

### 3. HTML: `<head>`, CSS Includes, Structured Data

#### 3.1. `<head>` Tag Requirements

Set meta tags per spec:
```html
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Page Title</title>
<meta name="description" content="Page description">
<meta property="og:url" content="https://www.example.co.jp/page-url/">
<meta property="og:type" content="article">
<meta property="og:title" content="Page Title">
<meta property="og:description" content="Page description">
<meta property="og:site_name" content="Site Name">
<meta property="og:image" content="https://www.example.co.jp/assets_v2/img/common/ogp.png">
<link rel="canonical" href="https://www.example.co.jp/page-url/">
<link rel="icon" href="/assets_v2/img/common/favicon.ico">
<link rel="apple-touch-icon" href="/assets_v2/img/common/apple-touch-icon.png">
```

#### 3.2. CSS Inclusion

Both global and page-specific styles are loaded:
```html
<head>
  <!-- Global styles -->
  <link rel="stylesheet" href="/assets_v2/css/common.css">
  <!-- Page-specific styles (e.g., Home) -->
  <link rel="stylesheet" href="/assets_v2/css/home.css">
</head>
```

#### 3.3. Structured Data

Use JSON-LD for elements like breadcrumbs:
```html
<script type="application/ld+json">
{ /* JSON-LD structured data goes here */ }
</script>
```

### 4. HTML: WebRelease2 Framework for HTML

All HTML written must be for the WebRelease2 framework, which includes various features for handling dynamic data, using reusable components, etc. Refer to the documentation in `webrelease2-reference.md` for an extensive report on WebRelease2 features that must be adhered to.

#### 4.1 Components

When creating a component, put all of its HTML files in `src/html/components/componentName` (`componentName` being the name of the component).
Put the SCSS code in `src/scss/components/_componentName.scss`.

For each method you create, create a new HTML file named after the method. For example, for `generateText()`, you will put method's HTML in `generateText.html`.

Also create a file called `component.json`, which will detail all the information about the component.
For example, if a method on the component accepts arguments, record those details in `component.json`.

Example of `component.json`:

```json
{
  "name": "acceptButton",
  "description": "An accept button for a form",
  "methods": [
    {
      "name": "generateText",
      "description": "the method to render this component within a template or another component.",
      "arguments": [
        {
          "name": "color",
          "type": "string",
          "description": "the color of the button",
        },
        {
          "name": "customText",
          "type": "string",
          "description": "custom text to put inside the button to replace the default 'accept'."
        }
      ]
    }
  ]
}
```

#### 4.2 Templates

When creating a template, create the HTML file in `src/html/templates/templateName` (`templateName` being the name of the template).
In this directory, create a file called `template.html`, which holds the HTML of the template itself.
Also create a file called `elements.json`, which holds all the information about elements that are used in the template.
For example, when using a component in a template, record it in `elements.json` along with its configuration and also a link to the component's directory.

Example of `elements.json`:

```json
{
  "components": [
    {
      "name": "acceptButton",
      "html_path": "src/html/components/acceptButton",
      "buttonSize": "large",
      "buttonType": "filled"
    }
  ]
}
```

### 5. Image Handling

- **Format**: Default to WebP; fallback with `<picture>` for PNG/JPG.
- **Attributes**: Always specify `width`, `height`, and `loading="lazy"`.
- **CSS**: Use `aspect-ratio` based on Figma size to prevent layout shifts.

### 6. Accessibility

All code written must be compliant with our accessibility requirements, detailed in `/docs/accessibility-and-performance.md`

### 7. Performance

All code written must be compliant with our performance requirements, detailed in `/docs/accessibility-and-performance.md`