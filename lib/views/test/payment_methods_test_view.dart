import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../models/membership_card.dart';

/// Test view để demo phương thức thanh toán MoMo và QR Banking
class PaymentMethodsTestView extends StatelessWidget {
  const PaymentMethodsTestView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Test Phương Thức Thanh Toán'),
        backgroundColor: const Color(0xFF2196F3),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Chọn phương thức thanh toán để test:',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),

              // Direct Payment
              _buildPaymentButton(
                context,
                'Thanh toán trực tiếp',
                'Đến quầy lễ tân',
                Colors.blue,
                Icons.store,
                () => _navigateToCheckout(context, 'direct'),
              ),

              const SizedBox(height: 12),

              // MoMo Payment
              _buildPaymentButton(
                context,
                'Thanh toán MoMo',
                'Nhanh chóng & an toàn',
                const Color(0xFFFF6B35),
                Icons.phone_android,
                () => _navigateToCheckout(context, 'momo'),
              ),

              const SizedBox(height: 12),

              // Bank QR Payment
              _buildPaymentButton(
                context,
                'QR Ngân hàng',
                'Quét mã QR',
                const Color(0xFF1E3A8A),
                Icons.qr_code_2,
                () => _navigateToCheckout(context, 'bank_qr'),
              ),

              const SizedBox(height: 32),

              // Information Box
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.blue.withOpacity(0.3)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Thông tin test',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Các phương thức thanh toán này đang ở chế độ demo.\n\n'
                      'Để sử dụng thanh toán thực tế:\n\n'
                      '1. MoMo: Tích hợp MoMo API với API key từ MoMo\n'
                      '2. QR Banking: Kết nối với dịch vụ kiểm tra giao dịch ngân hàng\n\n'
                      'Hiện tại, các view đang hiển thị mock data.',
                      style: TextStyle(fontSize: 12, height: 1.6),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Test with Different Card Types
              const Text(
                'Hoặc test với các loại thẻ khác nhau:',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              _buildCardTypeButton('Thẻ 1 Tháng'),
              const SizedBox(height: 8),
              _buildCardTypeButton('Thẻ 3 Tháng'),
              const SizedBox(height: 8),
              _buildCardTypeButton('Thẻ 6 Tháng'),
              const SizedBox(height: 8),
              _buildCardTypeButton('Thẻ 1 Năm'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPaymentButton(
    BuildContext context,
    String title,
    String subtitle,
    Color color,
    IconData icon,
    VoidCallback onPressed,
  ) {
    return Card(
      elevation: 2,
      child: ListTile(
        leading: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: Colors.white, size: 28),
        ),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: onPressed,
      ),
    );
  }

  Widget _buildCardTypeButton(String cardName) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton(
        onPressed: () => _navigateToCheckoutWithCard(Get.context!, cardName),
        child: Text(cardName),
      ),
    );
  }

  void _navigateToCheckout(BuildContext context, String paymentType) {
    // Create a demo membership card
    final demoCard = MembershipCard(
      id: 'demo-card-${DateTime.now().millisecondsSinceEpoch}',
      cardName: 'Thẻ Tập 3 Tháng',
      description: 'Thẻ tập 3 tháng cho phép vào gym không giới hạn',
      cardType: CardType.member,
      price: 300000,
      duration: 3,
      durationType: DurationType.months,
      isActive: true,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      createdBy: 'admin',
    );

    // Navigate to checkout view
    Get.toNamed(
      '/checkout',
      arguments: demoCard,
    );
  }

  void _navigateToCheckoutWithCard(BuildContext context, String cardName) {
    // Create a membership card based on selection
    double price = 0;
    int duration = 0;
    DurationType durationType = DurationType.months;

    if (cardName.contains('1 Tháng')) {
      price = 150000;
      duration = 1;
      durationType = DurationType.months;
    } else if (cardName.contains('3 Tháng')) {
      price = 300000;
      duration = 3;
      durationType = DurationType.months;
    } else if (cardName.contains('6 Tháng')) {
      price = 550000;
      duration = 6;
      durationType = DurationType.months;
    } else if (cardName.contains('1 Năm')) {
      price = 900000;
      duration = 1;
      durationType = DurationType.years;
    }

    final card = MembershipCard(
      id: 'demo-card-${DateTime.now().millisecondsSinceEpoch}',
      cardName: cardName,
      description: '$cardName cho phép vào gym không giới hạn',
      cardType: CardType.member,
      price: price,
      duration: duration,
      durationType: durationType,
      isActive: true,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      createdBy: 'admin',
    );

    // Navigate to checkout
    Get.toNamed('/checkout', arguments: card);
  }
}
