import 'package:crypto_app/models/coin.dart';
import 'package:crypto_app/repositories/coin.repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';

class CoinsController extends ChangeNotifier {
  late List<Coin> table;
  late Map<String, String> loc;
  List<Coin> selected = [];
  late CoinRepository coins;

  void clearSelection() {
    selected = [];
    notifyListeners();
  }

  checkTableCoins() async {
    if (table.isEmpty) {
      await coins.checkPrices();
    } else {
      return;
    }
    notifyListeners();
  }
}
