import 'package:flutter/material.dart';

import '../models/entities.dart';
import '../models/learning_store.dart';
import 'admin_view.dart';
import 'common.dart';
import 'learner_view.dart';

enum _AuthStage { welcome, login, register }

class AuthView extends StatefulWidget {
  const AuthView({super.key});

  @override
  State<AuthView> createState() => _AuthViewState();
}

class _AuthViewState extends State<AuthView> {
  final _username = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _confirm = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  _AuthStage _stage = _AuthStage.welcome;
  bool _showPassword = false;
  bool _remember = true;

  @override
  void dispose() {
    _username.dispose();
    _email.dispose();
    _password.dispose();
    _confirm.dispose();
    super.dispose();
  }

  void _login() {
    final user = LearningStore.instance.signIn(_username.text, _password.text);
    if (user == null) {
      _message('Check your username and password.');
      return;
    }
    _open(user);
  }

  void _register() {
    if (!_formKey.currentState!.validate()) return;
    final user = LearningStore.instance.register(
      _username.text,
      _email.text,
      _password.text,
    );
    if (user == null) {
      _message('That username or email is already in use.');
      return;
    }
    _open(user);
  }

  void _open(AppUser user) {
    Navigator.pushReplacement<void, void>(
      context,
      MaterialPageRoute<void>(
        builder: (_) => user.role == UserRole.admin
            ? const AdminView()
            : const LearnerView(),
      ),
    );
  }

  void _message(String value) =>
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(value)));

  void _fillAdminDemo() {
    _username.text = 'admin';
    _password.text = 'admin123';
    setState(() => _stage = _AuthStage.login);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: Colors.white,
    body: SafeArea(
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 480),
          child: _stage == _AuthStage.welcome ? _welcome() : _authForm(),
        ),
      ),
    ),
  );

  Widget _welcome() => Padding(
    padding: const EdgeInsets.fromLTRB(26, 22, 26, 18),
    child: Column(
      children: [
        const Brand(),
        const Spacer(),
        Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.center,
          children: [
            Container(
              width: 184,
              height: 184,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Palette.blue,
                boxShadow: [
                  BoxShadow(
                    color: Palette.blue.withValues(alpha: 0.2),
                    blurRadius: 35,
                    spreadRadius: 5,
                  ),
                ],
              ),
              child: const Center(
                child: Text(
                  'A 文',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 44,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ),
            const Positioned(
              right: -18,
              top: 5,
              child: _Bubble('สวัสดี', Color(0xFFE78370)),
            ),
            const Positioned(
              left: -18,
              bottom: 14,
              child: _Bubble('ขอบคุณ', Palette.yellow),
            ),
          ],
        ),
        const Spacer(),
        const Text(
          'YOUR DAILY LANGUAGE BOOST',
          style: TextStyle(
            color: Palette.blue,
            fontSize: 10,
            fontWeight: FontWeight.w800,
            letterSpacing: 1.2,
          ),
        ),
        const SizedBox(height: 10),
        const Text(
          'Learn Thai\nin a fun way',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Palette.ink,
            fontSize: 31,
            height: 1.08,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 12),
        const Text(
          'Discover Thai courses, practice with flashcards, and track your progress.',
          textAlign: TextAlign.center,
          style: TextStyle(color: Palette.muted, height: 1.45, fontSize: 13),
        ),
        const SizedBox(height: 22),
        SizedBox(
          width: double.infinity,
          child: FilledButton.icon(
            onPressed: () => setState(() => _stage = _AuthStage.login),
            icon: const Icon(Icons.arrow_forward_rounded),
            label: const Text('Get Started'),
            style: primaryButton(),
          ),
        ),
      ],
    ),
  );

  Widget _authForm() {
    final registering = _stage == _AuthStage.register;
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                IconButton(
                  onPressed: () => setState(
                    () => _stage = registering
                        ? _AuthStage.login
                        : _AuthStage.welcome,
                  ),
                  tooltip: 'Back',
                  icon: const Icon(Icons.arrow_back_rounded),
                ),
                const Spacer(),
                const Brand(compact: true),
                const Spacer(),
                const SizedBox(width: 48),
              ],
            ),
            if (!registering) ...[
              const SizedBox(height: 8),
              const Center(child: _Orbit()),
              const SizedBox(height: 9),
            ],
            Text(
              registering ? 'Start learning today' : 'Welcome Back',
              style: const TextStyle(
                color: Palette.ink,
                fontSize: 25,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              registering
                  ? 'Create your free learner account.'
                  : 'Log in and continue your learning journey.',
              style: const TextStyle(color: Palette.muted, fontSize: 12),
            ),
            const SizedBox(height: 18),
            if (registering) ...[
              const _LearnerNotice(),
              const SizedBox(height: 13),
              _Field(
                label: 'Username',
                hint: 'Choose a username',
                controller: _username,
                icon: Icons.person_outline,
                validator: (v) =>
                    v == null || v.trim().isEmpty ? 'Choose a username' : null,
              ),
              const SizedBox(height: 11),
              _Field(
                label: 'Email',
                hint: 'you@example.com',
                controller: _email,
                icon: Icons.mail_outline,
                keyboardType: TextInputType.emailAddress,
                validator: (v) => v == null || !v.contains('@')
                    ? 'Enter a valid email'
                    : null,
              ),
              const SizedBox(height: 11),
            ] else ...[
              _Field(
                label: 'Username',
                hint: 'Enter your username',
                controller: _username,
                icon: Icons.person_outline,
              ),
              const SizedBox(height: 11),
            ],
            _Field(
              label: 'Password',
              hint: registering ? 'Create a password' : 'Enter your password',
              controller: _password,
              icon: Icons.lock_outline,
              obscure: !_showPassword,
              validator: (v) => v == null || v.length < 6
                  ? 'Use at least 6 characters'
                  : null,
              suffix: IconButton(
                tooltip: _showPassword ? 'Hide password' : 'Show password',
                onPressed: () => setState(() => _showPassword = !_showPassword),
                icon: Icon(
                  _showPassword
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                  size: 19,
                ),
              ),
            ),
            if (registering) ...[
              const SizedBox(height: 11),
              _Field(
                label: 'Confirm password',
                hint: 'Repeat your password',
                controller: _confirm,
                icon: Icons.lock_outline,
                obscure: true,
                validator: (v) =>
                    v != _password.text ? 'Passwords do not match' : null,
              ),
            ] else ...[
              const SizedBox(height: 7),
              Row(
                children: [
                  SizedBox(
                    width: 24,
                    height: 24,
                    child: Checkbox(
                      value: _remember,
                      activeColor: Palette.blue,
                      onChanged: (v) => setState(() => _remember = v ?? false),
                    ),
                  ),
                  const SizedBox(width: 6),
                  const Text('Remember me', style: TextStyle(fontSize: 10)),
                  const Spacer(),
                  TextButton(
                    onPressed: () => _message(
                      'Password reset is not connected in this demo.',
                    ),
                    child: const Text(
                      'Forgot password?',
                      style: TextStyle(fontSize: 10),
                    ),
                  ),
                ],
              ),
            ],
            const SizedBox(height: 10),
            SizedBox(
              height: 48,
              child: FilledButton(
                onPressed: registering ? _register : _login,
                style: primaryButton(),
                child: Text(registering ? 'Register' : 'Login'),
              ),
            ),
            if (!registering) ...[
              const SizedBox(height: 7),
              Wrap(
                alignment: WrapAlignment.center,
                spacing: 5,
                children: [
                  ActionChip(
                    label: const Text(
                      'Admin: admin / admin123',
                      style: TextStyle(fontSize: 8),
                    ),
                    onPressed: _fillAdminDemo,
                  ),
                ],
              ),
            ],
            const SizedBox(height: 8),
            Center(
              child: Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  Text(
                    registering ? 'Already registered? ' : 'New to LinguaGo? ',
                    style: const TextStyle(color: Palette.muted, fontSize: 10),
                  ),
                  TextButton(
                    onPressed: () => setState(
                      () => _stage = registering
                          ? _AuthStage.login
                          : _AuthStage.register,
                    ),
                    style: TextButton.styleFrom(padding: EdgeInsets.zero),
                    child: Text(
                      registering ? 'Log in' : 'Create an account',
                      style: const TextStyle(
                        color: Palette.blue,
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Field extends StatelessWidget {
  const _Field({
    required this.label,
    required this.hint,
    required this.controller,
    required this.icon,
    this.validator,
    this.keyboardType,
    this.obscure = false,
    this.suffix,
  });
  final String label;
  final String hint;
  final TextEditingController controller;
  final IconData icon;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final bool obscure;
  final Widget? suffix;
  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        label,
        style: const TextStyle(
          color: Palette.ink,
          fontSize: 10,
          fontWeight: FontWeight.w700,
        ),
      ),
      const SizedBox(height: 5),
      TextFormField(
        controller: controller,
        validator: validator,
        keyboardType: keyboardType,
        obscureText: obscure,
        decoration: inputStyle(
          hint,
          prefix: Icon(icon, size: 18, color: Palette.muted),
          suffix: suffix,
        ),
      ),
    ],
  );
}

class _Bubble extends StatelessWidget {
  const _Bubble(this.text, this.color);
  final String text;
  final Color color;
  @override
  Widget build(BuildContext context) => Transform.rotate(
    angle: -0.1,
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(9),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w800,
        ),
      ),
    ),
  );
}

class _Orbit extends StatelessWidget {
  const _Orbit();
  @override
  Widget build(BuildContext context) => SizedBox(
    width: 126,
    height: 112,
    child: Stack(
      alignment: Alignment.center,
      children: [
        Container(
          width: 102,
          height: 102,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: const Color(0xFFDCE1F7)),
          ),
        ),
        Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            color: Palette.blue,
            borderRadius: BorderRadius.circular(13),
          ),
          child: const Icon(Icons.menu_book_rounded, color: Colors.white),
        ),
        const Positioned(top: 0, right: 18, child: _OrbitLetter('พ')),
        const Positioned(bottom: 2, left: 6, child: _OrbitLetter('ก')),
        const Positioned(bottom: 0, right: 4, child: _OrbitLetter('า')),
      ],
    ),
  );
}

class _OrbitLetter extends StatelessWidget {
  const _OrbitLetter(this.text);
  final String text;
  @override
  Widget build(BuildContext context) => Container(
    width: 24,
    height: 24,
    alignment: Alignment.center,
    decoration: BoxDecoration(
      color: Palette.yellow,
      borderRadius: BorderRadius.circular(6),
    ),
    child: Text(
      text,
      style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 12),
    ),
  );
}

class _LearnerNotice extends StatelessWidget {
  const _LearnerNotice();
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(10),
    decoration: BoxDecoration(
      color: const Color(0xFFF1F3FF),
      borderRadius: BorderRadius.circular(8),
    ),
    child: const Row(
      children: [
        Icon(Icons.person_outline, color: Palette.blue),
        SizedBox(width: 9),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Account type: Learner',
                style: TextStyle(fontSize: 10, fontWeight: FontWeight.w800),
              ),
              Text(
                'New accounts are registered as learners.',
                style: TextStyle(fontSize: 8, color: Palette.muted),
              ),
            ],
          ),
        ),
        Icon(Icons.check_rounded, color: Palette.blue, size: 17),
      ],
    ),
  );
}
