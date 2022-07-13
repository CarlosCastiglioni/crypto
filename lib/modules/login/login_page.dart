import 'package:crypto_app/modules/login/login_controller.dart';
import 'package:crypto_app/themes/app_colors.dart';
import 'package:crypto_app/themes/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<LoginController>(context);
    controller.loading = false;
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 100),
          child: Consumer<LoginController>(
            builder: (BuildContext context, value, Widget? child) {
              return Form(
                key: controller.formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      controller.title,
                      style: TextStyles.title,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(24),
                      child: TextFormField(
                        controller: controller.email,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'E-mail',
                        ),
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please inform a valid e-mail!';
                          }
                          return null;
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 12.0, horizontal: 24.0),
                      child: TextFormField(
                        controller: controller.password,
                        obscureText: true,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Password',
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please inform your password!';
                          } else if (value.length < 6) {
                            return 'Password should have at least 6 digits!';
                          }
                          return null;
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: ElevatedButton(
                        onPressed: () {
                          if (controller.formKey.currentState!.validate()) {
                            if (controller.isLoged) {
                              controller.login(context);
                            } else {
                              controller.register(context);
                            }
                          }
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: (controller.loading)
                              ? [
                                  const Padding(
                                    padding: EdgeInsets.all(16),
                                    child: SizedBox(
                                      width: 24,
                                      height: 24,
                                      child: CircularProgressIndicator(
                                        color: AppColors.background,
                                      ),
                                    ),
                                  )
                                ]
                              : [
                                  Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Text(
                                      controller.actionButton,
                                      style: TextStyles.buttonPrimary,
                                    ),
                                  ),
                                ],
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () =>
                          controller.setFormAction(!controller.isLoged),
                      child: Text(controller.toggleButton),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
