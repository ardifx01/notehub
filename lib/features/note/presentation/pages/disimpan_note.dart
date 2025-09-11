import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:notehub/core/const/colors.dart';
import 'package:notehub/core/widgets/small_note_card.dart';
import 'package:notehub/features/auth/presentation/controllers/auth_controller.dart';
import 'package:notehub/features/note/presentation/controllers/note_controller.dart';
import 'package:notehub/features/note/presentation/pages/note_profil.dart';
import 'package:notehub/features/note/presentation/pages/small_note_card_shimmer.dart';
import 'package:notehub/features/profile/presentation/pages/profile_page.dart';
import 'package:shimmer/shimmer.dart';

class DisimpanNote extends StatelessWidget {
  DisimpanNote({super.key});

  final authController = Get.find<AuthController>();
  final noteController = Get.find<NoteController>();

  @override
  Widget build(BuildContext context) {
    var user = authController.user.value;
    return Scaffold(
        appBar: AppBar(
          toolbarHeight: 70,
          leading: IconButton(
              onPressed: () => Get.back(),
              icon: Icon(Icons.arrow_back, color: AppColors.surfaceColor)),
          title: Text(
            'Note Disimpan',
            style: TextStyle(
                color: AppColors.surfaceColor, fontWeight: FontWeight.bold),
          ),
          actions: [
            // Profil
            Padding(
              padding: const EdgeInsets.only(right: 20.0),
              child: GestureDetector(
                child: Obx(
                  () => CircleAvatar(
                    radius: 20,
                    backgroundColor: AppColors.buttonColor2,
                    backgroundImage: authController.user.value?.foto != ''
                        ? NetworkImage(authController.user.value!.foto!)
                        : const AssetImage('assets/images/default_avatar.png')
                            as ImageProvider,
                  ),
                ),
                onTap: () {
                  Get.to(ProfilePage());
                },
              ),
            ),
          ],
          backgroundColor: AppColors.primaryColor,
        ),
        body:

            // ================= LIST NOTES =================
            Obx(() {
          if (noteController.isLoading.value) {
            return SmallNoteCardShimmer();
          }
          if (noteController.savedNotes.isEmpty) {
            return const Center(
              child: Text(
                "Belum ada catatan disimpan",
                style: TextStyle(color: AppColors.disabledTextColor),
              ),
            );
          }

          return GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1,
            ),
            itemCount: noteController.savedNotes.length,
            itemBuilder: (context, index) {
              final note = noteController.savedNotes[index];
              return SmallNoteCard(
                  note: note,
                  onTap: () {
                    Get.to(() => NoteProfil(note: note));
                  },
                  trailing: IconButton(
                    color: AppColors.surfaceColor,
                    onPressed: () async {
                      try {
                        await noteController.removeSavedNote(user!.id, note.id);
                      } catch (e) {
                        Get.snackbar('Error', 'Gagal unsave note ini: $e',
                            backgroundColor: AppColors.errorColor,
                            colorText: AppColors.surfaceColor);
                      }
                    },
                    icon: Icon(Icons.delete),
                  ));
            },
          );
        }));
  }
}

