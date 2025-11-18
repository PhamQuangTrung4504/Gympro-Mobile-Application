# Hướng Dẫn Test: Thanh Toán MoMo và QR Ngân Hàng

## 🎯 Mục Đích
Hướng dẫn test 2 phương thức thanh toán mới trong GymPro:
- **MoMo**: Thanh toán qua ứng dụng MoMo
- **QR Ngân hàng**: Quét mã QR từ app ngân hàng

## 📱 Cách Test Trên Chrome Browser

### Bước 1: Chạy ứng dụng
```bash
cd c:\Users\truon\gympro
flutter run -d chrome
```

### Bước 2: Truy cập trang test
Sau khi app load xong, truy cập:
```
http://localhost:port/test-payment-methods
```

Hoặc điều hướng bằng code:
```dart
Get.toNamed('/test-payment-methods');
```

### Bước 3: Chọn phương thức thanh toán
Trên trang test, bạn sẽ thấy 3 nút:
1. **Thanh toán trực tiếp** (xanh dương)
2. **Thanh toán MoMo** (cam) - NEW
3. **QR Ngân hàng** (xanh đen) - NEW

## 🧪 Test Scenarios

### Scenario 1: Test MoMo Payment
1. Click "Thanh toán MoMo"
2. Chọn một loại thẻ tập (VD: Thẻ 3 Tháng)
3. Tại trang checkout, chọn radio button "Thanh toán MoMo"
4. Click "Xác nhận thanh toán"
5. Bạn sẽ thấy màn hình MoMo với:
   - Logo MoMo
   - Chi tiết đơn hàng
   - Hướng dẫn thanh toán từng bước
   - Nút "Thanh toán [số tiền] VNĐ qua MoMo"

**Expected Result:**
- Hiển thị thông tin chi tiết thẻ tập
- Hiển thị số tiền cần thanh toán
- Nút thanh toán hoạt động
- Sau 2 giây, hiển thị dialog thành công

### Scenario 2: Test QR Banking Payment
1. Click "QR Ngân hàng"
2. Chọn một loại thẻ tập (VD: Thẻ 6 Tháng)
3. Tại trang checkout, chọn radio button "QR Ngân hàng"
4. Click "Xác nhận thanh toán"
5. Bạn sẽ thấy màn hình QR với:
   - Mã QR (250x250 pixels)
   - Thông tin chuyển khoản chi tiết
   - Nút copy cho số tài khoản
   - Nút copy cho nội dung chuyển khoản
   - Nút "Tôi đã chuyển khoản"

**Expected Result:**
- Mã QR hiển thị đúng
- Thông tin ngân hàng đầy đủ
- Nút copy hoạt động (hiển thị "Đã sao chép")
- Nút xác nhận thanh toán
- Sau 2 giây, hiển thị dialog thành công

### Scenario 3: Test Với Các Loại Thẻ Khác Nhau
Tại trang test, nhấn các nút:
- "Thẻ 1 Tháng" (150,000 VNĐ)
- "Thẻ 3 Tháng" (300,000 VNĐ)
- "Thẻ 6 Tháng" (550,000 VNĐ)
- "Thẻ 1 Năm" (900,000 VNĐ)

**Expected Result:**
- Giá tiền hiển thị đúng
- Thông tin thanh toán cập nhật chính xác
- Mã QR và thông tin ngân hàng cập nhật

### Scenario 4: Test Navigation
1. Ở trang checkout, thay đổi lựa chọn thanh toán:
   - Chọn "Thanh toán trực tiếp" → Click "Xác nhận" → Đi đến direct payment
   - Chọn "Thanh toán MoMo" → Click "Xác nhận" → Đi đến MoMo payment
   - Chọn "QR Ngân hàng" → Click "Xác nhận" → Đi đến QR payment

**Expected Result:**
- Navigation hoạt động chính xác
- Dữ liệu được truyền đúng
- Không có error

## 📊 UI/UX Test

### MoMo Payment View
- [ ] Logo MoMo hiển thị (hoặc icon fallback)
- [ ] Thông tin chi tiết sản phẩm đầy đủ
- [ ] Hướng dẫn rõ ràng và dễ hiểu
- [ ] Nút thanh toán nhìn rõ
- [ ] Dialog thành công hiển thị đúng

### QR Banking Payment View
- [ ] Mã QR tạo thành công
- [ ] Thông tin ngân hàng đầy đủ
- [ ] Nút copy hoạt động
- [ ] Thông báo "Đã sao chép" hiển thị
- [ ] Các lưu ý hữu ích
- [ ] Dialog thành công hiển thị đúng

### Checkout View
- [ ] 3 radio button hiển thị rõ ràng
- [ ] Icon khác nhau cho từng phương thức
- [ ] Màu sắc phân biệt được
- [ ] Chọn phương thức hoạt động
- [ ] Nút thanh toán responsive

## 🔍 Data Flow Test

### Direct Payment Flow
```
Checkout → Select "Thanh toán trực tiếp" → Click confirm
→ DirectPaymentConfirmationView
```

### MoMo Payment Flow
```
Checkout → Select "Thanh toán MoMo" → Click confirm
→ MoMoPaymentView
→ Display order details + MoMo instructions
→ Click confirm → Show success dialog
```

### QR Banking Payment Flow
```
Checkout → Select "QR Ngân hàng" → Click confirm
→ BankQRPaymentView
→ Display QR code + bank transfer info
→ User can copy account number & transfer content
→ User clicks "I've transferred" → Show success dialog
```

## 🐛 Bug Check List

- [ ] Không có crash khi chuyển đổi phương thức thanh toán
- [ ] Dữ liệu không bị mất khi navigation
- [ ] QR code tạo thành công
- [ ] UI responsive trên các kích thước màn hình
- [ ] Không có memory leak
- [ ] Console không có error
- [ ] Buttons responsive khi touch/hover

## 💡 Notes

### Current Status
- ✅ Views được tạo
- ✅ Routes được cấu hình
- ✅ Controller xử lý logic
- ✅ UI/UX hoàn chỉnh
- 🟡 Integration với MoMo API: **TODO**
- 🟡 Integration với Banking API: **TODO**
- 🟡 Webhook callback: **TODO**

### Next Steps
1. Tích hợp MoMo API v2
2. Tích hợp Banking transaction verification
3. Implement webhook handlers
4. Add database integration
5. Production testing

## 📞 Troubleshooting

### Vấn đề: MoMo button không hoạt động
**Giải pháp**: Kiểm tra:
- Route `/momo-payment` có trong `app_pages.dart` không?
- `MoMoPaymentView` import đúng không?
- Controller `createPayment()` có navigate đúng không?

### Vấn đề: QR code không hiển thị
**Giải pháp**: Kiểm tra:
- `qr_flutter` package có installed không?
- QR data generation có lỗi không?
- Browser hỗ trợ QR rendering không?

### Vấn đề: Copy to clipboard không hoạt động
**Giải pháp**: Kiểm tra:
- `flutter/services` import đúng không?
- `Clipboard.setData()` được gọi không?
- Browser permission cho clipboard?

## ✅ Checklist Hoàn Thành

- [x] Tạo MoMo Payment View
- [x] Tạo QR Banking Payment View
- [x] Cập nhật Checkout View
- [x] Cập nhật Controller
- [x] Cập nhật Models
- [x] Cập nhật Routes
- [x] Tạo Test View
- [ ] Tích hợp API thực
- [ ] Production testing
- [ ] Release

---

**Ghi chú**: Hiện tại các payment method này đang ở chế độ **DEMO**. Để sử dụng thanh toán thực tế, bạn cần:
1. Đăng ký API key từ MoMo
2. Tích hợp MoMo SDK
3. Tích hợp Banking verification service
4. Setup webhook handlers
