// presentation/controllers/tema_controller.dart
import 'dart:convert';
import 'package:get/get.dart';
import 'package:notehub/core/const/config.dart';
import 'package:notehub/features/theme/domain/tema_repository.dart';
import 'package:notehub/features/theme/models/tema_model.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebTemaController extends GetxController {
  late WebViewController webViewController;
  final TemaRepository repository;

  WebTemaController({required this.repository});

  @override
  void onInit() {
    super.onInit();
    webViewController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..addJavaScriptChannel(
        'ThemeChannel',
        onMessageReceived: (msg) async {
          final data = jsonDecode(msg.message);
          final tema = TemaModel(
            noteId: data['noteId'],
            link: data['temaLink'],
          );

          try {
            await repository.updateTema(tema);
            webViewController.runJavaScript(
              "alert('Tema berhasil disimpan untuk Note ${tema.noteId}')",
            );
          } catch (e) {
            webViewController.runJavaScript(
              "alert('Gagal simpan tema')",
            );
          }
        },
      );
  }

  void loadPage(String noteId, String userName) {
    final fullUrl = "${Config.url_web}?note_id=$noteId/user_name=$userName";
    webViewController.loadRequest(Uri.parse(fullUrl));
  }
}
