// Shared client-side validation used by every form in the app, so the
// same "is this a valid email / phone / amount" rule isn't rewritten
// per page.
class Validators {
  const Validators._();

  static final RegExp _emailPattern = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
  static final RegExp _phonePattern = RegExp(r'^\+?[0-9]{7,15}$');

  // At most 2 decimal places - rejects fat-finger amounts like 10.999.
  static final RegExp _amountPattern = RegExp(r'^\d+(\.\d{1,2})?$');

  static bool isValidEmail(String value) => _emailPattern.hasMatch(value.trim());

  static bool isValidPhoneNumber(String value) {
    final String stripped = value.trim().replaceAll(RegExp(r'[\s-]'), '');
    return _phonePattern.hasMatch(stripped);
  }

  // A "recipient" for Send Money can be either an email or a phone
  // number - accept whichever the user typed.
  static bool isValidRecipient(String value) {
    final String trimmed = value.trim();
    return isValidEmail(trimmed) || isValidPhoneNumber(trimmed);
  }

  static bool isValidAmount(String value) {
    final String trimmed = value.trim();
    if (!_amountPattern.hasMatch(trimmed)) {
      return false;
    }
    final double? parsed = double.tryParse(trimmed);
    return parsed != null && parsed > 0;
  }
}
