/// Data model representing a verified daily care message for MomBee mothers.
/// Strictly avoids fabricated doctor quotes and attributions.
class DailyMessage {
  final String greeting;
  final String title;
  final String message;
  final String careTip;
  final String category;
  final String doctorQuote;
  final String doctorName;
  final String doctorRole;

  const DailyMessage({
    required this.greeting,
    required this.title,
    required this.message,
    this.careTip = '',
    required this.category,
    this.doctorQuote = '',
    this.doctorName = '',
    this.doctorRole = '',
  });

  bool get hasDoctorQuote =>
      doctorQuote.isNotEmpty && doctorName.isNotEmpty;
}
