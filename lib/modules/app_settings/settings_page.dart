import 'package:crypto/configs/app_settings.dart';
import 'package:crypto/repositories/account_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../services/auth_service.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    final account = context.watch<AccountRepository>();
    final loc = context.read<AppSettings>().locale;
    NumberFormat real =
        NumberFormat.currency(locale: loc["locale"], name: loc["name"]);

    return Scaffold(
      appBar: AppBar(title: const Center(child: Text("Settings"))),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            ListTile(
              title: const Text("Balance"),
              subtitle: Text(
                real.format(account.balance),
                style: const TextStyle(fontSize: 25, color: Colors.indigo),
              ),
              trailing: IconButton(
                  onPressed: updateBalance, icon: const Icon(Icons.edit)),
            ),
            const Divider(),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 24),
              child: OutlinedButton(
                onPressed: () => context.read<AuthService>().logout(),
                style: OutlinedButton.styleFrom(
                  primary: Colors.red,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Text(
                        'Logout',
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  updateBalance() async {
    final form = GlobalKey<FormState>();
    final value = TextEditingController();
    final account = context.read<AccountRepository>();

    value.text = account.balance.toString();

    AlertDialog dialog = AlertDialog(
      title: Text("Update Balance"),
      content: Form(
        key: form,
        child: TextFormField(
          controller: value,
          keyboardType: TextInputType.number,
          inputFormatters: [
            // Regular expression for floating numbers
            FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d*')),
          ],
          validator: (value) {
            if (value!.isEmpty) return "Please inform the account balance";
            return null;
          },
        ),
      ),
      actions: [
        TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel")),
        TextButton(
            onPressed: () {
              if (form.currentState!.validate()) {
                account.setBalance(double.parse(value.text));
                Navigator.pop(context);
              }
            },
            child: const Text("Save")),
      ],
    );

    showDialog(context: context, builder: (context) => dialog);
  }
}
