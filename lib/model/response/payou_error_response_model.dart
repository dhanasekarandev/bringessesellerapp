class RazorpayErrorResponseModel {
  final String? status;
  final String? message;
  final ErrorDetail? error;

  RazorpayErrorResponseModel({
     this.status,
    this.message,
    this.error,
  });

  factory RazorpayErrorResponseModel.fromJson(Map<String, dynamic> json) {
    return RazorpayErrorResponseModel(
      status: json['status'] ?? "",
      message: json['message'] ?? '',
      error: json['error'] != null ? ErrorDetail.fromJson(json['error']) : null,
    );
  }

  Map<String, dynamic> toJson() => {
        'status': status,
        'message': message,
        'error': error?.toJson(),
      };
}

class ErrorDetail {
  final ErrorInfo? error;

  ErrorDetail({this.error});

  factory ErrorDetail.fromJson(Map<String, dynamic> json) {
    return ErrorDetail(
      error: json['error'] != null ? ErrorInfo.fromJson(json['error']) : null,
    );
  }

  Map<String, dynamic> toJson() => {
        'error': error?.toJson(),
      };
}

class ErrorInfo {
  final String? code;
  final String? description;
  final String? source;
  final String? step;
  final String? reason;
  final Map<String, dynamic>? metadata;
  final String? field;

  ErrorInfo({
    this.code,
    this.description,
    this.source,
    this.step,
    this.reason,
    this.metadata,
    this.field,
  });

  factory ErrorInfo.fromJson(Map<String, dynamic> json) {
    return ErrorInfo(
      code: json['code'],
      description: json['description'],
      source: json['source'],
      step: json['step'],
      reason: json['reason'],
      metadata: json['metadata'] != null
          ? Map<String, dynamic>.from(json['metadata'])
          : null,
      field: json['field'],
    );
  }

  Map<String, dynamic> toJson() => {
        'code': code,
        'description': description,
        'source': source,
        'step': step,
        'reason': reason,
        'metadata': metadata,
        'field': field,
      };
}
