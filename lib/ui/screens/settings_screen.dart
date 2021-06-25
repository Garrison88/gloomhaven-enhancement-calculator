import 'dart:ui';

import 'package:easy_dynamic_theme/easy_dynamic_theme.dart';
import 'package:flutter/material.dart';
import 'package:gloomhaven_enhancement_calc/shared_prefs.dart';
import 'package:flutter_svg_provider/flutter_svg_provider.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Settings',
          style: TextStyle(
            fontSize: 25.0,
          ),
        ),
      ),
      body: ListView(children: <Widget>[
        SwitchListTile(
            title: const Text('Theme'),
            subtitle: SharedPrefs().darkTheme
                ? const Text('Dark')
                : const Text('Light'),
            // activeThumbImage: AssetImage('images/elem_dark.svg'),
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
        SettingsDivider(),
        SwitchListTile(
            title: const Text('Inline Icons'),
            subtitle: const Text('Show icons in perk rows'),
            value: SharedPrefs().showPerkImages,
            onChanged: (val) {
              setState(() {
                SharedPrefs().showPerkImages = val;
              });
            }),
        SettingsDivider(),
        SwitchListTile(
            subtitle: const Text('Gloomhaven'),
            title: const Text("Open 'Envelope X'"),
            value: SharedPrefs().envelopeX,
            onChanged: (val) {
              setState(() {
                SharedPrefs().envelopeX = val;
              });
            }),
        SettingsDivider(),
        SwitchListTile(
            subtitle: const Text('Forgotten Circles'),
            title: const Text('Scenario 114 Reward'),
            value: SharedPrefs().partyBoon,
            onChanged: (val) {
              setState(() {
                SharedPrefs().partyBoon = val;
              });
            }),
        SettingsDivider(),
        SwitchListTile(
            subtitle: const Text(
                "Include 'released' classes created by the community"),
            title: const Text('Custom Classes'),
            value: SharedPrefs().customClasses,
            onChanged: (val) {
              setState(() {
                SharedPrefs().customClasses = val;
              });
            }),
      ]),
    );
  }
}

class SettingsDivider extends StatelessWidget {
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
