import 'package:agape/common/repository/record_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';





final disabilityRecordControllerProvider = Provider((ref) {
  final disabilityRecordRepository = ref.read(disabilityRecordRepositoryProvider);
  return DisabilityRecordController(disabilityRecordRepository);
});

class DisabilityRecordController {
  DisabilityRecordRepository disabilityRecordRepository;

  DisabilityRecordController(this.disabilityRecordRepository);

  Future<List<Map<String, dynamic>>> getAllRecords() async {
    try {
      final response = await disabilityRecordRepository.getAllRecords();
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> getRecordById(String id) async {
    try {
      final response = await disabilityRecordRepository.getRecordById(id);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<String> createRecord(Map<String, dynamic> recordData) async {
    try {
      final response =
          await disabilityRecordRepository.createRecord(recordData);
      return response;
    } catch (e) {
      rethrow;
    }
  }
}
