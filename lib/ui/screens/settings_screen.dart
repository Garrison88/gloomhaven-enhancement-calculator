import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gloomhaven_enhancement_calc/data/constants.dart';
import 'package:gloomhaven_enhancement_calc/data/database_helpers.dart';
import 'package:gloomhaven_enhancement_calc/ui/screens/changelog_screen.dart';
import 'package:gloomhaven_enhancement_calc/models/player_class.dart';
import 'package:gloomhaven_enhancement_calc/shared_prefs.dart';
import 'package:gloomhaven_enhancement_calc/theme/theme_provider.dart';
import 'package:gloomhaven_enhancement_calc/viewmodels/characters_model.dart';
import 'package:gloomhaven_enhancement_calc/viewmodels/enhancement_calculator_model.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsScreen extends StatefulWidget {
  final EnhancementCalculatorModel enhancementCalculatorModel;

  const SettingsScreen({super.key, required this.enhancementCalculatorModel});

  @override
  SettingsScreenState createState() => SettingsScreenState();
}

class SettingsScreenState extends State<SettingsScreen> {
  final ScrollController scrollController = ScrollController();
  bool isBottom = false;
  @override
  void initState() {
    super.initState();
    scrollController.addListener(() {
      if ((scrollController.offset >=
          scrollController.position.maxScrollExtent)) {
        setState(() {
          isBottom = true;
        });
      } else {
        setState(() {
          isBottom = false;
        });
      }
    });
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  late String downloadPath;

  final Future<PackageInfo> _packageInfoFuture = PackageInfo.fromPlatform();

  // @override
  // void initState() {
  //   super.initState();

  //   _packageInfoFuture = PackageInfo.fromPlatform();
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
        title: Text(
          'Settings',
          style: Theme.of(context).textTheme.headlineLarge,
        ),
      ),
      body: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: maxWidth),
          child: ListView(
            children: <Widget>[
              const SettingsSection(title: 'GAMEPLAY'),
              SwitchListTile(
                secondary: Icon(
                  SharedPrefs().customClasses
                      ? MdiIcons.testTube
                      : MdiIcons.testTubeOff,
                ),
                subtitle: Text(
                  "Include Crimson Scales, Trail of Ashes, and 'released' custom classes created by the CCUG community",
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                title: const Text('Custom Classes'),
                value: SharedPrefs().customClasses,
                onChanged: (val) {
                  setState(() {
                    SharedPrefs().customClasses = val;
                  });
                },
              ),
              SwitchListTile(
                secondary: const Icon(Icons.warning_rounded),
                title: const Text("Solve 'Envelope X'"),
                subtitle: Text(
                  'Gloomhaven spoilers',
                  style: Theme.of(context).textTheme.titleLarge,
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
                          builder:
                              (BuildContext context, StateSetter setState) {
                                return AlertDialog(
                                  content: Container(
                                    constraints: const BoxConstraints(
                                      maxWidth: maxDialogWidth,
                                    ),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        const Text(
                                          'Enter the solution to the puzzle',
                                        ),
                                        const SizedBox(height: 8),
                                        TextField(
                                          autofocus: true,
                                          onChanged: (String val) {
                                            setState(() {
                                              envelopeXSolved =
                                                  val.toLowerCase().trim() ==
                                                  'bladeswarm';
                                            });
                                          },
                                          decoration: const InputDecoration(
                                            labelText: 'Solution',
                                            border: OutlineInputBorder(),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  actions: <Widget>[
                                    TextButton(
                                      child: const Text('Cancel'),
                                      onPressed: () {
                                        Navigator.of(context).pop(false);
                                      },
                                    ),
                                    TextButton(
                                      onPressed: envelopeXSolved
                                          ? () {
                                              Navigator.of(context).pop(true);
                                            }
                                          : null,
                                      child: Text(
                                        'Solve',
                                        style: TextStyle(
                                          color: envelopeXSolved
                                              ? Theme.of(
                                                  context,
                                                ).colorScheme.primary
                                              : Theme.of(context).disabledColor,
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              },
                        );
                      },
                    ).then((bool? value) {
                      if (value != null && value) {
                        setState(() {
                          SharedPrefs().envelopeX = val;
                        });
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
                                      Theme.of(context).colorScheme.onSurface,
                                      BlendMode.srcIn,
                                    ),
                                  ),
                                  const SizedBox(width: smallPadding),
                                  const Text('Bladeswarm unlocked'),
                                ],
                              ),
                            ),
                          );
                      }
                    });
                  }
                },
              ),
              SwitchListTile(
                secondary: const Icon(Icons.warning_rounded),
                title: const Text("Unlock 'Envelope V'"),
                subtitle: Text(
                  'Crimson Scales spoilers',
                  style: Theme.of(context).textTheme.titleLarge,
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
                          builder: (BuildContext context, StateSetter setState) {
                            return AlertDialog(
                              content: Container(
                                constraints: const BoxConstraints(
                                  maxWidth: maxDialogWidth,
                                ),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Text(
                                      'What is the password for unlocking this envelope?',
                                    ),
                                    const SizedBox(height: 8),
                                    TextField(
                                      autofocus: true,
                                      onChanged: (String val) {
                                        setState(() {
                                          envelopeVSolved =
                                              val.toLowerCase().trim() ==
                                              'ashes';
                                        });
                                      },
                                      decoration: const InputDecoration(
                                        labelText: 'Password',
                                        border: OutlineInputBorder(),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              actions: <Widget>[
                                TextButton(
                                  child: const Text('Cancel'),
                                  onPressed: () {
                                    Navigator.of(context).pop(false);
                                  },
                                ),
                                TextButton(
                                  onPressed: envelopeVSolved
                                      ? () {
                                          Navigator.of(context).pop(true);
                                        }
                                      : null,
                                  child: Text(
                                    'Unlock',
                                    style: TextStyle(
                                      color: envelopeVSolved
                                          ? Theme.of(
                                              context,
                                            ).colorScheme.primary
                                          : Theme.of(context).disabledColor,
                                    ),
                                  ),
                                ),
                              ],
                            );
                          },
                        );
                      },
                    ).then((bool? value) {
                      if (value != null && value) {
                        setState(() {
                          SharedPrefs().envelopeV = val;
                        });
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
                                      Theme.of(context).colorScheme.onSurface,
                                      BlendMode.srcIn,
                                    ),
                                  ),
                                  const SizedBox(width: smallPadding),
                                  const Text('Vanquisher unlocked'),
                                ],
                              ),
                            ),
                          );
                      }
                    });
                  }
                },
              ),
              const SettingsSection(title: 'DISPLAY'),
              Theme(
                data: Theme.of(context).copyWith(
                  colorScheme: Theme.of(
                    context,
                  ).colorScheme.copyWith(outline: Colors.transparent),
                ),
                child: SwitchListTile(
                  secondary: Icon(
                    Theme.of(context).brightness == Brightness.dark
                        ? Icons.dark_mode_rounded
                        : Icons.light_mode_rounded,
                  ),
                  title: const Text('Brightness'),
                  subtitle: Text(
                    Theme.of(context).brightness == Brightness.dark
                        ? 'Dark'
                        : 'Light',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  activeThumbImage: const AssetImage('images/elem_dark.png'),
                  activeThumbColor: const Color(0xff1f272e),
                  inactiveThumbColor: const Color(0xffeda50b),
                  inactiveTrackColor: const Color(
                    0xffeda50b,
                  ).withValues(alpha: 0.75),
                  activeTrackColor: const Color(0xff1f272e),
                  inactiveThumbImage: const AssetImage('images/elem_light.png'),
                  value: context.watch<ThemeProvider>().useDarkMode,
                  onChanged: (val) {
                    context.read<ThemeProvider>().updateDarkMode(val);
                  },
                ),
              ),
              SwitchListTile(
                secondary: Icon(MdiIcons.formatFont),
                title: const Text('Use Inter Font'),
                subtitle: Text(
                  'Replace stylized fonts with Inter to improve readability',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                value: context.watch<ThemeProvider>().useDefaultFonts,
                onChanged: (val) {
                  context.read<ThemeProvider>().updateDefaultFonts(val);
                },
              ),
              SwitchListTile(
                secondary: Icon(
                  context.read<CharactersModel>().showRetired
                      ? Icons.visibility_rounded
                      : Icons.visibility_off_rounded,
                ),
                title: const Text('Show Retired Characters'),
                subtitle: Text(
                  'Toggle visibility of retired characters in the Characters tab to reduce clutter',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                value: context.read<CharactersModel>().showRetired,
                onChanged: (val) {
                  setState(() {
                    context.read<CharactersModel>().toggleShowRetired();
                  });
                },
              ),
              const SettingsSection(title: 'BACKUP & RESTORE'),
              ListTile(
                leading: const Icon(Icons.upload_rounded),
                title: const Text('Backup'),
                subtitle: Text(
                  'Backup your current characters',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                onTap: () async {
                  await showDialog<String?>(
                    context: context,
                    builder: (context) {
                      final TextEditingController
                      fileNameController = TextEditingController()
                        ..text =
                            'ghc_backup_${DateFormat('yyyy-MM-dd_HH:mm').format(DateTime.now())}'
                                .replaceAll(RegExp(':'), '-');
                      return AlertDialog(
                        title: Platform.isAndroid
                            ? const Icon(Icons.warning_rounded)
                            : null,
                        content: Container(
                          constraints: const BoxConstraints(
                            maxWidth: maxDialogWidth,
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              if (Platform.isAndroid) ...[
                                const Text(
                                  'If another backup file already exists in the Downloads folder with the same name, it will be overwritten',
                                ),
                                const SizedBox(height: 8),
                              ],
                              TextField(
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: 'Filename',
                                ),
                                controller: fileNameController,
                                inputFormatters: [
                                  FilteringTextInputFormatter.deny(
                                    RegExp(
                                      '[\\#|\\<|\\>|\\+|\\\$|\\%|\\!|\\`|\\&|\\*|\\\'|\\||\\}|\\{|\\?|\\"|\\=|\\/|\\:|\\\\|\\ |\\@]',
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        actions: <Widget>[
                          TextButton(
                            child: const Text('Cancel'),
                            onPressed: () => Navigator.of(context).pop(),
                          ),
                          if (Platform.isAndroid)
                            TextButton.icon(
                              icon: Icon(
                                Icons.save,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                              label: const Text('Save'),
                              onPressed: () async {
                                if (!await _getStoragePermission()) {
                                  return;
                                }
                                String value = await DatabaseHelper.instance
                                    .generateBackup();
                                downloadPath = '/storage/emulated/0/Download';
                                File backupFile = File(
                                  '$downloadPath/${fileNameController.text}.txt',
                                );
                                await backupFile.writeAsString(value);
                                Navigator.of(context).pop('save');
                              },
                            ),
                          TextButton.icon(
                            onPressed: () {
                              Navigator.of(
                                context,
                              ).pop(fileNameController.text);
                            },
                            icon: Platform.isAndroid
                                ? Icon(
                                    Icons.share,
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.primary,
                                  )
                                : Container(),
                            label: Text(
                              Platform.isAndroid ? 'Share' : 'Continue',
                            ),
                          ),
                        ],
                      );
                    },
                  ).then((String? backupName) async {
                    if (backupName != null) {
                      if (backupName == 'save') {
                        ScaffoldMessenger.of(context)
                          ..clearSnackBars()
                          ..showSnackBar(
                            SnackBar(content: Text('Saved to $downloadPath')),
                          );
                      } else {
                        Directory directory = await getTemporaryDirectory();
                        downloadPath = directory.path;
                        String backupValue = await DatabaseHelper.instance
                            .generateBackup();
                        File backupFile = File('$downloadPath/$backupName.txt');
                        await backupFile.writeAsString(backupValue);
                        await Share.shareXFiles(
                          [XFile('$downloadPath/$backupName.txt')],
                          sharePositionOrigin:
                              Offset(
                                MediaQuery.of(context).size.height / 2,
                                MediaQuery.of(context).size.width / 2,
                              ) &
                              const Size(3.0, 4.0),
                        );
                      }
                    }
                  });
                },
              ),
              ListTile(
                leading: const Icon(Icons.download_rounded),
                title: const Text('Restore'),
                subtitle: Text(
                  'Restore your characters from a backup file',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                onTap: () async {
                  final bool? choice = await showDialog<bool?>(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        content: Container(
                          constraints: const BoxConstraints(
                            maxWidth: maxDialogWidth,
                          ),
                          child: const Text(
                            'Restoring a backup file will overwrite any current characters. Do you wish to continue?',
                          ),
                        ),
                        actions: <Widget>[
                          TextButton(
                            child: const Text('Cancel'),
                            onPressed: () {
                              Navigator.of(context).pop(false);
                            },
                          ),
                          TextButton(
                            child: const Text('Continue'),
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
                  if (choice == null || !choice) {
                    return;
                  }
                  await FilePicker.platform
                      .pickFiles(
                        type: FileType.custom,
                        allowMultiple: false,
                        allowedExtensions: ['txt'],
                      )
                      .then((FilePickerResult? result) async {
                        if (result != null) {
                          String contents;
                          String? path = result.files.single.path;
                          if (path == null) {
                            return;
                          }
                          File file = File(path);
                          contents = file.readAsStringSync();

                          _showLoaderDialog(context);
                          try {
                            await DatabaseHelper.instance.restoreBackup(
                              contents,
                            );
                            SharedPrefs().initialPage = 0;
                            await context
                                .read<CharactersModel>()
                                .loadCharacters();
                            context.read<CharactersModel>().jumpToPage(0);
                          } catch (e) {
                            await showDialog(
                              barrierDismissible: false,
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text(
                                    'Error During Restore Operation',
                                    style: Theme.of(
                                      context,
                                    ).textTheme.headlineLarge,
                                  ),
                                  actions: [
                                    TextButton.icon(
                                      onPressed: () => Clipboard.setData(
                                        ClipboardData(text: e.toString()),
                                      ),
                                      icon: const Icon(Icons.copy),
                                      label: const Text('Copy'),
                                    ),
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.of(context).pop(),
                                      child: const Text('Close'),
                                    ),
                                  ],
                                  content: Container(
                                    constraints: const BoxConstraints(
                                      maxWidth: maxDialogWidth,
                                    ),
                                    child: SingleChildScrollView(
                                      child: Text(
                                        'There was an error during the restoration process. Your existing data was saved and your backup hasn\'t been modified. Please contact the developer (through the Settings menu) with your existing backup file and this information:\n\n${e.toString()}',
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
                      });
                },
              ),
              if (kDebugMode) ...[
                const SettingsSection(title: 'TESTING'),
                ListTile(
                  title: const Text('Create All'),
                  onTap: () => context
                      .read<CharactersModel>()
                      .createCharactersTest(includeAllVariants: true),
                ),
                ListTile(
                  title: const Text('Gloomhaven'),
                  onTap: () =>
                      context.read<CharactersModel>().createCharactersTest(
                        classCategory: ClassCategory.gloomhaven,
                      ),
                ),
                ListTile(
                  title: const Text('Gloomhaven & variants'),
                  onTap: () =>
                      context.read<CharactersModel>().createCharactersTest(
                        classCategory: ClassCategory.gloomhaven,
                        includeAllVariants: true,
                      ),
                ),
                ListTile(
                  title: const Text('Frosthaven'),
                  onTap: () =>
                      context.read<CharactersModel>().createCharactersTest(
                        classCategory: ClassCategory.frosthaven,
                      ),
                ),
                ListTile(
                  title: const Text('Frosthaven & variants'),
                  onTap: () =>
                      context.read<CharactersModel>().createCharactersTest(
                        classCategory: ClassCategory.frosthaven,
                        includeAllVariants: true,
                      ),
                ),
                ListTile(
                  title: const Text('Crimson Scales'),
                  onTap: () =>
                      context.read<CharactersModel>().createCharactersTest(
                        classCategory: ClassCategory.crimsonScales,
                      ),
                ),
                ListTile(
                  title: const Text('Crimson Scales & variants'),
                  onTap: () =>
                      context.read<CharactersModel>().createCharactersTest(
                        classCategory: ClassCategory.crimsonScales,
                        includeAllVariants: true,
                      ),
                ),
                ListTile(
                  title: const Text('Custom'),
                  onTap: () =>
                      context.read<CharactersModel>().createCharactersTest(
                        classCategory: ClassCategory.custom,
                      ),
                ),
                ListTile(
                  title: const Text('Custom & variants'),
                  onTap: () =>
                      context.read<CharactersModel>().createCharactersTest(
                        classCategory: ClassCategory.custom,
                        includeAllVariants: true,
                      ),
                ),
              ],
              const SizedBox(height: smallPadding),
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
              return Column(
                children: [
                  const Text('Support & Feedback', textAlign: TextAlign.center),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      IconButton(
                        icon: const FaIcon(FontAwesomeIcons.discord),
                        onPressed: () {
                          _launchURL(
                            Uri(
                              scheme: 'https',
                              host: 'discord.gg',
                              path: 'UwuGf4hdnA',
                            ),
                          );
                        },
                      ),
                      IconButton(
                        icon: const FaIcon(FontAwesomeIcons.instagram),
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
                        icon: const Icon(Icons.email),
                        onPressed: () async {
                          final deviceInfo = await _getDeviceInfo();
                          final appVersion = snapshot.data != null
                              ? '${snapshot.data!.version}+${snapshot.data!.buildNumber}'
                              : 'Unknown';

                          final emailBody =
                              '''
App Version: $appVersion
Platform: ${Platform.isIOS ? 'iOS' : 'Android'}
$deviceInfo

--- Please describe your issue or provide your feedback below ---

''';

                          await _launchURL(
                            Uri.parse(
                              'mailto:tomkatcreative@gmail.com'
                              '?subject=${Uri.encodeComponent('GHC Support & Feedback')}'
                              '&body=${Uri.encodeComponent(emailBody)}',
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                  if (kDebugMode ||
                      (Platform.isAndroid && SharedPrefs().isUSRegion))
                    IconButton(
                      icon: SvgPicture.asset(
                        'images/bmc-button.svg',
                        height: 32,
                      ),
                      tooltip: 'Buy Me a Coffee',
                      onPressed: () {
                        _launchURL(
                          Uri(
                            scheme: 'https',
                            host: 'buymeacoffee.com',
                            path: '/tomkatcreative',
                          ),
                        );
                      },
                    ),
                  Padding(
                    padding: const EdgeInsets.only(
                      bottom: smallPadding,
                      right: smallPadding,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'v${snapshot.data!.version} ',
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 16,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const ChangelogScreen(),
                              ),
                            );
                          },
                          child: const Text(
                            'Changelog',
                            style: TextStyle(color: Colors.blue, fontSize: 16),
                          ),
                        ),
                        const Text(
                          ' • ',
                          style: TextStyle(color: Colors.grey, fontSize: 16),
                        ),
                        GestureDetector(
                          onTap: () {
                            _launchURL(
                              Uri.parse(
                                'https://creativecommons.org/licenses/by-nc-sa/4.0/',
                              ),
                            );
                          },
                          child: const Text(
                            'License',
                            style: TextStyle(color: Colors.blue, fontSize: 16),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
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
              constraints: const BoxConstraints(maxWidth: maxDialogWidth),
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
    ? await launchUrl(uri, mode: LaunchMode.externalApplication)
    : await launchUrl(uri);

Future<String> _getDeviceInfo() async {
  final deviceInfo = DeviceInfoPlugin();

  if (Platform.isIOS) {
    final iosInfo = await deviceInfo.iosInfo;
    return 'Device: ${iosInfo.utsname.machine}\n'
        'OS Version: iOS ${iosInfo.systemVersion}';
  } else if (Platform.isAndroid) {
    final androidInfo = await deviceInfo.androidInfo;
    return 'Device: ${androidInfo.manufacturer} ${androidInfo.model}\n'
        'OS Version: Android ${androidInfo.version.release} (SDK ${androidInfo.version.sdkInt})';
  }

  return 'Device: Unknown';
}

class SettingsSection extends StatelessWidget {
  final String title;
  const SettingsSection({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Text(
        title,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
    );
  }
}
