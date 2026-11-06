import 'dart:math';
import 'package:flutter/material.dart';

void main() => runApp(const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: CafeDiscountPage(),
    ));

class CafeDiscountPage extends StatefulWidget {
  const CafeDiscountPage({super.key});

  @override
  State<CafeDiscountPage> createState() => _CafeDiscountPageState();
}

class _CafeDiscountPageState extends State<CafeDiscountPage> {
  final TextEditingController _billController = TextEditingController();
  int _discountPercent = 0;
  String _finalResult = '';

  // 1. RANDOM NUMBER: Generates random discount (5%, 10%, 15%, 20%, or 25%)
  void _generateDiscount() {
    setState(() {
      _discountPercent = (Random().nextInt(5) + 1) * 5;
    });
  }

  // 2. TEXTFIELD LOGIC: Calculates final bill price after discount
  void _calculateTotal() {
    final String input = _billController.text.trim();
    final double? bill = double.tryParse(input);

    if (bill == null || bill <= 0) {
      setState(() {
        _finalResult = 'Please enter a valid bill amount.';
      });
      return;
    }

    final double discountAmount = bill * (_discountPercent / 100);
    final double finalBill = bill - discountAmount;

    setState(() {
      _finalResult = 'Original Bill: \$${bill.toStringAsFixed(2)}\n'
          'Discount ($_discountPercent%): -\$${discountAmount.toStringAsFixed(2)}\n'
          'Final Total: \$${finalBill.toStringAsFixed(2)}';
    });
  }

  void _reset() {
    setState(() {
      _billController.clear();
      _discountPercent = 0;
      _finalResult = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('☕ Cafe Lucky Discount'),
        backgroundColor: Colors.brown,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column( // LAYOUT: Vertical Stack
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // TOPIC 1: ASSET IMAGE BANNER
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(
                'assets/images/cafe_banner.png', //IMG
                height: 130,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  height: 130,
                  color: Colors.brown.shade100,
                  child: const Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.local_cafe, size: 36, color: Colors.brown),
                        SizedBox(width: 8),
                        Text('Welcome to Daily Coffee!',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // INSERTED IMAGE: Displays the supplied cafe image from the web.
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTYPzW-mf0H9oDRZm_FX7NWNWvzVnurkIqi1wzhKhhckg&s=10',
                height: 130,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => const SizedBox.shrink(),
              ),
            ),
            const SizedBox(height: 16),

            // TOPIC 2 & 3: RANDOM DISCOUNT + ROW LAYOUT
            Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row( // LAYOUT: Horizontal Alignment
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Coupon: $_discountPercent% OFF',
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.brown,
                          foregroundColor: Colors.white),
                      onPressed: _generateDiscount,
                      icon: const Icon(Icons.card_giftcard), // ICON
                      label: const Text('Draw Coupon'), // BUTTON
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // TOPIC 4: TEXTFIELD & ICONS
            TextField(
              controller: _billController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Enter Total Bill (\$)',
                prefixIcon: Icon(Icons.attach_money, color: Colors.brown),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),

            // TOPIC 3 & 4: EXPANDED BUTTONS IN ROW
            Row(
              children: [
                Expanded( // LAYOUT: Takes 50% width
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.brown,
                        foregroundColor: Colors.white),
                    onPressed: _calculateTotal,
                    icon: const Icon(Icons.calculate),
                    label: const Text('Calculate'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded( // LAYOUT: Takes 50% width
                  child: OutlinedButton.icon(
                    onPressed: _reset,
                    icon: const Icon(Icons.refresh),
                    label: const Text('Reset'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // DYNAMIC RESULT DISPLAY
            if (_finalResult.isNotEmpty)
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.brown.shade50,
                  border: Border.all(color: Colors.brown.shade300),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  _finalResult,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.brown),
                ),
              ),
          ],
        ),
      ),
    );
  }
}