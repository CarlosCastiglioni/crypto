import 'package:crypto_app/modules/coins/coins_page.dart';
import 'package:crypto_app/modules/home/home_controller.dart';
import 'package:crypto_app/themes/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../app_settings/settings_page.dart';
import '../favorites/favorites_page.dart';
import '../wallet/wallet_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Consumer<HomeController>(
      builder: (BuildContext context, controller, Widget? child) {
        return Scaffold(
          body: PageView(
            onPageChanged: controller.setPage,
            controller: controller.pc,
            children: const [
              CoinsPage(),
              FavoritesPage(),
              WalletPage(),
              SettingsPage(),
            ],
          ),
          bottomNavigationBar: NavigationBarTheme(
            data: NavigationBarThemeData(
                indicatorColor: AppColors.label,
                labelTextStyle: MaterialStateProperty.all(const TextStyle(
                    fontSize: 14, fontWeight: FontWeight.w500))),
            child: NavigationBar(
              destinations: const [
                NavigationDestination(
                    icon: Icon(Icons.view_list_outlined),
                    label: "All",
                    selectedIcon: Icon(Icons.view_list)),
                NavigationDestination(
                    icon: Icon(Icons.star_border),
                    label: "Favorites",
                    selectedIcon: Icon(Icons.star_outlined)),
                NavigationDestination(
                    icon: Icon(Icons.account_balance_wallet_outlined),
                    label: "Wallet",
                    selectedIcon: Icon(Icons.account_balance_wallet)),
                NavigationDestination(
                    icon: Icon(Icons.settings_outlined),
                    label: "Settings",
                    selectedIcon: Icon(Icons.settings)),
              ],
              selectedIndex: controller.currentPage,
              onDestinationSelected: (page) {
                controller.pc.animateToPage(page,
                    duration: const Duration(milliseconds: 400),
                    curve: Curves.ease);
              },
              backgroundColor: AppColors.background,
            ),
          ),
        );
      },
    );
  }
}
