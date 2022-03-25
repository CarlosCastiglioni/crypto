import 'package:crypto_app/configs/app_settings.dart';
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
        ChangeNotifierProvider(create: (context) => AppSettings()),
        ChangeNotifierProvider(
            create: (context) => FavoritesRepository(
                  auth: context.read<AuthService>(),
                  coins: context.read<CoinRepository>(),
                )),
      ],
      child: MyApp(),
    ),
  );
}
