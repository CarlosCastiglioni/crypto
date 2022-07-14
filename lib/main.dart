import 'package:crypto_app/modules/app_settings/settings_controller.dart';
import 'package:crypto_app/modules/coins/coins_controller.dart';
import 'package:crypto_app/modules/home/home_controller.dart';
import 'package:crypto_app/modules/login/login_controller.dart';
import 'package:crypto_app/repositories/account_repository.dart';
import 'package:crypto_app/repositories/coin.repository.dart';
import 'package:crypto_app/repositories/favorites_repository.dart';
import 'package:crypto_app/services/auth_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'my_app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AuthService()),
        ChangeNotifierProvider(create: (context) => CoinRepository()),
        ChangeNotifierProvider(
            create: (context) => AccountRepository(
                  coins: context.read<CoinRepository>(),
                )),
        ChangeNotifierProvider(
            create: (context) => FavoritesRepository(
                  auth: context.read<AuthService>(),
                  coins: context.read<CoinRepository>(),
                )),
        ChangeNotifierProvider(
            create: (context) =>
                LoginController(auth: context.read<AuthService>())),
        ChangeNotifierProvider(create: (context) => HomeController()),
        ChangeNotifierProvider(create: (context) => SettingsController()),
        ChangeNotifierProvider(create: (context) => CoinsController()),
      ],
      child: const MyApp(),
    ),
  );
}
