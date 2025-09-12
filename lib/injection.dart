import 'package:get/get.dart';
import 'package:notehub/features/auth/data/auth_localdatasource.dart';
import 'package:notehub/features/auth/data/auth_remotedatasource.dart';
import 'package:notehub/features/auth/data/auth_repo_impl.dart';
import 'package:notehub/features/auth/domain/auth_repository.dart';
import 'package:notehub/features/auth/presentation/controllers/auth_controller.dart';
import 'package:notehub/features/auth/presentation/controllers/login_controller.dart';
import 'package:notehub/features/auth/presentation/controllers/signup_controller.dart';
import 'package:notehub/features/note/data/note_remotedatasource.dart';
import 'package:notehub/features/note/data/note_repo_impl.dart';
import 'package:notehub/features/note/domain/note_repository.dart';
import 'package:notehub/features/note/presentation/controllers/buat_note_controller.dart';
import 'package:notehub/features/note/presentation/controllers/note_controller.dart';
import 'package:notehub/features/profile/presentation/controllers/edit_controller.dart';
import 'package:notehub/features/profile/presentation/controllers/profile_controller.dart';
import 'package:notehub/features/theme/data/tema_remotedatasource.dart';
import 'package:notehub/features/theme/data/tema_repository_impl.dart';
import 'package:notehub/features/theme/domain/tema_repository.dart';
import 'package:notehub/features/theme/presentation/controller/web_tema_controller.dart';

Future<void> initDependencies() async {
  // ✅ NOTE
  // Datasource
  Get.lazyPut(() => NoteRemoteDataSource(), fenix: true);

  // Repository
  Get.lazyPut<NoteRepository>(
      () => NoteRepositoryImpl(remoteDataSource: Get.find()),
      fenix: true);

  // Controller
  Get.lazyPut(() => BuatNoteController(), fenix: true);
  Get.put(NoteController(repository: Get.find<NoteRepository>()));

  // ✅ AUTH / PROFILE
  // DataSource
  Get.lazyPut(() => AuthRemoteDataSource(), fenix: true);
  Get.lazyPut(() => AuthLocalDataSource(), fenix: true);

  // Repository
  Get.lazyPut<AuthRepository>(
      () => AuthRepositoryImpl(
            remoteDataSource: Get.find(),
            localDataSource: Get.find(),
          ),
      fenix: true);

  // Controller
  Get.put(LoginController(), permanent: true);
  Get.put(SignUpController(), permanent: true);
  Get.put(EditController(), permanent: true);
  Get.put(AuthController(Get.find<AuthRepository>()), permanent: true);
  Get.lazyPut(
      () => ProfileController(authRepository: Get.find<AuthRepository>()),
      fenix: true);

  // TEMA

  // datasource
  Get.lazyPut(() => TemaRemotedatasource(), fenix: true);

  // repository
  Get.lazyPut<TemaRepository>(() =>
      TemaRepositoryImpl(remotedatasource: Get.find<TemaRemotedatasource>()), fenix: true);
  // controller
  Get.lazyPut(() => WebTemaController(repository: Get.find<TemaRepository>()), fenix: true);
}
