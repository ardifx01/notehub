import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:notehub/core/const/colors.dart';
import 'package:notehub/core/widgets/custom_textfield.dart';
import 'package:notehub/core/widgets/small_note_card.dart';
import 'package:notehub/features/auth/presentation/controllers/auth_controller.dart';
import 'package:notehub/features/note/presentation/controllers/note_controller.dart';
import 'package:notehub/features/note/presentation/pages/note_profil.dart';
import 'package:notehub/features/note/presentation/pages/small_note_card_shimmer.dart';
import 'package:notehub/features/profile/presentation/pages/profile_page.dart';


class JelajahiNotes extends StatefulWidget {
  const JelajahiNotes({super.key});

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
    noteController.fetchFypNotes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            color: AppColors.primaryColor,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ================= HEADER =================
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 30),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Back
                      IconButton(
                        onPressed: () => Get.back(),
                        icon: const Icon(Icons.arrow_back,
                            color: AppColors.surfaceColor),
                      ),

                      // Profil
                      GestureDetector(
                        child: Obx(
                          () => CircleAvatar(
                            radius: 20,
                            backgroundColor: AppColors.buttonColor2,
                            backgroundImage: authController.user.value?.foto !=
                                    ''
                                ? NetworkImage(authController.user.value!.foto!)
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

                // ================= SEARCH AND FILTER =================
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Judul
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
                          // Search
                          Expanded(
                            child: customTextfield(
                              hintText: "Cari Note",
                              controller: cariController,
                              onChanged: (value) async {
                                await noteController.fetchFypNotes(
                                    search: value);
                              },
                            ),
                          ),
                          const SizedBox(width: 8),

                          // Dropdown filter button berdasarkan kategori
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
                            onSelected: (value) async {
                              await noteController.fetchFypNotes(
                                  kategori: value);
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
                              PopupMenuItem(
                                value: '',
                                child: Text('Semua',
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

          // ================= LIST NOTES =================
          Expanded(
            child: Obx(() {
              if (noteController.isLoading.value) {
                return SmallNoteCardShimmer();
              }
              if (noteController.allFypNotes.isEmpty) {
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
                    .getFilteredNotes(noteController.allFypNotes)
                    .length,
                itemBuilder: (context, index) {
                  final note = noteController
                      .getFilteredNotes(noteController.allFypNotes)[index];
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




