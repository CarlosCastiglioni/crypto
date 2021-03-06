import 'package:bot_toast/bot_toast.dart';
import 'package:crypto_app/themes/app_colors.dart';
import 'package:crypto_app/themes/app_text_styles.dart';
import 'package:crypto_app/widgets/auth_check.dart';
import 'package:flutter/material.dart';

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      builder: BotToastInit(),
      title: "Crypto",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          appBarTheme: AppBarTheme(titleTextStyle: TextStyles.baseTitle),
          colorScheme:
              ColorScheme.fromSwatch().copyWith(primary: AppColors.primary)),
      home: const AuthCheck(),
    );
  }
}
