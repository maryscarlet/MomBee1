---
name: Nurture & Glow
colors:
  surface: '#fcf9f8'
  surface-dim: '#dcd9d9'
  surface-bright: '#fcf9f8'
  surface-container-lowest: '#ffffff'
  surface-container-low: '#f6f3f2'
  surface-container: '#f0eded'
  surface-container-high: '#eae7e7'
  surface-container-highest: '#e4e2e1'
  on-surface: '#1b1c1c'
  on-surface-variant: '#5d3f41'
  inverse-surface: '#303030'
  inverse-on-surface: '#f3f0f0'
  outline: '#926e70'
  outline-variant: '#e7bcbe'
  surface-tint: '#be003b'
  primary: '#b90039'
  on-primary: '#ffffff'
  primary-container: '#e8004a'
  on-primary-container: '#fffbff'
  inverse-primary: '#ffb2b7'
  secondary: '#745b00'
  on-secondary: '#ffffff'
  secondary-container: '#fecb17'
  on-secondary-container: '#6f5700'
  tertiary: '#5e5b5c'
  on-tertiary: '#ffffff'
  tertiary-container: '#777475'
  on-tertiary-container: '#fffbff'
  error: '#ba1a1a'
  on-error: '#ffffff'
  error-container: '#ffdad6'
  on-error-container: '#93000a'
  primary-fixed: '#ffdadb'
  primary-fixed-dim: '#ffb2b7'
  on-primary-fixed: '#40000e'
  on-primary-fixed-variant: '#91002b'
  secondary-fixed: '#ffe08d'
  secondary-fixed-dim: '#f2c000'
  on-secondary-fixed: '#241a00'
  on-secondary-fixed-variant: '#584400'
  tertiary-fixed: '#e7e1e2'
  tertiary-fixed-dim: '#cac5c6'
  on-tertiary-fixed: '#1d1b1c'
  on-tertiary-fixed-variant: '#494647'
  background: '#fcf9f8'
  on-background: '#1b1c1c'
  surface-variant: '#e4e2e1'
typography:
  headline-lg:
    fontFamily: Noto Sans
    fontSize: 30px
    fontWeight: '700'
    lineHeight: 40px
  headline-lg-mobile:
    fontFamily: Noto Sans
    fontSize: 24px
    fontWeight: '700'
    lineHeight: 32px
  headline-md:
    fontFamily: Noto Sans
    fontSize: 20px
    fontWeight: '600'
    lineHeight: 28px
  body-lg:
    fontFamily: Inter
    fontSize: 18px
    fontWeight: '400'
    lineHeight: 28px
  body-md:
    fontFamily: Inter
    fontSize: 16px
    fontWeight: '400'
    lineHeight: 24px
  label-md:
    fontFamily: Inter
    fontSize: 14px
    fontWeight: '600'
    lineHeight: 20px
    letterSpacing: 0.02em
  label-sm:
    fontFamily: Inter
    fontSize: 12px
    fontWeight: '500'
    lineHeight: 16px
rounded:
  sm: 0.25rem
  DEFAULT: 0.5rem
  md: 0.75rem
  lg: 1rem
  xl: 1.5rem
  full: 9999px
spacing:
  base: 8px
  container-margin: 20px
  gutter: 16px
  stack-sm: 8px
  stack-md: 16px
  stack-lg: 24px
  section-gap: 40px
---

## Brand & Style

The design system is crafted to evoke feelings of safety, warmth, and modern professional care for mothers and infants in Bangladesh. The brand personality is **Nurturing, Reliable, and Sophisticated**. 

The visual style blends **Modern Minimalism** with **Tactile Warmth**. It avoids the clinical coldness of traditional medical apps by using soft, warm-toned backgrounds and rounded surfaces, while maintaining a premium feel through generous whitespace and precise typography. The interface should feel like a supportive companion—calm and uncluttered—ensuring that information is easily digestible for busy parents.

Key attributes include:
- **Human-Centric:** Focus on photography of real moments and soft, organic shapes.
- **Trustworthy:** A clean, organized structure that conveys medical and developmental expertise.
- **Cultural Resonance:** Optimized for Bengali script readability and local preferences for vibrant yet harmonious color palettes.

## Colors

This design system uses a palette that balances high-energy action colors with soothing foundational tones. 

- **MomBee Pink (#F80C51):** The primary driver for action. Used for primary buttons, active navigation states, and critical health tracking indicators.
- **MomBee Yellow (#FECB16):** Used as a secondary highlight to denote "joy" and "growth." Ideal for baby milestones, tips, and positive progress bars.
- **Warm Neutrals:** The background strategy utilizes `#FFF9FA` (Warm Blush) for maternal-focused screens and `#FFF6D6` (Creamy Sun) for baby-centric sections. This subtle color-coding helps users subconsciously navigate the app's dual purpose.
- **Typography & UI:** Deep charcoal (`#2D2D2D`) is used for text to ensure high contrast against warm backgrounds without the harshness of pure black.

## Typography

The typography system is designed for bilingual excellence. **Noto Sans Bengali** provides a clear, modern, and highly legible experience for Bangla text, maintaining the correct x-height and stroke weight to feel premium. **Inter** is utilized for English numerals and UI labels for a technical, precise feel.

- **Scale:** Headings use a slightly tighter line-height to feel impactful, while body text uses a generous 1.5x line-height to improve readability during late-night feeding sessions or stressful moments.
- **Hierarchy:** Use bold weights for headers to establish a clear information scent. For Bangla text, ensure weights are never too thin, as the script complexity requires slightly more "ink" to remain legible on mobile screens.

## Layout & Spacing

This design system follows a **Dynamic Fluid Layout** optimized for the "one-handed" mobile usage common among parents. 

- **Grid:** A 4-column mobile grid with 20px side margins and 16px gutters.
- **Rhythm:** An 8px base unit governs all spacing.
- **White Space:** We prioritize "breathable" layouts. Content cards should be separated by at least 24px (stack-lg) to avoid a cluttered or overwhelming appearance. 
- **Touch Targets:** All interactive elements maintain a minimum hit area of 48x48px, even if their visual representation is smaller.

## Elevation & Depth

Visual hierarchy is achieved through **Tonal Layering** and **Ambient Shadows**.

- **Surfaces:** Main content lives on soft white cards against the tinted backgrounds (#FFF9FA or #FFF6D6).
- **Shadows:** We use a "Natural Bloom" shadow: a very soft, diffused drop shadow with a subtle tint of the primary color (`rgba(248, 12, 81, 0.04)`). This makes cards appear to "float" gently rather than being stuck to the background.
- **Depth Levels:**
    - **Level 0 (Floor):** The tinted background.
    - **Level 1 (Card):** Standard content containers with 4px blur, 2px Y-offset.
    - **Level 2 (Active/Floating):** Primary buttons and bottom navigation, using 12px blur for higher perceived elevation.

## Shapes

The shape language is **Warm and Rounded**, avoiding any sharp corners that might feel aggressive or clinical.

- **Cards & Containers:** Use `rounded-lg` (16px) for the majority of UI containers.
- **Buttons:** Use `rounded-xl` (24px) or full pill-shape for primary CTAs to make them feel inviting and "tappable."
- **Small Elements:** Tooltips and tags use `rounded-sm` (8px).
- **Icons:** Use modern 2px stroke-width outline icons with rounded caps and joins to match the curvature of the UI components.

## Components

### Buttons
- **Primary:** Solid MomBee Pink with white text. High elevation.
- **Secondary:** White background with MomBee Pink border and text.
- **Soft:** Light pink background (`rgba(248, 12, 81, 0.1)`) with primary pink text for secondary actions within cards.

### Cards
- **Feature Cards:** Large cards with a subtle gradient background or soft elevation. Used for "Daily Tips" or "Growth Tracking."
- **List Cards:** Simple white cards with a 1px border (`#F0E4E6`) and no shadow to keep long lists looking clean.

### Input Fields
- Modern, outlined style with 16px corner radius. Labels are always visible (top-aligned) to ensure the user doesn't lose context. The active state uses a 2px MomBee Pink border.

### Chips & Tags
- Used for categories like "Health," "Nutrition," or "Vaccination." These use the MomBee Yellow or Pink at 10% opacity for the background with full-color text for maximum readability without visual noise.

### Progress Indicators
- Smooth, rounded bars using MomBee Yellow for baby growth and MomBee Pink for maternal health goals.

### Bottom Navigation
- A frosted-glass effect (Backdrop Blur) with a white tint. Icons use the primary pink for the active state with a small dot indicator underneath.