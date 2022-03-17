import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

import '../../models/coin.dart';

class CoinDetailsPage extends StatefulWidget {
  Coin coin;

  CoinDetailsPage({Key? key, required this.coin}) : super(key: key);

  @override
  State<CoinDetailsPage> createState() => _CoinDetailsPageState();
}

class _CoinDetailsPageState extends State<CoinDetailsPage> {
  NumberFormat real = NumberFormat.currency(locale: "pt_BR", name: "R\$");
  final _form = GlobalKey<FormState>();
  final _value = TextEditingController();
  double quantity = 0;

  buy() {
    if (_form.currentState!.validate()) {
      BotToast.showText(text: "Purchase finished with success!");
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.coin.name),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(width: 50, child: Image.asset(widget.coin.icon)),
                  SizedBox(
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
            (quantity > 0)
                ? SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: Container(
                      child: Text(
                        "$quantity ${widget.coin.acronym}",
                        style: TextStyle(fontSize: 20, color: Colors.teal),
                      ),
                      margin: EdgeInsets.only(bottom: 24),
                      padding: EdgeInsets.all(12),
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
                style: TextStyle(fontSize: 22),
                decoration: InputDecoration(
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
    );
  }
}
