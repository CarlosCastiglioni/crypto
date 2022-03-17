import 'package:crypto/repositories/favorites_repository.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'my_app.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => FavoritesRepository(),
      child: const MyApp(),
    ),
  );
}
