import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../models/coin.dart';
import '../../repositories/account_repository.dart';
import '../../widgets/graphic_history.dart';

class CoinDetailsPage extends StatefulWidget {
  final Coin coin;

  const CoinDetailsPage({Key? key, required this.coin}) : super(key: key);

  @override
  State<CoinDetailsPage> createState() => _CoinDetailsPageState();
}

class _CoinDetailsPageState extends State<CoinDetailsPage> {
  NumberFormat real = NumberFormat.currency(locale: "pt_BR", name: "R\$");
  final _form = GlobalKey<FormState>();
  final _value = TextEditingController();
  double quantity = 0;
  late AccountRepository account;
  Widget graphic = Container();
  bool graphicLoaded = false;

  getGraphic() {
    if (!graphicLoaded) {
      graphic = GraphicHistory(coin: widget.coin);
      graphicLoaded = true;
    }
    return graphic;
  }

  buy() async {
    if (_form.currentState!.validate()) {
      await account.buy(widget.coin, double.parse(_value.text));

      BotToast.showText(text: "Purchase finished with success!");
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    account = Provider.of<AccountRepository>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.coin.name),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                        child: Image.network(
                      widget.coin.icon,
                      scale: 2.5,
                    )),
                    const SizedBox(
                      width: 10,
                    ),
                    Text(
                      real.format(widget.coin.price),
                      style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.w600,
                          letterSpacing: -1,
                          color: Colors.grey[800]),
                    )
                  ],
                ),
              ),
              getGraphic(),
              (quantity > 0)
                  ? SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: Container(
                        child: Text(
                          "$quantity ${widget.coin.acronym}",
                          style:
                              const TextStyle(fontSize: 20, color: Colors.teal),
                        ),
                        margin: const EdgeInsets.only(bottom: 24),
                        padding: const EdgeInsets.all(12),
                        alignment: Alignment.center,
                        decoration:
                            BoxDecoration(color: Colors.teal.withOpacity(0.05)),
                      ),
                    )
                  : const SizedBox(
                      height: 24,
                    ),
              Form(
                key: _form,
                child: TextFormField(
                  controller: _value,
                  style: const TextStyle(fontSize: 22),
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "Value",
                      prefixIcon: Icon(Icons.monetization_on_outlined),
                      suffix: Text(
                        "Reais",
                        style: TextStyle(fontSize: 14),
                      )),
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Please inform a value";
                    } else if (double.parse(value) < 50) {
                      return "Minimum of 50 reais";
                    } else if (double.parse(value) > account.balance) {
                      return "Not enough balance";
                    }
                    return null;
                  },
                  onChanged: (value) {
                    setState(() {
                      quantity = (value.isEmpty)
                          ? 0
                          : double.parse(value) / widget.coin.price;
                    });
                  },
                ),
              ),
              Container(
                alignment: Alignment.bottomCenter,
                margin: EdgeInsets.only(
                  top: 24,
                ),
                child: ElevatedButton(
                    onPressed: () {
                      buy();
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.check),
                        Padding(
                          padding: EdgeInsets.all(16),
                          child: Text(
                            "Buy",
                            style: TextStyle(fontSize: 20),
                          ),
                        )
                      ],
                    )),
              )
            ],
          ),
        ),
      ),
    );
  }
}
