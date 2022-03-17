import 'package:crypto/modules/coin_details/coin_details_page.dart';
import 'package:crypto/repositories/coin.repository.dart';
import 'package:crypto/repositories/favorites_repository.dart';
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
  final table = CoinRepository.table;
  NumberFormat real = NumberFormat.currency(locale: 'pt_BR', name: 'R\$');
  List<Coin> selected = [];
  late FavoritesRepository favorites;

  dynamicAppbar() {
    if (selected.isEmpty) {
      return AppBar(
        title: const Center(child: Text("Cryptocurrencies")),
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
        title: Center(child: Text('${selected.length} selected')),
        backgroundColor: Colors.blueGrey[50],
        elevation: 1,
        iconTheme: const IconThemeData(color: Colors.black87),
        titleTextStyle: const TextStyle(
            color: Colors.black87, fontSize: 20, fontWeight: FontWeight.bold),
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
    favorites = Provider.of<FavoritesRepository>(context);

    return Scaffold(
      appBar: dynamicAppbar(),
      body: ListView.separated(
          itemBuilder: (BuildContext context, int coin) {
            return ListTile(
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(12))),
              leading: (selected.contains(table[coin]))
                  ? const CircleAvatar(
                      child: Icon(Icons.check),
                    )
                  : SizedBox(width: 40, child: Image.asset(table[coin].icon)),
              title: Row(
                children: [
                  Text(table[coin].name,
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w500,
                      )),
                  if (favorites.list.contains(table[coin]))
                    const Icon(
                      Icons.star,
                      color: Colors.amber,
                      size: 14,
                    )
                ],
              ),
              trailing: Text(real.format(table[coin].price)),
              selected: selected.contains(table[coin]),
              selectedTileColor: Colors.indigo[50],
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
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: selected.isNotEmpty
          ? FloatingActionButton.extended(
              onPressed: () {
                favorites.saveAll(selected);
                clearSelection();
              },
              icon: const Icon(Icons.star),
              label: const Text(
                "Favorite",
                style: TextStyle(letterSpacing: 0, fontWeight: FontWeight.bold),
              ))
          : null,
    );
  }
}
