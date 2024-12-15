import 'package:agape/common/repository/record_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


final disabilityRecordControllerProvider = Provider((ref) {
  final disabilityRecordRepository = ref.read(disabilityRecordRepositoryProvider);
  return DisabilityRecordController(disabilityRecordRepository);
});

final statsProvider = FutureProvider<Map<String, dynamic>>((ref) async {
  final controller = ref.read(disabilityRecordControllerProvider);
  return await controller.getStatistics();
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

  Future<String> updateRecord(String id, Map<String, dynamic> recordData) async {
    try {
      final response =
       await disabilityRecordRepository.updateRecord(id, recordData);
      return response;
    } catch (e) {
      rethrow;
    }
  }
Future<List<Map<String, dynamic>>> filterRecords({
  String? gender,
  String? region,
  String? equipmentType,
  String? month,
  int? year,
}) async {
  try {
    final response = await disabilityRecordRepository.filterRecords(
      gender: gender,
      region: region,
      equipmentType: equipmentType,
      month: month,
      year: year,
    );
    return response;
  } catch (e) {
    rethrow;
  }
}

  // search records
  Future<List<Map<String, dynamic>>> searchRecords(String query) async {
    try {
      final response = await disabilityRecordRepository.searchRecords(query);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<String> deleteRecord(String id) async {
    try {
      final response = await disabilityRecordRepository.deleteRecord(id);
      return response;
    } catch (e) {
      rethrow;
    }
  }
  
  // get statistics
  Future<Map<String, dynamic>> getStatistics() async {
    try {
      final response = await disabilityRecordRepository.getStats();
      return response;
    } catch (e) {
      rethrow;
    }
  }
}
