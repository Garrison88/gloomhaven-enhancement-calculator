import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:gloomhaven_enhancement_calc/data/constants.dart';
import 'package:gloomhaven_enhancement_calc/data/database_helpers.dart';
import 'package:gloomhaven_enhancement_calc/shared_prefs.dart';
import 'package:gloomhaven_enhancement_calc/viewmodels/app_model.dart';
import 'package:gloomhaven_enhancement_calc/viewmodels/characters_model.dart';
import 'package:gloomhaven_enhancement_calc/viewmodels/enhancement_calculator_model.dart';

class SettingsScreen extends StatefulWidget {
  final AppModel appModel;
  final CharactersModel charactersModel;

  final EnhancementCalculatorModel enhancementCalculatorModel;

  const SettingsScreen({
    Key key,
    this.appModel,
    this.charactersModel,
    this.enhancementCalculatorModel,
  }) : super(key: key);

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  String downloadPath;

  Future<PackageInfo> _packageInfoFuture;

  @override
  void initState() {
    super.initState();

    _packageInfoFuture = PackageInfo.fromPlatform();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: Icon(
            Platform.isIOS ? Icons.arrow_back_ios_new : Icons.arrow_back,
          ),
        ),
        title: const Text(
          'Settings',
          style: TextStyle(
            fontSize: 25.0,
          ),
        ),
      ),
      body: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: maxWidth),
          child: ListView(
            children: <Widget>[
              Theme(
                data: Theme.of(context).copyWith(
                    colorScheme: Theme.of(context)
                        .colorScheme
                        .copyWith(outline: Colors.transparent)),
                child: SwitchListTile(
                  title: const Text('Theme'),
                  subtitle: Theme.of(context).brightness == Brightness.dark
                      ? const Text('Dark')
                      : const Text('Light'),
                  activeThumbImage: const AssetImage('images/elem_dark.png'),
                  activeColor: const Color(0xff1f272e),
                  inactiveThumbColor: const Color(0xffeda50b),
                  inactiveTrackColor: const Color(0xffeda50b).withOpacity(0.75),
                  activeTrackColor: const Color(0xff1f272e),
                  inactiveThumbImage: const AssetImage('images/elem_light.png'),
                  value: widget.appModel.themeMode == ThemeMode.dark,
                  onChanged: (val) {
                    SharedPrefs().darkTheme = val;
                    widget.appModel.updateTheme(
                      themeMode: val ? ThemeMode.dark : ThemeMode.light,
                    );
                    widget.charactersModel.updateTheme();
                  },
                ),
              ),
              const SettingsDivider(),
              SwitchListTile(
                title: const Text("Solve 'Envelope X'"),
                subtitle: Row(
                  children: const [
                    Icon(Icons.warning),
                    SizedBox(
                      width: smallPadding,
                    ),
                    Expanded(
                      child: Text('Gloomhaven spoilers'),
                    ),
                  ],
                ),
                value: SharedPrefs().envelopeX,
                onChanged: (val) {
                  if (!val) {
                    setState(() {
                      SharedPrefs().envelopeX = false;
                    });
                  } else {
                    showDialog<bool>(
                        context: context,
                        builder: (_) {
                          bool envelopeXSolved = false;
                          return StatefulBuilder(
                            builder: (
                              BuildContext context,
                              StateSetter setState,
                            ) {
                              return AlertDialog(
                                content: Container(
                                  constraints: const BoxConstraints(
                                    maxWidth: maxDialogWidth,
                                  ),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Text(
                                          'Enter the solution to the puzzle'),
                                      TextField(
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleMedium,
                                        autofocus: true,
                                        onChanged: (String val) {
                                          setState(() {
                                            envelopeXSolved =
                                                val.toLowerCase().trim() ==
                                                    'bladeswarm';
                                          });
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                                actions: <Widget>[
                                  TextButton(
                                    child: Text(
                                      'Cancel',
                                      style: TextStyle(
                                        color: Theme.of(context).brightness ==
                                                Brightness.dark
                                            ? Colors.grey[300]
                                            : Colors.black87,
                                      ),
                                    ),
                                    onPressed: () {
                                      Navigator.of(context).pop(false);
                                    },
                                  ),
                                  TextButton(
                                    child: Text(
                                      'Solve',
                                      style: TextStyle(
                                        color: envelopeXSolved
                                            ? Theme.of(context)
                                                .colorScheme
                                                .primary
                                            : Theme.of(context).disabledColor,
                                      ),
                                    ),
                                    onPressed: envelopeXSolved
                                        ? () {
                                            Navigator.of(context).pop(true);
                                          }
                                        : null,
                                  ),
                                ],
                              );
                            },
                          );
                        }).then(
                      (value) {
                        if (value) {
                          setState(
                            () {
                              SharedPrefs().envelopeX = val;
                            },
                          );
                          ScaffoldMessenger.of(context)
                            ..clearSnackBars()
                            ..showSnackBar(
                              SnackBar(
                                content: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    SvgPicture.asset(
                                      'images/class_icons/bladeswarm.svg',
                                      width: iconSize,
                                      height: iconSize,
                                      colorFilter: ColorFilter.mode(
                                        Theme.of(context)
                                            .colorScheme
                                            .onBackground,
                                        BlendMode.srcIn,
                                      ),
                                    ),
                                    const SizedBox(
                                      width: smallPadding,
                                    ),
                                    const Text('Bladeswarm unlocked'),
                                  ],
                                ),
                              ),
                            );
                        }
                      },
                    );
                  }
                },
              ),
              const SettingsDivider(),
              SwitchListTile(
                title: const Text('Scenario 114 Reward'),
                subtitle: Row(
                  children: const [
                    Icon(Icons.warning),
                    SizedBox(
                      width: smallPadding,
                    ),
                    Expanded(
                      child: Text(
                        'Forgotten Circles spoilers',
                        overflow: TextOverflow.fade,
                      ),
                    ),
                  ],
                ),
                value: SharedPrefs().partyBoon,
                onChanged: (val) {
                  setState(
                    () {
                      SharedPrefs().partyBoon = val;
                      widget.enhancementCalculatorModel.calculateCost();
                    },
                  );
                },
              ),
              const SettingsDivider(),
              Stack(
                alignment: Alignment.center,
                children: [
                  ListTile(
                    title: const Text('Building 44'),
                    subtitle: Row(
                      children: const [
                        Icon(Icons.warning),
                        SizedBox(
                          width: smallPadding,
                        ),
                        Expanded(
                          child: Text(
                            'Frosthaven spoilers',
                            overflow: TextOverflow.fade,
                          ),
                        ),
                      ],
                    ),
                    onTap: () async {
                      await showDialog<bool>(
                        barrierDismissible: false,
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: const Center(
                              child: Text('Enhancer'),
                            ),
                            content: StatefulBuilder(
                              builder: (
                                thisLowerContext,
                                innerSetState,
                              ) {
                                return Container(
                                  constraints: const BoxConstraints(
                                    maxWidth: maxDialogWidth,
                                  ),
                                  child: SingleChildScrollView(
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        CheckboxListTile(
                                          enabled: false,
                                          title: Text('Lvl 1',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .titleMedium
                                                  .copyWith(color: null)),
                                          value: true,
                                          onChanged: (_) => {},
                                        ),
                                        Text(
                                          'Buy enhancements',
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleMedium
                                              .copyWith(
                                                color:
                                                    SharedPrefs().enhancerLvl1
                                                        ? null
                                                        : Colors.grey,
                                                fontSize: 20,
                                              ),
                                        ),
                                        CheckboxListTile(
                                          title: const Text('Lvl 2'),
                                          value: SharedPrefs().enhancerLvl2,
                                          onChanged: (val) {
                                            innerSetState(
                                              () {
                                                SharedPrefs().enhancerLvl2 =
                                                    val;
                                                widget
                                                    .enhancementCalculatorModel
                                                    .calculateCost();
                                              },
                                            );
                                          },
                                        ),
                                        Text(
                                          'and reduce all enhancement costs by 10 gold',
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleMedium
                                              .copyWith(
                                                color:
                                                    SharedPrefs().enhancerLvl2
                                                        ? null
                                                        : Colors.grey,
                                                fontSize: 20,
                                              ),
                                        ),
                                        CheckboxListTile(
                                          title: const Text('Lvl 3'),
                                          value: SharedPrefs().enhancerLvl3,
                                          onChanged: (val) {
                                            innerSetState(
                                              () {
                                                SharedPrefs().enhancerLvl3 =
                                                    val;
                                                widget
                                                    .enhancementCalculatorModel
                                                    .calculateCost();
                                              },
                                            );
                                          },
                                        ),
                                        Text(
                                          'and reduce level penalties by 10 gold per level',
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleMedium
                                              .copyWith(
                                                color:
                                                    SharedPrefs().enhancerLvl3
                                                        ? null
                                                        : Colors.grey,
                                                fontSize: 20,
                                              ),
                                        ),
                                        CheckboxListTile(
                                          title: const Text('Lvl 4'),
                                          value: SharedPrefs().enhancerLvl4,
                                          onChanged: (val) {
                                            innerSetState(
                                              () {
                                                SharedPrefs().enhancerLvl4 =
                                                    val;
                                                widget
                                                    .enhancementCalculatorModel
                                                    .calculateCost();
                                              },
                                            );
                                          },
                                        ),
                                        Text(
                                          'and reduce repeat penalties by 25 gold per enhancement',
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleMedium
                                              .copyWith(
                                                color:
                                                    SharedPrefs().enhancerLvl4
                                                        ? null
                                                        : Colors.grey,
                                                fontSize: 20,
                                              ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                            actions: <Widget>[
                              TextButton(
                                child: Text(
                                  'Close',
                                  style: TextStyle(
                                    color: Theme.of(context).brightness ==
                                            Brightness.dark
                                        ? Colors.grey[300]
                                        : Colors.black87,
                                  ),
                                ),
                                onPressed: () {
                                  Navigator.of(context).pop(false);
                                },
                              ),
                            ],
                          );
                        },
                      );
                    },
                  ),
                  Positioned(
                    right: 32.5,
                    child: IgnorePointer(
                      ignoring: true,
                      child: Icon(
                        Icons.open_in_new,
                        size: 30,
                        color: Theme.of(context)
                            .colorScheme
                            .onSurface
                            .withOpacity(.75),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 32.5,
                  ),
                ],
              ),
              const SettingsDivider(),
              SwitchListTile(
                subtitle: const Text(
                    "Include Crimson Scales, Trail of Ashes, and 'released' custom classes created by the community"),
                title: const Text('Custom Content'),
                value: SharedPrefs().customClasses,
                onChanged: (val) {
                  setState(() {
                    SharedPrefs().customClasses = val;
                  });
                },
              ),
              const SettingsDivider(),
              SwitchListTile(
                title: const Text("Unlock 'Envelope V'"),
                subtitle: Row(
                  children: const [
                    Icon(Icons.warning),
                    SizedBox(
                      width: smallPadding,
                    ),
                    Expanded(
                      child: Text('Crimson Scales spoilers'),
                    ),
                  ],
                ),
                value: SharedPrefs().envelopeV,
                onChanged: (val) {
                  if (!val) {
                    setState(() {
                      SharedPrefs().envelopeV = false;
                    });
                  } else {
                    showDialog<bool>(
                        context: context,
                        builder: (_) {
                          bool envelopeVSolved = false;
                          return StatefulBuilder(
                            builder: (
                              BuildContext context,
                              StateSetter setState,
                            ) {
                              return AlertDialog(
                                content: Container(
                                  constraints: const BoxConstraints(
                                    maxWidth: maxDialogWidth,
                                  ),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Text(
                                          'What is the password for unlocking this envelope?'),
                                      TextField(
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleMedium,
                                        autofocus: true,
                                        onChanged: (String val) {
                                          setState(() {
                                            envelopeVSolved =
                                                val.toLowerCase().trim() ==
                                                    'ashes';
                                          });
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                                actions: <Widget>[
                                  TextButton(
                                    child: Text(
                                      'Cancel',
                                      style: TextStyle(
                                        color: Theme.of(context).brightness ==
                                                Brightness.dark
                                            ? Colors.grey[300]
                                            : Colors.black87,
                                      ),
                                    ),
                                    onPressed: () {
                                      Navigator.of(context).pop(false);
                                    },
                                  ),
                                  TextButton(
                                    child: Text(
                                      'Unlock',
                                      style: TextStyle(
                                        color: envelopeVSolved
                                            ? Theme.of(context)
                                                .colorScheme
                                                .primary
                                            : Theme.of(context).disabledColor,
                                      ),
                                    ),
                                    onPressed: envelopeVSolved
                                        ? () {
                                            Navigator.of(context).pop(true);
                                          }
                                        : null,
                                  ),
                                ],
                              );
                            },
                          );
                        }).then(
                      (value) {
                        if (value) {
                          setState(
                            () {
                              SharedPrefs().envelopeV = val;
                            },
                          );
                          ScaffoldMessenger.of(context)
                            ..clearSnackBars()
                            ..showSnackBar(
                              SnackBar(
                                content: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    SvgPicture.asset(
                                      'images/class_icons/vanquisher.svg',
                                      width: iconSize,
                                      height: iconSize,
                                      colorFilter: ColorFilter.mode(
                                        Theme.of(context)
                                            .colorScheme
                                            .onBackground,
                                        BlendMode.srcIn,
                                      ),
                                    ),
                                    const SizedBox(
                                      width: smallPadding,
                                    ),
                                    const Text('Vanquisher unlocked'),
                                  ],
                                ),
                              ),
                            );
                        }
                      },
                    );
                  }
                },
              ),
              const SettingsDivider(),
              SwitchListTile(
                title: const Text('Show Retired Characters'),
                value: widget.charactersModel.showRetired,
                onChanged: (val) {
                  context.read<AppModel>().updateTheme();
                  setState(() {
                    widget.charactersModel.toggleShowRetired();
                  });
                },
              ),
              const SettingsDivider(),
              ListTile(
                title: const Text('Backup'),
                subtitle: const Text('Backup your current characters'),
                onTap: () async {
                  await showDialog<String>(
                    context: context,
                    builder: (context) {
                      final TextEditingController titleController =
                          TextEditingController()
                            ..text =
                                'ghc_backup_${DateFormat('yyyy-MM-dd_HH:mm').format(DateTime.now())}'
                                    .replaceAll(RegExp(':'), '-');
                      return AlertDialog(
                        title: Platform.isAndroid
                            ? const Icon(Icons.warning)
                            : null,
                        content: Container(
                          constraints: const BoxConstraints(
                            maxWidth: maxDialogWidth,
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              if (Platform.isAndroid)
                                const Text(
                                    'If another backup file already exists in the Downloads folder with the same name, it will be overwritten'),
                              TextField(
                                style: Theme.of(context).textTheme.titleMedium,
                                decoration: const InputDecoration(
                                    labelText: 'filename'),
                                controller: titleController,
                                inputFormatters: [
                                  FilteringTextInputFormatter.deny(
                                    RegExp(
                                        '[\\#|\\<|\\>|\\+|\\\$|\\%|\\!|\\`|\\&|\\*|\\\'|\\||\\}|\\{|\\?|\\"|\\=|\\/|\\:|\\\\|\\ |\\@]'),
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                        actions: <Widget>[
                          if (Platform.isAndroid)
                            TextButton.icon(
                              icon: Icon(
                                Icons.save,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                              label: Text(
                                'Save',
                                style: TextStyle(
                                  color: Theme.of(context).brightness ==
                                          Brightness.dark
                                      ? Colors.grey[300]
                                      : Colors.black87,
                                ),
                              ),
                              onPressed: () async {
                                if (!await _getStoragePermission()) {
                                  return;
                                }
                                String value = await DatabaseHelper.instance
                                    .generateBackup();
                                downloadPath = '/storage/emulated/0/Download';
                                File backupFile = File(
                                    '$downloadPath/${titleController.text}.txt');
                                await backupFile.writeAsString(value);
                                Navigator.of(context).pop('save');
                              },
                            ),
                          TextButton.icon(
                            onPressed: () {
                              Navigator.of(context).pop(titleController.text);
                            },
                            icon: Platform.isAndroid
                                ? Icon(
                                    Icons.share,
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                  )
                                : Container(),
                            label: Text(
                              Platform.isAndroid ? 'Share' : 'Continue',
                              style: TextStyle(
                                color: Platform.isAndroid
                                    ? Theme.of(context).brightness ==
                                            Brightness.dark
                                        ? Colors.grey[300]
                                        : Colors.black87
                                    : Theme.of(context).colorScheme.primary,
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ).then(
                    (backupName) async {
                      if (backupName != null) {
                        if (backupName == 'save') {
                          ScaffoldMessenger.of(context)
                            ..clearSnackBars()
                            ..showSnackBar(
                              SnackBar(
                                content: Text('Saved to $downloadPath'),
                              ),
                            );
                        } else {
                          Directory directory = await getTemporaryDirectory();
                          downloadPath = directory.path;
                          String backupValue =
                              await DatabaseHelper.instance.generateBackup();
                          File backupFile =
                              File('$downloadPath/$backupName.txt');
                          await backupFile.writeAsString(backupValue);
                          await Share.shareXFiles(
                            [
                              XFile(
                                '$downloadPath/$backupName.txt',
                              ),
                            ],
                            sharePositionOrigin: Offset(
                                  MediaQuery.of(context).size.height / 2,
                                  MediaQuery.of(context).size.width / 2,
                                ) &
                                const Size(
                                  3.0,
                                  4.0,
                                ),
                          );
                        }
                      }
                    },
                  );
                },
              ),
              const SettingsDivider(),
              ListTile(
                title: const Text('Restore'),
                subtitle:
                    const Text('Restore your characters from a backup file'),
                onTap: () async {
                  final bool choice = await showDialog<bool>(
                    barrierDismissible: false,
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        content: Container(
                          constraints: const BoxConstraints(
                            maxWidth: maxDialogWidth,
                          ),
                          child: const Text(
                              'Restoring a backup file will overwrite any current characters. Do you wish to proceed?'),
                        ),
                        actions: <Widget>[
                          TextButton(
                            child: Text(
                              'Cancel',
                              style: TextStyle(
                                color: Theme.of(context).brightness ==
                                        Brightness.dark
                                    ? Colors.grey[300]
                                    : Colors.black87,
                              ),
                            ),
                            onPressed: () {
                              Navigator.of(context).pop(false);
                            },
                          ),
                          TextButton(
                            child: Text(
                              'Proceed',
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                            onPressed: () async {
                              if (!await _getStoragePermission()) {
                                return;
                              }
                              Navigator.of(context).pop(true);
                            },
                          ),
                        ],
                      );
                    },
                  );
                  if (!choice) {
                    return;
                  }
                  await FilePicker.platform.pickFiles(
                    type: FileType.custom,
                    allowMultiple: false,
                    allowedExtensions: ['txt'],
                  ).then(
                    (result) async {
                      if (result != null) {
                        String contents;
                        File file = File(result.files.single.path);
                        contents = file.readAsStringSync();
                        if (contents != null) {
                          _showLoaderDialog(context);
                          try {
                            await DatabaseHelper.instance.restoreBackup(
                              contents,
                            );
                            SharedPrefs().initialPage = 0;
                            await widget.charactersModel.loadCharacters();
                            widget.charactersModel.jumpToPage(0);
                          } catch (e) {
                            await showDialog(
                              barrierDismissible: false,
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: const Text(
                                      'Error During Restore Operation'),
                                  actions: [
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.of(context).pop(),
                                      child: const Text('Ok'),
                                    ),
                                  ],
                                  content: Container(
                                    constraints: const BoxConstraints(
                                      maxWidth: maxDialogWidth,
                                    ),
                                    child: SingleChildScrollView(
                                      child: Text(
                                        'There was an error during the restoration. Your existing data was saved and your backup hasn\'t been modified. Please contact the developer with your backup file and this information:\n${e.toString()}',
                                      ),
                                    ),
                                  ),
                                );
                              },
                            );
                          }
                          Navigator.of(context).pop();
                          Navigator.of(context).pop();
                        }
                      }
                    },
                  );
                },
              ),
              const SizedBox(
                height: smallPadding,
              ),
            ],
          ),
        ),
      ),
      persistentFooterButtons: [
        FutureBuilder(
          future: _packageInfoFuture,
          builder: (BuildContext context, AsyncSnapshot<PackageInfo> snapshot) {
            if (snapshot.connectionState == ConnectionState.done &&
                snapshot.hasData) {
              return Theme(
                data: Theme.of(context)
                    .copyWith(dividerColor: Colors.transparent),
                child: Column(
                  children: [
                    const Text(
                      'Support & Feedback',
                      textAlign: TextAlign.center,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        IconButton(
                          icon: const FaIcon(
                            FontAwesomeIcons.discord,
                          ),
                          onPressed: () {
                            _launchURL(
                              Uri(
                                scheme: 'https',
                                host: 'discord.gg',
                                path: 'FxuKNzDAmj',
                              ),
                            );
                          },
                        ),
                        IconButton(
                          icon: const FaIcon(
                            FontAwesomeIcons.instagram,
                          ),
                          onPressed: () async {
                            await _launchURL(
                              Uri(
                                scheme: 'https',
                                host: 'instagram.com',
                                path: 'tomkatcreative',
                              ),
                            );
                          },
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.email,
                          ),
                          onPressed: () async {
                            await _launchURL(
                              Uri(
                                scheme: 'mailto',
                                path: 'tomkatcreative@gmail.com',
                                queryParameters: {
                                  'subject':
                                      'GHC support - v${snapshot.data.version}+${snapshot.data.buildNumber}'
                                },
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Padding(
                        padding: const EdgeInsets.only(
                          bottom: smallPadding,
                          right: smallPadding,
                        ),
                        child: Text(
                          'v${snapshot.data.version}+${snapshot.data.buildNumber}',
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              );
            } else {
              return Container();
            }
          },
        ),
      ],
    );
  }
}

Future<bool> _getStoragePermission() async {
  if (Platform.isAndroid) {
    return true;
  }
  PermissionStatus permissionStatus = await Permission.storage.request();
  if (permissionStatus.isGranted) {
    return true;
  } else if (permissionStatus.isPermanentlyDenied) {
    await openAppSettings();
  } else if (permissionStatus.isDenied) {
    return false;
  }
  return false;
}

void _showLoaderDialog(BuildContext context) {
  showDialog(
    barrierDismissible: false,
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        content: Row(
          children: [
            const CircularProgressIndicator(),
            Container(
              constraints: const BoxConstraints(
                maxWidth: maxDialogWidth,
              ),
              margin: const EdgeInsets.only(left: 7),
              child: const Text('Restoring...'),
            ),
          ],
        ),
      );
    },
  );
}

Future<void> _launchURL(Uri uri) async => await canLaunchUrl(uri)
    ? await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      )
    : await launchUrl(
        uri,
      );

class SettingsDivider extends StatelessWidget {
  const SettingsDivider({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: Divider(
        endIndent: 16,
        indent: 16,
        height: 1,
      ),
    );
  }
}
