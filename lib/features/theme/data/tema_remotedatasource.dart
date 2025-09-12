import 'dart:convert';

import 'package:notehub/core/const/config.dart';
import 'package:http/http.dart' as http;
import 'package:notehub/features/theme/models/tema_model.dart';

class TemaRemotedatasource {
  final String baseUrl = Config.base_URL;

  Future<void> updateTema(TemaModel tema) async {
    print("📤 Kirim ke backend: ${tema.toJson()}");

    var response = await http.post(
      Uri.parse('$baseUrl/apply_tema'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'note_id': tema.noteId,
        'foto_url': tema.fotoUrl,
      }),
    );

    print("📩 Respon backend: ${response.statusCode} ${response.body}");

    if (response.statusCode != 200) {
      throw Exception('Gagal update tema: ${response.body}');
    }
  }
}
