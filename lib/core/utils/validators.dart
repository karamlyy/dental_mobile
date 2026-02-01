class Validators {
  /// Email validasiyası
  /// Returns null əgər email düzgündürsə, əks halda error message qaytarır
  static String? validateEmail(String? email) {
    if (email == null || email.trim().isEmpty) {
      return 'Email tələb olunur';
    }

    final trimmedEmail = email.trim();

    // Sadə email regex pattern
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );

    if (!emailRegex.hasMatch(trimmedEmail)) {
      return 'Düzgün email daxil edin';
    }

    return null;
  }

  /// Email-in düzgün olub olmadığını yoxlayır (bool qaytarır)
  static bool isValidEmail(String? email) {
    return validateEmail(email) == null;
  }
}
