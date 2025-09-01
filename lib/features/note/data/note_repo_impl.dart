
import 'package:notehub/features/note/data/note_remotedatasource.dart';
import 'package:notehub/features/note/domain/note_repository.dart';
import 'package:notehub/features/note/models/note_model.dart';

class NoteRepositoryImpl implements NoteRepository {
  final NoteRemoteDataSource remoteDataSource;

  NoteRepositoryImpl({required this.remoteDataSource});

  @override
  Future<NoteModel> uploadNote(int userId, String judul, String isi, String kategori) {
    return remoteDataSource.uploadNote(userId: userId, judul: judul, isi: isi, kategori: kategori);
  }

  @override
  Future<List<NoteModel>> getUserNotes(int userId) {
    return remoteDataSource.getUserNotes(userId);
  }

  @override
  Future<List<NoteModel>> getAllNotes() {
    return remoteDataSource.getAllNotes();
  }

  @override
  Future<void> deleteNote(int noteId) {
    return remoteDataSource.deleteNote(noteId);
  }

  @override
  Future<void> saveNote(int userId, int noteId) {
    return remoteDataSource.saveNote(userId, noteId);
  }

   @override
  Future<void> unsaveNote(int userId, int noteId) {
    return remoteDataSource.unsaveNote(userId, noteId);
  }

  @override
  Future<List<NoteModel>> getSavedNotes(int userId) {
    return remoteDataSource.getSavedNotes(userId);
  }
}
