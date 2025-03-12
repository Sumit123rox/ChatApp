import 'package:flutter/material.dart';

class BackButtonWidget extends StatelessWidget {
  final double? alpha;
  final Color? iconColor;
  const BackButtonWidget({super.key, this.alpha = 0.5, this.iconColor = Colors.white});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () => Navigator.pop(context),
      icon: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.black.withValues(alpha: alpha),
        ),
        child: Icon(
          Icons.arrow_back_ios_new_outlined,
          size: 15,
          color: iconColor,
        ),
      ),
    );
  }
}
