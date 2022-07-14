import 'package:crypto_app/models/coin.dart';
import 'package:flutter/cupertino.dart';

class CoinsController extends ChangeNotifier {
  List<Coin> selected = [];

  void clearSelection() {
    selected = [];
    notifyListeners();
  }
}
