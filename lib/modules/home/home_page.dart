import 'package:crypto_app/modules/coins/coins_page.dart';
import 'package:flutter/material.dart';

import '../app_settings/settings_page.dart';
import '../favorites/favorites_page.dart';
import '../wallet/wallet_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int currentPage = 0;
  late PageController pc;

  @override
  void initState() {
    super.initState();
    pc = PageController(initialPage: currentPage);
  }

  setPage(page) {
    setState(() {
      currentPage = page;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        onPageChanged: setPage,
        controller: pc,
        children: const [
          CoinsPage(),
          FavoritesPage(),
          WalletPage(),
          SettingsPage(),
        ],
      ),
      bottomNavigationBar: NavigationBarTheme(
        data: NavigationBarThemeData(
            labelTextStyle: MaterialStateProperty.all(
                const TextStyle(fontSize: 14, fontWeight: FontWeight.w500))),
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
          selectedIndex: currentPage,
          onDestinationSelected: (page) {
            pc.animateToPage(page,
                duration: const Duration(milliseconds: 400),
                curve: Curves.ease);
          },
          backgroundColor: Colors.grey[100],
        ),
      ),
    );
  }
}
