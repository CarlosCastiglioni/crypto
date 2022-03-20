import 'package:crypto/models/coin.dart';

class Position {
  Coin coin;
  double quantity;

  Position({required this.coin, required this.quantity});
}
