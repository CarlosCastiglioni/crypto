import 'package:crypto_app/modules/coin_details/coin_details_page.dart';
import 'package:crypto_app/modules/coins/coins_controller.dart';
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
  late FavoritesRepository favorites;

  dynamicAppbar(Function clearSelection, List<Coin> selected) {
    if (selected.isEmpty) {
      return AppBar(
        title: const Center(child: Text("Cryptocurrencies")),
      );
    } else {
      return AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            clearSelection();
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

  @override
  Widget build(BuildContext context) {
    return Consumer<CoinsController>(builder: (context, controller, child) {
      favorites = context.watch<FavoritesRepository>();
      controller.coins = context.watch<CoinRepository>();
      controller.table = controller.coins.table;
      controller.checkTableCoins();
      return Scaffold(
        appBar: dynamicAppbar(controller.clearSelection, controller.selected),
        body: RefreshIndicator(
          onRefresh: () => controller.coins.checkPrices(),
          child: ListView.separated(
              itemBuilder: (BuildContext context, int coin) {
                return ListTile(
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(12))),
                  leading: (controller.selected
                          .contains(controller.table[coin]))
                      ? const CircleAvatar(
                          backgroundColor: AppColors.label,
                          foregroundColor: AppColors.background,
                          child: Icon(
                            Icons.check,
                          ),
                        )
                      : SizedBox(
                          width: 40,
                          child: Image.network(controller.table[coin].icon)),
                  title: Row(
                    children: [
                      Text(controller.table[coin].name, style: TextStyles.text),
                      if (favorites.list.any((fav) =>
                          fav.acronym == controller.table[coin].acronym))
                        const Icon(
                          Icons.star,
                          color: AppColors.label,
                          size: 14,
                        )
                    ],
                  ),
                  trailing: Text(NumberFormat.currency()
                      .format(controller.table[coin].price)),
                  selected:
                      controller.selected.contains(controller.table[coin]),
                  selectedTileColor: AppColors.secondary.withOpacity(0.7),
                  onLongPress: () {
                    setState(() {
                      (controller.selected.contains(controller.table[coin]))
                          ? controller.selected.remove(controller.table[coin])
                          : controller.selected.add(controller.table[coin]);
                    });
                  },
                  onTap: () => showDetails(controller.table[coin]),
                );
              },
              padding: const EdgeInsets.all(16),
              separatorBuilder: (_, __) => const Divider(),
              itemCount: controller.table.length),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: controller.selected.isNotEmpty
            ? FloatingActionButton.extended(
                onPressed: () {
                  favorites.saveAll(controller.selected);
                  controller.clearSelection();
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
    });
  }
}
