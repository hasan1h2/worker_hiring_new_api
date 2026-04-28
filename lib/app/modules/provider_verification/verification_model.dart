class VerificationModel {
  final int? id;
  final String? documentType;
  final String? document;
  final bool? isVerified;
  final String? status;
  final String? updateAt;

  VerificationModel({
    this.id,
    this.documentType,
    this.document,
    this.isVerified,
    this.status,
    this.updateAt,
  });

  factory VerificationModel.fromJson(Map<String, dynamic> json) {
    return VerificationModel(
      id: json['id'],
      documentType: json['document_type'],
      document: json['document'],
      isVerified: json['is_verified'],
      status: json['status'],
      updateAt: json['update_at'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'document_type': documentType,
      'document': document,
      'is_verified': isVerified,
      'status': status,
      'update_at': updateAt,
    };
  }
}

class VerificationResponse {
  final bool? status;
  final VerificationModel? data;

  VerificationResponse({this.status, this.data});

  factory VerificationResponse.fromJson(Map<String, dynamic> json) {
    return VerificationResponse(
      status: json['status'],
      data: json['data'] != null ? VerificationModel.fromJson(json['data']) : null,
    );
  }
}
