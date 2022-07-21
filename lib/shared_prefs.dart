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

  // bool get showPerkImages => _sharedPrefs.getBool('showPerkImages') ?? true;

  // set showPerkImages(bool value) {
  //   _sharedPrefs.setBool('showPerkImages', value);
  // }

  bool get partyBoon => _sharedPrefs.getBool('partyBoon') ?? false;

  set partyBoon(bool value) {
    _sharedPrefs.setBool('partyBoon', value);
  }

  bool get customClasses => _sharedPrefs.getBool('customClasses') ?? false;

  set customClasses(bool value) {
    _sharedPrefs.setBool('customClasses', value);
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

  bool get resourcesExpanded =>
      _sharedPrefs.getBool('resourcesExpanded') ?? false;

  set resourcesExpanded(bool value) {
    _sharedPrefs.setBool('resourcesExpanded', value);
  }

  // int get bottomNavInitialPage =>
  //     _sharedPrefs.getInt('bottomNavInitialPage') ?? 0;

  // set bottomNavInitialPage(int value) {
  //   _sharedPrefs.setInt('bottomNavInitialPage', value);
  // }

  int get targetCardLvl => _sharedPrefs.getInt('targetCardLvl') ?? 0;

  set targetCardLvl(int value) {
    _sharedPrefs.setInt('targetCardLvl', value);
  }

  int get previousEnhancements =>
      _sharedPrefs.getInt('enhancementsOnTargetAction') ?? 0;

  set previousEnhancements(int value) {
    _sharedPrefs.setInt('enhancementsOnTargetAction', value);
  }

  int get enhancementTypeIndex => _sharedPrefs.getInt('enhancementType') ?? 0;

  set enhancementTypeIndex(int value) {
    _sharedPrefs.setInt('enhancementType', value);
  }

  bool get disableMultiTargetSwitch =>
      _sharedPrefs.getBool('disableMultiTargetsSwitch') ?? false;

  set disableMultiTargetSwitch(bool value) {
    _sharedPrefs.setBool('disableMultiTargetsSwitch', value);
  }

  bool get showRetiredCharacters =>
      _sharedPrefs.getBool('showRetiredCharacters') ?? true;

  set showRetiredCharacters(bool value) {
    _sharedPrefs.setBool('showRetiredCharacters', value);
  }

  bool get multipleTargetsSwitch =>
      _sharedPrefs.getBool('multipleTargetsSelected') ?? false;

  set multipleTargetsSwitch(bool value) {
    _sharedPrefs.setBool('multipleTargetsSelected', value);
  }

  String get backup => _sharedPrefs.getString('backup') ?? '';

  set backup(String value) {
    _sharedPrefs.setString('backup', value);
  }

  bool get gloomhavenMode => _sharedPrefs.getBool('gloomhavenMode') ?? true;

  set gloomhavenMode(bool value) {
    _sharedPrefs.setBool('gloomhavenMode', value);
  }

  bool get lostNonPersistent =>
      _sharedPrefs.getBool('lostNonPersistent') ?? false;

  set lostNonPersistent(bool value) {
    _sharedPrefs.setBool('lostNonPersistent', value);
  }

  bool get persistent => _sharedPrefs.getBool('persistent') ?? false;

  set persistent(bool value) {
    _sharedPrefs.setBool('persistent', value);
  }
}
