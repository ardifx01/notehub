import 'package:notehub/features/theme/models/tema_model.dart';

abstract class TemaRepository {
  Future<void> updateTema(TemaModel tema);
}
