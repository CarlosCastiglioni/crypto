import 'package:crypto/models/history.dart';
import 'package:crypto/models/position.dart';
import 'package:crypto/repositories/coin.repository.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

import '../databases/db.dart';
import '../models/coin.dart';

class AccountRepository extends ChangeNotifier {
  late Database db;
  List<Position> _wallet = [];
  List<History> _history = [];
  double _balance = 0;

  get balance => _balance;
  List<Position> get wallet => _wallet;
  List<History> get history => _history;

  AccountRepository() {
    _initRepository();
  }

  _initRepository() async {
    await _getBalance();
    await _getWallet();
    await _getHistory();
  }

  _getHistory() async {
    _history = [];
    List operations = await db.query("history");
    operations.forEach((operation) {
      Coin coin = CoinRepository.table.firstWhere(
        (c) => c.acronym == operation["acronym"],
      );
      _history.add(History(
        operationDate:
            DateTime.fromMillisecondsSinceEpoch(operation["operation_date"]),
        operationType: operation["operation_type"],
        coin: coin,
        value: operation["value"],
        quantity: double.parse(operation["quantity"]),
      ));
    });
    notifyListeners();
  }

  _getBalance() async {
    db = await DB.instance.database;
    List account = await db.query("account", limit: 1);
    _balance = account.first["balance"];
    notifyListeners();
  }

  setBalance(double value) async {
    db = await DB.instance.database;
    db.update("account", {
      "balance": value,
    });
    _balance = value;
    notifyListeners();
  }

  _getWallet() async {
    _wallet = [];
    List positions = await db.query('wallet');
    positions.forEach((position) {
      Coin coin = CoinRepository.table.firstWhere(
        (c) => c.acronym == position['acronym'],
      );
      _wallet.add(Position(
        coin: coin,
        quantity: double.parse(position['quantity']),
      ));
    });
    notifyListeners();
  }

  buy(Coin coin, double value) async {
    db = await DB.instance.database;

    await db.transaction((txn) async {
      // Verify if coin was already bought
      final coinPosition = await txn.query(
        "wallet",
        where: "acronym = ?",
        whereArgs: [coin.acronym],
      );
      if (coinPosition.isEmpty) {
        await txn.insert("wallet", {
          "acronym": coin.acronym,
          "coin": coin.name,
          "quantity": (value / coin.price).toString()
        });
      } else {
        final current = double.parse(coinPosition.first["quantity"].toString());
        await txn.update(
          "wallet",
          {"quantity": ((value / coin.price) + current).toString()},
          where: "acronym = ?",
          whereArgs: [coin.acronym],
        );
      }
      // Insert purchase to history
      await txn.insert("history", {
        "acronym": coin.acronym,
        "coin": coin.name,
        "quantity": (value / coin.price).toString(),
        "value": value,
        "operation_type": "buy",
        "operation_date": DateTime.now().microsecondsSinceEpoch
      });

      // Update balance
      await txn.update("account", {"balance": balance - value});
    });
    await _initRepository();
    notifyListeners();
  }
}
