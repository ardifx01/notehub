import 'package:notehub/features/theme/data/tema_remotedatasource.dart';
import 'package:notehub/features/theme/domain/tema_repository.dart';
import 'package:notehub/features/theme/models/tema_model.dart';

class TemaRepositoryImpl implements TemaRepository {
  final TemaRemotedatasource remotedatasource;

  TemaRepositoryImpl({required this.remotedatasource});

  // UPDATE TEMA
  @override
  Future<void> updateTema(TemaModel tema) async {
    await remotedatasource.updateTema(tema);
  }
}
