---
name: Tech Daily Editorial
colors:
  surface: '#fdf8f8'
  surface-dim: '#ddd9d8'
  surface-bright: '#fdf8f8'
  surface-container-lowest: '#ffffff'
  surface-container-low: '#f7f3f2'
  surface-container: '#f1edec'
  surface-container-high: '#ebe7e6'
  surface-container-highest: '#e5e2e1'
  on-surface: '#1c1b1b'
  on-surface-variant: '#444748'
  inverse-surface: '#313030'
  inverse-on-surface: '#f4f0ef'
  outline: '#747878'
  outline-variant: '#c4c7c7'
  surface-tint: '#5f5e5e'
  primary: '#000000'
  on-primary: '#ffffff'
  primary-container: '#1c1b1b'
  on-primary-container: '#858383'
  inverse-primary: '#c8c6c5'
  secondary: '#0041c9'
  on-secondary: '#ffffff'
  secondary-container: '#0356ff'
  on-secondary-container: '#e4e7ff'
  tertiary: '#000000'
  on-tertiary: '#ffffff'
  tertiary-container: '#1c1b1a'
  on-tertiary-container: '#868382'
  error: '#ba1a1a'
  on-error: '#ffffff'
  error-container: '#ffdad6'
  on-error-container: '#93000a'
  primary-fixed: '#e5e2e1'
  primary-fixed-dim: '#c8c6c5'
  on-primary-fixed: '#1c1b1b'
  on-primary-fixed-variant: '#474746'
  secondary-fixed: '#dce1ff'
  secondary-fixed-dim: '#b6c4ff'
  on-secondary-fixed: '#001551'
  on-secondary-fixed-variant: '#0039b3'
  tertiary-fixed: '#e6e2df'
  tertiary-fixed-dim: '#cac6c4'
  on-tertiary-fixed: '#1c1b1a'
  on-tertiary-fixed-variant: '#484645'
  background: '#fdf8f8'
  on-background: '#1c1b1b'
  surface-variant: '#e5e2e1'
typography:
  display-xl:
    fontFamily: Source Serif 4
    fontSize: 64px
    fontWeight: '700'
    lineHeight: 72px
    letterSpacing: -0.02em
  display-xl-mobile:
    fontFamily: Source Serif 4
    fontSize: 40px
    fontWeight: '700'
    lineHeight: 44px
    letterSpacing: -0.01em
  headline-lg:
    fontFamily: Source Serif 4
    fontSize: 40px
    fontWeight: '600'
    lineHeight: 48px
  headline-md:
    fontFamily: Source Serif 4
    fontSize: 32px
    fontWeight: '600'
    lineHeight: 38px
  body-lg:
    fontFamily: Inter
    fontSize: 20px
    fontWeight: '400'
    lineHeight: 32px
  body-md:
    fontFamily: Inter
    fontSize: 16px
    fontWeight: '400'
    lineHeight: 26px
  label-caps:
    fontFamily: Inter
    fontSize: 12px
    fontWeight: '600'
    lineHeight: 16px
    letterSpacing: 0.08em
  caption:
    fontFamily: Inter
    fontSize: 14px
    fontWeight: '400'
    lineHeight: 20px
spacing:
  unit: 4px
  container-max: 1280px
  gutter: 32px
  margin-mobile: 20px
  section-gap: 80px
---

## Brand & Style

This design system is built upon a **Premium Editorial** aesthetic, merging the authoritative weight of traditional broadsheets with the precision of modern technology journalism. It prioritizes clarity, intellectual rigor, and a "Digital Paper" feel.

The style is characterized by:
- **Neo-Traditionalism:** High-contrast serif headlines paired with systematic sans-serif utility.
- **Content-First Minimalism:** Large expanses of whitespace that frame the text, treating every article as a piece of literature.
- **Structural Integrity:** A heavy reliance on thin, crisp dividers and typographic alignment rather than shadows or cards to define hierarchy.
- **Static Elegance:** Motion should be subtle and functional (e.g., a simple fade-in), avoiding bouncy or playful transitions to maintain a serious tone.

## Colors

The palette mimics the physical experience of reading a high-end journal. 

- **Ink & Paper:** The core interface uses `#1A1A1A` (Ink) on `#F9F9F7` (Paper). This creates a softer, more sophisticated contrast than pure black on white, reducing eye strain for long-form reading.
- **Secondary Ink:** Used for captions, bylines, and metadata to create a clear visual step down from the primary narrative.
- **Digital Accents:** A single "Tech Blue" (`#0055FF`) is used sparingly for links, active states, and categorized tags. A secondary "Alert" red is reserved for breaking news or live technical updates.
- **Borders:** Dividers use a very faint version of Ink (approx. 10-15% opacity) to suggest structure without creating "boxes."

## Typography

Typography is the cornerstone of this design system. It utilizes a dual-font strategy to balance heritage and technology.

- **Source Serif 4:** Used for all editorial headings. It provides the "authoritative" voice. For Display sizes, use tighter tracking (-0.02em) to create a denser, more impactful appearance.
- **Inter:** Used for body copy, navigation, and UI elements. Inter's tall x-height ensures maximum legibility in multi-column layouts and data-heavy sidebars.
- **Hierarchy:** Use `label-caps` for section headers (e.g., "SILICON VALLEY," "ARTIFICIAL INTELLIGENCE") to create a distinct visual break from article titles.
- **Leading:** Body text utilizes generous line heights (1.6x) to facilitate a comfortable reading rhythm.

## Layout & Spacing

The layout is governed by a **Strict Editorial Grid**, prioritizing vertical rhythm and clear content columns.

- **Grid System:** A 12-column grid for desktop. Long-form articles should ideally occupy a 6-column or 8-column central span to keep line lengths readable (approx. 65-75 characters).
- **Whitespace:** Use significant vertical padding between sections (`section-gap`) to signify the end of one topic and the beginning of another, mimicking the folded sections of a newspaper.
- **The "Rule of Hairlines":** Instead of using background color blocks to separate content, use 1px horizontal hairlines. This maintains the "Paper" aesthetic.
- **Responsive Behavior:** On mobile, margins reduce to 20px, and typography scales down aggressively to ensure headlines don't break awkwardly.

## Elevation & Depth

This design system avoids all traditional depth markers such as drop shadows, blurs, or gradients. It is a strictly "Flat" system that creates hierarchy through:

- **Layering via Lines:** Content is partitioned by 1px rules (`#1A1A1A` at 10% opacity).
- **Z-Index for Modals:** If a modal or dropdown is necessary, it should use a crisp, 1px solid border with no shadow, appearing to sit directly on top of the paper surface.
- **Tonal Tiers:** Very subtle shifts in background color (e.g., from `#F9F9F7` to `#F2F2F0`) can be used for secondary sidebars or "grey boxes" for data callouts.

## Shapes

To maintain a serious, newspaper-inspired aesthetic, the design system utilizes **Sharp** edges across all elements.

- **Zero Radius:** Buttons, input fields, image containers, and labels must have `0px` border-radius.
- **Visual Impact:** Square corners reinforce the technical and professional nature of the content, contrasting against the more organic forms of the serif typography.

## Components

### Buttons & Links
- **Primary Button:** Solid `#1A1A1A` background, white text, sharp corners. No hover elevation—use a slight opacity shift or a color change to `#333333`.
- **Ghost Button:** 1px black border, sharp corners, no fill.
- **Editorial Link:** Underlined in the accent blue, or a simple "Ink" underline that appears on hover.

### Inputs & Forms
- **Fields:** Bottom-border only (1px) or a full sharp-edged stroke. Place labels in `label-caps` typography above the field.

### Cards & Content
- **Article Card:** No container or shadow. Composed of an image (top), a category label (accent color, all caps), a headline (Serif), and a summary (Sans). Separated from other cards by 1px hairlines.
- **Bylines:** Small `label-caps` for the name, followed by a light-weight date stamp. Use a small vertical pipe `|` as a separator.

### Navigational Elements
- **Masthead:** Large, centered Serif logotype. Navigation links underneath, separated by a thin horizontal rule.
- **Dividers:** 1px solid rules are the primary tool for layout organization.

### Special Editorial Components
- **Pull Quotes:** Large Serif text, centered, with 1px horizontal lines above and below to pull it out of the flow.
- **Data Tables:** Minimalist, no vertical lines, only light horizontal rules to guide the eye. Use monospaced numbers if available for alignment.