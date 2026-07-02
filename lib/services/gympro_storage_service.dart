import 'dart:convert';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

class GymProStorageService {
  static const String _apiGatewayUrl = "https://ple4nn48ib.execute-api.us-east-1.amazonaws.com/default/GymPro_Get_Upload_URL";

  static Future<String?> chooseAndUploadImage() async {
    try {
      print('➔ GymProStorageService: Khởi chạy ImagePicker trực tiếp...');
      // Gọi trực tiếp ImagePicker để mở thư viện ảnh của thiết bị/trình duyệt
      final XFile? image = await ImagePicker().pickImage(
        source: ImageSource.gallery,
        maxWidth: 512,
        maxHeight: 512,
        imageQuality: 80,
      );
      
      if (image == null) {
        print('⚠️ Người dùng đã hủy chọn ảnh.');
        return null;
      }

      print('➔ Đang đọc bytes của ảnh: ${image.name}');
      final List<int> imageBytes = await image.readAsBytes();
      
      print("➔ Đang xin link Presigned URL từ AWS Lambda...");
      final response = await http.post(
        Uri.parse(_apiGatewayUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "fileName": "gympro_${DateTime.now().millisecondsSinceEpoch}_${image.name}",
          "contentType": "image/jpeg"
        }),
      );

      if (response.statusCode != 200) {
        throw Exception("Lambda lỗi: ${response.body}");
      }

      final data = jsonDecode(response.body);
      final String uploadUrl = data['uploadUrl']; 
      final String imageUrl = data['imageUrl'];   

      print("➔ Đang đẩy ảnh trực tiếp lên AWS S3...");
      final uploadResponse = await http.put(
        Uri.parse(uploadUrl),
        body: imageBytes,
        headers: {"Content-Type": "image/jpeg"},
      );

      if (uploadResponse.statusCode == 200) {
        print("🎉 UPLOAD THÀNH CÔNG LÊN AWS S3! URL: $imageUrl");
        return imageUrl;
      }
      
      print("❌ Lỗi PUT S3: Status ${uploadResponse.statusCode}");
      return null;
    } catch (e) {
      print("❌ Lỗi hệ thống Upload S3: $e");
      return null;
    }
  }
}
