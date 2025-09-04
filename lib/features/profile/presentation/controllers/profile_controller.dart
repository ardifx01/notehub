import 'package:get/get.dart';
import 'package:notehub/features/auth/domain/auth_repository.dart';
import 'package:notehub/features/auth/models/user_model.dart';
import 'package:notehub/features/auth/presentation/controllers/auth_controller.dart';
import 'package:notehub/features/note/presentation/controllers/note_controller.dart';

class ProfileController extends GetxController {
  final AuthRepository authRepository;

  ProfileController({required this.authRepository});

  final authController = Get.find<AuthController>();
  final noteController = Get.find<NoteController>();

  var isLoadingUser = false.obs;
  var selectedUser = Rxn<UserModel>();

  Future<void> loadUserProfile(int userId) async {
    // kalau lagi loading user yg sama, jangan ulang
    if (isLoadingUser.value && selectedUser.value?.id == userId) return;

    // kalau user yg sama sudah ada, jangan fetch ulang
    if (selectedUser.value?.id == userId) return;

    try {
      isLoadingUser.value = true;
      print("🤣 Mulai ambil data user lain $userId");

      final user = await authRepository.getUser(userId);
      selectedUser.value = user;

      await noteController.fetchUserNotes(userId, forPeople: true);
      await noteController.fetchSavedNotes(userId, forPeople: true);

      print("✅ Ambil data user lain berhasil, user lain: ${user.toJson()}");
    } finally {
      isLoadingUser.value = false;
    }
  }

  @override
  void onClose() {
    // reset supaya kalau pindah user, data lama gak nyangkut
    selectedUser.value = null;
    super.onClose();
  }
}
