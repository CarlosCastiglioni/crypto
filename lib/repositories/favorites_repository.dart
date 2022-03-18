import 'dart:collection';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../configs/shared_pref.dart';
import '../models/coin.dart';

class FavoritesRepository extends ChangeNotifier {
  final List<Coin> _list = [];
  SharedPref sharedPref = SharedPref();

  FavoritesRepository() {
    _startFavorites();
  }

  _startFavorites() async {
    await _readFavorite();
  }

  _readFavorite() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.getKeys().forEach((coins) async {
      Coin coin = Coin.fromJson(await sharedPref.read(coins));
      _list.add(coin);
    });
    notifyListeners();
  }

  UnmodifiableListView<Coin> get list => UnmodifiableListView(_list);

  saveAll(List<Coin> coins) {
    coins.forEach((coins) {
      if (!_list.any((current) => current.acronym == coins.acronym)) {
        _list.add(coins);
        sharedPref.save(coins.acronym, coins);
      }
    });
    notifyListeners();
  }

  remove(Coin coins) {
    _list.remove(coins);
    sharedPref.remove(coins.acronym);
    notifyListeners();
  }
}
