import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefs {
  static SharedPreferences _sharedPrefs;

  factory SharedPrefs() => SharedPrefs._internal();

  SharedPrefs._internal();

  Future<void> init() async {
    _sharedPrefs ??= await SharedPreferences.getInstance();
  }

  void remove(String key) {
    _sharedPrefs.remove(key);
  }

  String get themeColor => _sharedPrefs.getString('themeColor') ?? '0xff4e7ec1';

  set themeColor(String value) {
    _sharedPrefs.setString('themeColor', value);
  }

  bool get envelopeX => _sharedPrefs.getBool('envelopeX') ?? false;

  set envelopeX(bool value) {
    _sharedPrefs.setBool('envelopeX', value);
  }

  int get initialPage => _sharedPrefs.getInt('initialPage') ?? 0;

  set initialPage(int value) {
    _sharedPrefs.setInt('initialPage', value);
  }

  int get targetCardLvl => _sharedPrefs.getInt('targetCardLvlKey') ?? 0;

  set targetCardLvl(int value) {
    _sharedPrefs.setInt('targetCardLvlKey', value);
  }

  int get previousEnhancements =>
      _sharedPrefs.getInt('enhancementsOnTargetActionKey') ?? 0;

  set previousEnhancements(int value) {
    _sharedPrefs.setInt('enhancementsOnTargetActionKey', value);
  }

  int get enhancementType => _sharedPrefs.getInt('enhancementTypeKey') ?? 0;

  set enhancementType(int value) {
    _sharedPrefs.setInt('enhancementTypeKey', value);
  }

  bool get disableMultiTargetSwitch =>
      _sharedPrefs.getBool('disableMultiTargetsSwitchKey') ?? false;

  set disableMultiTargetSwitch(bool value) {
    _sharedPrefs.setBool('disableMultiTargetsSwitchKey', value);
  }

  bool get multipleTargetsSwitch =>
      _sharedPrefs.getBool('multipleTargetsSelectedKey') ?? false;

  set multipleTargetsSwitch(bool value) {
    _sharedPrefs.setBool('multipleTargetsSelectedKey', value);
  }

  int get enhancementCost => _sharedPrefs.getInt('enhancementCost') ?? 0;

  set enhancementCost(int value) {
    _sharedPrefs.setInt('enhancementCost', value);
  }
}
