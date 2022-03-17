import 'package:crypto/modules/coin_details/coin_details_page.dart';
import 'package:crypto/repositories/coin.repository.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../models/coin.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final table = CoinRepository.table;
  NumberFormat real = NumberFormat.currency(locale: 'pt_BR', name: 'R\$');
  List<Coin> selected = [];

  dynamicAppbar() {
    if (selected.isEmpty) {
      return AppBar(
        title: Center(child: Text("Cryptocurrencies")),
      );
    } else {
      return AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            setState(() {
              selected = [];
            });
          },
        ),
        title: Center(child: Text('${selected.length} selected')),
        backgroundColor: Colors.blueGrey[50],
        elevation: 1,
        iconTheme: IconThemeData(color: Colors.black87),
        titleTextStyle: TextStyle(
            color: Colors.black87, fontSize: 20, fontWeight: FontWeight.bold),
      );
    }
  }

  showDetails(Coin coin) {
    Navigator.push(context,
        MaterialPageRoute(builder: (_) => CoinDetailsPage(coin: coin)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: dynamicAppbar(),
      body: ListView.separated(
          itemBuilder: (BuildContext context, int coin) {
            return ListTile(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(12))),
              leading: (selected.contains(table[coin]))
                  ? CircleAvatar(
                      child: Icon(Icons.check),
                    )
                  : SizedBox(width: 40, child: Image.asset(table[coin].icon)),
              title: Text(table[coin].name,
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w500,
                  )),
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
          padding: EdgeInsets.all(16),
          separatorBuilder: (_, __) => Divider(),
          itemCount: table.length),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: selected.isNotEmpty
          ? FloatingActionButton.extended(
              onPressed: () {},
              icon: Icon(Icons.star),
              label: Text(
                "Favorite",
                style: TextStyle(letterSpacing: 0, fontWeight: FontWeight.bold),
              ))
          : null,
    );
  }
}
