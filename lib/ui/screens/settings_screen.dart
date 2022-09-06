import 'dart:io';

import 'package:easy_dynamic_theme/easy_dynamic_theme.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_statusbarcolor_ns/flutter_statusbarcolor_ns.dart';
import 'package:flutter_svg/flutter_svg.dart' as flutter_svg;
import 'package:flutter_svg_provider/flutter_svg_provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../viewmodels/characters_model.dart';
import '../../viewmodels/enhancement_calculator_model.dart';
import 'package:intl/intl.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../data/constants.dart';
import '../../data/database_helpers.dart';
import '../../shared_prefs.dart';

class SettingsScreen extends StatefulWidget {
  final void Function() updateTheme;
  final CharactersModel charactersModel;
  final EnhancementCalculatorModel enhancementCalculatorModel;

  const SettingsScreen({
    Key key,
    this.updateTheme,
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

  // @override
  // void didChangeDependencies() {
  //   SystemChrome.setSystemUIOverlayStyle(
  //     SystemUiOverlayStyle(
  //       statusBarIconBrightness: Theme.of(context).brightness == Brightness.dark
  //           ? Brightness.light
  //           : Brightness.dark,
  //       systemNavigationBarIconBrightness:
  //           Theme.of(context).brightness == Brightness.dark
  //               ? Brightness.dark
  //               : Brightness.light,
  //     ),
  //   );
  //   super.didChangeDependencies();
  // }

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
      body: ListView(
        children: <Widget>[
          SwitchListTile(
            title: const Text('Theme'),
            subtitle: Theme.of(context).brightness == Brightness.dark
                ? const Text('Dark')
                : const Text('Light'),
            activeThumbImage: const Svg('images/elem_dark.svg'),
            activeColor: const Color(0xff1f272e),
            inactiveThumbColor: const Color(0xffeda50b),
            inactiveTrackColor: const Color(0xffeda50b).withOpacity(0.75),
            activeTrackColor: Colors.white30,
            inactiveThumbImage: const Svg('images/elem_light.svg'),
            value: Theme.of(context).brightness == Brightness.dark,
            onChanged: (val) {
              // setState(() {
              SharedPrefs().darkTheme = val;
              EasyDynamicTheme.of(context).changeTheme(dynamic: true);
              // SystemChrome.setSystemUIOverlayStyle(
              //     val ? SystemUiOverlayStyle.dark : SystemUiOverlayStyle.light
              // SystemUiOverlayStyle(
              //   systemStatusBarContrastEnforced: false,
              //   statusBarIconBrightness:
              //       val ? Brightness.light : Brightness.dark,
              //   systemNavigationBarIconBrightness:
              //       val ? Brightness.dark : Brightness.light,
              //   systemNavigationBarColor:
              //       Theme.of(context).scaffoldBackgroundColor,
              // ),
              // );
              // });
            },
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
                                child: Text(
                                  'Cancel',
                                  style: TextStyle(
                                    color: SharedPrefs().darkTheme
                                        ? Colors.grey[300]
                                        : Colors.black87,
                                  ),
                                ),
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
                      ScaffoldMessenger.of(context)
                        ..clearSnackBars()
                        ..showSnackBar(
                          SnackBar(
                            content: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                flutter_svg.SvgPicture.asset(
                                  'images/class_icons/bladeswarm.svg',
                                  width: iconSize,
                                  height: iconSize,
                                  color: Theme.of(context).brightness ==
                                          Brightness.dark
                                      ? Colors.black
                                      : Colors.white,
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
          SwitchListTile(
            subtitle: const Text(
                "Include Crimson Scales classes and 'released' custom classes created by the community"),
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
              int index = widget.charactersModel.characters
                  .indexOf(widget.charactersModel.currentCharacter);
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
                        child: Text(
                          'Cancel',
                          style: TextStyle(
                            color: SharedPrefs().darkTheme
                                ? Colors.grey[300]
                                : Colors.black87,
                          ),
                        ),
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
                      await DatabaseHelper.instance.restoreBackup(
                        contents,
                      );
                      await widget.charactersModel.loadCharacters();
                      widget.charactersModel.jumpToPage(0);
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

Future<void> _launchURL(Uri uri) async => await canLaunchUrl(uri)
    ? await launchUrl(uri)
    : throw 'Could not launch $uri';

String encodeQueryParameters(Map<String, String> params) {
  return params.entries
      .map(
        (e) => '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}',
      )
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
