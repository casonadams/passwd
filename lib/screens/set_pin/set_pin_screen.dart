import 'package:ez_localization/ez_localization.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:supercharged/supercharged.dart';

import '../../widgets/pin_input.dart';
import 'set_pin_viewmodel.dart';

class SetPinScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<SetPinViewModel>.reactive(
      viewModelBuilder: () => SetPinViewModel(),
      builder: (context, model, child) => Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              context.getString("set_pin"),
              style: Theme.of(context).textTheme.headline5.copyWith(
                    fontWeight: FontWeight.w900,
                  ),
            ),
            SizedBox(
              height: 32,
            ),
            PinInputWidget(
              onSubmit: (String value) {
                model.pin = value.toInt();
              },
            ),
            FutureBuilder<bool>(
              future: model.biometricsAvailable(),
              builder: (context, snapshot) {
                if (snapshot.hasData && snapshot.data) {
                  return Column(
                    children: [
                      SizedBox(
                        height: 6,
                      ),
                      Container(
                        width: 284,
                        child: ListTile(
                          leading: Icon(
                            Icons.fingerprint_outlined,
                          ),
                          contentPadding: const EdgeInsets.all(0),
                          title: Text(
                            context.getString("enable_biometrics"),
                          ),
                          trailing: Switch(
                            value: model.biometrics,
                            onChanged: (bool value) {
                              model.setBiometrics(value);
                            },
                          ),
                        ),
                      ),
                    ],
                  );
                }

                return Container();
              },
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: model.nextEnabled
              ? () {
                  model.next();
                }
              : null,
          label: Text(
            context.getString("next"),
          ),
          icon: Icon(Icons.chevron_right),
          disabledElevation: 0.0,
          elevation: 52.0,
        ),
      ),
    );
  }
}
