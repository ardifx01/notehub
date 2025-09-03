import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:notehub/core/const/colors.dart';
import 'package:notehub/core/functions/convert_date.dart';
import 'package:notehub/core/widgets/small_note_card.dart';
import 'package:notehub/features/auth/models/user_model.dart';
import 'package:notehub/features/note/presentation/controllers/note_controller.dart';
import 'package:notehub/features/note/presentation/pages/note_profil.dart';

class ProfileLain extends StatefulWidget {
  final UserModel selectedUser; // user lain
  const ProfileLain({super.key, required this.selectedUser});

  @override
  State<ProfileLain> createState() => _ProfileLainState();
}

class _ProfileLainState extends State<ProfileLain> {
  final noteController = Get.find<NoteController>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadUserData();
    });
  }

  Future<void> _loadUserData() async {
    try {
      await noteController.fetchUserNotes(widget.selectedUser.id,
          forPeople: true);
      await noteController.fetchSavedNotes(widget.selectedUser.id,
          forPeople: true);
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
      backgroundColor: AppColors.surfaceColor,
      body: Column(
        children: [
          // ================= HEADER HIJAU =================
          Container(
            width: double.infinity,
            padding: const EdgeInsets.only(top: 10, bottom: 30),
            decoration: const BoxDecoration(
              color: AppColors.primaryColor
            ),
            child: Column(
              children: [
                // tombol back
                Align(
                  alignment: Alignment.topLeft,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back,
                          color: AppColors.surfaceColor),
                      onPressed: () => Get.back(),
                    ),
                  ),
                ),
                // avatar + nama
                CircleAvatar(
                  radius: 50,
                  backgroundColor: AppColors.buttonColor2,
                  child: widget.selectedUser.foto != null
                      ? ClipOval(
                          child: Image.network(
                            widget.selectedUser.foto!.trim(),
                            fit: BoxFit.cover,
                            width: 100,
                            height: 100,
                            errorBuilder: (context, error, stackTrace) {
                              return Image.asset(
                                "assets/images/default_avatar.png",
                                fit: BoxFit.cover,
                                width: 100,
                                height: 100,
                              );
                            },
                          ),
                        )
                      : ClipOval(
                          child: Image.asset(
                            "assets/images/default_avatar.png",
                            fit: BoxFit.cover,
                            width: 100,
                            height: 100,
                          ),
                        ),
                ),
                const SizedBox(height: 10),
                Text(
                  widget.selectedUser.nama,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.surfaceColor,
                  ),
                ),
                const SizedBox(height: 20),

                // info box (Sejak, Notes, Disimpan)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _InfoBox(
                        title: "Sejak",
                        value: formatTanggal(widget.selectedUser.createdAt),
                      ),
                      Obx(() => _InfoBox(
                            title: "Notes",
                            value: noteController.peopleNotes.length.toString(),
                          )),
                      Obx(() => _InfoBox(
                            title: "Disimpan",
                            value: noteController.peopleSavedNotes.length
                                .toString(),
                          )),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // ================= ISI CATATAN =================
          Expanded(
            child: Obx(() {
              if (noteController.isLoading.value) {
                return Center(
                  child: LoadingAnimationWidget.staggeredDotsWave(
                    color: AppColors.primaryColor,
                    size: 30,
                  ),
                );
              }
              if (noteController.peopleNotes.isEmpty) {
                return const Center(
                  child: Text(
                    "Belum ada catatan",
                    style: TextStyle(color: AppColors.disabledTextColor),
                  ),
                );
              }

              return GridView.builder(
                padding: const EdgeInsets.all(25),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 0.9,
                ),
                itemCount: noteController.peopleNotes.length,
                itemBuilder: (context, index) {
                  final note = noteController.peopleNotes[index];
                  return SmallNoteCard(
                    note: note,
                    onTap: () {
                      Get.to(() => NoteProfil(note: note));
                    },
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }
}

// InfoBox kecil untuk menampilkan angka
class _InfoBox extends StatelessWidget {
  final String title;
  final String value;
  const _InfoBox({required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          title,
          style: const TextStyle(
            color: AppColors.surfaceColor,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 5),
        Text(
          value,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: AppColors.surfaceColor,
          ),
        ),
      ],
    );
  }
}
