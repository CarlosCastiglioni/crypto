import 'package:crypto_app/configs/app_settings.dart';
import 'package:crypto_app/repositories/account_repository.dart';
import 'package:crypto_app/themes/app_colors.dart';
import 'package:crypto_app/themes/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';

import '../../models/position.dart';

class WalletPage extends StatefulWidget {
  const WalletPage({Key? key}) : super(key: key);

  @override
  State<WalletPage> createState() => _WalletPageState();
}

class _WalletPageState extends State<WalletPage> {
  int index = 0;
  double totalWallet = 0;
  late double balance;
  late NumberFormat real;
  late AccountRepository account;

  String graphicLabel = "";
  double graphicValue = 0;
  List<Position> wallet = [];

  @override
  Widget build(BuildContext context) {
    account = context.watch<AccountRepository>();
    final loc = context.read<AppSettings>().locale;
    real = NumberFormat.currency(locale: loc["locale"], name: loc["name"]);
    balance = account.balance;

    setTotalWallet();

    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(top: 48),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.only(top: 48, bottom: 8),
              child: Text(
                "Wallet",
                style: TextStyles.bigLabel,
              ),
            ),
            Text(
              real.format(totalWallet),
              style: TextStyles.smallLabel,
            ),
            loadGraphic(),
            loadHistory(),
          ],
        ),
      ),
    );
  }

  loadHistory() {
    final history = account.history;
    final date = DateFormat('dd/MM/yyyy - hh:mm');

    List<Widget> widgets = [];

    for (var operation in history.reversed) {
      widgets.add(ListTile(
        title: Text(operation.coin.name),
        subtitle: Text(date.format(operation.operationDate)),
        trailing: Text(
            (operation.coin.price * operation.quantity).toStringAsFixed(2)),
      ));
      widgets.add(const Divider());
    }

    return Column(
      children: widgets,
    );
  }

  setTotalWallet() {
    final walletList = account.wallet;
    setState(() {
      totalWallet = account.balance;
      for (var position in walletList) {
        totalWallet += position.coin.price * position.quantity;
      }
    });
  }

  loadGraphic() {
    return (account.balance <= 0 && account.coins.table.isEmpty)
        ? SizedBox(
            width: MediaQuery.of(context).size.width,
            height: 200,
            child: null,
          )
        : Stack(
            alignment: Alignment.center,
            children: [
              AspectRatio(
                aspectRatio: 1,
                child: PieChart(
                  PieChartData(
                    sectionsSpace: 5,
                    centerSpaceRadius: 110,
                    sections: loadWallet(),
                    pieTouchData: PieTouchData(
                      touchCallback: (_, dynamic touch) => setState(() {
                        index = touch.touchedSection!.touchedSectionIndex;
                        setGraphicData(index);
                      }),
                    ),
                  ),
                ),
              ),
              Column(
                children: [
                  Text(
                    graphicLabel,
                    style: TextStyles.bigLabel,
                  ),
                  Text(
                    real.format(graphicValue),
                    style: TextStyles.smallLabel,
                  ),
                ],
              ),
            ],
          );
  }

  List<PieChartSectionData> loadWallet() {
    setGraphicData(index);
    wallet = account.wallet;
    final listSize = wallet.length + 1;

    return List.generate(listSize, (i) {
      final isTouched = i == index;
      final isBalance = i == listSize - 1;
      final fontSize = isTouched ? 18.0 : 14.0;
      final radius = isTouched ? 60.0 : 50.0;
      final color = isTouched ? AppColors.label : AppColors.secondary;

      double percentage = 0;
      if (!isBalance) {
        percentage = wallet[i].coin.price * wallet[i].quantity / totalWallet;
      } else {
        percentage = (account.balance > 0) ? account.balance / totalWallet : 0;
      }
      percentage *= 100;

      return PieChartSectionData(
          color: color,
          value: percentage,
          title: "${percentage.toStringAsFixed(0)}%",
          radius: radius,
          titleStyle: TextStyle(
            fontSize: fontSize,
            fontWeight: FontWeight.bold,
            color: AppColors.dark,
          ));
    });
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
