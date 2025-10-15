/// SOS Alert Request Model matching backend API
class SosRequestModel {
  final String username;
  final List<String> phoneNumbers;
  final String location;

  const SosRequestModel({
    required this.username,
    required this.phoneNumbers,
    required this.location,
  });

  Map<String, dynamic> toJson() => {
    'username': username,
    'phoneNumbers': phoneNumbers,
    'location': location,
  };

  factory SosRequestModel.fromJson(Map<String, dynamic> json) => SosRequestModel(
    username: json['username'] as String,
    phoneNumbers: List<String>.from(json['phoneNumbers'] as List),
    location: json['location'] as String,
  );
}

/// SOS Alert Response Model
class SosResponseModel {
  final bool success;
  final String message;
  final List<SosResultModel> results;

  const SosResponseModel({
    required this.success,
    required this.message,
    required this.results,
  });

  factory SosResponseModel.fromJson(Map<String, dynamic> json) => SosResponseModel(
    success: json['success'] as bool,
    message: json['message'] as String,
    results: (json['results'] as List)
        .map((e) => SosResultModel.fromJson(e as Map<String, dynamic>))
        .toList(),
  );

  Map<String, dynamic> toJson() => {
    'success': success,
    'message': message,
    'results': results.map((e) => e.toJson()).toList(),
  };
}

/// Individual SOS Result Model
class SosResultModel {
  final String number;
  final String status;
  final String? sid;
  final String? error;

  const SosResultModel({
    required this.number,
    required this.status,
    this.sid,
    this.error,
  });

  factory SosResultModel.fromJson(Map<String, dynamic> json) => SosResultModel(
    number: json['number'] as String,
    status: json['status'] as String,
    sid: json['sid'] as String?,
    error: json['error'] as String?,
  );

  Map<String, dynamic> toJson() => {
    'number': number,
    'status': status,
    if (sid != null) 'sid': sid,
    if (error != null) 'error': error,
  };
}
