import 'dart:io';

import 'package:bot_toast/bot_toast.dart';
import 'package:crypto_app/configs/app_settings.dart';
import 'package:crypto_app/repositories/account_repository.dart';
import 'package:crypto_app/themes/app_colors.dart';
import 'package:crypto_app/themes/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../services/auth_service.dart';
import '../documents/documents_page.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  XFile? id;

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
                style: TextStyles.titleRegular,
              ),
              trailing: IconButton(
                  onPressed: updateBalance, icon: const Icon(Icons.edit)),
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text("Scan your ID"),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const DocumentsPage(),
                    fullscreenDialog: true),
              ),
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.attach_file),
              title: const Text("Attach ID"),
              onTap: selectId,
              trailing: id != null ? Image.file(File(id!.path)) : null,
            ),
            const Divider(),
            Expanded(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 24),
                  child: OutlinedButton(
                    onPressed: () => context.read<AuthService>().logout(),
                    style: OutlinedButton.styleFrom(
                      primary: AppColors.cancel,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Text(
                            'Logout',
                            style: TextStyles.subtitleBold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  selectId() async {
    final ImagePicker picker = ImagePicker();
    try {
      XFile? file = await picker.pickImage(source: ImageSource.gallery);
      if (file != null) setState(() => id = file);
    } catch (e) {
      BotToast.showText(text: e.toString());
    }
  }

  updateBalance() async {
    final form = GlobalKey<FormState>();
    final value = TextEditingController();
    final account = context.read<AccountRepository>();

    value.text = account.balance.toString();

    AlertDialog dialog = AlertDialog(
      title: const Text("Update Balance"),
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
