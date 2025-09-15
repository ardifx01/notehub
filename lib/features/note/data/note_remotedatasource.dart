// note_remote_data_source.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:notehub/core/const/config.dart';
import '../models/note_model.dart';

class NoteRemoteDataSource {
  String baseUrl = Config.base_URL;

  // ==============================
  // UPLOAD NOTE
  // ==============================
  Future<NoteModel> uploadNote({
    required int userId,
    required String judul,
    required String isi,
    String kategori = "Random",
  }) async {
    final response = await http.post(
      Uri.parse("$baseUrl/note"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "user_id": userId,
        "judul": judul,
        "isi": isi,
        "kategori": kategori,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return NoteModel(
        id: data["id"],
        userId: userId,
        judul: judul,
        isi: isi,
        kategori: kategori,
        tanggal: DateTime.now(),
        tema: data["tema"] ?? "default",
      );
    } else {
      throw Exception("Failed to upload note");
    }
  }

  // ==============================
  // AMBIL NOTES USER TERTENTU
  // ==============================
  Future<List<NoteModel>> getUserNotes(int userId) async {
    final response = await http.get(Uri.parse("$baseUrl/notes/$userId"));
    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.map((e) => NoteModel.fromJson(e)).toList();
    } else {
      throw Exception("Failed to fetch notes");
    }
  }

  // ==============================
  // AMBIL SEMUA NOTES YANG ADA
  // ==============================
  // Future<List<NoteModel>> getAllNotes() async {
  //   final response = await http.get(Uri.parse("$baseUrl/notes"));
  //   if (response.statusCode == 200) {
  //     final List data = jsonDecode(response.body);
  //     return data.map((e) => NoteModel.fromJson(e)).toList();
  //   } else {
  //     throw Exception("Failed to fetch all notes");
  //   }
  // }

  // ==============================
  // AMBIL NOTES FYP/JELAJAH 
  // ==============================
  Future<List<NoteModel>> getFypNotes(String? search, String? kategori) async {
    // rakit query param
    final queryParams = <String, String>{};
    if (search != null && search.isNotEmpty) {
      queryParams['search'] = search;
    }
    if (kategori != null && kategori.isNotEmpty) {
      queryParams['kategori'] = kategori;
    }

    // bikin uri dengan query param
    final uri =
        Uri.parse("$baseUrl/fyp_notes").replace(queryParameters: queryParams);

    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.map((e) => NoteModel.fromJson(e)).toList();
    } else {
      throw Exception("Failed to fetch fyp notes: ${response.body}");
    }
  }

  // ==============================
  // HAPUS NOTE TERTENTU
  // ==============================
  Future<void> deleteNote(int noteId) async {
    final response = await http.delete(Uri.parse("$baseUrl/note/$noteId"));
    if (response.statusCode != 200) {
      throw Exception("Failed to delete note");
    }
  }

  // ==============================
  // SIMPAN NOTE
  // ==============================
  Future<void> saveNote(int userId, int noteId) async {
    final response = await http.post(
      Uri.parse("$baseUrl/save_note"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "user_id": userId,
        "note_id": noteId,
      }),
    );
    if (response.statusCode != 200) {
      throw Exception("Failed to save note");
    }
  }

  Future<void> unsaveNote(int userId, int noteId) async {
    final response = await http.delete(
      Uri.parse("$baseUrl/unsave_note"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "user_id": userId,
        "note_id": noteId,
      }),
    );
    if (response.statusCode != 200) {
      throw Exception("Failed to unsave note");
    }
  }

  // ==============================
  // AMBIL NOTES YANG DISIMPAN USER TERTENTU
  // ==============================
  Future<List<NoteModel>> getSavedNotes(int userId) async {
    final response = await http.get(Uri.parse("$baseUrl/saved_notes/$userId"));
    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.map((e) => NoteModel.fromJson(e)).toList();
    } else {
      throw Exception("Failed to fetch saved notes");
    }
  }
}
