import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:notehub/features/auth/presentation/controllers/login_controller.dart';
import 'package:notehub/features/auth/presentation/controllers/signup_controller.dart';

Future<void> initDependencies() async {
  // ✅ Core


  // ✅ Auth
  Get.lazyPut(() => LoginController(), fenix: true);
  Get.lazyPut(() => SignUpController(), fenix: true);


  // ✅ Note


  // ✅ Profile

}