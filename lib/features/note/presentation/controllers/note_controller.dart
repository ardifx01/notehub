// note_controller.dart
import 'package:get/get.dart';
import 'package:notehub/features/note/domain/note_repository.dart';
import 'package:notehub/features/note/models/note_model.dart';

class NoteController extends GetxController {
  final NoteRepository repository;
  NoteController({required this.repository});

  // ----------------------------- DATA
  var notes = <NoteModel>[].obs; // catatan milik user
  var savedNotes = <NoteModel>[].obs; // catatan disimpan user
  var allNotes = <NoteModel>[].obs; // semua catatan (fyp)
  var allFypNotes = <NoteModel>[].obs; // semua catatan (fyp)
  var peopleNotes = <NoteModel>[].obs; // catatan user lain (selected)
  var peopleSavedNotes = <NoteModel>[].obs; // catatan disimpan user lain
  var isLoading = false.obs;

  // ----------------------------- FILTER STATE
  var selectedFilter = ''.obs; // filter kategori
  var searchQuery = ''.obs; // filter judul (search bar)

  // ----------------------------- FILTER FUNCTION
  /// mengembalikan notes sesuai filter kategori + judul
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

  // ----------------------------- HEATMAP CALENDAR
  /// menghitung jumlah note per tanggal (maksimal level = 5)
  Map<DateTime, int> get notesCount {
    final map = <DateTime, int>{};

    for (var note in notes) {
      final date =
          DateTime(note.tanggal.year, note.tanggal.month, note.tanggal.day);
      map[date] = (map[date] ?? 0) + 1;

      if (map[date]! > 5) {
        map[date] = 5;
      }
    }
    print(map);
    return map;
  }

  // ----------------------------- FETCH
  /// ambil notes milik user (atau user lain dengan forPeople = true)
  Future<void> fetchUserNotes(int userId, {bool forPeople = false}) async {
    try {
      isLoading.value = true;
      var fetchedNotes = await repository.getUserNotes(userId);

      if (!forPeople) {
        notes.value = fetchedNotes.reversed.toList();
        print(
            '🗒️ Notes user $userId berhasil diambil sejumlah ${notes.length}');
      } else {
        peopleNotes.value = fetchedNotes.reversed.toList();
        print(
            '🗒️ Notes user lain $userId berhasil diambil sejumlah ${peopleNotes.length}');
      }
    } catch (e) {
      print("Error fetching notes: $e");
    } finally {
      isLoading.value = false;
    }
  }

  /// ambil saved notes milik user (atau user lain dengan forPeople = true)
  Future<void> fetchSavedNotes(int userId, {bool forPeople = false}) async {
    try {
      isLoading.value = true;
      var fetchedNotes = await repository.getSavedNotes(userId);

      if (!forPeople) {
        savedNotes.value = fetchedNotes.reversed.toList();
        print(
            '🔖 Saved notes user $userId berhasil diambil sejumlah ${savedNotes.length}');
      } else {
        peopleSavedNotes.value = fetchedNotes.reversed.toList();
        print(
            '🔖 Saved notes user lain $userId berhasil diambil sejumlah ${peopleSavedNotes.length}');
      }
    } catch (e) {
      print("Error fetching saved notes: $e");
    } finally {
      isLoading.value = false;
    }
  }

  /// ambil semua notes (random order untuk FYP)
  Future<void> fetchAllNotes() async {
    try {
      isLoading.value = true;
      var fetchedNotes = await repository.getAllNotes();
      fetchedNotes.shuffle(); // acak urutan

      allNotes.value = fetchedNotes;
      print('📑 Semua Notes diambil sejumlah ${allNotes.length}');
    } catch (e) {
      print("Error ambil semua note $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchFypNotes(String? search, String? kategori) async {
    try {
      isLoading.value = true;
      var fetchedFypNotes = await repository.getFypNotes(search, kategori);
      fetchedFypNotes.shuffle();

      allFypNotes.value = fetchedFypNotes;
      print('📑 Fyp Notes diambil sejumlah ${allFypNotes.length}');
    } catch (e) {
      print("Error ambil notes fyp: $e");
    } finally {
      isLoading.value = false;
    }
  }

  // ----------------------------- ADD & DELETE
  /// tambah note baru ke repository & simpan di state user
  Future<void> addNote(
      int userId, String judul, String isi, String kategori) async {
    try {
      isLoading.value = true;
      final note = await repository.uploadNote(userId, judul, isi, kategori);
      notes.add(note);
    } catch (e) {
      print("Error uploading note: $e");
    } finally {
      isLoading.value = false;
    }
  }

  /// hapus note berdasarkan id
  Future<void> removeNote(int noteId) async {
    try {
      await repository.deleteNote(noteId);
      notes.removeWhere((n) => n.id == noteId);
    } catch (e) {
      print("Error deleting note: $e");
    }
  }

  // ----------------------------- SAVE & UNSAVE
  /// simpan note ke daftar saved user
  Future<void> saveNote(int userId, int noteId) async {
    try {
      await repository.saveNote(userId, noteId);
      await fetchSavedNotes(userId);
    } catch (e) {
      print("Error saving note: $e");
    }
  }

  /// hapus note dari daftar saved user
  Future<void> removeSavedNote(int userId, int noteId) async {
    try {
      await repository.unsaveNote(userId, noteId);
      await fetchSavedNotes(userId);
    } catch (e) {
      print("Error remove saved note: $e");
    }
  }

  /// toggle simpan / unsave note
  Future<void> toggleSaveNote(int userId, int noteId) async {
    if (isNoteSaved(noteId)) {
      await removeSavedNote(userId, noteId);
    } else {
      await saveNote(userId, noteId);
    }
  }

  /// cek apakah note dengan id tertentu sudah disimpan user
  bool isNoteSaved(int noteId) {
    return savedNotes.any((n) => n.id == noteId);
  }

  // Memebersihkan cache untuk logout
  void clear() {
    notes.clear();
    savedNotes.clear();
    allNotes.clear();
    peopleNotes.clear();
    peopleSavedNotes.clear();
    print('🧹 Cache notes dibersihkan');
  }
}
