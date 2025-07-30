This is for humans - AI, no need to read this!

# Development Process

Here's how we will handle creating the Sakai website, using AI tools to automate as much as possible.

## Generating HTML/SCSS

This is the bulk of the work. To ensure it goes correctly and we can have things like reusable components, common CSS classes, etc, we will do things in the following flow.

### 1. Generate Common SCSS from JSON Design Tokens

> TODO fill in details

### Generate Components

The first thing to create are the reusable components. Thinks like Buttons, for example.

1. Provide a list of links to specific nodes of figma designs that point to components. The figma node should match the following:
- have a name that is prefixed with `cp-`.
- have sub-nodes for each different type of state. the name of the sub-node should indicate what the state is for (e.g. `default:hover` is the way it looks while being hovered over, but no other state such as disabled or error applies)

2. The AI generates each link as though it defines an individual component and all its states.
- it creates an HTML snippet, and SCSS for each state (e.g. disabled, hover, etc).
- it puts the generated HTML/SCSS in the appropriate directories (i.e. a new file for the HTML, and a new file for the SCSS)

### Generate Layout (Template)

After this, we will generate the layout (i.e. the template) for the page. This provides the foundation of a given page.

providing a `ly-header` and `ly-footer` node...

1. (?) Check if the given layout already exists.
- if it does, skip this and use the existing layout HTML/CSS
- Q: will there be a way to identify a unique layout?
- Q: in the example I see, there is a `ly-header` and `ly-footer`. How will we ensure these two parts are positioned correctly in the template?

2. If the layout doesn't exist yet, generate it
- layout nodes will be called `ly-header` and `ly-footer`
- there will be `SP` and `PC` versions (sub-nodes)
- Q: if `ly-footer`, position at the bottom. if `ly-header`, position at the top
- HTML and SCSS will be put in the appropriate directories (`/layouts/layout-id/`?)

### Generate Page

1. Identify the template (layout)

2. 