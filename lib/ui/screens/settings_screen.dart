import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart' as flutter_svg;
// import 'package:flutter_svg_provider/flutter_svg_provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gloomhaven_enhancement_calc/viewmodels/app_model.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import '../../viewmodels/characters_model.dart';
import '../../viewmodels/enhancement_calculator_model.dart';
import 'package:intl/intl.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../data/constants.dart';
import '../../data/database_helpers.dart';
import '../../shared_prefs.dart';

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
      body: ListView(
        children: <Widget>[
          SwitchListTile(
            title: const Text('Theme'),
            subtitle: Theme.of(context).brightness == Brightness.dark
                ? const Text('Dark')
                : const Text('Light'),
            // activeThumbImage: const Svg('images/elem_dark.svg'),
            activeColor: const Color(0xff1f272e),
            inactiveThumbColor: const Color(0xffeda50b),
            inactiveTrackColor: const Color(0xffeda50b).withOpacity(0.75),
            activeTrackColor: Colors.white30,
            // inactiveThumbImage: const Svg('images/elem_light.svg'),
            value: widget.appModel.themeMode == ThemeMode.dark,
            onChanged: (val) {
              SharedPrefs().darkTheme = val;
              widget.appModel.updateTheme(
                themeMode: val ? ThemeMode.dark : ThemeMode.light,
              );
              SystemChrome.setSystemUIOverlayStyle(
                SystemUiOverlayStyle(
                  systemNavigationBarIconBrightness:
                      val ? Brightness.light : Brightness.dark,
                  systemNavigationBarColor: val
                      ? Color(
                          int.parse(
                            '0xff1c1b1f',
                          ),
                        )
                      : Colors.white,
                ),
              );
              widget.charactersModel.updateTheme();
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
                        builder: (
                          BuildContext context,
                          StateSetter setState,
                        ) {
                          return AlertDialog(
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Text('Enter the solution to the puzzle'),
                                TextField(
                                  style:
                                      Theme.of(context).textTheme.titleMedium,
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
                                        ? Theme.of(context).colorScheme.primary
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
                                flutter_svg.SvgPicture.asset(
                                  'images/class_icons/bladeswarm.svg',
                                  width: iconSize,
                                  height: iconSize,
                                  colorFilter: ColorFilter.mode(
                                    Theme.of(context).brightness ==
                                            Brightness.dark
                                        ? Colors.white
                                        : Color(
                                            int.parse(
                                              '0xff424242',
                                            ),
                                          ),
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
                    title:
                        Platform.isAndroid ? const Icon(Icons.warning) : null,
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (Platform.isAndroid)
                          const Text(
                              'If another backup file already exists in the Downloads folder with the same name, it will be overwritten'),
                        TextField(
                          style: Theme.of(context).textTheme.titleMedium,
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
                            ? Icon(
                                Icons.share,
                                color: Theme.of(context).colorScheme.primary,
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
                      File backupFile = File('$downloadPath/$backupName.txt');
                      await backupFile.writeAsString(backupValue);
                      await Share.shareXFiles(
                        [
                          XFile(
                            '$downloadPath/$backupName.txt',
                          ),
                        ],
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
                            color:
                                Theme.of(context).brightness == Brightness.dark
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
                              title:
                                  const Text('Error During Restore Operation'),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.of(context).pop(),
                                  child: const Text('Ok'),
                                ),
                              ],
                              content: SingleChildScrollView(
                                child: Text(
                                  'There was an error during the restoration. Your existing data was saved and your backup hasn\'t been modified. Please contact the developer with your backup file and this information:\n${e.toString()}',
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
  if (Platform.isAndroid) {
    return true;
  }
  PermissionStatus permissionStatus = await Permission.storage.request();
  if (permissionStatus.isGranted) {
    return true;
  } else if (permissionStatus.isPermanentlyDenied) {
    await openAppSettings();
    // return true;
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
