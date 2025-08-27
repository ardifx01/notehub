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
}
