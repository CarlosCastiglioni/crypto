import 'package:crypto/configs/app_settings.dart';
import 'package:crypto/repositories/account_repository.dart';
import 'package:crypto/repositories/favorites_repository.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'my_app.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: ((context) => AccountRepository())),
        ChangeNotifierProvider(create: ((context) => AppSettings())),
        ChangeNotifierProvider(create: ((context) => FavoritesRepository())),
      ],
      child: const MyApp(),
    ),
  );
}
