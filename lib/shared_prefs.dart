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

  void removeAll() => _sharedPrefs.clear();

  bool get clearSharedPrefs => _sharedPrefs.getBool('clearOldPrefs') ?? true;

  set clearSharedPrefs(bool value) {
    _sharedPrefs.setBool('clearOldPrefs', value);
  }

  bool get showPerkImages => _sharedPrefs.getBool('showPerkImages') ?? true;

  set showPerkImages(bool value) {
    _sharedPrefs.setBool('showPerkImages', value);
  }

  bool get partyBoon => _sharedPrefs.getBool('partyBoon') ?? false;

  set partyBoon(bool value) {
    _sharedPrefs.setBool('partyBoon', value);
  }

  bool get darkTheme => _sharedPrefs.getBool('darkTheme') ?? false;

  set darkTheme(bool value) {
    _sharedPrefs.setBool('darkTheme', value);
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

  int get targetCardLvl => _sharedPrefs.getInt('targetCardLvl') ?? 0;

  set targetCardLvl(int value) {
    _sharedPrefs.setInt('targetCardLvl', value);
  }

  int get previousEnhancements =>
      _sharedPrefs.getInt('enhancementsOnTargetAction') ?? 0;

  set previousEnhancements(int value) {
    _sharedPrefs.setInt('enhancementsOnTargetAction', value);
  }

  int get enhancementType => _sharedPrefs.getInt('enhancementType') ?? 0;

  set enhancementType(int value) {
    _sharedPrefs.setInt('enhancementType', value);
  }

  bool get disableMultiTargetSwitch =>
      _sharedPrefs.getBool('disableMultiTargetsSwitch') ?? false;

  set disableMultiTargetSwitch(bool value) {
    _sharedPrefs.setBool('disableMultiTargetsSwitch', value);
  }

  bool get multipleTargetsSwitch =>
      _sharedPrefs.getBool('multipleTargetsSelected') ?? false;

  set multipleTargetsSwitch(bool value) {
    _sharedPrefs.setBool('multipleTargetsSelected', value);
  }

  int get enhancementCost => _sharedPrefs.getInt('enhancementCost') ?? 0;

  set enhancementCost(int value) {
    _sharedPrefs.setInt('enhancementCost', value);
  }
}
