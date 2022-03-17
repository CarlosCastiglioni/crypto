import 'dart:collection';
import 'package:flutter/cupertino.dart';
import '../models/coin.dart';

class FavoritesRepository extends ChangeNotifier {
  final List<Coin> _list = [];

  UnmodifiableListView<Coin> get list => UnmodifiableListView(_list);

  saveAll(List<Coin> coins) {
    coins.forEach((coin) {
      if (!_list.contains(coin)) _list.add(coin);
    });
    notifyListeners();
  }

  remove(Coin coins) {
    _list.remove(coins);
    notifyListeners();
  }
}
