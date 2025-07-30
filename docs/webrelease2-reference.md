# WebRelease2 - Comprehensive Technical Reference

## 1. Expression Syntax

**Purpose**: WebRelease2 uses `%expression%` syntax for dynamic content insertion, allowing templates to output dynamic data, perform calculations, and call functions.

**When to use**: Whenever you need to insert dynamic content, reference page elements, or perform operations within template HTML.

### Basic Expression Types

- **Element references**: `%elementName%` - Access form fields, content elements, and page data
- **Resource references**: `%resourceName%` - Reference images, CSS files, and other assets
- **Function calls**: `%functionName(params)%` - Use built-in functions for formatting, calculations
- **Method calls**: `%methodName(args)%` - Call custom template methods
- **Arithmetic operations**: `%1 + 1%` - Perform mathematical calculations inline
- **Nested expressions**: `%pageTitle(selectedPage())%` - Combine functions and references

### Escaping

- Use `%%` to output a literal `%` character when you need to display percentage symbols in content

## 2. Element References

**Purpose**: Access data from form elements, page content, and structured data within your WebRelease2 pages.

**When to use**:

- Displaying user input from forms
- Accessing page metadata and content
- Working with structured data like addresses, contact info
- Building dynamic navigation from page hierarchies

### Basic Syntax

```html
%elementName%
<!-- Simple element - displays the element's value -->
%groupElement.child%
<!-- Nested element - access child within a group -->
%arrayElement[0]%
<!-- Array access - get specific item from list -->
%addresses[1].name%
<!-- Nested array access - get property of array item -->
```

**Key concepts**:

- Dot notation (`.`) accesses nested properties
- Square brackets (`[]`) access array elements by index (0-based)
- References resolve to different value types based on element type

### Element Value Types

| Element Type      | Reference Value             |
| ----------------- | --------------------------- |
| Single-line Text  | Input string                |
| Multi-line Text   | Input string                |
| WYSIWYG Editor    | HTML content string         |
| Radio Button      | Selected option text        |
| Checkbox          | CheckBox object             |
| Date/Time         | Milliseconds since 1970/1/1 |
| Table of Contents | Page object array           |
| Link              | Linked page URL             |
| Image             | Image URL                   |
| Attached File     | File URL                    |

## 3. Conditional Logic

**Purpose**: Control which content appears based on data availability, user choices, or other conditions.

**When to use**:

- Show/hide content based on form selections
- Display different layouts for different content types
- Handle optional data fields gracefully
- Create responsive content that adapts to available data

### wr-if / wr-then / wr-else - Basic Conditional Rendering

**Use cases**: Simple true/false decisions, checking if data exists, binary content switching.

```xml
<!-- Basic conditional -->
<wr-if condition="isNotNull(picture)">
    <img src="%picture%" alt="%altText%" />
</wr-if>

<!-- With then/else -->
<wr-if condition="layout == \"Left\"">
    <wr-then>
        <img src="%picture%" style="float: left;" />
    </wr-then>
    <wr-else>
        <img src="%picture%" style="float: right;" />
    </wr-else>
</wr-if>
```

### wr-switch / wr-case / wr-default - Multi-way Branching

**Purpose**: Handle multiple possible values efficiently, similar to switch statements in programming.

**When to use**:

- Displaying different content based on category/type
- Converting codes to readable text (status codes, month numbers)
- Template layout switching based on page type

**Key features**: Only first matching case executes, no fall-through behavior, optional default case.

```xml
<wr-switch value="number(formatDate(currentTime(), \"M\"))">
    <wr-case value="1">January</wr-case>
    <wr-case value="2">February</wr-case>
    <wr-case value="3">March</wr-case>
    <wr-default>Unknown Month</wr-default>
</wr-switch>
```

### wr-conditional / wr-cond - Sequential Condition Checking

**Purpose**: Test multiple conditions in sequence, executing only the first match.

**When to use**:

- Priority-based content display
- Fallback content chains
- Complex conditional logic with multiple alternatives

**Best practice**: Use the last `wr-cond` with `condition="true"` as a default/fallback case.

```xml
<wr-conditional>
    <wr-cond condition="isNotNull(startDate)">
        Event starts: %formatDate(startDate, "yyyy/MM/dd")%
    </wr-cond>
    <wr-cond condition="isNotNull(endDate)">
        Event ends: %formatDate(endDate, "yyyy/MM/dd")%
    </wr-cond>
    <wr-cond condition="true">
        No event dates available
    </wr-cond>
</wr-conditional>
```

## 4. Loops

**Purpose**: Generate repeated HTML content by iterating through data collections, strings, or performing fixed-count operations.

**When to use**:

- Display lists of items (products, articles, addresses)
- Generate table rows from data arrays
- Create navigation menus from page hierarchies
- Process each character in a string
- Generate numbered sequences or pagination

### wr-for - Iteration and Looping

**Key attributes**:

- `list`: Array or collection to iterate over
- `string`: String to process character by character
- `times`: Fixed number of iterations
- `variable`: Variable name for current item
- `count`: 1-based counter (optional)
- `index`: 0-based index (optional)

**Important**: Cannot combine `list`, `string`, and `times` in the same loop.

```xml
<!-- List iteration -->
<wr-for list="addresses" variable="address" count="i" index="j">
    <tr>
        <td>%i%</td>                    <!-- 1-based counter -->
        <td>%j%</td>                    <!-- 0-based index -->
        <td>%address.postalCode%</td>
        <td>%address.address%</td>
    </tr>
</wr-for>

<!-- String iteration -->
<wr-for string="text" variable="char" count="i">
    Character %i%: %char%<br/>
</wr-for>

<!-- Fixed iterations -->
<wr-for times="5" variable="x" count="i">
    Iteration %i%: %x%<br/>
</wr-for>
```

### wr-break - Loop Control

**Purpose**: Exit loops early based on conditions or after processing a certain number of items.

**When to use**:

- Limit results to first N items
- Stop processing when a condition is met
- Implement "show more" functionality
- Performance optimization for large datasets

**Best practice**: Combine with wr-if for conditional breaking with additional output.

```xml
<wr-for list="items" variable="item" count="i">
    <p>%item.name%</p>
    <!-- Conditional break -->
    <wr-break condition="i == 3"/>

    <!-- Unconditional break with output -->
    <wr-if condition="i == 5">
        <p>Showing first 5 items only</p>
        <wr-break/>
    </wr-if>
</wr-for>
```

## 5. Variable Management

**Purpose**: Create temporary storage for data manipulation, filtering, and complex template logic.

**When to use**:

- Filter data collections based on criteria
- Accumulate results from loops
- Store computed values for reuse
- Build complex data structures during template processing

### wr-variable - Variable Declaration

**Key concepts**:

- All variables are stored as arrays internally
- Can be initialized empty, with a value, or with generated content
- Scope is within the current template/method
- Variables can be referenced like template elements

```xml
<!-- Empty variable -->
<wr-variable name="results"/>

<!-- Variable with initial value -->
<wr-variable name="counter" value="0"/>

<!-- Variable with complex content -->
<wr-variable name="pageList">
    <wr-for list="index" variable="x">
        %pageTitle(x)%<br/>
    </wr-for>
</wr-variable>
```

### wr-append - Adding Data to Variables

**Purpose**: Build arrays by adding items one at a time, typically used for filtering or collecting data during loops.

**When to use**:

- Filter items from a larger collection
- Collect matching results during iteration
- Build custom data structures
- Accumulate values based on conditions

**Common pattern**: Initialize empty variable, loop through data, conditionally append matching items, then process the filtered results.

```xml
<wr-variable name="tokyoBranches"/>

<wr-for list="branchList" variable="branch">
    <wr-if condition="branch.region == \"Tokyo\"">
        <wr-append name="tokyoBranches" value="branch"/>
    </wr-if>
</wr-for>

<!-- Using the filtered results -->
<wr-for list="tokyoBranches" variable="branch">
    <td>%branch.name%</td>
    <td>%branch.phone%</td>
</wr-for>
```

### wr-clear - Resetting Variables

**Purpose**: Reset a variable to empty state, useful for reusing variables or clearing data between operations.

**When to use**:

- Reuse variables in complex templates
- Clear accumulated data before new operations
- Reset state in methods that might be called multiple times

**Note**: Only clears variable contents, doesn't delete the variable or affect page elements.

```xml
<wr-clear name="results"/>
```

## 6. Operators

**Purpose**: Perform comparisons, logical operations, and calculations within template expressions and conditions.

**When to use**:

- Conditional logic in wr-if statements
- Data validation and filtering
- Mathematical calculations
- Complex boolean expressions

### Comparison Operators

- `==` Equal to - Test for equality (supports type conversion)
- `!=` Not equal to - Test for inequality
- `<` Less than - Numeric/string comparison
- `<=` Less than or equal to
- `>` Greater than - Numeric/string comparison
- `>=` Greater than or equal to

### Logical Operators

- `&&` Logical AND - Both conditions must be true
- `||` Logical OR - Either condition can be true

### Arithmetic Operators

- `+` Addition - Numeric addition or string concatenation
- `-` Subtraction - Numeric subtraction
- `*` Multiplication - Numeric multiplication
- `/` Division - Basic division (use `divide()` function for precision)

**Type conversion notes**:

- Mixed types are converted to numeric for comparison
- Use `number()` function for strict numeric comparison
- Use `string()` function for strict string comparison

### Type Conversion Examples

```xml
<wr-if condition="number(price) > 1000">
    Expensive item
</wr-if>

<wr-if condition="string(category) == \"electronics\"">
    Electronic device
</wr-if>
```

## 7. Methods

**Purpose**: Create reusable template functions for complex logic, HTML generation, and data processing.

**When to use**:

- Reusable HTML components (cards, buttons, forms)
- Complex data transformations
- Encapsulate business logic
- Create template libraries and shared functionality

**Key features**:

- Support multiple parameters
- Can return values using wr-return
- Can be recursive
- Can be private (template-only) or public
- Access to all template variables and functions

### Method Definition

**Syntax**: `methodName(param1, param2) { template content }`

**Best practices**: Use descriptive names, keep methods focused on single responsibilities, document complex methods with comments.

```xml
<!-- Method definition in template -->
drawImage(img, alt) {
    <img src="%img%" alt="%alt%" class="responsive-image"/>
}

formatPrice(price, currency) {
    <span class="price">%currency%%price%</span>
}
```

### Method Usage

**Calling methods**: Use standard function call syntax within expressions: `%methodName(arg1, arg2)%`

```xml
%drawImage(productImage, productName)%
%formatPrice(itemPrice, "¥")%
```

### Method with Return Value

**Purpose**: Create methods that process data and return results for use in other parts of the template.

**Common patterns**:

- Data filtering and transformation
- Conditional data processing
- Building structured results from complex logic

```xml
getNewsPages() {
    <wr-variable name="result"/>
    <wr-for list="index" variable="page">
        <wr-if condition="page.category == \"news\"">
            <wr-append name="result" value="page"/>
            <wr-if condition="count(result) >= 5">
                <wr-return value="result"/>
            </wr-if>
        </wr-if>
    </wr-for>
    <wr-return value="result"/>
}
```

## 8. Components

**Purpose**: Create reusable, modular content blocks that can be embedded within templates and other components. Components provide a way to organize template logic into maintainable, reusable units.

**When to use**: 
- Create reusable HTML patterns (cards, navigation, forms)
- Modularize complex template logic
- Build component libraries for consistent design
- Enable content selection through selectors
- Centralize maintenance of common UI elements

**Key concepts**: 
- Components are template-like structures but cannot directly create pages
- Must be embedded within templates or other components
- Content generation occurs through component methods
- Support their own elements, resources, and methods
- Can be combined with selectors for dynamic content selection

### Component Structure

**Basic component anatomy**:
- **Elements**: Data fields specific to the component (text, images, selections)
- **Resources**: Component-specific assets (CSS, images, scripts)
- **Methods**: Functions that generate HTML output (typically `generateText()`)
- **Configuration**: Name, folder location, description, and settings

### Creating Components

**Component creation workflow**:
1. Define component elements (data fields)
2. Add component resources if needed
3. Implement component methods (especially `generateText()`)
4. Embed component in templates using component elements

**Example component definition**:
```xml
<!-- Component: "Image with Text" -->
<!-- Elements: picture (Image), layout (Radio), altText (Text), text (Multiline Text) -->

<div class="image-text-component">
    <wr-if condition="isNotNull(picture)">
        <wr-if condition="layout == \"Left\"">
            <wr-then>
                <img src="%picture%" alt="%altText%" style="float: left; margin-right: 20px;" />
            </wr-then>
            <wr-else>
                <img src="%picture%" alt="%altText%" style="float: right; margin-left: 20px;" />
            </wr-else>
        </wr-if>
    </wr-if>
    <div class="text-content">
        %text%
    </div>
    <div style="clear: both;"></div>
</div>
```

### Using Components in Templates

**Basic component usage**:
1. Call the component's method to generate content

**Template integration pattern**:
```xml
<!-- In template with component element named "contentBlock" -->
<div class="content-section">
    %contentBlock.selectedValue().generateText()%
</div>
```

**Component element reference**:
```xml
<!-- Access component element data -->
%componentElement.elementName%

<!-- Call component methods -->
%componentElement.methodName(parameters)%

<!-- Common pattern for content generation -->
%componentElement.selectedValue().generateText()%
```

### Components with Selectors

**Purpose**: Selectors enable dynamic selection between different component types within a single template element.

**When to use**: 
- Provide content authors with multiple layout options
- Create flexible content areas that can display different component types
- Build adaptive templates that change based on content needs

**Selector implementation**:
```xml
<!-- Template with selector element "part" -->
<!-- Selector configured with multiple component options -->

<section class="flexible-content">
    <wr-for list="part" variable="section">
        <!-- Renders selected component type -->
        %section.selectedValue().generateText()%
    </wr-for>
</section>
```

**Benefits of selector pattern**:
- Authors can choose appropriate component for each content section
- Single template supports multiple content presentation styles
- Easy to add new component types without template modification
- Consistent interface for different content types

### Component Best Practices

**Design principles**:
- **Single responsibility**: Each component should handle one specific content type or layout
- **Parameterization**: Use component elements to make components flexible and reusable
- **Method naming**: Use descriptive method names, `generateText()` is conventional for main output
- **Error handling**: Include validation in component methods for required elements
- **Resource management**: Keep component-specific assets within component resources

**Common component patterns**:

1. **Content Cards**:
```xml
<div class="card">
    <wr-if condition="isNotNull(image)">
        <img src="%image%" alt="%title%" class="card-image" />
    </wr-if>
    <div class="card-content">
        <h3>%title%</h3>
        <p>%description%</p>
        <wr-if condition="isNotNull(link)">
            <a href="%link%" class="card-link">Read More</a>
        </wr-if>
    </div>
</div>
```

2. **Ordered Lists**:
```xml
<ol class="ordered-list">
    <wr-for list="items" variable="item">
        <li>%item%</li>
    </wr-for>
</ol>
```

3. **Navigation Menus**:
```xml
<nav class="component-nav">
    <ul>
        <wr-for list="menuItems" variable="item">
            <li>
                <a href="%item.url%">%item.title%</a>
            </li>
        </wr-for>
    </ul>
</nav>

```

**Component organization**:
- Group related components in folders
- Use descriptive component names
- Document component elements and their purposes
- Test components with various data scenarios
- Consider component dependencies and relationships

## 9. Resources

**Purpose**: Manage and reference static assets like images, CSS files, JavaScript, and other files used in templates.

**When to use**:

- Template-specific styling and scripts
- Images and media files
- Any static assets needed by the template

### Template Resources vs Site Resources

- **Template Resources**: Stored in template directory, template-specific
- **Site Resources**: Available across the entire site
- **Priority**: Elements > Template Resources > Site Resources

### Resource References

**Syntax**: Use resource name within expressions: `%resourceName%`

**Best practices**:

- Use descriptive resource names
- Avoid conflicts with element names
- Prefer resource references over hardcoded URLs for maintainability

```xml
<!-- Resource reference -->
<img src="%goldfish%" alt="Goldfish image"/>
<link rel="stylesheet" href="%main-style%"/>

<!-- Priority order: Elements > Template Resources > Site Resources -->
```

## 10. Error Handling and Control

**Purpose**: Implement validation, error checking, and controlled template execution flow.

**When to use**:

- Validate required form fields
- Check data integrity before processing
- Provide user-friendly error messages
- Prevent template processing with invalid data

### wr-error - Template Error Generation

**Purpose**: Stop template processing and display error messages when conditions aren't met.

**Behavior**:

- Stops content generation immediately
- Shows error message in preview mode
- Logs errors in FTP generation records
- HTML in error messages is automatically escaped

**Best practice**: Use descriptive error messages that help users understand what's wrong and how to fix it.

```xml
<wr-error condition="isNull(emailAddress)">
    Email address is required.
</wr-error>

<!-- Unconditional error -->
<wr-error>
    This template is under maintenance.
</wr-error>
```

### wr-return - Method Return Values

**Purpose**: Return values from methods and exit method execution early.

**When to use**:

- Return processed data from methods
- Early method termination based on conditions
- Provide default values when data is unavailable
- Control method execution flow

**Key features**:

- Can return variables, computed values, or static content
- Exits method immediately when encountered
- Essential for methods that process and transform data

```xml
<!-- In methods -->
<wr-if condition="count(results) == 0">
    <wr-return value="\"No results found\""/>
</wr-if>
<wr-return value="results"/>
```

## 11. Comments

**Purpose**: Add documentation and notes within templates without affecting output.

**When to use**:

- Document complex template logic
- Add development notes and TODOs
- Temporarily disable template sections
- Explain business rules and data relationships

### Comment Syntax

**Two formats available**:

- `<wr-->content</wr-->` - Primary comment syntax
- `<wr-comment>content</wr-comment>` - Alternative syntax

**Features**:

- Support multi-line comments
- Can nest different comment types for two-level commenting
- Completely removed from generated output
- Cannot nest same comment type directly

```xml
<wr-->
This is a comment and will not appear in output.
Multiple lines are supported.
</wr-->

<wr-comment>
Alternative comment syntax.
</wr-comment>

<!-- Nested comments -->
<wr-->
First level comment
    <wr-comment>
    Second level comment
    </wr-comment>
</wr-->
```

## 12. Functions

**Purpose**: WebRelease2 provides 91+ built-in functions for data manipulation, formatting, and template operations.

**When to use**:

- Format dates and numbers for display
- Manipulate strings and text content
- Perform calculations and data validation
- Access page and site metadata
- Check data availability and types

**Function categories**:

- **Date/Time manipulation**: `currentTime()`, `formatDate()` - Format dates, get current time
- **String processing**: `string()`, `length()`, `substring()` - Text manipulation and formatting
- **Mathematical operations**: `number()`, `divide()`, `setScale()` - Precise calculations
- **Page operations**: `pageTitle()`, `pageURL()` - Access page metadata
- **Utility functions**: `isNull()`, `isNotNull()`, `count()` - Data validation and checks

### Function Examples

**Best practices**:

- Use appropriate functions for data types (string() for text, number() for calculations)
- Chain functions for complex operations
- Refer to function index for complete parameter specifications

```xml
%formatDate(currentTime(), "yyyy/MM/dd (E)")%
%pageTitle()%
%count(addresses)%
%isNotNull(description)%
```

## 13. Complete Template Example

**Purpose**: Demonstrates real-world usage of WebRelease2 features in a complete, functional template.

**Features demonstrated**:

- Conditional content rendering
- Multi-way page type switching
- Data filtering and variable management
- Loop control and item limiting
- Error handling and validation
- Resource references and method calls
- Component usage with selectors

**Template structure**: Header with conditional image, main content area with different layouts based on page type, component integration, error checking for data integrity.

```xml
<!DOCTYPE html>
<html>
<head>
    <title>%pageTitle()%</title>
    <link rel="stylesheet" href="%main-css%"/>
</head>
<body>
    <wr-- Page header with conditional navigation -->
    <header>
        <h1>%siteName%</h1>
        <wr-if condition="isNotNull(headerImage)">
            <img src="%headerImage%" alt="Header"/>
        </wr-if>
        
        <wr-- Component usage: Navigation component -->
        <wr-if condition="isNotNull(mainNavigation)">
            %mainNavigation.selectedValue().generateText()%
        </wr-if>
    </header>

    <wr-- Main content area -->
    <main>
        <wr-switch value="pageType">
            <wr-case value="news">
                <wr-- News page layout -->
                <wr-for list="articles" variable="article" count="i">
                    <article>
                        <h2>%article.title%</h2>
                        <time>%formatDate(article.date, "yyyy/MM/dd")%</time>
                        <p>%article.summary%</p>
                    </article>
                    <wr-break condition="i >= 5"/>
                </wr-for>
            </wr-case>

            <wr-case value="product">
                <wr-- Product page layout -->
                <wr-variable name="expensiveItems"/>
                <wr-for list="products" variable="product">
                    <wr-if condition="number(product.price) > 10000">
                        <wr-append name="expensiveItems" value="product"/>
                    </wr-if>
                </wr-for>

                <h2>Premium Products</h2>
                <wr-for list="expensiveItems" variable="item">
                    %drawProductCard(item.name, item.price, item.image)%
                </wr-for>
            </wr-case>

            <wr-default>
                <wr-- Default page layout with flexible content -->
                <h2>%pageTitle%</h2>
                <div class="content">
                    <wr-- Component usage: Flexible content sections -->
                    <wr-for list="contentSections" variable="section">
                        %section.selectedValue().generateText()%
                    </wr-for>
                </div>
            </wr-default>
        </wr-switch>
    </main>

    <wr-- Error checking -->
    <wr-error condition="isNull(content) && pageType != \"news\"">
        Page content is missing.
    </wr-error>
</body>
</html>
```

## Summary

This comprehensive reference covers all major WebRelease2 template features with practical examples optimized for AI-assisted development. Each section includes:

- **Purpose**: What the feature does and why it exists
- **When to use**: Specific scenarios and use cases
- **Best practices**: Recommended approaches and common patterns
- **Technical details**: Syntax, parameters, and implementation examples

**Key WebRelease2 concepts for AI developers**:

1. **Static generation**: Templates are processed server-side to generate static HTML
2. **Expression-based**: `%expression%` syntax for all dynamic content
3. **Array-centric**: Variables are stored as arrays, supporting complex data manipulation
4. **Type-flexible**: Automatic type conversion with explicit conversion functions
5. **Method-supported**: Reusable template functions for complex logic
6. **Resource-aware**: Built-in asset management with priority-based resolution
7. **Component-driven**: Modular, reusable content blocks with their own elements and methods
8. **Selector-enabled**: Dynamic component selection for flexible content authoring