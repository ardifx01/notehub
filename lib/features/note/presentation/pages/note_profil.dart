import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:notehub/core/const/colors.dart';
import 'package:notehub/core/widgets/note_detail_card.dart';
import 'package:notehub/features/auth/presentation/controllers/auth_controller.dart';
import 'package:notehub/features/note/models/note_model.dart';
import 'package:notehub/features/note/presentation/controllers/note_controller.dart';
import 'package:notehub/features/profile/presentation/controllers/profile_controller.dart';
import 'package:notehub/features/profile/presentation/pages/profile_lain.dart';

class NoteProfil extends StatefulWidget {
  final NoteModel note;
  const NoteProfil({super.key, required this.note});

  @override
  State<NoteProfil> createState() => _NoteProfilState();
}

class _NoteProfilState extends State<NoteProfil> {
  final noteController = Get.find<NoteController>();
  final authController = Get.find<AuthController>();
  final profileController = Get.find<ProfileController>();

  @override
  void initState() {
    super.initState();
    // ambil data user pemilik note
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadUserData();
    });
  }

  Future<void> _loadUserData() async {
    try {
      await profileController.loadUserProfile(widget.note.userId);
    } catch (e) {
      Get.snackbar(
        'Error',
        'Gagal memuat user: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // background sesuai kategori note
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                  'assets/images/background_${widget.note.kategori.toLowerCase()}.png',
                ),
                fit: BoxFit.cover,
              ),
            ),
          ),

          Column(
            children: [
              // tombol back
              Align(
                alignment: AlignmentDirectional.topStart,
                child: Padding(
                  padding: const EdgeInsets.all(15),
                  child: IconButton(
                    onPressed: () => Get.back(),
                    color: AppColors.surfaceColor,
                    icon: const Icon(Icons.arrow_back_rounded),
                  ),
                ),
              ),

              // konten note
              Padding(
                padding: const EdgeInsets.all(25),
                child: Obx(() {
                  final user = profileController.selectedUser.value;
                  if (user == null) {
                    return Center(
                      child: CircularProgressIndicator(
                        color: AppColors.buttonColor2,
                      ),
                    );
                  }

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              Get.to(() => ProfileLain(selectedUser: user));
                            },
                            child: CircleAvatar(
                              radius: 15,
                              backgroundColor: AppColors.buttonColor2,
                              backgroundImage: (user.foto != null &&
                                      user.foto!.isNotEmpty)
                                  ? NetworkImage(user.foto!.trim())
                                  : const AssetImage(
                                          'assets/images/default_avatar.png')
                                      as ImageProvider,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Text(
                            user.nama,
                            style: const TextStyle(
                              color: AppColors.surfaceColor,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 15),

                      // note detail card
                      NoteDetailCard(
                        note: widget.note,
                        icon: noteController.isNoteSaved(widget.note.id)
                            ? Icons.bookmark
                            : Icons.bookmark_border,
                        iconColor: noteController.isNoteSaved(widget.note.id)
                            ? AppColors.buttonColor3
                            : Colors.grey.shade300,
                        onIconPressed: () async {
                          try {
                            await noteController.toggleSaveNote(
                              authController.user.value!.id,
                              widget.note.id,
                            );
                          } catch (e) {
                            Get.snackbar(
                              'Error',
                              'Gagal save note ini: ${e.toString()}',
                              backgroundColor: AppColors.errorColor,
                              colorText: AppColors.surfaceColor,
                            );
                          }
                        },
                      ),
                    ],
                  );
                }),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
