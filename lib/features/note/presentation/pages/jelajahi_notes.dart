import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:notehub/core/const/colors.dart';
import 'package:notehub/core/functions/convert_date.dart';
import 'package:notehub/core/functions/warna_kategori.dart';
import 'package:notehub/core/widgets/custom_textfield.dart';
import 'package:notehub/core/widgets/small_note_card.dart';
import 'package:notehub/features/auth/presentation/controllers/auth_controller.dart';
import 'package:notehub/features/home/presentation/home_page.dart';
import 'package:notehub/features/note/presentation/controllers/note_controller.dart';
import 'package:notehub/features/note/presentation/pages/note_pribadi.dart';
import 'package:notehub/features/note/presentation/pages/note_profil.dart';
import 'package:notehub/features/profile/presentation/pages/profile_page.dart';

class JelajahiNotes extends StatefulWidget {
  JelajahiNotes({super.key});

  @override
  State<JelajahiNotes> createState() => _JelajahiNotesState();
}

class _JelajahiNotesState extends State<JelajahiNotes> {
  final authController = Get.find<AuthController>();

  final noteController = Get.find<NoteController>();

  final cariController = TextEditingController();

  @override
  void initState() {
    super.initState();
    noteController.fetchAllNotes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Container(
              color: AppColors.primaryColor,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // --------- Header (tombol back dan profil)
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          onPressed: () => Get.back(),
                          icon: const Icon(Icons.arrow_back,
                              color: AppColors.surfaceColor),
                        ),
                        GestureDetector(
                          child: Obx(
                            () => CircleAvatar(
                              radius: 20,
                              backgroundColor: AppColors.buttonColor2,
                              backgroundImage: authController
                                          .user.value?.foto !=
                                      ''
                                  ? NetworkImage(
                                      authController.user.value!.foto!)
                                  : const AssetImage(
                                          'assets/images/default_avatar.png')
                                      as ImageProvider,
                            ),
                          ),
                          onTap: () {
                            Get.to(ProfilePage());
                          },
                        ),
                      ],
                    ),
                  ),

                  // ---------- Search + Filter Row
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 25, vertical: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Jelajahi Notes",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                            color: AppColors.surfaceColor,
                          ),
                        ),
                        SizedBox(height: 10),
                        Row(
                          children: [
                            Expanded(
                              child: customTextfield(
                                hintText: "Cari Note",
                                controller: cariController,
                                onChanged: (value) {
                                  noteController.searchQuery.value = value;
                                },
                              ),
                            ),
                            const SizedBox(width: 8),
                            PopupMenuButton<String>(
                              icon: const Icon(Icons.menu_rounded,
                                  color: Colors.white),
                              color: AppColors.buttonColor3,
                              style: ButtonStyle(
                                backgroundColor: WidgetStateProperty.all(
                                    AppColors.buttonColor3),
                                shape: WidgetStateProperty.all(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              onSelected: (value) {
                                // toggle filter
                                if (noteController.selectedFilter.value ==
                                    value) {
                                  noteController.selectedFilter.value =
                                      ''; // kosongin -> semua muncul
                                } else {
                                  noteController.selectedFilter.value = value;
                                }
                              },
                              itemBuilder: (context) => const [
                                PopupMenuItem(
                                  value: 'Belajar',
                                  child: Text('Belajar',
                                      style: TextStyle(
                                          color: AppColors.surfaceColor)),
                                ),
                                PopupMenuItem(
                                  value: 'Cerita',
                                  child: Text('Cerita',
                                      style: TextStyle(
                                          color: AppColors.surfaceColor)),
                                ),
                                PopupMenuItem(
                                  value: 'Random',
                                  child: Text('Random',
                                      style: TextStyle(
                                          color: AppColors.surfaceColor)),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 15),
                ],
              ),
            ),
            // ------------- List Notes
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
                if (noteController.allNotes.isEmpty) {
                  return const Center(
                    child: Text(
                      "Belum ada catatan",
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
                  itemCount: noteController
                      .getFilteredNotes(noteController.allNotes)
                      .length,
                  itemBuilder: (context, index) {
                    final note = noteController
                        .getFilteredNotes(noteController.allNotes)[index];
                    return SmallNoteCard(
                      note: note,
                      onTap: () {
                        // authController. // TODO:
                        Get.to(() => NoteProfil(note: note));
                      },
                      trailing: CircleAvatar(
                        backgroundColor: AppColors.surfaceColor,
                        radius: 15,
                      ),
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
