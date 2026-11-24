/// Normalizes an Egyptian mobile number to E.164 (+201XXXXXXXXX).
/// Accepts 01XXXXXXXXX, +201XXXXXXXXX, 00201XXXXXXXXX and 201XXXXXXXXX.
/// Returns null when the input is not a valid Egyptian mobile number.
String? normalizeEgyptianMobile(String input) {
  var digits = input.replaceAll(RegExp(r'[\s\-()]'), '');
  if (digits.startsWith('+')) digits = digits.substring(1);
  if (digits.startsWith('00')) digits = digits.substring(2);
  if (digits.startsWith('20')) digits = digits.substring(2);
  if (digits.startsWith('0')) digits = digits.substring(1);
  if (!RegExp(r'^1[0125]\d{8}$').hasMatch(digits)) return null;
  return '+20$digits';
}
