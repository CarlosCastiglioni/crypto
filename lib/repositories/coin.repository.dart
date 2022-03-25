import 'package:crypto_app/models/coin.dart';
import 'package:flutter/cupertino.dart';
import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:sqflite/sqlite_api.dart';
import 'package:http/http.dart' as http;
import '../databases/db.dart';

class CoinRepository extends ChangeNotifier {
  List<Coin> _table = [];
  late Timer interval;

  List<Coin> get table => _table;

  CoinRepository() {
    _setupCoinsTable();
    _setupDataTableCoin();
    _readCoinsTable();
    // _refreshPrices();
  }

  // _refreshPrices() async {
  //   interval = Timer.periodic(Duration(minutes: 5), (_) => checkPrices());
  // }

  getCoinHistory(Coin coin) async {
    final response = await http.get(
      Uri.parse(
        'https://api.coinbase.com/v2/assets/prices/${coin.baseId}?base=BRL',
      ),
    );
    List<Map<String, dynamic>> prices = [];

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      final Map<String, dynamic> coin = json['data']['prices'];

      prices.add(coin['hour']);
      prices.add(coin['day']);
      prices.add(coin['week']);
      prices.add(coin['month']);
      prices.add(coin['year']);
      prices.add(coin['all']);
    }

    return prices;
  }

  checkPrices() async {
    String uri = 'https://api.coinbase.com/v2/assets/prices?base=BRL';
    final response = await http.get(Uri.parse(uri));

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      final List<dynamic> coins = json['data'];
      Database db = await DB.instance.database;
      Batch batch = db.batch();

      _table.forEach((current) {
        coins.forEach((fresh) {
          if (current.baseId == fresh['base_id']) {
            final coin = fresh['prices'];
            final price = coin['latest_price'];
            final timestamp = DateTime.parse(price['timestamp']);

            batch.update(
              'coins',
              {
                'price': coin['latest'],
                'timestamp': timestamp.millisecondsSinceEpoch,
                'changeTime': price['percent_change']['hour'].toString(),
                'changeDay': price['percent_change']['day'].toString(),
                'changeWeek': price['percent_change']['week'].toString(),
                'changeMonth': price['percent_change']['month'].toString(),
                'changeYear': price['percent_change']['year'].toString(),
                'changeAllPeriod': price['percent_change']['all'].toString()
              },
              where: 'baseId = ?',
              whereArgs: [current.baseId],
            );
          }
        });
      });
      await batch.commit(noResult: true);
      await _readCoinsTable();
    }
  }

  _readCoinsTable() async {
    Database db = await DB.instance.database;
    List resultados = await db.query('coins');

    _table = resultados.map((row) {
      return Coin(
        baseId: row['baseId'],
        icon: row['icon'],
        acronym: row['acronym'],
        name: row['name'],
        price: double.parse(row['price']),
        timestamp: DateTime.fromMillisecondsSinceEpoch(row['timestamp']),
        changeTime: double.parse(row['changeTime']),
        changeDay: double.parse(row['changeDay']),
        changeWeek: double.parse(row['changeWeek']),
        changeMonth: double.parse(row['changeMonth']),
        changeYear: double.parse(row['changeYear']),
        changeAllPeriod: double.parse(row['changeAllPeriod']),
      );
    }).toList();

    notifyListeners();
  }

  _coinsTableIsEmpty() async {
    Database db = await DB.instance.database;
    List resultados = await db.query('coins');
    return resultados.isEmpty;
  }

  _setupDataTableCoin() async {
    if (await _coinsTableIsEmpty()) {
      String uri = 'https://api.coinbase.com/v2/assets/search?base=BRL';

      final response = await http.get(Uri.parse(uri));

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        final List<dynamic> coins = json['data'];
        Database db = await DB.instance.database;
        Batch batch = db.batch();

        coins.forEach((coin) {
          final price = coin['latest_price'];
          final timestamp = DateTime.parse(price['timestamp']);

          batch.insert('coins', {
            'baseId': coin['id'],
            'acronym': coin['symbol'],
            'name': coin['name'],
            'icon': coin['image_url'],
            'price': coin['latest'],
            'timestamp': timestamp.millisecondsSinceEpoch,
            'changeTime': price['percent_change']['hour'].toString(),
            'changeDay': price['percent_change']['day'].toString(),
            'changeWeek': price['percent_change']['week'].toString(),
            'changeMonth': price['percent_change']['month'].toString(),
            'changeYear': price['percent_change']['year'].toString(),
            'changeAllPeriod': price['percent_change']['all'].toString()
          });
        });
        await batch.commit(noResult: true);
      }
    }
  }

  _setupCoinsTable() async {
    const String table = '''
      CREATE TABLE IF NOT EXISTS coins (
        baseId TEXT PRIMARY KEY,
        acronym TEXT,
        name TEXT,
        icon TEXT,
        price TEXT,
        timestamp INTEGER,
        changeTime TEXT,
        changeDay TEXT,
        changeWeek TEXT,
        changeMonth TEXT,
        changeYear TEXT,
        changeAllPeriod TEXT
      );
    ''';
    Database db = await DB.instance.database;
    await db.execute(table);
  }
}
