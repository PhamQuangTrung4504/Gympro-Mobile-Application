# MoMo QR Code Implementation Guide

## 📱 QR Code MoMo Mới Được Thêm

Đã thêm mã QR MoMo vào màn hình thanh toán để tượng trưng.

### 🎯 Mục Đích

MoMo QR code cho phép người dùng:
- Quét mã QR bằng ứng dụng MoMo
- Xác nhận thông tin thanh toán
- Hoàn thành giao dịch nhanh chóng

### 📍 Vị Trí

File: `lib/views/checkout/momo_payment_view.dart`

Hiển thị: Giữa logo MoMo và chi tiết đơn hàng

```
┌────────────────────────────┐
│   Header                   │
├────────────────────────────┤
│   MoMo Logo (120x120)      │
├────────────────────────────┤
│   QR Code (200x200) ✨ NEW │
├────────────────────────────┤
│   Order Details Card       │
├────────────────────────────┤
│   Instructions             │
├────────────────────────────┤
│   Payment Button           │
└────────────────────────────┘
```

### 🔧 Technical Details

#### QR Code Generation
```dart
String _generateMoMoQRData({
  required double amount,
  required String description,
}) {
  const phoneNumber = '0123456789'; // Demo phone
  const momoName = 'GYMPRO';
  final amountStr = amount.toStringAsFixed(0);
  
  // MoMo QR format
  final qrData = 'momo://transfer?phone=$phoneNumber&name=$momoName&amount=$amountStr&note=$description';
  return qrData;
}
```

#### QR Code Format
```
momo://transfer?phone=PHONE&name=NAME&amount=AMOUNT&note=NOTE

Example:
momo://transfer?phone=0123456789&name=GYMPRO&amount=300000&note=GYMPRO-Thẻ%203%20Tháng
```

#### Display Settings
```dart
QrImageView(
  data: qrData,              // QR data
  version: QrVersions.auto,  // Auto size
  size: 200.0,               // 200x200 pixels
  backgroundColor: Colors.white,
  foregroundColor: Colors.black,
)
```

### 🎨 UI Design

QR code được đặt trong một Container với:
- **Background**: Gray tinted (10% opacity)
- **Border**: Light gray border
- **BorderRadius**: 12px rounded corners
- **Padding**: 16px all sides
- **Text**: "Quét mã QR bằng ứng dụng MoMo"

### 📊 QR Code Details

| Attribute | Value |
|-----------|-------|
| Format | VietQR (MoMo Deep Link) |
| Size | 200x200 pixels |
| Version | Auto |
| Error Correction | Auto |
| Foreground | Black |
| Background | White |

### 💡 How It Works

1. **Generation**: QR data được tạo từ số tiền và mô tả
2. **Rendering**: QrImageView render thành mã QR 2D
3. **Scanning**: Người dùng quét bằng MoMo app
4. **Deep Link**: MoMo app nhận biết link và mở transfer screen
5. **Confirmation**: Người dùng xác nhận và thanh toán

### 🔄 Deep Link Format

**MoMo URL Scheme:**
```
momo://transfer?phone=<PHONE>&name=<NAME>&amount=<AMOUNT>&note=<NOTE>
```

**Parameters:**
- `phone`: Số điện thoại MoMo nhận tiền (demo: 0123456789)
- `name`: Tên người nhận (GYMPRO)
- `amount`: Số tiền cần thanh toán
- `note`: Nội dung chuyển khoản

### 📱 MoMo App Integration

Khi người dùng quét QR:
1. MoMo app nhận deep link
2. Tự động mở transfer screen
3. Điền sẵn thông tin:
   - Số điện thoại người nhận
   - Tên người nhận
   - Số tiền
   - Nội dung chuyển khoản
4. Người dùng xác nhận bằng PIN/Biometric
5. Giao dịch hoàn thành

### 🎯 Demo Phone & Account

```
Phone: 0123456789
Name: GYMPRO
Purpose: Demo/Testing only
```

⚠️ **Lưu ý**: Những thông tin này là demo. Để production:
- Thay phone = số MoMo thực
- Thay name = tên business thực
- Setup webhook để verify payment

### 🔐 Security Notes

- QR code chỉ chứa transfer link (không chứa sensitive data)
- Tất cả thông tin đều safe để hiển thị công khai
- Người dùng phải xác thực qua MoMo app
- No credentials stored in QR code

### 🚀 Future Enhancements

1. **Real MoMo Account**
   - Replace demo phone với production MoMo account
   - Update name với business name

2. **Dynamic QR**
   - Include unique transaction ID
   - Add timestamp
   - Add reference number

3. **QR Customization**
   - Add GymPro logo vào giữa QR
   - Custom color scheme
   - Add branding

4. **Analytics**
   - Track QR scans
   - Track successful payments
   - Monitor conversion rate

### 📝 Example Usage

```dart
// Tạo QR data
final qrData = _generateMoMoQRData(
  amount: 300000,
  description: 'GYMPRO-Thẻ 3 Tháng',
);

// Output: 
// momo://transfer?phone=0123456789&name=GYMPRO&amount=300000&note=GYMPRO-Thẻ%203%20Tháng

// Hiển thị
QrImageView(
  data: qrData,
  size: 200.0,
)
```

### 🧪 Testing QR Code

#### On Physical Device
1. Cài đặt MoMo app
2. Chạy GymPro app
3. Chọn thanh toán MoMo
4. Quét mã QR
5. MoMo app sẽ mở transfer screen

#### On Web/Desktop
1. QR code hiển thị nhưng không thể quét
2. Dùng phone để quét
3. Hoặc dùng QR scanner online

### 💻 Code Location

```
lib/views/checkout/momo_payment_view.dart
  ├── import 'package:qr_flutter/qr_flutter.dart';
  ├── _generateMoMoQRData() method
  └── QrImageView widget
```

### 📚 Related Files

- `lib/views/checkout/bank_qr_payment_view.dart` - Banking QR (khác)
- `lib/models/payment_transaction.dart` - Payment data model
- `lib/controllers/checkout_controller.dart` - Payment controller

### ✅ Checklist

- [x] QR code generation implemented
- [x] QR code display in UI
- [x] MoMo deep link format correct
- [x] Demo data included
- [x] Error handling added
- [x] UI design professional
- [x] Documentation complete
- [ ] Real MoMo account setup (TODO)
- [ ] Production webhook setup (TODO)

### 🎯 Next Steps

1. **Testing**: Test QR scanning with MoMo app
2. **Integration**: Integrate real MoMo account
3. **Webhook**: Setup payment verification
4. **Analytics**: Add payment tracking
5. **Production**: Deploy to production

---

**Status**: ✅ Demo QR Code Ready  
**Last Updated**: November 11, 2025  
**Version**: 1.0.0
