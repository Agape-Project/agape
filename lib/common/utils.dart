
import 'package:intl/intl.dart';

int calculateAge(String dateOfBirth) {
  try {
    DateTime birthDate = DateTime.parse(dateOfBirth);
    DateTime today = DateTime.now();

    int age = today.year - birthDate.year;

    if (today.month < birthDate.month || 
        (today.month == birthDate.month && today.day < birthDate.day)) {
      age--;
    }

    return age;
  } catch (e) {
    return 0; 
  }
}

String formatDate(String? date) {
  if (date == null || date.isEmpty) return 'N/A';
  try {
    final parsedDate = DateTime.parse(date);
    return DateFormat('MMM d, yyyy').format(parsedDate); 
  } catch (e) {
    return 'Invalid Date';
  }
}
