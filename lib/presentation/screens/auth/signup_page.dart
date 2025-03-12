import 'package:chat_app/config/theme/app_theme.dart';
import 'package:chat_app/core/common/custom_button_widget.dart';
import 'package:chat_app/core/common/custom_text_field.dart';
import 'package:chat_app/core/utils/common_extensions.dart';
import 'package:chat_app/presentation/widgets/back_button.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();
  final _usernameController = TextEditingController();
  final _phoneController = TextEditingController();

  bool _isPasswordVisible = false;
  final _nameFocus = FocusNode();
  final _usernameFocus = FocusNode();
  final _emailFocus = FocusNode();
  final _passwordFocus = FocusNode();
  final _phoneFocus = FocusNode();

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
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: BackButtonWidget(alpha: 0.3),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Create Account",
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              SizedBox(height: 5),
              Text(
                "Please fill the details to continue",
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
                controller: _nameController,
                hintText: "Full Name",
                focusNode: _nameFocus,
                validator:
                    (value) =>
                        value.validateRequired("Please enter your Fullname."),
                prefixIcon: Icon(Icons.person_outline),
              ),
              SizedBox(height: 10),
              CustomTextField(
                controller: _usernameController,
                hintText: "Username",
                focusNode: _usernameFocus,
                validator:
                    (value) =>
                        value.validateRequired("Please enter your Username."),
                prefixIcon: Icon(Icons.alternate_email_outlined),
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
              SizedBox(height: 10),
              CustomTextField(
                controller: _phoneController,
                hintText: "Phone Number",
                focusNode: _phoneFocus,
                keyboardType: TextInputType.phone,
                validator:
                    (value) => value.validateRequired(
                      "Please enter a valid Phone Number.",
                      pattern: RegExp(r'^\+?[\d\s-]{10,}$'),
                      patternErrorMessage:
                          'Please enter a valid phone number (e.g., +1234567890)',
                    ),
                prefixIcon: Icon(Icons.phone_outlined),
              ),
              SizedBox(height: 30),
              CustomButtonWidget(
                onPressed: () {
                  FocusScope.of(context).unfocus();
                  if (_formKey.currentState?.validate() ?? false) {}
                },
                text: "Create Account",
              ),
              SizedBox(height: 20),
              Center(
                child: RichText(
                  text: TextSpan(
                    text: "Already have an Account?  ",
                    style: Theme.of(
                      context,
                    ).textTheme.bodyMedium?.copyWith(color: Colors.grey),
                    children: [
                      TextSpan(
                        text: 'Login',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppTheme.primaryColor,
                        ),
                        recognizer:
                            TapGestureRecognizer()
                              ..onTap = () {
                                Navigator.pop(context);
                              },
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    _usernameController.dispose();
    _phoneController.dispose();
    _nameFocus.dispose();
    _usernameFocus.dispose();
    _emailFocus.dispose();
    _passwordFocus.dispose();
    _phoneFocus.dispose();
    super.dispose();
  }
}
