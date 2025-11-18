# 🎨 MoMo Payment Screen - Visual Guide

## 📱 MoMo Payment View Layout

### Full Screen View
```
┌─────────────────────────────────────────────┐
│ [<] Thanh toán MoMo         [▼]              │ ← AppBar (Orange #FF6B35)
├─────────────────────────────────────────────┤
│                                              │
│ Thanh toán qua MoMo                         │ ← Title
│ Nhanh chóng, an toàn và tiện lợi            │ ← Subtitle (Gray)
│                                              │
│         ┌─────────────────┐                 │
│         │  [Payments]     │                 │ ← MoMo Icon (Orange)
│         │   OR Image      │                 │
│         └─────────────────┘                 │
│                                              │
│         ┌─────────────────┐                 │
│         │ ┌─────────────┐ │                 │ ← QR Code
│         │ │▌▌▌ ▌▌▌ ▌▌▌│ │ (200x200)
│         │ │▌▌ ▌▌▌ ▌▌ ▌│ │
│         │ │ ▌▌▌ ▌▌ ▌▌▌│ │
│         │ └─────────────┘ │
│         │ Quét mã QR...   │
│         └─────────────────┘
│                                              │
│ ╔════════════════════════════════════════╗  │
│ ║ Chi tiết đơn hàng                      ║  │ ← Order Card
│ ║ Sản phẩm:      Thẻ 3 Tháng           ║  │
│ ║ Mô tả:         Thẻ tập 3 tháng...   ║  │
│ ║ ─────────────────────────────────── ║  │
│ ║ Tổng cộng:     300,000 VNĐ (Green) ║  │
│ ╚════════════════════════════════════════╝  │
│                                              │
│ ┌────────────────────────────────────────┐  │
│ │ ⓘ Hướng dẫn thanh toán                 │  │ ← Info Box
│ │ 1. Nhấn "Thanh toán MoMo"              │  │
│ │ 2. Nhập mã PIN hoặc sinh trắc học     │  │
│ │ 3. Xác nhận giao dịch                  │  │
│ │ 4. Quay lại app để xem kết quả        │  │
│ └────────────────────────────────────────┘  │
│                                              │
│ ┌────────────────────────────────────────┐  │
│ │ Thanh toán 300,000 VNĐ qua MoMo      │  │ ← Action Button
│ │          [Loading/Ready]                │  │ (Orange)
│ └────────────────────────────────────────┘  │
│                                              │
│ ┌────────────────────────────────────────┐  │
│ │ Quay lại                                │  │ ← Back Button
│ └────────────────────────────────────────┘  │
│                                              │
└─────────────────────────────────────────────┘
```

## 🎨 Color Scheme

| Element | Color | Hex | RGB |
|---------|-------|-----|-----|
| AppBar Background | Orange | #FF6B35 | (255, 107, 53) |
| AppBar Text | White | #FFFFFF | (255, 255, 255) |
| Title | Black | #000000 | (0, 0, 0) |
| Subtitle | Gray | #999999 | (153, 153, 153) |
| Order Total | Green | #4CAF50 | (76, 175, 80) |
| Button Background | Orange | #FF6B35 | (255, 107, 53) |
| Button Text | White | #FFFFFF | (255, 255, 255) |
| Border | Light Gray | #CCCCCC | (204, 204, 204) |
| Info Background | Light Blue | rgba(33,150,243,0.1) | - |
| QR Background | Light Gray | rgba(0,0,0,0.1) | - |

## 📏 Dimensions

### Screen Sizes
- **Mobile Portrait**: 360dp - 400dp wide
- **Mobile Landscape**: 640dp - 800dp wide
- **Tablet**: 600dp+ wide
- **Web**: 400dp - 800dp preferred

### Component Sizes

| Component | Size |
|-----------|------|
| AppBar Height | 56dp |
| MoMo Logo | 120x120dp |
| QR Code | 200x200dp |
| Order Card | Full width - 32dp padding |
| Button Height | 56dp |
| Border Radius | 8dp - 12dp |

## 🎯 Layout Structure

### Padding & Spacing

```dart
// Main container
Padding: 16.0 all sides

// Vertical spacing
- Header to Logo: 24dp
- Logo to QR: 24dp
- QR to Order Card: 24dp
- Order Card to Info: 24dp
- Info to Button: 32dp
- Button to Back Button: 12dp
- Back Button to Bottom: 20dp

// Card padding
- Order Card: 16.0 all sides
- Info Box: 12.0 all sides
```

## 📲 Responsive Design

### Mobile (Small)
```
Content takes: 100% - 32dp (16dp padding each side)
Max width: 328dp
Stack layout: Vertical
```

### Tablet (Medium)
```
Content takes: 90% centered
Max width: 500dp
Stack layout: Vertical
```

### Desktop (Large)
```
Content takes: 70% centered
Max width: 600dp
Stack layout: Vertical
```

## 🎨 Typography

| Element | Style |
|---------|-------|
| Title | 20sp, Bold, Black |
| Subtitle | 14sp, Regular, Gray |
| Card Title | 16sp, Bold, Black |
| Card Text | 12sp, Regular, Gray |
| Button Text | 16sp, SemiBold, White |
| Info Title | 12sp, Bold, Blue |
| Info Text | 12sp, Regular, Black |
| Label | 12sp, Regular, Gray |
| Amount | 16sp, Bold, Green |

## 🎬 Animations & Transitions

### Page Transitions
- Enter: Slide from bottom + Fade in (300ms)
- Exit: Slide to bottom + Fade out (200ms)

### Button States
- Normal: Orange background
- Hover: Orange darker (Desktop)
- Loading: Show spinner
- Disabled: Orange 50% opacity

### Success Dialog
- Appear: Scale up + Fade in (300ms)
- Icon: Check circle with green color
- Duration: 2 seconds before auto-close

## 🌙 Dark Mode Support

```dart
// AppBar
- Light: Orange (#FF6B35)
- Dark: Orange (#FF8C42)

// Background
- Light: White (#FFFFFF)
- Dark: Dark Gray (#121212)

// Text
- Light: Black (#000000)
- Dark: White (#FFFFFF)

// Card
- Light: White (#FFFFFF)
- Dark: Gray (#1E1E1E)

// Borders
- Light: Light Gray (#CCCCCC)
- Dark: Gray (#333333)
```

## ♿ Accessibility

### Touch Targets
- Minimum: 48dp x 48dp
- Button: 56dp height
- Spacing between: 8dp minimum

### Contrast Ratio
- Text on background: 4.5:1 (WCAG AA)
- Color blind friendly: Use shapes + text
- Font size: Minimum 12sp

### Semantics
- AppBar: Back button accessible
- QR Code: Labeled "MoMo QR Code"
- Buttons: Clear labels
- Cards: Proper heading hierarchy

## 🎥 Screen Flow

### MoMo Payment Screen Sequence

```
1. Load → Show components gradually
   - AppBar (instant)
   - Title + Subtitle (fade in)
   - Logo (fade in)
   - QR Code (fade in)
   - Order Card (slide up)
   - Info Box (slide up)
   - Buttons (slide up)

2. User scans QR → Button highlight

3. User taps button → Loading state
   - Button shows spinner
   - Disabled state
   - Loading text

4. After 2s → Success dialog
   - Icon with checkmark
   - Transaction ID
   - Close button

5. User taps "Xong" → Navigate to home
```

## 📋 Component Checklist

### AppBar
- [x] Title text
- [x] Back button
- [x] Orange background
- [x] White text/icons

### Header Section
- [x] Subtitle text
- [x] Gray color
- [x] Proper spacing

### MoMo Logo/Icon
- [x] 120x120 size
- [x] Centered alignment
- [x] Error fallback icon
- [x] Orange color fallback

### QR Code
- [x] 200x200 size
- [x] Centered alignment
- [x] Light gray background
- [x] Border styling
- [x] Label text below

### Order Details Card
- [x] White background
- [x] Shadow/elevation
- [x] Product name
- [x] Description
- [x] Divider line
- [x] Total amount (green)
- [x] Proper padding

### Info Box
- [x] Info icon
- [x] Title text
- [x] Instructions (4 steps)
- [x] Blue background
- [x] Border styling

### Action Buttons
- [x] Orange button (primary)
- [x] Outlined button (secondary)
- [x] Loading state
- [x] Full width
- [x] Proper spacing

### Success Dialog
- [x] Check icon
- [x] Success title
- [x] Transaction ID
- [x] Close button

---

## 🎨 Design Tokens

```dart
// Colors
const momoOrange = Color(0xFFFF6B35);
const momoOrangeDark = Color(0xFFFF8C42);
const successGreen = Color(0xFF4CAF50);
const textBlack = Color(0xFF000000);
const textGray = Color(0xFF999999);
const borderGray = Color(0xFFCCCCCC);
const infoBlueTint = Color.fromARGB(25, 33, 150, 243);

// Spacing
const defaultPadding = 16.0;
const smallSpacing = 8.0;
const mediumSpacing = 12.0;
const largeSpacing = 24.0;
const xlSpacing = 32.0;

// Border Radius
const smallRadius = 8.0;
const mediumRadius = 12.0;
const largeRadius = 16.0;

// Font Sizes
const titleSize = 20.0;
const subtitleSize = 14.0;
const bodySize = 12.0;
const buttonSize = 16.0;
```

---

**Design Version**: 1.0.0  
**Last Updated**: November 11, 2025  
**Status**: ✅ Complete
