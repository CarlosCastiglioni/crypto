import 'package:crypto_app/repositories/favorites_repository.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../widgets/coin_card.dart';

class FavoritesPage extends StatefulWidget {
  const FavoritesPage({Key? key}) : super(key: key);

  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text("Favorite Coins")),
      ),
      body: Container(
        color: Colors.indigo.withOpacity(0.05),
        height: MediaQuery.of(context).size.height,
        padding: const EdgeInsets.all(12.0),
        child:
            Consumer<FavoritesRepository>(builder: (context, favorites, child) {
          return favorites.list.isEmpty
              ? const ListTile(
                  leading: Icon(Icons.star),
                  title: Text("No favorite coins"),
                )
              : ListView.builder(
                  itemCount: favorites.list.length,
                  itemBuilder: (_, index) {
                    return CoinCard(coin: favorites.list[index]);
                  },
                );
        }),
      ),
    );
  }
}
