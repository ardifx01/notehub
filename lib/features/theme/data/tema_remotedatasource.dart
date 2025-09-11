import 'dart:convert';

import 'package:notehub/core/const/config.dart';
import 'package:http/http.dart' as http;
import 'package:notehub/features/theme/models/tema_model.dart';

class TemaRemotedatasource {
  final String baseUrl = Config.base_URL;

  Future<void> updateTema(TemaModel tema) async {
    var response = await http.post(Uri.parse('$baseUrl/apply_tema'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(tema.toJson()));

    if (response.statusCode != 200) {
      Exception('Gagal update tema');
    }
  }
}
