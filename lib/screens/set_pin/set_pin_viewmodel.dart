import 'package:flutter/foundation.dart';
import 'package:stacked_services/stacked_services.dart';

import '../../models/biometrics_result.dart';
import '../../router/router.gr.dart';
import '../../services/authentication/authentication_service.dart';
import '../../services/biometrics/biometrics_service.dart';
import '../../services/locator.dart';

class SetPinViewModel extends ChangeNotifier {
  bool _biometrics = false;
  bool get biometrics => _biometrics;

  Future<void> setBiometrics(bool value) async {
    if (value) {
      BiometricsResult result = await locator<BiometricsService>()
          .authenticate("Initialize biometrics");

      if (result == BiometricsResult.AUTHENTICATED) {
        _biometrics = true;
      } else {
        _biometrics = false;
      }
    } else {
      _biometrics = false;
    }

    locator<AuthenticationService>().writeBiometrics(_biometrics);

    notifyListeners();
  }

  int _pin;
  int get pin => _pin;

  set pin(int pin) {
    _pin = pin;
    notifyListeners();
    nextEnabled = true;
  }

  bool _nextEnabled = false;
  bool get nextEnabled => _nextEnabled;

  set nextEnabled(bool value) {
    _nextEnabled = value;
    notifyListeners();
  }

  Future<bool> biometricsAvailable() async {
    return await locator<BiometricsService>().biometricsAvailable();
  }

  Future next() async {
    await locator<AuthenticationService>().writePin(_pin);
    locator<NavigationService>().clearStackAndShow(Routes.homeScreen);
  }
}
