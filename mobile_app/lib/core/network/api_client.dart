import 'dart:convert';
import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';

final apiClientProvider = Provider<ApiClient>((ref) => ApiClient());

class ApiClient {
  ApiClient({
    this.baseUrl = const String.fromEnvironment(
      'API_BASE_URL',
      defaultValue: 'http://10.0.2.2:8080',
    ),
  });

  final String baseUrl;
  String? _token;

  void setToken(String? token) {
    _token = token == null || token.isEmpty ? null : token;
  }

  Future<Map<String, dynamic>> get(String path) => request(path);

  Future<Map<String, dynamic>> post(String path, Map<String, dynamic> body) {
    return request(path, method: 'POST', body: body);
  }

  Future<Map<String, dynamic>> request(
    String path, {
    String method = 'GET',
    Map<String, dynamic>? body,
  }) async {
    final client = HttpClient();
    try {
      final uri = Uri.parse('$baseUrl$path');
      final request = await client.openUrl(method, uri);
      request.headers.contentType = ContentType.json;
      request.headers.set(HttpHeaders.acceptHeader, ContentType.json.mimeType);
      if (_token != null) {
        request.headers.set(HttpHeaders.authorizationHeader, 'Bearer $_token');
      }
      if (body != null) {
        request.write(jsonEncode(body));
      }

      final response = await request.close();
      final raw = await response.transform(utf8.decoder).join();
      final decoded = raw.isEmpty
          ? <String, dynamic>{}
          : jsonDecode(raw) as Map<String, dynamic>;

      if (response.statusCode < 200 || response.statusCode >= 300) {
        throw ApiException(
          decoded['error']?.toString() ?? 'Ошибка API',
          response.statusCode,
        );
      }

      return decoded;
    } finally {
      client.close(force: true);
    }
  }
}

class ApiException implements Exception {
  ApiException(this.message, this.statusCode);

  final String message;
  final int statusCode;

  @override
  String toString() => message;
}
