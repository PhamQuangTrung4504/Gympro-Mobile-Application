# 🔍 DEBUG GUIDE: Admin Không Thấy Thẻ

## 📋 Tình Huống
- Admin không thấy thẻ mà customer thanh toán
- Cần debug xem thẻ có được tạo hay không

## 🛠️ Debug Steps

### Step 1: Kiểm tra Console Logs

**Khi customer thanh toán thẻ qua MoMo/Bank QR, bạn sẽ thấy logs:**

```
⏳ Updating payment status for transaction: PAY_1234567890
📝 Creating membership for user: userId123, card: cardId456
📋 Card: Premium 30 Days, Duration: 30 days
✅ User membership created/updated successfully: membershipId789
   Start: 2025-11-18T10:30:00.000Z, End: 2025-12-18T10:30:00.000Z
```

✅ Nếu thấy logs này → Membership được tạo xong

❌ Nếu không thấy → Payment status không được update

---

### Step 2: Kiểm tra Admin View Logs

**Khi admin mở trang "Quản Lý Thẻ Hội Viên":**

```
🔄 MemberManagementController onReady - refreshing data
📥 Loading user memberships from Firestore...
📊 Found X user memberships
📌 Processing membership: membershipId789
   Status: completed, Active: true
✅ Loaded X memberships successfully
```

✅ Nếu thấy logs này → Data đã load

❌ Nếu `Found 0 user memberships` → Firestore không có data

---

### Step 3: Kiểm tra Real-Time Listener

**Khi customer thanh toán (sau khi admin view đã mở):**

```
🎯 Setting up real-time listener for user_memberships...
🔔 LISTENER TRIGGERED - Detected X user_memberships
📌 Processing membership: membershipId789
   Data: {id: ..., userId: ..., isActive: true, paymentStatus: 'completed', ...}
   User: John Doe (john@example.com)
   Card: Premium 30 Days
✅ LISTENER: Updated X memberships in UI
```

✅ Nếu thấy logs này → Real-time update working

❌ Nếu không thấy `LISTENER TRIGGERED` → Listener không setup

---

## 🔧 Troubleshooting

### Problem 1: Payment status không update
```
❌ Không thấy logs từ PaymentService
```

**Giải pháp:**
- Kiểm tra `momo_payment_view.dart` - có gọi `updatePaymentStatus()` không?
- Kiểm tra `bank_qr_payment_view.dart` - có gọi `updatePaymentStatus()` không?
- Logs: `⏳ Updating payment status...`

### Problem 2: Admin không thấy thẻ lúc đầu
```
✅ Payment status update xong
✅ Listener trigger xong
❌ Nhưng admin vẫn không thấy
```

**Giải pháp:**
- Kiểm tra view filter logic
- Xem `searchQuery` có block thẻ không?
- Thử xóa searchQuery (click nút X)
- Scroll down xem thẻ có ở dưới không?

### Problem 3: Listener không trigger
```
🔄 onReady
📥 Loading...
✅ Loaded X memberships
❌ Nhưng "LISTENER TRIGGERED" không xuất hiện
```

**Giải pháp:**
- Listener setup nhưng chưa có change
- Hãy thanh toán 1 thẻ khác
- Kiểm tra Firestore có data không (Firebase Console)

---

## 📊 Complete Debug Flow

```
1. Customer mua thẻ → Click thanh toán MoMo
   ↓ (Logs từ momo_payment_view)
   ⏳ Updating payment status for transaction: PAY_1234567890
   
2. PaymentService process
   ↓ (Logs từ payment_service)
   📝 Creating membership for user: userId123
   ✅ User membership created: membershipId789
   
3. Admin mở trang Quản Lý Thẻ
   ↓ (Logs từ member_management_controller)
   🔄 MemberManagementController onReady
   📥 Loading user memberships...
   ✅ Loaded 5 memberships
   
4. Listener active
   ↓ (Chờ thẻ mới được tạo)
   
5. Customer thanh toán xong
   ↓
   🔔 LISTENER TRIGGERED
   📌 Processing membership: membershipId789
   ✅ LISTENER: Updated 6 memberships in UI
   
6. Admin view refresh
   ↓
   ✅ Thẻ hiển thị ngay
```

---

## 🧪 Manual Test

### Case 1: Check Firestore Directly
1. Vào [Firebase Console](https://console.firebase.google.com)
2. Chọn project
3. Firestore → Collections → `user_memberships`
4. Tìm membership mới
5. Kiểm tra fields:
   - `isActive: true`
   - `paymentStatus: 'completed'`
   - `startDate`: hôm nay
   - `endDate`: ngày sau

### Case 2: Check Admin View
1. Mở trang "Quản Lý Thẻ Hội Viên"
2. Kiểm tra search/filter (xóa search nếu có)
3. Scroll xem thẻ mới ở đâu
4. Bấm vào thẻ → Xem chi tiết → Kiểm tra startDate/endDate

### Case 3: Test Real-Time
1. Mở trang "Quản Lý Thẻ"
2. Mở 1 tab khác → Thanh toán thẻ
3. Quay lại tab admin
4. ✅ Thẻ phải hiển thị ngay (không cần refresh)

---

## 📋 Log Checklist

### ✅ Successful Flow
- [ ] `⏳ Updating payment status` (payment_service.dart)
- [ ] `📝 Creating membership` (payment_service.dart)
- [ ] `✅ User membership created` (payment_service.dart)
- [ ] `🔄 MemberManagementController onReady` (member_management_controller.dart)
- [ ] `📥 Loading user memberships` (member_management_controller.dart)
- [ ] `📊 Found X user memberships` (member_management_controller.dart)
- [ ] `✅ Loaded X memberships` (member_management_controller.dart)
- [ ] `🎯 Setting up real-time listener` (member_management_controller.dart)
- [ ] `🔔 LISTENER TRIGGERED` (member_management_controller.dart)
- [ ] `✅ LISTENER: Updated X memberships in UI` (member_management_controller.dart)

### ❌ Failure Indicators
- [ ] Logs từ payment_service không thấy → Payment không process
- [ ] `📊 Found 0 user memberships` → Firestore không có data
- [ ] `🔔 LISTENER TRIGGERED` không thấy → Listener không working
- [ ] `❌ Error` logs → Có exception

---

## 🎯 If Still Not Working

1. **Kiểm tra Console Logs** → Có error message không?
2. **Kiểm tra Firestore** → Data có trong DB không?
3. **Kiểm tra Payment Transaction** → Status có update không?
4. **Kiểm tra View Filter** → Filter có block data không?
5. **Restart App** → Có vấn đề cached data không?

---

## 💡 Quick Fixes

```dart
// Fix 1: Refresh manually
controller.loadAllUserMemberships();

// Fix 2: Clear search
controller.updateSearchQuery('');

// Fix 3: Force update
controller.userMemberships.refresh();
```
