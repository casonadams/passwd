import 'dart:io';

import 'package:ez_localization/ez_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:stacked/stacked.dart';

import '../../models/device_type.dart';
import '../../models/otp.dart';
import '../../utils/get_device_type.dart';
import '../../widgets/button.dart';
import '../../widgets/otp/otp_widget.dart';
import '../../widgets/tags/tags_widget.dart';
import '../add_otp/add_otp_screen.dart';
import '../generate_password/generate_password_screen.dart';
import 'add_account_viewmodel.dart';

class AddAccountScreen extends HookWidget {
  @override
  Widget build(BuildContext context) {
    TextEditingController nameController = useTextEditingController();
    TextEditingController usernameController = useTextEditingController();
    TextEditingController passwordController = useTextEditingController();
    TextEditingController notesController = useTextEditingController();

    FocusNode usernameFocus = useFocusNode();
    FocusNode passwordFocus = useFocusNode();
    FocusNode notesFocus = useFocusNode();

    return ViewModelBuilder<AddAccountViewModel>.reactive(
      viewModelBuilder: () => AddAccountViewModel(),
      onModelReady: (model) {
        nameController.addListener(() {
          model.name = nameController.text;
        });

        usernameController.addListener(() {
          model.username = usernameController.text;
        });

        passwordController.addListener(() {
          model.password = passwordController.text;
        });

        notesController.addListener(() {
          model.notes = notesController.text;
        });
      },
      builder: (context, model, child) => Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            context.getString("add_account"),
            style: TextStyle(
              letterSpacing: 1.25,
              fontSize: 18,
            ),
          ),
          leading: IconButton(
            onPressed: () {
              model.pop();
            },
            tooltip: context.getString("back_tooltip"),
            icon: Icon(Feather.x_circle),
          ),
          actions: [
            IconButton(
              onPressed: model.isUsernameValid && model.isPasswordValid
                  ? () {
                      model.popWithData();
                    }
                  : null,
              tooltip: context.getString("done_tooltip"),
              icon: Icon(Feather.check_circle),
            ),
          ],
        ),
        body: SafeArea(
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(
              parent: const BouncingScrollPhysics(),
            ),
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
            ),
            children: [
              TextFormField(
                controller: nameController,
                decoration: InputDecoration(
                  labelText: context.getString("name_url").toUpperCase(),
                ),
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (val) {
                  usernameFocus.requestFocus();
                },
              ),
              SizedBox(
                height: 12,
              ),
              TextFormField(
                controller: usernameController,
                decoration: InputDecoration(
                  labelText: context.getString("username_email").toUpperCase(),
                  errorText: !model.isUsernameValid
                      ? context.getString("empty_username")
                      : null,
                ),
                focusNode: usernameFocus,
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (val) {
                  passwordFocus.requestFocus();
                },
              ),
              SizedBox(
                height: 12,
              ),
              TextFormField(
                controller: passwordController,
                decoration: InputDecoration(
                  labelText: context.getString("password").toUpperCase(),
                  errorText: !model.isPasswordValid
                      ? context.getString("empty_password")
                      : null,
                ),
                focusNode: passwordFocus,
                obscureText: true,
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (val) {
                  notesFocus.requestFocus();
                },
              ),
              SizedBox(
                height: 12,
              ),
              Button(
                child: Text(
                  context.getString("generate_password"),
                ),
                onClick: () async {
                  MediaQueryData data = MediaQuery.of(context);
                  if (getDeviceType(data) == DeviceType.DESKTOP) {
                    String password = await showDialog(
                      context: context,
                      child: Center(
                        child: SizedBox(
                          height: 412,
                          width: 460,
                          child: Dialog(
                            child: GeneratePasswordScreen(),
                          ),
                        ),
                      ),
                    );

                    model.processGeneratePassword(
                      password,
                      (pass) {
                        passwordController.text = pass;
                      },
                    );
                  } else {
                    await model.generatePassword((pass) {
                      passwordController.text = pass;
                    });
                  }
                },
              ),
              TextFormField(
                controller: notesController,
                decoration: InputDecoration(
                  labelText: context.getString("notes").toUpperCase(),
                ),
                textInputAction: TextInputAction.done,
                focusNode: notesFocus,
                onFieldSubmitted: (val) {
                  notesFocus.unfocus();
                },
              ),
              SizedBox(
                height: 12,
              ),
              Builder(
                builder: (context) => Button(
                  child: Text(
                    context.getString("two_factor_authentication"),
                  ),
                  onClick: () async {
                    if (!Platform.isAndroid || !Platform.isIOS) {
                      MediaQueryData data = MediaQuery.of(context);
                      if (getDeviceType(data) == DeviceType.DESKTOP) {
                        Otp otp = await showDialog(
                          context: context,
                          child: Center(
                            child: SizedBox(
                              height: 360,
                              width: 460,
                              child: Dialog(
                                child: AddOtpScreen(),
                              ),
                            ),
                          ),
                        );

                        model.processAddOtp(otp);
                      } else {
                        model.toOtp();
                      }
                    } else {
                      showModalBottomSheet(
                        context: context,
                        builder: (context) => Container(
                          child: Wrap(
                            children: [
                              ListTile(
                                leading: Icon(Feather.camera),
                                title: Text(
                                  context.getString("scan_qr"),
                                ),
                                onTap: () async {
                                  Navigator.of(context).pop();

                                  await model.scanOtp(() {
                                    Scaffold.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          context.getString("failed_qr"),
                                        ),
                                      ),
                                    );
                                  });
                                },
                              ),
                              ListTile(
                                leading: Icon(Icons.keyboard),
                                title: Text(
                                  context.getString("enter_manually"),
                                ),
                                onTap: () {
                                  Navigator.of(context).pop();
                                  model.toOtp();
                                },
                              ),
                              ListTile(
                                leading: Icon(Feather.x),
                                title: Text(
                                  context.getString("cancel"),
                                ),
                                onTap: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    }
                  },
                ),
              ),
              if (model.otpAvailable)
                SizedBox(
                  height: 16,
                ),
              if (model.otpAvailable)
                OtpWidget(
                  otp: model.otp,
                ),
              SizedBox(
                height: 16,
              ),
              TagsWidget(
                onChange: (tags) {
                  model.tags = tags;
                },
                tags: model.tags,
                showAdd: true,
              ),
              SizedBox(
                height: 16,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
