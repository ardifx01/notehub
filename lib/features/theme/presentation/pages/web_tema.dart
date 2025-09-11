import 'package:flutter/material.dart';
import 'package:get/get.dart';
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

    controller.loadPage(noteId, authController.user.value!.id.toString());

    return Scaffold(
      appBar: AppBar(title: const Text("Pilih Tema")),
      body: WebViewWidget(controller: controller.webViewController),
    );
  }
}
