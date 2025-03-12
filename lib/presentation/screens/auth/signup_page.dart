import 'package:chat_app/config/theme/app_theme.dart';
import 'package:chat_app/core/common/custom_button_widget.dart';
import 'package:chat_app/core/common/custom_text_field.dart';
import 'package:chat_app/presentation/widgets/back_button.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();
  final _usernameController = TextEditingController();
  final _phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(leading: BackButtonWidget(alpha: 0.3)),
      body: Form(
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
                prefixIcon: Icon(Icons.email_outlined),
              ),
              SizedBox(height: 10),
              CustomTextField(
                controller: _nameController,
                hintText: "Full Name",
                prefixIcon: Icon(Icons.person_outline),
              ),
              SizedBox(height: 10),
              CustomTextField(
                controller: _usernameController,
                hintText: "Username",
                obscureText: true,
                prefixIcon: Icon(Icons.alternate_email_outlined),
              ),
              SizedBox(height: 10),
              CustomTextField(
                controller: _passwordController,
                hintText: "Password",
                obscureText: true,
                prefixIcon: Icon(Icons.password_outlined),
                suffixIcon: Icon(Icons.visibility_sharp),
              ),
              SizedBox(height: 10),
              CustomTextField(
                controller: _phoneController,
                hintText: "Phone Number",
                obscureText: true,
                prefixIcon: Icon(Icons.phone_outlined),
              ),
              SizedBox(height: 30),
              CustomButtonWidget(onPressed: () {}, text: "Create Account"),
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
    super.dispose();
  }
}
