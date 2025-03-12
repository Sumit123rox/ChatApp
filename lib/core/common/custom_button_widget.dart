import 'package:flutter/material.dart';

class CustomButtonWidget extends StatelessWidget {
  final VoidCallback onPressed;
  final String? text;
  final Widget? child;

  const CustomButtonWidget({
    super.key,
    required this.onPressed,
    this.text,
    this.child,
  }) : assert(
         text != null || child != null,
         'Either text or child must be provided.',
       );

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        child:
            child ??
            Text(
              text ?? "",
              style: TextStyle(color: Colors.white, fontFamily: 'Lufga'),
            ),
      ),
    );
  }
}
