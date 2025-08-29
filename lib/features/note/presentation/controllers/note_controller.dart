// note_controller.dart
import 'package:get/get.dart';
import 'package:notehub/features/note/domain/note_repository.dart';
import 'package:notehub/features/note/models/note_model.dart';

class NoteController extends GetxController {
  final NoteRepository repository;
  NoteController({required this.repository});

  var notes = <NoteModel>[].obs;
  var savedNotes = <NoteModel>[].obs;
  var peopleNotes = <NoteModel>[].obs;
  var allNotes = <NoteModel>[].obs;
  var isLoading = false.obs;

  // filter kategori
  var selectedFilter = ''.obs;

  // filter judul (search bar)
  var searchQuery = ''.obs;

  List<NoteModel> get filteredNotes {
    var filtered = notes;

    // filter kategori
    if (selectedFilter.value.isNotEmpty) {
      filtered = filtered
          .where((n) =>
              n.kategori.toLowerCase() == selectedFilter.value.toLowerCase())
          .toList()
          .obs;
    }

    // filter judul
    if (searchQuery.value.isNotEmpty) {
      filtered = filtered
          .where((n) =>
              n.judul.toLowerCase().contains(searchQuery.value.toLowerCase()))
          .toList()
          .obs;
    }

    return filtered;
  }

  Future<void> fetchUserNotes(int userId) async {
    try {
      isLoading.value = true;
      notes.value = await repository.getUserNotes(userId);
      print('🗒️ Notes user $userId berhasil diambil sejumlah ${notes.length}');
    } catch (e) {
      print("Error fetching notes: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchSavedNotes(int userId) async {
    try {
      isLoading.value = true;
      savedNotes.value = await repository.getSavedNotes(userId);
      print(
          '🔖 Saved notes user $userId berhasil diambil sejumlah ${savedNotes.length}');
    } catch (e) {
      print("Error fetching saved notes: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> addNote(
      int userId, String judul, String isi, String kategori) async {
    try {
      final note = await repository.uploadNote(userId, judul, isi, kategori);
      notes.add(note);
    } catch (e) {
      print("Error uploading note: $e");
    }
  }

  Future<void> removeNote(int noteId) async {
    try {
      await repository.deleteNote(noteId);
      notes.removeWhere((n) => n.id == noteId);
    } catch (e) {
      print("Error deleting note: $e");
    }
  }

  Future<void> saveNote(int userId, int noteId) async {
    try {
      await repository.saveNote(userId, noteId);
      fetchSavedNotes(userId);
    } catch (e) {
      print("Error saving note: $e");
    }
  }

  Future<void> fetchAllNotes() async {
    try {
      isLoading.value = true;
      var fetchedNotes = await repository.getAllNotes();

      // 🔀 Acak urutan list
      fetchedNotes.shuffle();

      allNotes.value = fetchedNotes;
      print('📑 Semua Notes  diambil sejumlah ${allNotes.length}');
    } catch (e) {
      print("Error fetching all database notes");
    } finally {
      isLoading.value = false;
    }
  }
}
