import 'package:dartz/dartz.dart';
import '../../entities/sos_entity.dart';
import '../../repositories/sos_repository.dart';
import '../../../core/utils/result.dart';
import '../../../core/error/failures.dart';
import '../../../data/models/sos_request_model.dart';
import '../../../data/repositories_impl/sos_repository_impl.dart';

/// Use case for sending SOS alerts
class SendSosAlertUseCase {
  final SosRepositoryImpl _repository;

  SendSosAlertUseCase(this._repository);

  Future<Result<SosResponseModel>> call({
    required String username,
    required List<String> phoneNumbers,
    required LocationEntity location,
    required String userId,
  }) async {
    // Validate inputs
    if (username.isEmpty) {
      return Left(ValidationFailure(message: 'Username cannot be empty'));
    }

    if (userId.isEmpty) {
      return Left(ValidationFailure(message: 'User ID cannot be empty'));
    }

    // Send SOS alert (phone numbers will be fetched from API)
    return await _repository.sendSosAlert(
      username: username,
      phoneNumbers: phoneNumbers, // This will be ignored, contacts fetched from API
      location: location,
      userId: userId,
    );
  }

  bool _isValidPhoneNumber(String phoneNumber) {
    // Basic phone number validation
    final cleanNumber = phoneNumber.replaceAll(RegExp(r'[^\d+]'), '');
    return cleanNumber.length >= 10 && cleanNumber.length <= 15;
  }
}

/// Validation failure class
class ValidationFailure extends Failure {
  const ValidationFailure({required String message}) : super(message: message);
}
