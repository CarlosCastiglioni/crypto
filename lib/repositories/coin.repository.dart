import 'package:crypto/models/coin.dart';

class CoinRepository {
  static List<Coin> table = [
    Coin(
        icon: "images/bitcoin.png",
        name: "Bitcoin",
        acronym: "BTC",
        price: 164603.00),
    Coin(icon: "images/cardano.png", name: "ADA", acronym: "BTC", price: 6.34),
    Coin(
        icon: "images/ethereum.png",
        name: "Ethereum",
        acronym: "ETH",
        price: 9716.00),
    Coin(icon: "images/xrp.png", name: "XRP", acronym: "XRP", price: 164603.00),
  ];
}
