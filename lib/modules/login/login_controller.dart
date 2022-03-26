import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/cupertino.dart';

import '../../services/auth_service.dart';

class LoginController extends ChangeNotifier {
  final formKey = GlobalKey<FormState>();
  final email = TextEditingController();
  final password = TextEditingController();
  bool isLoged = true;
  String title = "Welcome To Crypto";
  String actionButton = "Login";
  late String toggleButton = "Sign-in";
  bool loading = false;
  final AuthService auth;

  LoginController({required this.auth});

  setFormAction(bool action) {
    isLoged = action;
    if (isLoged) {
      title = 'Welcome To Crypto';
      actionButton = 'Login';
      toggleButton = 'Sign-in';
    } else {
      title = 'Create an account';
      actionButton = 'Sign-in';
      toggleButton = 'Back to login page';
    }
    notifyListeners();
  }

  login(context) async {
    loading = true;
    try {
      await auth.login(email.text, password.text);
    } on AuthException catch (e) {
      loading = false;
      BotToast.showText(text: e.message);
    }
    notifyListeners();
  }

  register(context) async {
    loading = true;
    try {
      await auth.register(email.text, password.text);
    } on AuthException catch (e) {
      loading = false;
      BotToast.showText(text: e.message);
    }
    notifyListeners();
  }
}
