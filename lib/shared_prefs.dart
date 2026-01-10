import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefs {
  static late SharedPreferences _sharedPrefs;

  factory SharedPrefs() => SharedPrefs._internal();

  SharedPrefs._internal();

  Future<void> init() async =>
      _sharedPrefs = await SharedPreferences.getInstance();

  void remove(String key) => _sharedPrefs.remove(key);

  void removeAll() => _sharedPrefs.clear();

  bool get clearSharedPrefs => _sharedPrefs.getBool('clearOldPrefs') ?? true;

  set clearSharedPrefs(bool value) =>
      _sharedPrefs.setBool('clearOldPrefs', value);

  bool get partyBoon => _sharedPrefs.getBool('partyBoon') ?? false;

  set partyBoon(bool value) => _sharedPrefs.setBool('partyBoon', value);

  bool get enhancerLvl1 => _sharedPrefs.getBool('enhancerLvl1') ?? enhancerLvl2;

  set enhancerLvl1(bool value) {
    if (!value) {
      enhancerLvl2 = false;
      enhancerLvl3 = false;
      enhancerLvl4 = false;
    }
    _sharedPrefs.setBool('enhancerLvl1', value);
  }

  bool get enhancerLvl2 => _sharedPrefs.getBool('enhancerLvl2') ?? enhancerLvl3;

  set enhancerLvl2(bool value) {
    if (value) {
      enhancerLvl1 = true;
    } else {
      enhancerLvl3 = false;
      enhancerLvl4 = false;
    }
    _sharedPrefs.setBool('enhancerLvl2', value);
  }

  bool get enhancerLvl3 => _sharedPrefs.getBool('enhancerLvl3') ?? enhancerLvl4;

  set enhancerLvl3(bool value) {
    if (value) {
      enhancerLvl2 = true;
      enhancerLvl1 = true;
    } else {
      enhancerLvl4 = false;
    }
    _sharedPrefs.setBool('enhancerLvl3', value);
  }

  bool get enhancerLvl4 => _sharedPrefs.getBool('enhancerLvl4') ?? false;

  set enhancerLvl4(bool value) {
    if (value) {
      enhancerLvl3 = true;
      enhancerLvl2 = true;
      enhancerLvl1 = true;
    }
    _sharedPrefs.setBool('enhancerLvl4', value);
  }

  bool get customClasses => _sharedPrefs.getBool('customClasses') ?? false;

  set customClasses(bool value) => _sharedPrefs.setBool('customClasses', value);

  bool get darkTheme => _sharedPrefs.getBool('darkTheme') ?? false;

  set darkTheme(bool value) => _sharedPrefs.setBool('darkTheme', value);

  int get primaryClassColor =>
      _sharedPrefs.getInt('primaryClassColor') ?? 0xff4e7ec1;

  set primaryClassColor(int value) =>
      _sharedPrefs.setInt('primaryClassColor', value);

  bool get envelopeX => _sharedPrefs.getBool('envelopeX') ?? false;

  set envelopeX(bool value) => _sharedPrefs.setBool('envelopeX', value);

  bool get envelopeV => _sharedPrefs.getBool('envelopeV') ?? false;

  set envelopeV(bool value) => _sharedPrefs.setBool('envelopeV', value);

  int get initialPage => _sharedPrefs.getInt('initialPage') ?? 0;

  set initialPage(int value) => _sharedPrefs.setInt('initialPage', value);

  bool get resourcesExpanded =>
      _sharedPrefs.getBool('resourcesExpanded') ?? false;

  set resourcesExpanded(bool value) =>
      _sharedPrefs.setBool('resourcesExpanded', value);

  int get targetCardLvl => _sharedPrefs.getInt('targetCardLvl') ?? 0;

  set targetCardLvl(int value) => _sharedPrefs.setInt('targetCardLvl', value);

  int get previousEnhancements =>
      _sharedPrefs.getInt('enhancementsOnTargetAction') ?? 0;

  set previousEnhancements(int value) =>
      _sharedPrefs.setInt('enhancementsOnTargetAction', value);

  int get enhancementTypeIndex => _sharedPrefs.getInt('enhancementType') ?? 0;

  set enhancementTypeIndex(int value) =>
      _sharedPrefs.setInt('enhancementType', value);

  bool get disableMultiTargetSwitch =>
      _sharedPrefs.getBool('disableMultiTargetsSwitch') ?? false;

  set disableMultiTargetSwitch(bool value) =>
      _sharedPrefs.setBool('disableMultiTargetsSwitch', value);

  bool get temporaryEnhancementMode =>
      _sharedPrefs.getBool('temporaryEnhancementMode') ?? false;

  set temporaryEnhancementMode(bool value) =>
      _sharedPrefs.setBool('temporaryEnhancementMode', value);

  bool get showRetiredCharacters =>
      _sharedPrefs.getBool('showRetiredCharacters') ?? true;

  set showRetiredCharacters(bool value) =>
      _sharedPrefs.setBool('showRetiredCharacters', value);

  bool get multipleTargetsSwitch =>
      _sharedPrefs.getBool('multipleTargetsSelected') ?? false;

  set multipleTargetsSwitch(bool value) =>
      _sharedPrefs.setBool('multipleTargetsSelected', value);

  String get backup => _sharedPrefs.getString('backup') ?? '';

  set backup(String value) => _sharedPrefs.setString('backup', value);

  bool get gloomhavenMode => _sharedPrefs.getBool('gloomhavenMode') ?? true;

  set gloomhavenMode(bool value) =>
      _sharedPrefs.setBool('gloomhavenMode', value);

  bool get lostNonPersistent =>
      _sharedPrefs.getBool('lostNonPersistent') ?? false;

  set lostNonPersistent(bool value) =>
      _sharedPrefs.setBool('lostNonPersistent', value);

  bool get persistent => _sharedPrefs.getBool('persistent') ?? false;

  set persistent(bool value) => _sharedPrefs.setBool('persistent', value);

  bool get hideCustomClassesWarningMessage =>
      _sharedPrefs.getBool('hideCustomClassesWarningMessage') ?? false;

  set hideCustomClassesWarningMessage(bool value) =>
      _sharedPrefs.setBool('hideCustomClassesWarningMessage', value);

  bool get showUpdate4Dialog =>
      _sharedPrefs.getBool('showUpdate4Dialog') ?? true;

  set showUpdate4Dialog(bool value) =>
      _sharedPrefs.setBool('showUpdate4Dialog', value);

  bool get showUpdate420Dialog =>
      _sharedPrefs.getBool('showUpdate420Dialog') ?? true;

  set showUpdate420Dialog(bool value) =>
      _sharedPrefs.setBool('showUpdate420Dialog', value);

  bool getPlayerClassIsUnlocked(String classCode) =>
      _sharedPrefs.getBool(classCode) ?? false;

  setPlayerClassIsUnlocked(String classCode, bool value) {
    _sharedPrefs.setBool(classCode, value);
  }

  bool get useDefaultFonts => _sharedPrefs.getBool('useDefaultFonts') ?? false;

  set useDefaultFonts(bool value) =>
      _sharedPrefs.setBool('useDefaultFonts', value);

  bool get hailsDiscount => _sharedPrefs.getBool('hailsDiscount') ?? false;

  set hailsDiscount(bool value) => _sharedPrefs.setBool('hailsDiscount', value);
}
