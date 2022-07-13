import 'dart:collection';
import 'package:bot_toast/bot_toast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto_app/repositories/coin.repository.dart';
import 'package:crypto_app/services/auth_service.dart';
import 'package:flutter/cupertino.dart';
import '../databases/db_firestore.dart';
import '../models/coin.dart';

class FavoritesRepository extends ChangeNotifier {
  final List<Coin> _list = [];
  late FirebaseFirestore db;
  late AuthService auth;
  CoinRepository coins;

  FavoritesRepository({required this.auth, required this.coins}) {
    _startFavorites();
  }

  _startFavorites() async {
    await _startFirestore();
    await _readFavorite();
  }

  _startFirestore() {
    db = DBFirestore.get();
  }

  _readFavorite() async {
    if (auth.user != null && _list.isEmpty) {
      try {
        final snapShot =
            await db.collection("users/${auth.user!.uid}/favorites").get();

        for (var doc in snapShot.docs) {
          Coin coin = coins.table
              .firstWhere((coin) => coin.acronym == doc.get("acronym"));
          _list.add(coin);
          notifyListeners();
        }
      } catch (e) {
        BotToast.showText(text: "No user Id");
      }
    }
  }

  UnmodifiableListView<Coin> get list => UnmodifiableListView(_list);

  saveAll(List<Coin> coins) {
    coins.forEach((coin) async {
      if (!_list.any((current) => current.acronym == coin.acronym)) {
        _list.add(coin);
        await db
            .collection("users/${auth.user!.uid}/favorites")
            .doc(coin.acronym)
            .set({
          "coin": coin.name,
          "acronym": coin.acronym,
          "price": coin.price
        });
      }
    });
    notifyListeners();
  }

  remove(Coin coin) async {
    await db
        .collection("users/${auth.user!.uid}/favorites")
        .doc(coin.acronym)
        .delete();
    _list.remove(coin);
    notifyListeners();
  }
}
