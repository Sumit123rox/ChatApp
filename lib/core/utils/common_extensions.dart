extension StringValidationExtension on String? {
  String? validateRequired(String errorMessage, {RegExp? pattern, String? patternErrorMessage}) {
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