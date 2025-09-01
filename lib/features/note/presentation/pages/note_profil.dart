import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:notehub/core/const/colors.dart';
import 'package:notehub/core/widgets/dialog_confirmation.dart';
import 'package:notehub/core/widgets/note_detail_card.dart';
import 'package:notehub/features/auth/presentation/controllers/auth_controller.dart';
import 'package:notehub/features/note/models/note_model.dart';
import 'package:notehub/features/note/presentation/controllers/note_controller.dart';
import 'package:notehub/features/note/presentation/pages/daftar_notes.dart';

class NoteProfil extends StatelessWidget {
  NoteProfil({super.key, required this.note});

  final NoteModel note;
  final noteController = Get.find<NoteController>();
  final authController = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    var user = authController.user.value;
    return Scaffold(
      body: Stack(
        children: [
          Container(
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage(
                          'assets/images/background_${note.kategori.toLowerCase()}.png'),
                      fit: BoxFit.cover))),
          Column(
            children: [
              Align(
                alignment: AlignmentDirectional.topStart,
                child: Padding(
                  padding: const EdgeInsets.all(15),
                  child: IconButton(
                      onPressed: () => Get.back(),
                      color: AppColors.surfaceColor,
                      icon: Icon(
                        Icons.arrow_back_rounded,
                      )),
                ),
              ),

              // Container
              Padding(
                padding: const EdgeInsets.all(25.0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 15,
                          backgroundColor: AppColors.surfaceColor,
                        ),
                        SizedBox(width: 10),
                        Text(
                          'Username',
                          style: TextStyle(color: AppColors.surfaceColor),
                        )
                      ],
                    ),
                    SizedBox(height: 15),
                    Obx(
                      () => NoteDetailCard(
                        note: note,
                        icon: noteController.isNoteSaved(note.id)
                            ? Icons.bookmark_rounded
                            : Icons.bookmark_rounded,
                        iconColor: noteController.isNoteSaved(note.id)
                            ? AppColors.buttonColor3
                            : Colors.grey.shade200,
                        onIconPressed: () async {
                          try {
                            await noteController.toggleSaveNote(
                                user!.id, note.id);
                          } catch (e) {
                            Get.snackbar('Error', 'Gagal save note ini: $e',
                                backgroundColor: AppColors.errorColor,
                                colorText: AppColors.surfaceColor);
                          }
                        },
                      ),
                    ),
                  ],
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
