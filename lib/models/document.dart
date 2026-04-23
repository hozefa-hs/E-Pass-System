import 'package:e_pass_system/models/pass.dart';

enum DocumentType {
  COLLEGE_ID,
  AGE_PROOF,
  COMPANY_LETTER;
  
  static DocumentType fromString(String documentType) {
    switch (documentType) {
      case 'COLLEGE_ID':
        return DocumentType.COLLEGE_ID;
      case 'AGE_PROOF':
        return DocumentType.AGE_PROOF;
      case 'COMPANY_LETTER':
        return DocumentType.COMPANY_LETTER;
      default:
        throw ArgumentError('Invalid document type: $documentType');
    }
  }
  
  String toApiString() {
    switch (this) {
      case DocumentType.COLLEGE_ID:
        return 'COLLEGE_ID';
      case DocumentType.AGE_PROOF:
        return 'AGE_PROOF';
      case DocumentType.COMPANY_LETTER:
        return 'COMPANY_LETTER';
    }
  }
  
  String get displayName {
    switch (this) {
      case DocumentType.COLLEGE_ID:
        return 'College ID';
      case DocumentType.AGE_PROOF:
        return 'Age Proof';
      case DocumentType.COMPANY_LETTER:
        return 'Company Letter';
    }
  }
  
  static DocumentType fromPassType(PassType passType) {
    switch (passType) {
      case PassType.STUDENT:
        return DocumentType.COLLEGE_ID;
      case PassType.SENIOR_CITIZEN:
        return DocumentType.AGE_PROOF;
      case PassType.CORPORATE:
        return DocumentType.COMPANY_LETTER;
    }
  }
}

class Document {
  final String id;
  final String passId;
  final String fileName;
  final String fileType;
  final String fileSize;
  final DocumentType documentType;
  final String contentType;
  final String uploadDate;

  Document({
    required this.id,
    required this.passId,
    required this.fileName,
    required this.fileType,
    required this.fileSize,
    required this.documentType,
    required this.contentType,
    required this.uploadDate,
  });

  factory Document.fromJson(Map<String, dynamic> json) {
    return Document(
      id: json['id'] ?? '',
      passId: json['passId'] ?? '',
      fileName: json['fileName'] ?? '',
      fileType: json['fileType'] ?? '',
      fileSize: json['fileSize']?.toString() ?? '',
      documentType: DocumentType.fromString(json['documentType'] ?? ''),
      contentType: json['contentType'] ?? '',
      uploadDate: json['uploadDate'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'passId': passId,
      'fileName': fileName,
      'fileType': fileType,
      'fileSize': fileSize,
      'documentType': documentType.toApiString(),
      'contentType': contentType,
      'uploadDate': uploadDate,
    };
  }
}
