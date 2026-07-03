import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'firebase_service.dart';

class CognitoUserMetadata {
  final DateTime? creationTime;
  final DateTime? lastSignInTime;

  CognitoUserMetadata({this.creationTime, this.lastSignInTime});
}

class CognitoUser {
  final String uid;
  final String email;
  final String? displayName;
  final String? phoneNumber;
  final String? photoURL;
  final CognitoUserMetadata metadata;

  CognitoUser({
    required this.uid,
    required this.email,
    this.displayName,
    this.phoneNumber,
    this.photoURL,
    CognitoUserMetadata? metadata,
  }) : metadata = metadata ?? CognitoUserMetadata(creationTime: DateTime.now());
}

class AuthService {
  // === KHÔI PHỤC BIẾN TĨNH ĐỂ GIỮ TƯƠNG THÍCH TOÀN CỤC ===
  static CognitoUser? currentUser;
  // ======================================================
  // Thay thế thuộc tính lấy current user ID (Cognito Sub)
  static Future<String?> get currentUserId async {
    try {
      final session = await Amplify.Auth.fetchAuthSession();
      if (session.isSignedIn) {
        final userDetails = await Amplify.Auth.getCurrentUser();
        return userDetails.userId;
      }
    } catch (_) {}
    return null;
  }

  // Đăng nhập qua AWS Cognito
  static Future<bool> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final result = await Amplify.Auth.signIn(username: email, password: password);
      return result.isSignedIn;
    } on AuthException catch (e) {
      throw Exception(_handleCognitoException(e));
    }
  }

  // Đăng ký qua AWS Cognito (Chờ kích hoạt mã OTP qua email)
  static Future<SignUpResult> registerWithEmailAndPassword({
    required String email,
    required String password,
    required String fullName,
  }) async {
    try {
      final result = await Amplify.Auth.signUp(
        username: email,
        password: password,
        options: SignUpOptions(
          userAttributes: {
            AuthUserAttributeKey.email: email,
            AuthUserAttributeKey.name: fullName,
          },
        ),
      );
      return result;
    } on AuthException catch (e) {
      throw Exception(_handleCognitoException(e));
    }
  }

  // Xác thực mã OTP sau khi đăng ký để mở khóa tài khoản Cognito + Đồng thời sinh Document dữ liệu bên Firestore
  static Future<bool> confirmSignUp({
    required String email,
    required String confirmationCode,
    required String fullName,
  }) async {
    try {
      final result = await Amplify.Auth.confirmSignUp(
        username: email,
        confirmationCode: confirmationCode,
      );
      return result.isSignUpComplete;
    } on AuthException catch (e) {
      throw Exception(_handleCognitoException(e));
    }
  }

  // Đăng xuất khỏi AWS Cognito
  static Future<void> signOut() async {
    try {
      await Amplify.Auth.signOut();
    } catch (e) {
      throw Exception('Lỗi đăng xuất hệ thống: $e');
    }
  }

  // Đổi mật khẩu
  static Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    try {
      await Amplify.Auth.updatePassword(oldPassword: currentPassword, newPassword: newPassword);
    } on AuthException catch (e) {
      throw Exception(_handleCognitoException(e));
    }
  }

  // Quên mật khẩu / Gửi mail reset
  static Future<void> resetPassword(String email) async {
    try {
      await Amplify.Auth.resetPassword(username: email);
    } on AuthException catch (e) {
      throw Exception(_handleCognitoException(e));
    }
  }

  // Xóa vĩnh viễn tài khoản
  static Future<void> deleteAccount([String? userId]) async {
    try {
      final uid = userId ?? await currentUserId;
      if (uid != null) {
        await FirebaseService.deleteUserAccount(uid); // Xóa Firestore trước
      }
      await Amplify.Auth.deleteUser(); // Xóa Cognito sau
    } on AuthException catch (e) {
      throw Exception(_handleCognitoException(e));
    }
  }

  // Bộ dịch thông báo lỗi chuẩn từ AWS Cognito sang Tiếng Việt
  static String _handleCognitoException(AuthException e) {
    if (e is UserNotFoundException) return 'Tài khoản Email này không tồn tại trong hệ thống.';
    if (e is AuthNotAuthorizedException) return 'Mật khẩu không chính xác. Vui lòng kiểm tra lại.';
    if (e is UsernameExistsException) return 'Email này đã được sử dụng bởi một hội viên khác.';
    if (e is InvalidPasswordException) return 'Mật khẩu quá yếu (Yêu cầu ít nhất 8 ký tự, gồm chữ hoa, chữ thường và số).';
    if (e is CodeMismatchException) return 'Mã xác thực OTP nhập vào không chính xác.';
    if (e is ExpiredCodeException) return 'Mã xác thực OTP đã hết hạn. Vui lòng bấm gửi lại mã.';
    return e.message;
  }
}
