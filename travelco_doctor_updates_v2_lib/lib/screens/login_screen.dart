import 'package:flutter/material.dart';
import '../widgets/travelco_logo.dart';
import 'home_screen.dart';
import 'register_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _password = TextEditingController();
  bool _hide = true;

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  void _login() {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => const HomeScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 460),
              child: Form(
                key: _formKey,
                child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                  const TravelcoLogo(size: 72),
                  const SizedBox(height: 28),
                  const Text('Welcome back', textAlign: TextAlign.center, style: TextStyle(fontSize: 29, fontWeight: FontWeight.w900)),
                  const SizedBox(height: 8),
                  const Text('Sign in to continue your journey', textAlign: TextAlign.center, style: TextStyle(color: Color(0xFF64748B))),
                  const SizedBox(height: 28),
                  TextFormField(
                    controller: _email,
                    decoration: const InputDecoration(labelText: 'Email', prefixIcon: Icon(Icons.email_outlined)),
                    validator: (v) => (v ?? '').contains('@') ? null : 'Enter a valid email',
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _password,
                    obscureText: _hide,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      prefixIcon: const Icon(Icons.lock_outline),
                      suffixIcon: IconButton(onPressed: () => setState(() => _hide = !_hide), icon: Icon(_hide ? Icons.visibility_off_outlined : Icons.visibility_outlined)),
                    ),
                    validator: (v) => (v ?? '').length >= 4 ? null : 'Use at least 4 characters',
                  ),
                  const SizedBox(height: 22),
                  ElevatedButton(onPressed: _login, child: const Text('Sign in')),
                  const SizedBox(height: 10),
                  TextButton(
                    onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const RegisterScreen())),
                    child: const Text('Create a new account'),
                  ),
                  const SizedBox(height: 8),

                ]),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
