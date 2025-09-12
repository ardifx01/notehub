import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:notehub/core/const/config.dart';
import 'package:notehub/features/auth/presentation/controllers/auth_controller.dart';
import 'package:notehub/features/theme/presentation/controller/web_tema_controller.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebTema extends StatelessWidget {
  final String noteId;
  WebTema({super.key, required this.noteId});
  final AuthController authController = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<WebTemaController>();

    controller.loadPage(noteId, authController.user.value!.nama.toString());

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.close_rounded),
          onPressed: () => Get.back(),
        ),
        title: SelectableText(
          '${Config.url_web}note_id=$noteId&user_name=${authController.user.value!.nama}',
          style: TextStyle(fontSize: 12),
          maxLines: 1,
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh_rounded),
            onPressed: () {
              controller.loadPage(
                  noteId, authController.user.value!.nama.toString());
            },
          )
        ],
      ),
      body: WebViewWidget(controller: controller.webViewController),
    );
  }
}
