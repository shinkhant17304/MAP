import 'package:flutter/material.dart';

import 'learner_store.dart';

class BusuuAuthView extends StatefulWidget {
  const BusuuAuthView({super.key});

  @override
  State<BusuuAuthView> createState() => _BusuuAuthViewState();
}

class _BusuuAuthViewState extends State<BusuuAuthView> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _fullNameController = TextEditingController();

  bool _isLogin = true;
  bool _obscurePassword = true;
  String _selectedRole = 'Learner'; // 'Learner' or 'Admin'

  Future<void> _handleAuthentication() async {
    final email = _usernameController.text.trim();
    final password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter your email and password')),
      );
      return;
    }

    // Role-based routing
    if (_selectedRole == 'Admin') {
      Navigator.pushReplacementNamed(context, '/admin');
      return;
    }

    final learnerStore = LearnerStore.instance;
    LearnerProfile? profile;
    if (_isLogin) {
      profile = await learnerStore.findByEmail(email);
      if (profile == null) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Learner account not found. Please register first.'),
          ),
        );
        return;
      }
    } else {
      final fullName = _fullNameController.text.trim();
      if (fullName.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please enter your full name')),
        );
        return;
      }
      final registered = await learnerStore.register(
        fullName: fullName,
        email: email,
      );
      if (!registered) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('An account already uses this email')),
        );
        return;
      }
      profile = await learnerStore.findByEmail(email);
    }

    if (!mounted) return;
    Navigator.pushReplacementNamed(context, '/main', arguments: profile);
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    _fullNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const busuuBlue = Color(0xFF0056C6);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          TextButton(
            onPressed: () => setState(() => _isLogin = !_isLogin),
            child: Text(
              _isLogin ? 'Register' : 'Sign In',
              style: const TextStyle(
                color: busuuBlue,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Busuu Branding Header
              const Icon(Icons.translate_rounded, size: 64, color: busuuBlue),
              const SizedBox(height: 12),
              Text(
                _isLogin ? 'Welcome back!' : 'Start Learning Today',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                _isLogin
                    ? 'Log in to continue your streak'
                    : 'Create your account to unlock language paths',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
              ),
              const SizedBox(height: 32),

              // Role Selector Tabs (Learner vs Admin)
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () => setState(() => _selectedRole = 'Learner'),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            color: _selectedRole == 'Learner'
                                ? busuuBlue
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.school_outlined,
                                size: 18,
                                color: _selectedRole == 'Learner'
                                    ? Colors.white
                                    : Colors.grey.shade700,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                'Learner',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: _selectedRole == 'Learner'
                                      ? Colors.white
                                      : Colors.grey.shade700,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () => setState(() => _selectedRole = 'Admin'),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            color: _selectedRole == 'Admin'
                                ? Colors.deepOrange
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.admin_panel_settings_outlined,
                                size: 18,
                                color: _selectedRole == 'Admin'
                                    ? Colors.white
                                    : Colors.grey.shade700,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                'Admin',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: _selectedRole == 'Admin'
                                      ? Colors.white
                                      : Colors.grey.shade700,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 28),

              if (!_isLogin && _selectedRole == 'Learner') ...[
                TextField(
                  controller: _fullNameController,
                  textCapitalization: TextCapitalization.words,
                  decoration: InputDecoration(
                    labelText: 'Full name',
                    prefixIcon: const Icon(Icons.badge_outlined),
                    filled: true,
                    fillColor: Colors.grey.shade50,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide(color: Colors.grey.shade300),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
              ],

              // Username Field
              TextField(
                controller: _usernameController,
                decoration: InputDecoration(
                  labelText: 'Email address',
                  prefixIcon: const Icon(Icons.person_outline),
                  filled: true,
                  fillColor: Colors.grey.shade50,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Password Field
              TextField(
                controller: _passwordController,
                obscureText: _obscurePassword,
                decoration: InputDecoration(
                  labelText: 'Password',
                  prefixIcon: const Icon(Icons.lock_outline),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                    ),
                    onPressed: () =>
                        setState(() => _obscurePassword = !_obscurePassword),
                  ),
                  filled: true,
                  fillColor: Colors.grey.shade50,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Action Button
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: _selectedRole == 'Admin'
                      ? Colors.deepOrange
                      : busuuBlue,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  elevation: 0,
                ),
                onPressed: _handleAuthentication,
                child: Text(
                  _isLogin
                      ? 'Log In as $_selectedRole'
                      : 'Create $_selectedRole Account',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Footer Disclaimer
              Center(
                child: Text(
                  _selectedRole == 'Admin'
                      ? '🔒 Authorized admin access only'
                      : '🌍 Join over 120 million global learners',
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
