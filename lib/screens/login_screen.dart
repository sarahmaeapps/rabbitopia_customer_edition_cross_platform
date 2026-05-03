import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();
  bool _isLogin = true;
  bool _obscurePassword = true;
  bool _isLoading = false;

  void _toggleMode() {
    setState(() {
      _isLogin = !_isLogin;
    });
  }

  Future<void> _submit() async {
    final authService = Provider.of<AuthService>(context, listen: false);
    setState(() {
      _isLoading = true;
    });

    try {
      if (_isLogin) {
        await authService.login(_emailController.text, _passwordController.text);
      } else {
        if (_nameController.text.isEmpty) {
          throw Exception('Please enter your name');
        }
        await authService.signUp(_emailController.text, _passwordController.text, _nameController.text);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/fur.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 40),
                  Image.asset('assets/images/rabbitopia_icon.png', height: 120, errorBuilder: (c, e, s) => const Icon(Icons.pets, size: 80, color: Colors.white)),
                  const SizedBox(height: 20),
                  Text(
                    'Rabbitopia',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 40),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.black54,
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(color: Colors.white24),
                    ),
                    child: Column(
                      children: [
                        if (!_isLogin)
                          TextField(
                            controller: _nameController,
                            decoration: const InputDecoration(labelText: 'Full Name', labelStyle: TextStyle(color: Colors.white70)),
                            style: const TextStyle(color: Colors.white),
                            keyboardType: TextInputType.name,
                          ),
                        TextField(
                          controller: _emailController,
                          decoration: const InputDecoration(labelText: 'Email', labelStyle: TextStyle(color: Colors.white70)),
                          style: const TextStyle(color: Colors.white),
                          keyboardType: TextInputType.emailAddress,
                        ),
                        TextField(
                          controller: _passwordController,
                          decoration: InputDecoration(
                            labelText: 'Password',
                            labelStyle: const TextStyle(color: Colors.white70),
                            suffixIcon: IconButton(
                              icon: Icon(_obscurePassword ? Icons.visibility : Icons.visibility_off, color: Colors.white70),
                              onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                            ),
                          ),
                          style: const TextStyle(color: Colors.white),
                          obscureText: _obscurePassword,
                        ),
                        const SizedBox(height: 30),
                        if (_isLoading)
                          const CircularProgressIndicator()
                        else
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: _submit,
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(vertical: 15),
                                backgroundColor: Colors.blueAccent,
                                foregroundColor: Colors.white,
                              ),
                              child: Text(_isLogin ? 'Login' : 'Sign Up', style: const TextStyle(fontSize: 18)),
                            ),
                          ),
                        const SizedBox(height: 10),
                        TextButton(
                          onPressed: _toggleMode,
                          child: Text(
                            _isLogin ? 'Create an account' : 'Already have an account? Login',
                            style: const TextStyle(color: Colors.white70),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
