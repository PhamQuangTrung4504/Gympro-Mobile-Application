import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'dart:math';
import '../../controllers/checkout_controller.dart';
import '../../models/membership_card.dart';
import '../../models/payment_transaction.dart';
import '../../widgets/loading_button.dart';
import 'package:flutter/services.dart';

class BankQRPaymentView extends StatefulWidget {
  const BankQRPaymentView({super.key});

  @override
  State<BankQRPaymentView> createState() => _BankQRPaymentViewState();
}

class _BankQRPaymentViewState extends State<BankQRPaymentView> {
  late CheckoutController controller;
  late MembershipCard membershipCard;
  late PaymentTransaction transaction;
  late String _displayedTransactionId;
  bool _showCopiedMessage = false;

  @override
  void initState() {
    super.initState();
    controller = Get.find<CheckoutController>();
    membershipCard = Get.arguments['membershipCard'] as MembershipCard;
    transaction = Get.arguments['transaction'] as PaymentTransaction;
    _displayedTransactionId = _generateTransactionId();
  }

  String _generateTransactionId() {
    final rnd = Random();
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    return List.generate(10, (_) => chars[rnd.nextInt(chars.length)]).join();
  }

  @override
  Widget build(BuildContext context) {
    final bankAccountNumber = '1234567890';
    final bankName = 'Techcombank';
    final accountHolder = 'GYMPRO CO., LTD';
    final amount = membershipCard.price.toStringAsFixed(0);
  final userEmail = controller.currentUser?.email ?? '';
  final description =
    'THANHTOAN ${membershipCard.cardName.replaceAll(' ', '')} | $userEmail | $_displayedTransactionId';

    // Generate QR code data (VietQR format)
    final qrData =
        '00020126480010A00000072701240006970454011215401210213${bankAccountNumber}5802VN5913${accountHolder}6009DA NANG62410615GYMPRO63048A14';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Thanh toán bằng QR ngân hàng'),
        backgroundColor: const Color(0xFF1E3A8A),
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
                'Quét mã QR để thanh toán',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                'Sử dụng ứng dụng ngân hàng của bạn để quét và thanh toán',
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),

              const SizedBox(height: 24),

              // Order Details
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
                          const Text('Số tiền:'),
                          Text(
                            '$amount VNĐ',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.green,
                              fontSize: 14,
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
                            _displayedTransactionId,
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // QR Code
              Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.symmetric(vertical: 20),
                decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.withOpacity(0.3)),
                ),
                child: Column(
                  children: [
                    QrImageView(
                      data: qrData,
                      version: QrVersions.auto,
                      size: 250.0,
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black,
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Quét mã QR bằng ứng dụng ngân hàng',
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Bank Transfer Details
              Card(
                elevation: 1,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Thông tin chuyển khoản',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      _buildBankInfoRow('Ngân hàng:', bankName),
                      const SizedBox(height: 8),
                      _buildBankInfoRow('Chủ tài khoản:', accountHolder),
                      const SizedBox(height: 8),
                      _buildCopyableRow('Số tài khoản:', bankAccountNumber),
                      const SizedBox(height: 8),
                      _buildBankInfoRow('Số tiền:', '$amount VNĐ'),
                      const SizedBox(height: 8),
                      _buildCopyableRow('Nội dung:', description),
                    ],
                  ),
                ),
              ),

              if (_showCopiedMessage)
                Padding(
                  padding: const EdgeInsets.only(top: 12.0),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.green.withOpacity(0.1),
                      border: Border.all(color: Colors.green.withOpacity(0.3)),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.check, color: Colors.green, size: 18),
                        SizedBox(width: 8),
                        Text(
                          'Đã sao chép',
                          style: TextStyle(
                            color: Colors.green,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
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
                          'Lưu ý',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      '• Quét mã QR bằng ứng dụng ngân hàng hoặc ứng dụng hỗ trợ\n'
                      '• Kiểm tra lại số tiền trước khi xác nhận\n'
                      '• Ghi đúng nội dung chuyển khoản\n'
                      '• Giao dịch có thể mất vài phút để xử lý',
                      style: TextStyle(fontSize: 12, height: 1.6),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              // Confirm Payment Button
              SizedBox(
                width: double.infinity,
                child: Obx(
                  () => LoadingButton(
                    text: 'Tôi đã chuyển khoản',
                    isLoading: controller.isProcessingPayment.value,
                    backgroundColor: const Color(0xFF1E3A8A),
                    onPressed: () {
                      _handlePaymentConfirmation(context);
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

  Widget _buildBankInfoRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 12, color: Colors.grey),
        ),
        Expanded(
          child: Text(
            value,
            textAlign: TextAlign.right,
            style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 12),
          ),
        ),
      ],
    );
  }

  Widget _buildCopyableRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 12, color: Colors.grey),
        ),
        Expanded(
          child: GestureDetector(
            onTap: () {
              _copyToClipboard(value);
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.1),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Expanded(
                    child: Text(
                      value,
                      textAlign: TextAlign.right,
                      style: const TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 12,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 6),
                  const Icon(Icons.copy, size: 14, color: Colors.blue),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _copyToClipboard(String text) {
    // Implement copy to clipboard functionality
    Clipboard.setData(ClipboardData(text: text));
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Đã sao chép: $text'),
        duration: const Duration(seconds: 2),
      ),
    );

    setState(() {
      _showCopiedMessage = true;
    });

    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _showCopiedMessage = false;
        });
      }
    });
  }

  void _handlePaymentConfirmation(BuildContext context) {
    controller.isProcessingPayment.value = true;

    // Simulate payment verification
    Future.delayed(const Duration(seconds: 2), () {
      controller.isProcessingPayment.value = false;

      // Show success dialog
      showDialog(
        context: context,
        barrierDismissible: false,
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
              const Text(
                'Đơn hàng của bạn sẽ được xử lý ngay',
              ),
              const SizedBox(height: 8),
              Text(
                'Mã giao dịch: ${transaction.id}',
                style: const TextStyle(fontSize: 12, color: Colors.grey),
                textAlign: TextAlign.center,
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
    });
  }
}
