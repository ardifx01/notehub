import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:notehub/core/const/colors.dart';
import 'package:notehub/core/widgets/dialog_confirmation.dart';
import 'package:notehub/core/widgets/note_detail_card.dart';
import 'package:notehub/features/note/models/note_model.dart';
import 'package:notehub/features/note/presentation/controllers/note_controller.dart';
import 'package:notehub/features/note/presentation/pages/daftar_notes.dart';

class NotePribadi extends StatelessWidget {
  NotePribadi({super.key, required this.note});

  final NoteModel note;
  final noteController = Get.find<NoteController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage(
                          'Assets/Images/background_${note.kategori.toLowerCase()}.png'),
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
                child: NoteDetailCard(
                  note: note,
                  iconColor: AppColors.buttonColor3,
                  onIconPressed: () async {
                    dialogConfirmation(
                        imagePath: 'assets/images/deco_quest.png',
                        title: 'Yakin Ingin Hapus Note Ini?',
                        middleText:
                            'kamu tidak bisa mengembalikan note ini setelah dihapus permanen',
                        onConfirm: () async {
                          try {
                            await noteController.removeNote(note.id);
                            Get.off(DaftarNotes());
                          } catch (e) {
                            Get.snackbar('Error', '$e',
                                backgroundColor: AppColors.errorColor,
                                colorText: AppColors.surfaceColor);
                          }
                        });
                  },
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
