import 'dart:io';
import 'dart:ui';

import 'package:easy_dynamic_theme/easy_dynamic_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../data/database_helpers.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import '../../data/constants.dart';
import '../../shared_prefs.dart';
import 'package:flutter_svg_provider/flutter_svg_provider.dart';
import 'package:file_picker/file_picker.dart';
import 'package:intl/intl.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({
    Key key,
  }) : super(key: key);

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  String downloadPath;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: Icon(
            Platform.isIOS ? Icons.arrow_back_ios_new : Icons.arrow_back,
            color: ThemeData.estimateBrightnessForColor(
                            Theme.of(context).colorScheme.secondary) ==
                        Brightness.dark ||
                    Theme.of(context).brightness == Brightness.dark
                ? Colors.white
                : Colors.black,
          ),
        ),
        title: Text(
          'Settings',
          style: TextStyle(
            fontSize: 25.0,
            color: ThemeData.estimateBrightnessForColor(
                            Theme.of(context).colorScheme.secondary) ==
                        Brightness.dark ||
                    Theme.of(context).brightness == Brightness.dark
                ? Colors.white
                : Colors.black,
          ),
        ),
      ),
      body: ListView(children: <Widget>[
        SwitchListTile(
            title: const Text('Theme'),
            subtitle: SharedPrefs().darkTheme
                ? const Text('Dark')
                : const Text('Light'),
            activeThumbImage: const Svg('images/elem_dark.svg'),
            activeColor: const Color(0xff1f272e),
            inactiveThumbColor: const Color(0xffeda50b),
            inactiveTrackColor: const Color(0xffeda50b).withOpacity(0.75),
            activeTrackColor: Colors.white30,
            inactiveThumbImage: const Svg('images/elem_light.svg'),
            value: SharedPrefs().darkTheme,
            onChanged: (val) {
              SharedPrefs().darkTheme = val;
              EasyDynamicTheme.of(context).changeTheme(dynamic: true);
            }),
        const SettingsDivider(),
        SwitchListTile(
            title: const Text('Inline Icons'),
            subtitle: const Text('Show icons in perk rows'),
            value: SharedPrefs().showPerkImages,
            onChanged: (val) {
              setState(() {
                SharedPrefs().showPerkImages = val;
              });
            }),
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
                      builder: (BuildContext context, StateSetter setState) {
                        return AlertDialog(
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Text('Enter the solution to the puzzle'),
                              TextField(
                                autofocus: true,
                                onChanged: (String val) {
                                  setState(() {
                                    envelopeXSolved =
                                        val.toLowerCase() == 'bladeswarm';
                                  });
                                },
                              ),
                            ],
                          ),
                          actions: <Widget>[
                            TextButton(
                              child: const Text('Cancel'),
                              onPressed: () {
                                Navigator.of(context).pop(false);
                              },
                            ),
                            TextButton(
                              child: const Text('Solve'),
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
                },
              );
            }),
        const SettingsDivider(),
        SwitchListTile(
          subtitle: const Text(
              "Include Crimson Scales classes and 'released' classes created by the community"),
          title: const Text('Custom Classes'),
          value: SharedPrefs().customClasses,
          onChanged: (val) {
            setState(() {
              SharedPrefs().customClasses = val;
            });
          },
        ),
        const SettingsDivider(),
        ListTile(
          title: Row(
            children: const [
              Padding(
                padding: EdgeInsets.only(right: 2),
                child: Icon(
                  Icons.file_upload_outlined,
                ),
              ),
              Text('Backup'),
            ],
          ),
          subtitle: const Text('Backup your current characters'),
          onTap: () async {
            if (!await _getStoragePermission()) {
              return;
            }
            await showDialog<String>(
              context: context,
              builder: (context) {
                final TextEditingController titleController =
                    TextEditingController()
                      ..text =
                          'ghc_backup_${DateFormat('yyyy-MM-dd_HH:mm').format(DateTime.now())}'
                              .replaceAll(RegExp(':'), '-');
                return AlertDialog(
                  content: TextField(
                    controller: titleController,
                    inputFormatters: [
                      FilteringTextInputFormatter.deny(
                        RegExp(
                            '[\\#|\\<|\\>|\\+|\\\$|\\%|\\!|\\`|\\&|\\*|\\\'|\\||\\}|\\{|\\?|\\"|\\=|\\/|\\:|\\\\|\\ |\\@]'),
                      )
                    ],
                  ),
                  actions: <Widget>[
                    if (Platform.isAndroid)
                      TextButton.icon(
                        icon: const Icon(Icons.save),
                        label: const Text('Save'),
                        onPressed: () async {
                          String value =
                              await DatabaseHelper.instance.generateBackup();
                          downloadPath = '/storage/emulated/0/Download';
                          File backupFile =
                              File('$downloadPath/${titleController.text}.txt');
                          await backupFile.writeAsString(value);
                          Navigator.of(context).pop('save');
                        },
                      ),
                    TextButton.icon(
                      onPressed: () {
                        Navigator.of(context).pop(titleController.text);
                      },
                      icon: Platform.isAndroid
                          ? const Icon(
                              Icons.share,
                            )
                          : Container(),
                      label: Text(Platform.isAndroid ? 'Share' : 'Continue'),
                    ),
                  ],
                );
              },
            ).then(
              (backupName) async {
                if (backupName != null) {
                  if (backupName == 'save') {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Saved to $downloadPath'),
                      ),
                    );
                  } else {
                    Directory directory =
                        await getApplicationDocumentsDirectory();
                    downloadPath = directory.path;
                    String backupValue =
                        await DatabaseHelper.instance.generateBackup();
                    File backupFile = File('$downloadPath/$backupName.txt');
                    await backupFile.writeAsString(backupValue);
                    await Share.shareFiles(
                      ['$downloadPath/$backupName.txt'],
                    );
                  }
                }
              },
            );
          },
        ),
        const SettingsDivider(),
        ListTile(
          title: Row(
            children: const [
              Padding(
                padding: EdgeInsets.only(right: 2),
                child: Icon(Icons.file_download_outlined),
              ),
              Text('Restore'),
            ],
          ),
          subtitle: const Text('Restore your characters from a backup file'),
          onTap: () async {
            final bool choice = await showDialog<bool>(
              barrierDismissible: false,
              context: context,
              builder: (context) {
                return AlertDialog(
                  content: const Text(
                      'Restoring a backup file will overwrite any current characters. Do you wish to proceed?'),
                  actions: <Widget>[
                    TextButton(
                      child: const Text('Cancel'),
                      onPressed: () {
                        Navigator.of(context).pop(false);
                      },
                    ),
                    TextButton(
                      child: const Text('Proceed'),
                      onPressed: () {
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
            await FilePicker.platform.pickFiles().then(
              (result) async {
                String contents;
                if (result != null) {
                  File file = File(result.files.single.path);
                  contents = file.readAsStringSync();
                }
                if (contents != null) {
                  showLoaderDialog(context);
                  await DatabaseHelper.instance.restoreBackup(contents);
                  Navigator.of(context).pop();
                  Phoenix.rebirth(context);
                }
              },
            );
          },
        ),
      ]),
    );
  }
}

Future<bool> _getStoragePermission() async {
  if (await Permission.storage.request().isGranted) {
    // setState(() {
    //   permissionGranted = true;
    // });
    return true;
  } else if (await Permission.storage.request().isPermanentlyDenied) {
    await openAppSettings();
  } else if (await Permission.storage.request().isDenied) {
    // setState(() {
    //   permissionGranted = false;
    // });
    return false;
  }
  return false;
}

showLoaderDialog(BuildContext context) {
  AlertDialog alert = AlertDialog(
    content: Row(
      children: [
        const CircularProgressIndicator(),
        Container(
          margin: const EdgeInsets.only(left: 7),
          child: const Text('Restoring...'),
        ),
      ],
    ),
  );
  showDialog(
    barrierDismissible: false,
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}

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
