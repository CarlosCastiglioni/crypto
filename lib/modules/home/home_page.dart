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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Center(child: Text("Cryptocurrencies")),
        ),
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
                    print(table[coin].name);
                  });
                },
              );
            },
            padding: EdgeInsets.all(16),
            separatorBuilder: (_, __) => Divider(),
            itemCount: table.length));
  }
}
