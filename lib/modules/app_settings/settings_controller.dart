import 'dart:io';

import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/Material.dart';

class SettingsController extends ChangeNotifier {
  File? image;

  Future savePhoto(File foto) async {
    try {
      BotToast.showText(text: 'Photo saved!');
      image = foto;
    } catch (e) {
      BotToast.showText(text: e.toString());
    }
    notifyListeners();
  }
}
