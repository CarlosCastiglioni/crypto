import 'package:crypto_app/models/position.dart';
import 'package:crypto_app/repositories/account_repository.dart';
import 'package:flutter/cupertino.dart';

class WalletController extends ChangeNotifier {
  double totalWallet = 0;
  late AccountRepository account;
  String graphicLabel = "";
  double graphicValue = 0;
  List<Position> wallet = [];

  setTotalWallet() {
    final walletList = account.wallet;

    totalWallet = account.balance;
    for (var position in walletList) {
      totalWallet += position.coin.price * position.quantity;
    }
  }

  setGraphicData(int index) {
    if (index < 0) return;

    if (index == wallet.length) {
      graphicLabel = "Balance";
      graphicValue = account.balance;
    } else {
      graphicLabel = wallet[index].coin.name;
      graphicValue = wallet[index].coin.price * wallet[index].quantity;
    }
  }
}
