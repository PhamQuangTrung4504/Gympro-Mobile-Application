# Tài liệu: Thêm phương thức thanh toán MoMo và QR Ngân hàng

## 📋 Tóm tắt

Đã thêm 2 phương thức thanh toán mới vào hệ thống thanh toán của GymPro:
- **MoMo**: Thanh toán qua ứng dụng MoMo
- **QR Ngân hàng**: Quét mã QR từ ứng dụng ngân hàng

## 📁 Files Tạo Mới

### 1. `lib/views/checkout/momo_payment_view.dart`
- View để xử lý thanh toán MoMo
- Hiển thị thông tin chi tiết đơn hàng
- Nút xác nhận thanh toán MoMo
- Hướng dẫn thanh toán cho người dùng

**Features:**
- Logo MoMo
- Chi tiết đơn hàng
- Hướng dẫn thanh toán từng bước
- Xác nhận thành công

### 2. `lib/views/checkout/bank_qr_payment_view.dart`
- View để xử lý thanh toán bằng mã QR ngân hàng
- Hiển thị mã QR cho người dùng quét
- Thông tin chuyển khoản chi tiết (số tài khoản, chủ tài khoản, nội dung chuyển khoản)
- Nút copy dễ dàng cho thông tin

**Features:**
- Tạo mã QR VietQR
- Hiển thị thông tin ngân hàng (Techcombank)
- Copy to clipboard cho số tài khoản, nội dung chuyển khoản
- Xác nhận thanh toán khi đã chuyển khoản

## 📝 Files Được Cập Nhật

### 1. `lib/views/checkout/checkout_view.dart`
- Thêm 2 option radio button cho MoMo và QR Banking
- Cải thiện UI với icon và màu sắc khác nhau cho từng phương thức

**Cấu trúc:**
```dart
// Phương thức 1: Thanh toán trực tiếp (cũ)
- Icon: Icons.store (xanh dương)

// Phương thức 2: MoMo (mới)
- Icon: Icons.phone_android (cam)
- Màu: #FF6B35

// Phương thức 3: QR Ngân hàng (mới)
- Icon: Icons.qr_code_2 (xanh đen)
- Màu: #1E3A8A
```

### 2. `lib/controllers/checkout_controller.dart`
- Cập nhật hàm `createPayment()` để xử lý 3 loại thanh toán
- Routing đến các view payment tương ứng:
  - `direct` → `/direct-payment-confirmation`
  - `momo` → `/momo-payment`
  - `bank_qr` → `/bank-qr-payment`

### 3. `lib/models/payment_method.dart`
- Thêm 2 enum mới:
  - `PaymentMethodType.momo`: Thanh toán MoMo
  - `PaymentMethodType.bankQR`: Thanh toán QR Banking

### 4. `lib/models/payment_transaction.dart`
- Cập nhật method `getPaymentMethodText()` để hỗ trợ các phương thức mới
- Thêm cases cho momo và bankQR

### 5. `lib/services/payment_service.dart`
- Cập nhật switch case trong `createPayment()` 
- Hỗ trợ momo và bankQR (hiện tại là demo)

### 6. `lib/routes/app_routes.dart`
- Thêm 2 route constants:
  - `static const momoPayment = '/momo-payment';`
  - `static const bankQRPayment = '/bank-qr-payment';`

### 7. `lib/routes/app_pages.dart`
- Thêm 2 GetPage routes:
  - MoMoPaymentView → `/momo-payment`
  - BankQRPaymentView → `/bank-qr-payment`

### 8. `lib/views/membership/checkout_view_old_complex.dart`
- Cập nhật `_getPaymentMethodColor()` cho momo và bankQR
- Cập nhật `_getPaymentMethodIcon()` cho momo và bankQR

## 🔄 Luồng Thanh Toán

```
Checkout View
    ↓
User chọn phương thức thanh toán
    ↓
┌─────────────────────────────────────────┐
│ ✓ Direct Payment                        │
│ ✓ MoMo (NEW)                            │
│ ✓ Bank QR (NEW)                         │
└─────────────────────────────────────────┘
    ↓
Nhấn "Xác nhận thanh toán"
    ↓
Controller.createPayment()
    ↓
┌────────────────────────────────────────────────────────┐
│ if (selectedPaymentType == 'direct')                   │
│   → DirectPaymentConfirmationView                       │
│ else if (selectedPaymentType == 'momo')                │
│   → MoMoPaymentView (NEW)                              │
│ else if (selectedPaymentType == 'bank_qr')             │
│   → BankQRPaymentView (NEW)                            │
└────────────────────────────────────────────────────────┘
    ↓
Xác nhận thanh toán
    ↓
Quay về Home (Success)
```

## 💳 Thông Tin Ngân Hàng (Demo)

```
Ngân hàng: Techcombank
Chủ tài khoản: GYMPRO CO., LTD
Số tài khoản: 1234567890
Nội dung: THANHTOA [Tên thẻ tập]
```

## 🎨 Giao Diện

### MoMo Payment View
- Logo MoMo (cam)
- Thông tin chi tiết sản phẩm
- Hướng dẫn thanh toán
- Nút "Thanh toán [số tiền] VNĐ qua MoMo"

### Bank QR Payment View
- Mã QR (250x250px)
- Thông tin chuyển khoản (có nút copy)
- Chi tiết ngân hàng
- Các lưu ý quan trọng
- Nút "Tôi đã chuyển khoản"

## 🔧 Hướng Dẫn Sử Dụng

### Cho Người Dùng

#### Thanh toán MoMo:
1. Chọn "Thanh toán MoMo" ở màn hình checkout
2. Nhấn "Thanh toán [số tiền] VNĐ qua MoMo"
3. Ứng dụng MoMo sẽ mở
4. Nhập PIN hoặc xác thực sinh trắc học
5. Xác nhận giao dịch
6. Quay lại ứng dụng để xem kết quả

#### Thanh toán QR Banking:
1. Chọn "QR Ngân hàng" ở màn hình checkout
2. Quét mã QR bằng ứng dụng ngân hàng của bạn
3. Kiểm tra lại thông tin thanh toán
4. Xác nhận chuyển khoản
5. Nhấn "Tôi đã chuyển khoản" để xác nhận
6. Hệ thống sẽ xác thực thanh toán

### Cho Developer

#### Để thêm logic thanh toán thực tế cho MoMo:
```dart
// Trong lib/views/checkout/momo_payment_view.dart
// Thay thế phần _handleMoMoPayment bằng:
// - Gọi MoMo API
// - Xử lý callback từ MoMo
// - Cập nhật trạng thái thanh toán trong Firestore
```

#### Để thêm logic thanh toán thực tế cho QR Banking:
```dart
// Trong lib/views/checkout/bank_qr_payment_view.dart
// Thay thế phần _handlePaymentConfirmation bằng:
// - Gọi API để kiểm tra giao dịch ngân hàng
// - Xác thực thanh toán trong Firestore
// - Cập nhật trạng thái đơn hàng
```

## 📦 Dependencies

Không cần thêm dependency mới. Đã sử dụng:
- `qr_flutter`: Cho tạo mã QR (đã có)
- `get`: Cho routing và state management (đã có)
- `flutter/services`: Cho clipboard operations (built-in)

## ✅ Kiểm Tra

Các file đã được compile và không có error:
- ✓ Routes định nghĩa đúng
- ✓ Models cập nhật đầy đủ
- ✓ Controllers xử lý logic thanh toán
- ✓ Views UI hoàn chỉnh

## 🚀 Tiếp Theo

Để hoàn thiện feature này, bạn cần:

1. **Tích hợp MoMo API**: Lấy API key từ MoMo và thêm logic gọi API thực
2. **Tích hợp Banking API**: Kết nối với dịch vụ kiểm tra giao dịch ngân hàng
3. **Webhook xử lý callback**: Tạo endpoint để xử lý callback từ MoMo
4. **Database**: Lưu trữ thông tin thanh toán vào Firestore
5. **Testing**: Test trên production environment với thẻ test

## 📞 Support

Nếu có bất kỳ vấn đề gì, hãy kiểm tra:
- Routes có được đăng ký đúng không?
- PaymentMethodType enum có các cases mới không?
- Views import đúng các models và controllers không?
