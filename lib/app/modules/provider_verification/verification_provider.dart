import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../data/api_endpoints.dart';

class VerificationProvider {
  final String baseUrl = ApiEndpoints.baseUrl;
  final _storage = const FlutterSecureStorage();

  Future<Map<String, String>> _getHeaders({bool isMultipart = false}) async {
    String? token = await _storage.read(key: 'access_token');
    return {
      if (!isMultipart) 'Content-Type': 'application/json',
      'Accept': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  Future<http.Response> getVerificationStatus() async {
    final headers = await _getHeaders();
    final url = Uri.parse('$baseUrl${ApiEndpoints.providerVerification}');
    return await http.get(url, headers: headers);
  }

  Future<http.StreamedResponse> submitVerificationDocuments(String documentType, List<File> documents) async {
    final headers = await _getHeaders(isMultipart: true);
    final url = Uri.parse('$baseUrl${ApiEndpoints.providerVerification}');
    
    var request = http.MultipartRequest('POST', url);
    request.headers.addAll(headers);
    request.fields['document_type'] = documentType;

    for (var file in documents) {
      request.files.add(await http.MultipartFile.fromPath('document', file.path));
    }

    return await request.send();
  }
}
