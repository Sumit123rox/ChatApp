import 'package:chat_app/config/theme/app_theme.dart';
import 'package:chat_app/core/common/custom_button_widget.dart';
import 'package:chat_app/core/common/custom_text_field.dart';
import 'package:chat_app/core/utils/common_extensions.dart';
import 'package:chat_app/presentation/screens/auth/signup_page.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isPasswordVisible = false;
  final _emailFocus = FocusNode();
  final _passwordFocus = FocusNode();

  // Password validation
  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a password';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters long';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 50),
                Text(
                  "Welcome back",
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                SizedBox(height: 10),
                Text(
                  "Sign in to continue",
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(color: Colors.grey),
                ),
                SizedBox(height: 40),
                CustomTextField(
                  controller: _emailController,
                  hintText: "Email",
                  focusNode: _emailFocus,
                  validator:
                      (value) => value.validateRequired(
                        "Please enter a valid Email.",
                        pattern: RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$'),
                        patternErrorMessage:
                            "Please enter a valid email address (e.g., example@email.com)",
                      ),
                  prefixIcon: Icon(Icons.email_outlined),
                ),
                SizedBox(height: 10),
                CustomTextField(
                  controller: _passwordController,
                  hintText: "Password",
                  obscureText: !_isPasswordVisible,
                  focusNode: _passwordFocus,
                  validator: _validatePassword,
                  prefixIcon: Icon(Icons.password_outlined),
                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        _isPasswordVisible = !_isPasswordVisible;
                      });
                    },
                    icon: Icon(
                      _isPasswordVisible
                          ? Icons.visibility_off_sharp
                          : Icons.visibility_sharp,
                    ),
                  ),
                ),
                SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: Text(
                    "Forget Password?",
                    textAlign: TextAlign.end,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
                SizedBox(height: 30),
                CustomButtonWidget(
                  onPressed: () {
                    FocusScope.of(context).unfocus();
                    if (_formKey.currentState?.validate() ?? false) {}
                  },
                  text: 'Login',
                ),
                SizedBox(height: 20),
                Center(
                  child: RichText(
                    text: TextSpan(
                      text: "Don't have an Account?  ",
                      style: Theme.of(
                        context,
                      ).textTheme.bodyMedium?.copyWith(color: Colors.grey),
                      children: [
                        TextSpan(
                          text: 'Sign up',
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(color: AppTheme.primaryColor),
                          recognizer:
                              TapGestureRecognizer()
                                ..onTap = () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder:
                                          (BuildContext context) =>
                                              SignupPage(),
                                    ),
                                  );
                                },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _emailFocus.dispose();
    _passwordFocus.dispose();
    super.dispose();
  }
}
