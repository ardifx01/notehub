// note_controller.dart
import 'package:get/get.dart';
import 'package:notehub/features/note/domain/note_repository.dart';
import 'package:notehub/features/note/models/note_model.dart';

class NoteController extends GetxController {
  final NoteRepository repository;
  NoteController({required this.repository});

  var notes = <NoteModel>[].obs; // Note user (saya)
  var savedNotes = <NoteModel>[].obs; // Saved note user
  var allNotes = <NoteModel>[].obs; // Semua note yang ada (fyp)

  var peopleNotes = <NoteModel>[].obs; // Note user lain selected
  var peopleSavedNotes = <NoteModel>[].obs; // Note saved user lain selected

  var isLoading = false.obs;

  // ----------------------------- FILTER
  // filter kategori
  var selectedFilter = ''.obs;

  // filter judul (search bar)
  var searchQuery = ''.obs;

  List<NoteModel> getFilteredNotes(List<NoteModel> source) {
    var filtered = source;

    // filter kategori
    if (selectedFilter.value.isNotEmpty) {
      filtered = filtered
          .where((n) =>
              n.kategori.toLowerCase() == selectedFilter.value.toLowerCase())
          .toList();
    }

    // filter judul
    if (searchQuery.value.isNotEmpty) {
      filtered = filtered
          .where((n) =>
              n.judul.toLowerCase().contains(searchQuery.value.toLowerCase()))
          .toList();
    }

    return filtered;
  }

  // ----------------------------- Daily Notes untuk heatmap calendar
  Map<DateTime, int> get notesCount {
    final map = <DateTime, int>{};

    for (var note in notes) {
      final date =
          DateTime(note.tanggal.year, note.tanggal.month, note.tanggal.day);
      map[date] = (map[date] ?? 0) + 1;

      // batasi maksimal level ke 5
      if (map[date]! > 5) {
        map[date] = 5;
      }
    }
    print(map);
    return map;
  }

  // ----------------------------- FETCH
  Future<void> fetchUserNotes(int userId, {bool forPeople = false}) async {
    try {
      isLoading.value = true;
      var fetchedNotes = await repository.getUserNotes(userId);

      if (forPeople == false) {
        notes.value = fetchedNotes.reversed.toList();
        print(
            '🗒️ Notes user $userId berhasil diambil sejumlah ${notes.length}');
      } else {
        peopleNotes.value = fetchedNotes.reversed.toList();
        print(
            '🗒️ Notes user lain $userId berhasil diambil sejumlah ${notes.length}');
      }
    } catch (e) {
      print("Error fetching notes: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchSavedNotes(int userId, {bool forPeople = false}) async {
    try {
      isLoading.value = true;
      var fetchedNotes = await repository.getSavedNotes(userId);

       if (forPeople == false) {
        savedNotes.value  = fetchedNotes.reversed.toList();
        print(
            '🔖 Saved notes user $userId berhasil diambil sejumlah ${savedNotes.length}');
      } else {
        peopleSavedNotes.value = fetchedNotes.reversed.toList();
        print(
            '🔖 Saved notes user lain $userId berhasil diambil sejumlah ${savedNotes.length}');
      }
    } catch (e) {
      print("Error fetching saved notes: $e");
    } finally {
      isLoading.value = false;
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

  // ----------------------------- ADD & DELETE
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

  // ----------------------------- SAVE & UNSAVE
  Future<void> saveNote(int userId, int noteId) async {
    try {
      await repository.saveNote(userId, noteId);
      await fetchSavedNotes(userId);
    } catch (e) {
      print("Error saving note: $e");
    }
  }

  Future<void> removesavedNote(int userId, int noteId) async {
    try {
      await repository.unsaveNote(userId, noteId);
      await fetchSavedNotes(userId);
    } catch (e) {
      print("Error remove saved note: $e");
    }
  }

  Future<void> toggleSaveNote(int userId, int noteId) async {
    if (isNoteSaved(noteId)) {
      await removesavedNote(userId, noteId);
    } else {
      await saveNote(userId, noteId);
    }
  }

  bool isNoteSaved(int noteId) {
    return savedNotes.any((n) => n.id == noteId);
  }
}
