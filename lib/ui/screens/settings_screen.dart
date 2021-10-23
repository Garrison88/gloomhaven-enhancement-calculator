import 'dart:io';
import 'dart:ui';

import 'package:easy_dynamic_theme/easy_dynamic_theme.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg_provider/flutter_svg_provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gloomhaven_enhancement_calc/viewmodels/characters_model.dart';
import 'package:intl/intl.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../data/constants.dart';
import '../../data/database_helpers.dart';
import '../../shared_prefs.dart';

class SettingsScreen extends StatefulWidget {
  final void Function() updateTheme;
  final CharactersModel charactersModel;

  const SettingsScreen({
    Key key,
    this.updateTheme,
    this.charactersModel,
  }) : super(key: key);

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  // final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

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
      // key: _scaffoldKey,
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
      body: ListView(
        children: <Widget>[
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
            // subtitle: const Text('Show retired characters in the list view'),
            title: const Text('Show Retired Characters'),
            value: widget.charactersModel.showRetired,
            onChanged: (val) {
              // SharedPrefs().showRetiredCharacters = val;
              widget.charactersModel.showRetired = val;
              SharedPrefs().showRetiredCharacters = val;
              // try {
              widget.updateTheme();
              // } catch (e) {
              //   print(e.toString());
              // }
              // widget.loadCharacters(val);
              // setState(() {
              // });
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
                    title:
                        Platform.isAndroid ? const Icon(Icons.warning) : null,
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (Platform.isAndroid)
                          const Text(
                              'If another backup file already exists in the Downloads folder with the same name, it will be overwritten'),
                        TextField(
                          decoration:
                              const InputDecoration(labelText: 'filename'),
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
                    actions: <Widget>[
                      if (Platform.isAndroid)
                        TextButton.icon(
                          icon: const Icon(Icons.save),
                          label: const Text('Save'),
                          onPressed: () async {
                            if (!await _getStoragePermission()) {
                              return;
                            }
                            String value =
                                await DatabaseHelper.instance.generateBackup();
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
                      Directory directory = await getTemporaryDirectory();
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
            title: const Text('Restore'),
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
                  String contents;
                  if (result != null) {
                    File file = File(result.files.single.path);
                    contents = file.readAsStringSync();
                    if (contents != null) {
                      _showLoaderDialog(context);
                      await DatabaseHelper.instance.restoreBackup(contents);
                      await widget.charactersModel.loadCharacters();
                      widget.charactersModel.setCurrentCharacter(index: 0);
                      widget.charactersModel.animateToIndex(0);
                      Navigator.of(context).pop();
                      Navigator.of(context).pop();
                    }
                  }
                },
              );
            },
          ),
          const SettingsDivider(),
          const SizedBox(
            height: smallPadding * 2,
          ),
          FutureBuilder(
            future: _packageInfoFuture,
            builder:
                (BuildContext context, AsyncSnapshot<PackageInfo> snapshot) {
              if (snapshot.connectionState == ConnectionState.done &&
                  snapshot.hasData) {
                return Theme(
                  data: Theme.of(context)
                      .copyWith(dividerColor: Colors.transparent),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      ListTile(
                        title: const Text(
                          'Support & Feedback',
                          textAlign: TextAlign.center,
                        ),
                        subtitle: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            IconButton(
                              icon: const FaIcon(
                                FontAwesomeIcons.discord,
                              ),
                              onPressed: () {
                                _launchURL('https://discord.gg/FxuKNzDAmj');
                              },
                            ),
                            IconButton(
                              icon: const FaIcon(
                                FontAwesomeIcons.instagram,
                              ),
                              onPressed: () {
                                _launchURL(
                                    'https://instagram.com/tomkatcreative');
                              },
                            ),
                            IconButton(
                              icon: const Icon(
                                Icons.email,
                              ),
                              onPressed: () {
                                final Uri uri = Uri(
                                  scheme: 'mailto',
                                  path: 'tomkatcreative@gmail.com',
                                  query: encodeQueryParameters(<String, String>{
                                    'subject':
                                        'GHC support - v${snapshot.data.version}+${snapshot.data.buildNumber}',
                                  }),
                                );
                                _launchURL(uri.toString());
                              },
                            ),
                          ],
                        ),
                      ),
                      Padding(
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
                    ],
                  ),
                );
              } else {
                return Container();
              }
            },
          ),
        ],
      ),
    );
  }
}

Future<bool> _getStoragePermission() async {
  if (await Permission.storage.request().isGranted) {
    return true;
  } else if (await Permission.storage.request().isPermanentlyDenied) {
    await openAppSettings();
  } else if (await Permission.storage.request().isDenied) {
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
              margin: const EdgeInsets.only(left: 7),
              child: const Text('Restoring...'),
            ),
          ],
        ),
      );
    },
  );
}

void _launchURL(String url) async =>
    await canLaunch(url) ? await launch(url) : throw 'Could not launch $url';

String encodeQueryParameters(Map<String, String> params) {
  return params.entries
      .map((e) =>
          '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
      .join('&');
}

class SettingsDivider extends StatelessWidget {
  const SettingsDivider({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // return Container(
    //   padding: const EdgeInsets.only(bottom: smallPadding + 1),
    // );
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
