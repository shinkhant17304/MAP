import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: true,
      home: SignInPage(),
    );
  }
}

class SignInPage extends StatelessWidget {
  const SignInPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1E1E1E),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Top Image Header
            SizedBox(
              height: 280,
              width: double.infinity,
              child: Image.network(
                'https://images.unsplash.com/photo-1509440159596-0249088772ff?w=800',
                fit: BoxFit.cover,
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 28.0, vertical: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header Row: SIGN IN / SIGN UP
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text(
                        'SIGN IN',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.1,
                        ),
                      ),
                      Text(
                        'SIGN UP',
                        style: TextStyle(
                          color: Color(0xFFE08B34),
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.1,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 50),

                  // Email Address Input Field
                  Row(
                    children: const [
                      Icon(
                        Icons.alternate_email,
                        color: Color(0xFFE08B34),
                        size: 22,
                      ),
                      SizedBox(width: 16),
                      Expanded(
                        child: TextField(
                          style: TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            hintText: 'Email Address',
                            hintStyle: TextStyle(color: Colors.grey, fontSize: 16),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Color(0xFFE08B34)),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 30),

                  // Password Input Field
                  Row(
                    children: const [
                      Icon(
                        Icons.lock_outline,
                        color: Color(0xFFE08B34),
                        size: 22,
                      ),
                      SizedBox(width: 16),
                      Expanded(
                        child: TextField(
                          obscureText: true,
                          style: TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            hintText: 'Password',
                            hintStyle: TextStyle(color: Colors.grey, fontSize: 16),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Color(0xFFE08B34)),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 60),

                  // Bottom Action Buttons Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Social/Action Icons (Left)
                      Row(
                        children: [
                          _buildCircleIconButton(Icons.android),
                          const SizedBox(width: 12),
                          _buildCircleIconButton(Icons.chat_bubble_outline),
                        ],
                      ),

                      // Submit Arrow Button (Right)
                      Container(
                        width: 50,
                        height: 50,
                        decoration: const BoxDecoration(
                          color: Color(0xFFE08B34),
                          shape: BoxShape.circle,
                        ),
                        child: IconButton(
                          icon: const Icon(Icons.arrow_forward, color: Colors.black),
                          onPressed: () {},
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  static Widget _buildCircleIconButton(IconData icon) {
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colors.grey.shade700, width: 1.5),
      ),
      child: Icon(
        icon,
        color: Colors.grey,
        size: 20,
      ),
    );
  }
}