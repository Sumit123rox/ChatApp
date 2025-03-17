import 'package:chat_app/data/services/service.locator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

extension StringValidationExtension on String? {
  String? validateRequired(
    String errorMessage, {
    RegExp? pattern,
    String? patternErrorMessage,
  }) {
    // Check if value is null or empty
    if (this == null || this!.isEmpty) {
      return errorMessage;
    }

    // If pattern is provided, validate against it
    if (pattern != null && !pattern.hasMatch(this!)) {
      return patternErrorMessage ?? errorMessage;
    }

    // Validation passed
    return null;
  }
}

extension BuildContextExtension on BuildContext {
  /// Shows a snackbar with the given message.
  ///
  /// Parameters:
  /// - [message]: The message to display in the snackbar.
  /// - [isError]: Whether this is an error message (shows in red if true).
  /// - [duration]: How long to display the snackbar. Defaults to 3 seconds.
  /// - [action]: Optional action button for the snackbar.
  void showSnackBar({
    required String message,
    bool isError = false,
    Duration duration = const Duration(seconds: 3),
    SnackBarAction? action,
  }) {
    ScaffoldMessenger.of(this).removeCurrentSnackBar();
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Text(message, style: TextStyle(color: Colors.white)),
        backgroundColor: isError ? Colors.red : Colors.green,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: EdgeInsets.all(10),
        duration: duration,
        action: action,
      ),
    );
  }
}

extension IsOwnExtension on String {
  bool isOwn() {
    return this == locator<FirebaseAuth>().currentUser?.uid;
  }
}
