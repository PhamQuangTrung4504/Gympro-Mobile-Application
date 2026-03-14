# GymPro Mobile Application

## Tóm tắt dự án

GymPro là sản phẩm mobile đa nền tảng giúp số hóa vận hành phòng gym và nâng trải nghiệm hội viên trong một ứng dụng duy nhất.

Hệ thống phục vụ đồng thời 3 nhóm người dùng:

- Hội viên: đăng ký, mua gói tập, theo dõi lịch tập, check-in QR, đọc tin tức, mua sản phẩm bổ trợ.
- Quản trị viên (Admin): vận hành thành viên, gói tập, nội dung, đơn hàng, lịch tập, doanh thu và báo cáo.
- Huấn luyện viên (PT): quản lý lịch làm việc và tương tác với luồng thuê PT từ hội viên.

Đây là dự án thể hiện năng lực full-cycle ở cả phía sản phẩm và kỹ thuật: phân vai nghiệp vụ, vận hành real-time, thanh toán, quản trị nội dung, AI hỗ trợ tư vấn sức khỏe và thương mại trong hệ sinh thái fitness.

## 1. Mục tiêu sản phẩm

### Bài toán kinh doanh

- Nhiều phòng gym đang quản lý bằng quy trình rời rạc (sổ tay, chat, file thủ công), khó kiểm soát doanh thu và chăm sóc hội viên.
- Hội viên cần trải nghiệm số liền mạch: mua gói, theo dõi tập luyện, nhận tư vấn nhanh, mua sản phẩm.

### Mục tiêu của GymPro

- Tập trung toàn bộ hành trình hội viên vào một ứng dụng.
- Chuẩn hóa vận hành cho admin và PT theo dữ liệu thời gian thực.
- Tăng khả năng giữ chân hội viên bằng trải nghiệm cá nhân hóa (lịch tập + AI tư vấn).

## 2. Giá trị nổi bật

- Tích hợp đa nghiệp vụ trong một app: membership + workout schedule + PT rental + commerce + content + check-in QR.
- Quản trị theo thời gian thực trên Firebase/Firestore, giảm độ trễ vận hành.
- AI Chat nội bộ theo dữ liệu fitness (JSON local), hỗ trợ BMI/BMR/TDEE và tư vấn bài tập/dinh dưỡng.
- Kiến trúc module hóa giúp dễ mở rộng theo từng domain kinh doanh.

## 3. Nhóm chức năng theo vai trò người dùng

### 3.1 Hội viên (Member)

- Tài khoản: đăng ký, đăng nhập, quên mật khẩu, cập nhật hồ sơ, avatar, đổi/xóa tài khoản.
- Membership: chọn gói, checkout, theo dõi trạng thái thanh toán, xem thẻ đã mua.
- Lịch tập: chọn lịch preset, theo dõi tiến độ, tạm dừng/tiếp tục/hoàn thành lịch trình.
- Tin tức: xem feed và nội dung chi tiết.
- Mua sắm: duyệt sản phẩm, giỏ hàng, địa chỉ nhận hàng, tạo đơn, theo dõi lịch sử đơn.
- Thuê PT: gửi yêu cầu thuê, theo dõi trạng thái, lịch sử phiên tập.
- Check-in/checkout: sử dụng mã QR để xác thực vào/ra phòng tập.
- AI Chat: hỏi đáp nhanh về dinh dưỡng, bài tập, chỉ số cơ thể.

### 3.2 Quản trị viên (Admin)

- Quản lý thành viên và vai trò người dùng.
- Quản lý danh mục bài tập.
- Quản lý gói membership và phân hệ mua gói của hội viên.
- Quản lý lịch tập mẫu và vận hành lịch tập người dùng.
- Quản lý tin tức (tạo/sửa/xóa/publish).
- Quản lý danh mục sản phẩm, tồn kho và đơn hàng.
- Quản lý quy trình check-in/checkout.
- Dashboard thống kê: doanh thu, giao dịch, phân bổ gói tập, doanh thu PT, doanh thu sản phẩm.

### 3.3 Huấn luyện viên (PT)

- PT dashboard và lịch làm việc.
- Nhận/duyệt/cập nhật trạng thái đơn thuê PT.
- Theo dõi các buổi tập trong gói thuê.

## 4. Luồng hoạt động chính của hệ thống

### 4.1 Khởi động và điều hướng

- Ứng dụng khởi tạo locale tiếng Việt và Firebase ngay từ entrypoint.
- Splash screen thực hiện kiểm tra phiên đăng nhập.
- Điều hướng theo trạng thái tài khoản và vai trò:
  - Chưa đăng nhập: vào màn hình login.
  - Đã đăng nhập member: vào home.
  - Đã đăng nhập PT: chuyển sang PT dashboard.

### 4.2 Luồng mua gói tập

- Người dùng chọn gói membership.
- Hệ thống tạo giao dịch thanh toán với trạng thái pending.
- Kênh thanh toán hỗ trợ chuyển khoản (VietQR) hoặc tại quầy.
- Khi hoàn tất, hệ thống kích hoạt bản ghi membership của người dùng theo thời hạn gói.

### 4.3 Luồng thương mại sản phẩm

- Người dùng thêm sản phẩm vào giỏ hàng.
- Tạo đơn hàng với thông tin nhận hàng và phương thức thanh toán.
- Tồn kho được cập nhật theo số lượng đã mua.
- Người dùng có thể theo dõi/hủy đơn ở trạng thái phù hợp.

### 4.4 Luồng QR check-in

- Ứng dụng sinh payload QR chứa định danh người dùng.
- Hệ thống xác thực QR, kiểm tra gói tập còn hiệu lực.
- Nếu hợp lệ, ghi nhận bản ghi check-in/checkout vào Firestore.

### 4.5 Luồng AI Chat

- AI Engine xử lý ngôn ngữ tự nhiên tiếng Việt (chuẩn hóa dấu, nhận diện từ khóa/ý định).
- Truy xuất dữ liệu local từ bộ JSON fitness.
- Trả lời theo ngữ cảnh hội thoại, hỗ trợ hỏi tiếp/hiện thêm nội dung.

## 5. Kiến trúc kỹ thuật

### 5.1 Nền tảng và công nghệ

- Frontend: Flutter (Dart), hỗ trợ Android, iOS, Web, Windows.
- State management và routing: GetX.
- Backend as a Service: Firebase Authentication, Cloud Firestore, Firebase Storage.
- Data visualization: fl_chart.
- Camera/QR: camera, mobile_scanner, qr_flutter.
- Tích hợp thanh toán: service lớp ứng dụng + VietQR.

### 5.2 Tổ chức source code

- Entry/App shell: main.dart, app.dart.
- Routes: app_routes.dart, app_pages.dart.
- Controllers: gom business logic theo từng domain.
- Services: kết nối dữ liệu, thanh toán, ảnh, QR, workflow kỹ thuật.
- Models: mô hình dữ liệu nghiệp vụ (user, membership, order, trainer...).
- Views/Screens: phân tách theo vai trò người dùng và nghiệp vụ.
- Feature module độc lập: AI Chat với controller, service, model, view riêng.

### 5.3 Kiểu kiến trúc

Thực tế dự án đi theo hướng feature-driven MVC/MVVM lai:

- Model: lớp dữ liệu và mapping Firestore.
- Controller: điều phối nghiệp vụ, trạng thái và hành vi UI.
- Service: lớp truy cập dữ liệu/tích hợp ngoài.
- View: hiển thị và tương tác người dùng.

## 6. Mô hình dữ liệu nghiệp vụ (Firestore)

Các collection trọng tâm:

- users: hồ sơ tài khoản, vai trò, thông tin cá nhân.
- membership_cards: định nghĩa gói tập.
- membership_purchases và user_memberships: lịch sử mua và trạng thái kích hoạt gói.
- workout_schedules và user_schedules: lịch mẫu và tiến độ người dùng.
- trainers và trainer_rentals: quản lý PT và đơn thuê PT.
- products và orders: thương mại sản phẩm và đơn hàng.
- news: nội dung truyền thông.
- payment_transactions: giao dịch thanh toán.
- check_ins: lịch sử check-in/checkout bằng QR.

## 7. Điểm mạnh thể hiện năng lực dự án

- Thiết kế sản phẩm đa vai trò với nghiệp vụ thực tế, không chỉ demo đơn lẻ.
- Xử lý real-time và đồng bộ dữ liệu Firestore ở nhiều domain.
- Có tư duy mở rộng: module AI tách riêng, route rõ ràng, model hóa dữ liệu đầy đủ.
- Bao quát được cả vận hành nội bộ (admin/PT) lẫn trải nghiệm người dùng cuối.

## 8. Môi trường chạy và cấu hình

### Yêu cầu

- Flutter SDK (khuyến nghị phiên bản stable mới).
- Dart SDK (theo Flutter).
- Android Studio/Xcode (khi build mobile).
- Firebase project đã cấu hình cho ứng dụng.
- Node.js/NPM (khi cần chạy script backend phụ trợ).

### Kiểm tra môi trường

```bash
flutter --version
flutter doctor
```

### Cấu hình Firebase

- Khởi tạo Firebase trong main.dart qua DefaultFirebaseOptions.currentPlatform.
- Cần cấu hình đầy đủ Authentication, Firestore và Storage.
- Bộ rule và config đi kèm trong repository:
  - firestore.rules
  - storage.rules
  - firebase.json

## 9. Hướng dẫn chạy dự án

### Cài đặt dependency

```bash
flutter pub get
```

### Chạy nhanh

```bash
flutter run
```

### Chạy theo nền tảng

```bash
flutter run -d android
flutter run -d ios
flutter run -d chrome
flutter run -d windows
```

### Chạy bằng task VS Code

- Task sẵn có: Flutter Run.

### Chạy script Node (nếu cần)

```bash
npm install
npm run backend
```

Hoặc chạy song song backend và app:

```bash
npm run dev
```

## 10. Build phát hành

```bash
flutter build apk --release
flutter build appbundle --release
flutter build web --release
flutter build windows --release
```

## 11. Lưu ý vận hành và chất lượng

- Dự án có một số file mang tính thử nghiệm/legacy (ví dụ biến thể \_old, \_backup, \_simple), cho thấy quá trình tối ưu liên tục.
- Cần kiểm soát môi trường Firebase chặt chẽ khi chuyển từ dev sang production.
- Nên bổ sung thêm test tự động cho các luồng quan trọng: auth, thanh toán, đơn hàng, check-in.

## 12. Kết luận ngắn gọn cho HR

GymPro là dự án mobile quy mô thực chiến trong lĩnh vực fitness management, thể hiện năng lực triển khai sản phẩm end-to-end:

- Thiết kế nghiệp vụ đa vai trò (member/admin/PT).
- Tổ chức kiến trúc module rõ ràng, dễ mở rộng.
- Tích hợp được nhiều bài toán thực tế: thanh toán, thương mại, lịch tập, AI trợ lý, kiểm soát ra vào bằng QR.

Đây là một hồ sơ dự án phù hợp để đánh giá năng lực xây dựng sản phẩm số hoàn chỉnh, từ tư duy nghiệp vụ đến triển khai kỹ thuật.
