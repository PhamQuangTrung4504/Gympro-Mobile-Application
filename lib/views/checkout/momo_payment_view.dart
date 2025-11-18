import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../../controllers/checkout_controller.dart';
import '../../models/membership_card.dart';
import '../../models/payment_transaction.dart';
import '../../services/payment_service.dart';
import '../../widgets/loading_button.dart';

class MoMoPaymentView extends StatelessWidget {
  final CheckoutController controller = Get.find<CheckoutController>();

  MoMoPaymentView({super.key});

  @override
  Widget build(BuildContext context) {
    // Get arguments
    final membershipCard = Get.arguments['membershipCard'] as MembershipCard?;
    final transaction = Get.arguments['transaction'] as PaymentTransaction?;

    if (membershipCard == null || transaction == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Lỗi')),
        body: const Center(child: Text('Dữ liệu không hợp lệ')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Thanh toán MoMo'),
        backgroundColor: const Color(0xFFFF6B35),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              const Text(
                'Thanh toán qua MoMo',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                'Nhanh chóng, an toàn và tiện lợi',
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),

              const SizedBox(height: 24),

              // MoMo Logo
              Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Image.asset(
                  'assets/images/momo_logo.png',
                  width: 120,
                  height: 120,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        color: const Color(0xFFFF6B35),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(
                        Icons.payments,
                        color: Colors.white,
                        size: 60,
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 24),

              // MoMo QR Code (for demo)
              Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.withOpacity(0.3)),
                ),
                child: Column(
                  children: [
                    QrImageView(
                      data: _generateMoMoQRData(
                        amount: membershipCard.price,
                        description: 'GYMPRO-${membershipCard.cardName}',
                      ),
                      version: QrVersions.auto,
                      size: 200.0,
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black,
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Quét mã QR bằng ứng dụng MoMo',
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),
              Card(
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Chi tiết đơn hàng',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Sản phẩm:'),
                          Text(
                            membershipCard.cardName,
                            style: const TextStyle(fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Mô tả:'),
                          Expanded(
                            child: Text(
                              membershipCard.description,
                              textAlign: TextAlign.right,
                              style: const TextStyle(fontSize: 12),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Mã giao dịch:'),
                          Text(
                            transaction.id,
                            style: const TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 12,
                              color: Color(0xFFFF6B35),
                            ),
                          ),
                        ],
                      ),
                      const Divider(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Tổng cộng:',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            '${membershipCard.price.toStringAsFixed(0)} VNĐ',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.green,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Transfer Content Box
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.orange.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.orange.withOpacity(0.3)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.info, color: Color(0xFFFF6B35), size: 20),
                        SizedBox(width: 8),
                        Text(
                          'Nội dung chuyển khoản',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color(0xFFFF6B35),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(color: Colors.grey.withOpacity(0.2)),
                      ),
                      child: SelectableText(
                        _generateTransferContent(
                          userEmail: controller.currentUser?.email ?? 'N/A',
                          transactionId: transaction.id,
                        ),
                        style: const TextStyle(
                          fontSize: 12,
                          fontFamily: 'monospace',
                          height: 1.6,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Sao chép nội dung trên vào phần ghi chú khi chuyển khoản',
                      style: TextStyle(fontSize: 11, color: Colors.grey),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Information Box
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.blue.withOpacity(0.3)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.info, color: Colors.blue, size: 20),
                        SizedBox(width: 8),
                        Text(
                          'Hướng dẫn thanh toán',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      '1. Nhấn "Thanh toán MoMo" để mở ứng dụng MoMo\n'
                      '2. Nhập mã PIN hoặc xác thực bằng sinh trắc học\n'
                      '3. Xác nhận giao dịch\n'
                      '4. Quay lại ứng dụng để xem kết quả',
                      style: TextStyle(fontSize: 12, height: 1.6),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              // MoMo Payment Button
              SizedBox(
                width: double.infinity,
                child: Obx(
                  () => LoadingButton(
                    text: 'Thanh toán ${membershipCard.price.toStringAsFixed(0)} VNĐ qua MoMo',
                    isLoading: controller.isProcessingPayment.value,
                    backgroundColor: const Color(0xFFFF6B35),
                    onPressed: () {
                      _handleMoMoPayment(context, transaction);
                    },
                  ),
                ),
              ),

              const SizedBox(height: 12),

              // Cancel Button
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () {
                    Get.back();
                  },
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: const Text('Quay lại'),
                ),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  void _handleMoMoPayment(BuildContext context, PaymentTransaction transaction) {
    controller.isProcessingPayment.value = true;

    // Simulate MoMo payment processing
    Future.delayed(const Duration(seconds: 2), () async {
      controller.isProcessingPayment.value = false;

      // Update payment status to completed and save membership
      try {
        final paymentService = PaymentService();
        print('⏳ Updating payment status for transaction: ${transaction.id}');
        await paymentService.updatePaymentStatus(
          transaction.id,
          PaymentStatus.completed,
        );
        print('✅ Payment status updated successfully');
        
        // Wait a bit more to ensure Firestore write is complete
        await Future.delayed(const Duration(milliseconds: 500));
      } catch (e) {
        print('❌ Error updating payment status: $e');
      }

      // Show success dialog
      if (context.mounted) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Thanh toán thành công'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.check_circle,
                  color: Colors.green,
                  size: 60,
                ),
                const SizedBox(height: 16),
                Text(
                  'Giao dịch: ${transaction.id}',
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                const Text(
                  'Thẻ tập của bạn đã được kích hoạt',
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Get.back(); // Close dialog
                  Get.offNamed('/home'); // Navigate to home
                },
                child: const Text('Xong'),
              ),
            ],
          ),
        );
      }
    });
  }

  /// Tạo nội dung chuyển khoản với email user và mã giao dịch
  String _generateTransferContent({
    required String userEmail,
    required String transactionId,
  }) {
    return '$userEmail - $transactionId';
  }

  /// Tạo dữ liệu QR code cho MoMo
  /// Format: momo://qr/[amount]/[description]
  String _generateMoMoQRData({
    required double amount,
    required String description,
  }) {
    // MoMo QR format
    // Dạng đơn giản: momo://transfer?phone=PHONE&name=NAME&amount=AMOUNT&note=NOTE
    // Hoặc: momo://[phoneNumber]/[amount]/[description]
    
    const phoneNumber = '0123456789'; // Demo phone
    const momoName = 'GYMPRO';
    final amountStr = amount.toStringAsFixed(0);
    
    // Tạo QR data theo MoMo format
    final qrData = 'momo://transfer?phone=$phoneNumber&name=$momoName&amount=$amountStr&note=$description';
    return qrData;
  }
}
