import 'package:crypto_app/configs/app_settings.dart';
import 'package:crypto_app/modules/coin_details/coin_details_page.dart';
import 'package:crypto_app/repositories/coin.repository.dart';
import 'package:crypto_app/repositories/favorites_repository.dart';
import 'package:crypto_app/themes/app_colors.dart';
import 'package:crypto_app/themes/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../models/coin.dart';

class CoinsPage extends StatefulWidget {
  const CoinsPage({Key? key}) : super(key: key);

  @override
  State<CoinsPage> createState() => _CoinsPageState();
}

class _CoinsPageState extends State<CoinsPage> {
  late List<Coin> table;
  late NumberFormat real;
  late Map<String, String> loc;
  List<Coin> selected = [];
  late FavoritesRepository favorites;
  late CoinRepository coins;

  checkTableCoins() async {
    if (table.isEmpty) {
      await coins.checkPrices();
    } else {
      return;
    }
  }

  readNumberFormat() {
    loc = context.watch<AppSettings>().locale;
    real = NumberFormat.currency(locale: loc["locale"], name: loc["name"]);
  }

  changeLanguageButton() {
    final locale = loc["locale"] == "pt_BR" ? "en_US" : "pt_BR";
    final name = loc["locale"] == "pt_BR" ? "\$" : "R\$";

    return PopupMenuButton(
      icon: const Icon(Icons.language),
      itemBuilder: (context) => [
        PopupMenuItem(
            child: ListTile(
          leading: const Icon(Icons.swap_vert),
          title: Text("Use $locale"),
          onTap: () {
            context.read<AppSettings>().setLocale(locale, name);
            Navigator.pop(context);
          },
        )),
      ],
    );
  }

  dynamicAppbar() {
    if (selected.isEmpty) {
      return AppBar(
        title: const Center(child: Text("Cryptocurrencies")),
        actions: [changeLanguageButton()],
      );
    } else {
      return AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            setState(() {
              selected = [];
            });
          },
        ),
        title: Center(child: Text('${selected.length} Selected')),
        backgroundColor: AppColors.label,
        elevation: 1,
        iconTheme: const IconThemeData(color: AppColors.dark),
        titleTextStyle: TextStyles.selectionTitle,
      );
    }
  }

  showDetails(Coin coin) {
    Navigator.push(context,
        MaterialPageRoute(builder: (_) => CoinDetailsPage(coin: coin)));
  }

  clearSelection() {
    setState(() {
      selected = [];
    });
  }

  @override
  Widget build(BuildContext context) {
    favorites = context.watch<FavoritesRepository>();
    coins = context.watch<CoinRepository>();
    table = coins.table;
    readNumberFormat();
    checkTableCoins();

    return Scaffold(
      appBar: dynamicAppbar(),
      body: RefreshIndicator(
        onRefresh: () => coins.checkPrices(),
        child: ListView.separated(
            itemBuilder: (BuildContext context, int coin) {
              return ListTile(
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(12))),
                leading: (selected.contains(table[coin]))
                    ? const CircleAvatar(
                        backgroundColor: AppColors.label,
                        foregroundColor: AppColors.background,
                        child: Icon(
                          Icons.check,
                        ),
                      )
                    : SizedBox(
                        width: 40, child: Image.network(table[coin].icon)),
                title: Row(
                  children: [
                    Text(table[coin].name, style: TextStyles.text),
                    if (favorites.list
                        .any((fav) => fav.acronym == table[coin].acronym))
                      const Icon(
                        Icons.star,
                        color: AppColors.label,
                        size: 14,
                      )
                  ],
                ),
                trailing: Text(real.format(table[coin].price)),
                selected: selected.contains(table[coin]),
                selectedTileColor: AppColors.secondary.withOpacity(0.7),
                onLongPress: () {
                  setState(() {
                    (selected.contains(table[coin]))
                        ? selected.remove(table[coin])
                        : selected.add(table[coin]);
                  });
                },
                onTap: () => showDetails(table[coin]),
              );
            },
            padding: const EdgeInsets.all(16),
            separatorBuilder: (_, __) => const Divider(),
            itemCount: table.length),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: selected.isNotEmpty
          ? FloatingActionButton.extended(
              onPressed: () {
                favorites.saveAll(selected);
                clearSelection();
              },
              icon: const Icon(Icons.star),
              label: Text(
                "Favorite",
                style: TextStyles.buttonSecondary,
              ),
              backgroundColor: AppColors.label,
            )
          : null,
    );
  }
}
