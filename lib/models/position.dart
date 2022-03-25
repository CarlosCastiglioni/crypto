import 'package:crypto_app/models/coin.dart';

class Position {
  Coin coin;
  double quantity;

  Position({required this.coin, required this.quantity});
}
