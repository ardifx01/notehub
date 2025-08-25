import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:notehub/core/network/api_client.dart';
import 'package:notehub/features/auth/data/auth_localdatasource.dart';
import 'package:notehub/features/auth/data/auth_remotedatasource.dart';
import 'package:notehub/features/auth/data/auth_repo_impl.dart';
import 'package:notehub/features/auth/domain/auth_repository.dart';
import 'package:notehub/features/auth/presentation/controllers/auth_controller.dart';
import 'package:notehub/features/auth/presentation/controllers/login_controller.dart';
import 'package:notehub/features/auth/presentation/controllers/signup_controller.dart';

Future<void> initDependencies() async {
  // ✅ CORE
  Get.lazyPut(() => ApiClient(), fenix: true);

  // ✅ AUTH
  // DataSource
  Get.lazyPut(() => AuthRemoteDataSource(Get.find()));
  Get.lazyPut(() => AuthLocalDataSource());

  // Repository
  Get.lazyPut<AuthRepository>(() => AuthRepositoryImpl(
        remoteDataSource: Get.find(),
        localDataSource: Get.find(),
      ));

  // Controller
  Get.lazyPut(() => LoginController(), fenix: true);
  Get.lazyPut(() => SignUpController(), fenix: true);
  Get.put(AuthController(Get.find<AuthRepository>()), permanent: true);

  // ✅ NOTE
  // Datasource
  // Repository
  // Controller

  // ✅ PROFILE
  // Datasource
  // Repository
  // Controller
}
