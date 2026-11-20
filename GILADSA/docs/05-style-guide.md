# 05. Style Guide

Design system tokens, typography rules, color standards, and UI component specifications for **Your App**.

---

## 🎨 Color Palette

| Token Name | Hex Code | Swatch Preview | Usage / Role |
| :--- | :--- | :--- | :--- |
| `--primary` | `#2563eb` | ![#2563eb](https://dummyimage.com/16x16/2563eb/2563eb.png) | Primary brand color, primary CTA buttons, active links |
| `--primary-hover` | `#1d4ed8` | ![#1d4ed8](https://dummyimage.com/16x16/1d4ed8/1d4ed8.png) | Hover state for primary buttons |
| `--surface` | `#ffffff` | ![#ffffff](https://dummyimage.com/16x16/ffffff/ffffff.png) | Card, modal, and container background |
| `--bg-body` | `#f8fafc` | ![#f8fafc](https://dummyimage.com/16x16/f8fafc/f8fafc.png) | Main application body background |
| `--text-main` | `#1e293b` | ![#1e293b](https://dummyimage.com/16x16/1e293b/1e293b.png) | Primary text, titles, headings |
| `--text-muted` | `#64748b` | ![#64748b](https://dummyimage.com/16x16/64748b/64748b.png) | Captions, secondary labels, placeholders |
| `--border` | `#e2e8f0` | ![#e2e8f0](https://dummyimage.com/16x16/e2e8f0/e2e8f0.png) | Table borders, form field borders, dividers |
| `--success` | `#16a34a` | ![#16a34a](https://dummyimage.com/16x16/16a34a/16a34a.png) | Published status, positive alerts, confirmations |
| `--warning` | `#eab308` | ![#eab308](https://dummyimage.com/16x16/eab308/eab308.png) | Draft status, warning banners |
| `--danger` | `#dc2626` | ![#dc2626](https://dummyimage.com/16x16/dc2626/dc2626.png) | Delete buttons, errors, validation alerts |

---

## ✍️ Typography

- **Font Family:** `-apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, Helvetica, Arial, sans-serif`
- **Monospace Family:** `ui-monospace, "SFMono-Regular", Menlo, Monaco, Consolas, monospace`

### Type Scale

| Element | Size | Weight | Line Height |
| :--- | :--- | :--- | :--- |
| **H1** | `1.75rem` (28px) | 700 (Bold) | 1.25 |
| **H2** | `1.375rem` (22px) | 600 (Semi-bold) | 1.3 |
| **H3** | `1.125rem` (18px) | 600 (Semi-bold) | 1.4 |
| **Body** | `0.9375rem` (15px) | 400 (Regular) | 1.5 |
| **Small / Caption** | `0.8125rem` (13px) | 400 (Regular) | 1.4 |

---

## 🔘 UI Components

### Buttons
- **Primary:** Background `--primary`, text white, rounded 6px, padding `0.5rem 1rem`.
- **Secondary / Outline:** Background transparent, border 1px solid `--border`, text `--text-main`.
- **Danger:** Background `--danger`, text white.

### Form Inputs
- Standard height: `38px`
- Border: `1px solid var(--border)`
- Focus state: Border color `var(--primary)`, outline shadow `0 0 0 3px rgba(37, 99, 235, 0.15)`.

### Badges / Status Tags
- **Published:** Light green background (`#dcfce7`), dark green text (`#166534`).
- **Draft:** Light amber background (`#fef3c7`), dark amber text (`#92400e`).
- **Archived:** Light gray background (`#f1f5f9`), slate text (`#475569`).

---

## 📐 Layout & Spacing
- Base unit: `4px` grid (`4px`, `8px`, `12px`, `16px`, `24px`, `32px`, `48px`).
- Container max-width: `1140px` centered with auto margins.
- Border radius: `6px` for controls, `8px` or `12px` for cards.

