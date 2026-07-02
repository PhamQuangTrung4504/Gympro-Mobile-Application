import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http; // THÊM THƯ VIỆN HTTP
import '../models/chat_message.dart';
import '../services/ai_data_service.dart';
import '../services/body_metrics_calculator.dart';
import '../services/ai_engine.dart';

/// Controller cho AI Chat kết nối song song AWS Cloud API và Local Engine
class AIChatController extends GetxController {
  final RxList<ChatMessage> _messages = <ChatMessage>[].obs;
  final RxBool _isTyping = false.obs;
  final RxBool _isChatOpen = false.obs;
  final Rx<Offset> _iconPosition = Offset.zero.obs;

  // Địa chỉ AWS API Gateway chính thức của bạn
  final String awsApiUrl = 'https://0lyzd4srec.execute-api.us-east-1.amazonaws.com/v1/ai-chat';

  // AI Services (Giữ lại để dự phòng hoặc làm Local Fallback)
  late final AIDataService _dataService;
  late final BodyMetricsCalculator _calculator;
  late final AIEngine _aiEngine;

  // ScrollController để tự động scroll đến tin nhắn mới
  final ScrollController scrollController = ScrollController();

  List<ChatMessage> get messages => _messages;
  bool get isTyping => _isTyping.value;
  bool get isChatOpen => _isChatOpen.value;
  Offset get iconPosition => _iconPosition.value;

  void updateIconPosition(Offset position) {
    _iconPosition.value = position;
  }

  @override
  void onInit() {
    super.onInit();
    _initializeAI();
  }

  @override
  void onClose() {
    scrollController.dispose();
    super.onClose();
  }

  /// Scroll xuống tin nhắn mới nhất
  void scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (scrollController.hasClients) {
        await Future.delayed(const Duration(milliseconds: 100));
        if (scrollController.hasClients) {
          final position = scrollController.position;
          scrollController.animateTo(
            position.maxScrollExtent,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOutCubic,
          );
        }
      }
    });
  }

  /// Khởi tạo AI Engine
  Future<void> _initializeAI() async {
    try {
      _dataService = AIDataService();
      await _dataService.initialize();

      _calculator = BodyMetricsCalculator(_dataService);
      _aiEngine = AIEngine(_dataService, _calculator);

      _addWelcomeMessage();
      print('✅ AI Chat Controller kết nối AWS Cloud sẵn sàng');
    } catch (e) {
      print('❌ Error initializing AI: $e');
      _addErrorMessage();
    }
  }

  void _addWelcomeMessage() {
    _messages.add(
      ChatMessage(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        content: '''
 Xin chào! Tôi là Gym Pro AI trợ lý đám mây thông minh của bạn!

 Tôi có thể giúp bạn:
• Tính BMI, BMR, TDEE
• Tư vấn bài tập sinh động
• Gợi ý thực đơn dinh dưỡng
• Lịch tập chuyên sâu theo thể trạng

Bạn cần giúp gì hôm nay? 
''',
        isUser: false,
        timestamp: DateTime.now(),
      ),
    );
  }

  void _addErrorMessage() {
    _messages.add(
      ChatMessage(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        content: 'Xin lỗi, đã có lỗi khi khởi tạo AI. Vui lòng thử lại sau! 😔',
        isUser: false,
        timestamp: DateTime.now(),
      ),
    );
  }

  void toggleChat() {
    _isChatOpen.value = !_isChatOpen.value;
  }

  void openChat() {
    _isChatOpen.value = true;
  }

  void closeChat() {
    _isChatOpen.value = false;
  }

  /// GỬI TIN NHẮN LÊN AWS LAMBDA
  Future<void> sendMessage(String content) async {
    if (content.trim().isEmpty) return;

    final userMessage = ChatMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      content: content.trim(),
      isUser: true,
      timestamp: DateTime.now(),
    );
    _messages.add(userMessage);

    // Tự động cuộn xuống dưới xem tin nhắn vừa gửi
    scrollToBottom();
    _isTyping.value = true;

    try {
      print("🚀 Đang gửi request lên AWS API Gateway...");
      
      // Thực hiện cuộc gọi HTTP POST lên Đám mây AWS
      final response = await http.post(
        Uri.parse(awsApiUrl),
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "message": content.trim(), // Truyền tin nhắn của người dùng lên Lambda
        }),
      ).timeout(const Duration(seconds: 15)); // Giới hạn timeout 15s đề phòng mạng lag

      _isTyping.value = false;

      if (response.statusCode == 200) {
        // Giải mã JSON nhận về từ AWS Lambda
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        final String aiResponse = responseData['message'] ?? 'Không nhận được phản hồi từ AI.';

        final aiMessage = ChatMessage(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          content: aiResponse,
          isUser: false,
          timestamp: DateTime.now(),
        );
        _messages.add(aiMessage);
      } else {
        // Nếu API lỗi (Ví dụ: 403, 404, 500), tự động dùng Engine Local làm phương án dự phòng (Fallback)
        print("⚠️ AWS lỗi (Mã lỗi ${response.statusCode}), chuyển sang dùng Local Engine...");
        final localResponse = await _aiEngine.processMessage(content);
        
        _messages.add(ChatMessage(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          content: "[Offline Mode] $localResponse",
          isUser: false,
          timestamp: DateTime.now(),
        ));
      }
      
      scrollToBottom(); // Cuộn tiếp khi nhận được câu trả lời
    } catch (e) {
      _isTyping.value = false;
      print("❌ Lỗi mạng khi gọi AWS: $e. Sử dụng Local Fallback...");
      
      // Nếu mất mạng hoàn toàn, tiếp tục dùng Local Engine làm Fallback cứu cánh
      try {
        final localResponse = await _aiEngine.processMessage(content);
        _messages.add(ChatMessage(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          content: "[Offline Mode] $localResponse",
          isUser: false,
          timestamp: DateTime.now(),
        ));
        scrollToBottom();
      } catch (localError) {
        _messages.add(ChatMessage(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          content: 'Không thể kết nối đến máy chủ AWS và Local Engine cũng gặp lỗi. 😔\n\n$e',
          isUser: false,
          timestamp: DateTime.now(),
        ));
      }
    }
  }

  void clearMessages() {
    _messages.clear();
    _aiEngine.clearContext();
    _addWelcomeMessage();
  }
}