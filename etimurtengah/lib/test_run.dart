import 'models/programme.dart';
import 'services/programme_service.dart';


void main() {
  
  final contoh = Programme.fromJson({
    'id': 'ETT-999',
    'universityName': 'Universiti Ujian',
    'country': 'Egypt',
    'city': 'Kaherah (Cairo)',
    'fieldOfStudy': 'Ujian',
    'studyLevel': 'bachelor',
    'category': 'spm',
    'estimatedAnnualCostMyr': 12000,
    'intakeMonth': 'September',
    'recognitionNote': 'Ujian sahaja.',
    'quotaSeats': 10,
  });

  print(contoh.universityName);
  print(contoh.estimatedAnnualCostMyr);
  print(contoh.studyLevel.label);
}
