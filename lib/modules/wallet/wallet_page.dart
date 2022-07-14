import 'package:crypto_app/modules/wallet/wallet.controller.dart';
import 'package:crypto_app/repositories/account_repository.dart';
import 'package:crypto_app/themes/app_colors.dart';
import 'package:crypto_app/themes/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';

class WalletPage extends StatefulWidget {
  const WalletPage({Key? key}) : super(key: key);

  @override
  State<WalletPage> createState() => _WalletPageState();
}

class _WalletPageState extends State<WalletPage> {
  int index = 0;
  late double balance;
  late NumberFormat usd;

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<WalletController>(context);

    loadHistory() {
      final history = controller.account.history;
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

    List<PieChartSectionData> loadWallet() {
      controller.setGraphicData(index);
      controller.wallet = controller.account.wallet;
      final listSize = controller.wallet.length + 1;

      return List.generate(listSize, (i) {
        final isTouched = i == index;
        final isBalance = i == listSize - 1;
        final fontSize = isTouched ? 18.0 : 14.0;
        final radius = isTouched ? 60.0 : 50.0;
        final color = isTouched ? AppColors.label : AppColors.secondary;

        double percentage = 0;
        if (!isBalance) {
          percentage = controller.wallet[i].coin.price *
              controller.wallet[i].quantity /
              controller.totalWallet;
        } else {
          percentage = (controller.account.balance > 0)
              ? controller.account.balance / controller.totalWallet
              : 0;
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

    loadGraphic() {
      return (controller.account.balance <= 0 &&
              controller.account.coins.table.isEmpty)
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
                          if (touch != null) {
                            index = touch.touchedSection!.touchedSectionIndex;
                            controller.setGraphicData(index);
                          }
                        }),
                      ),
                    ),
                  ),
                ),
                Column(
                  children: [
                    Text(
                      controller.graphicLabel,
                      style: TextStyles.bigLabel,
                    ),
                    Text(
                      usd.format(controller.graphicValue),
                      style: TextStyles.smallLabel,
                    ),
                  ],
                ),
              ],
            );
    }

    controller.account = context.watch<AccountRepository>();
    usd = NumberFormat.currency(locale: "en_US");
    balance = controller.account.balance;
    controller.setTotalWallet();

    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(top: 48),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 48, bottom: 8),
              child: Text(
                "Wallet",
                style: TextStyles.bigLabel,
              ),
            ),
            Text(
              usd.format(controller.totalWallet),
              style: TextStyles.smallLabel,
            ),
            loadGraphic(),
            loadHistory(),
          ],
        ),
      ),
    );
  }
}
