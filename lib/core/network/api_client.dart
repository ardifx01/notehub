import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:notehub/core/const/config.dart';

class ApiClient {
  final String baseUrl = Config.base_URL;

  // Generic GET
  Future<dynamic> get(String endpoint) async {
    final response = await http.get(Uri.parse('$baseUrl$endpoint'));
    return _processResponse(response);
  }

  // Generic POST
  Future<dynamic> post(String endpoint, Map<String, dynamic> body) async {
    final response = await http.post(
      Uri.parse('$baseUrl$endpoint'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(body),
    );
    return _processResponse(response);
  }

  // Generic PUT
  // Generic PUT
  Future<dynamic> put(String endpoint, Map<String, dynamic> body) async {
    final response = await http.put(
      Uri.parse('$baseUrl$endpoint'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(body),
    );
    return _processResponse(response);
  }

  // Generic DELETE
  Future<dynamic> delete(String endpoint) async {
    final response = await http.delete(Uri.parse('$baseUrl$endpoint'));
    return _processResponse(response);
  }

  // Response handler
  dynamic _processResponse(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      if (response.body.isNotEmpty) {
        return jsonDecode(response.body);
      } else {
        return {"message": "success"}; // fallback default
      }
    } else {
      throw Exception("Error: ${response.statusCode}");
    }
  }

  // api_client.dart
  Future<dynamic> multipartPut(
    String endpoint, {
    required Map<String, String> fields,
    Map<String, String>? headers,
    Map<String, String>? files, // key = field name, value = file path
  }) async {
    var uri = Uri.parse('$baseUrl$endpoint');
    var request = http.MultipartRequest('PUT', uri);

    // tambahkan field
    request.fields.addAll(fields);

    // tambahkan file (kalau ada)
    if (files != null) {
      for (var entry in files.entries) {
        request.files
            .add(await http.MultipartFile.fromPath(entry.key, entry.value));
      }
    }

    // tambahkan headers (optional)
    if (headers != null) {
      request.headers.addAll(headers);
    }

    // kirim request
    var response = await request.send();
    var responseString = await response.stream.bytesToString();

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return jsonDecode(responseString);
    } else {
      throw Exception("API Error ${response.statusCode}: $responseString");
    }
  }
}
