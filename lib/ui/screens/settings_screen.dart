import 'package:easy_dynamic_theme/easy_dynamic_theme.dart';
import 'package:flutter/material.dart';
import 'package:gloomhaven_enhancement_calc/shared_prefs.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Settings',
          style: TextStyle(
            fontSize: 25.0,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: ListView(children: <Widget>[
          SwitchListTile(
              title: Text('Theme'),
              subtitle: SharedPrefs().darkTheme ? Text('Dark') : Text('Light'),
              activeThumbImage: AssetImage('images/elem_dark.png'),
              activeColor: Color(0xff1f272e),
              inactiveThumbColor: Color(0xffeda50b),
              inactiveTrackColor: Color(0xffeda50b).withOpacity(0.75),
              activeTrackColor: Colors.black12,
              inactiveThumbImage: AssetImage('images/elem_light.png'),
              value: SharedPrefs().darkTheme,
              onChanged: (val) {
                SharedPrefs().darkTheme = val;
                EasyDynamicTheme.of(context).changeTheme(dynamic: true);
              }),
          SettingsDivider(),
          SwitchListTile(
              title: Text('Inline Icons'),
              subtitle: Text('Show icons in perk rows'),
              value: SharedPrefs().showPerkImages,
              onChanged: (val) {
                setState(() {
                  SharedPrefs().showPerkImages = val;
                });
              }),
          SettingsDivider(),
          SwitchListTile(
              subtitle: Text('Gloomhaven'),
              title: Text("Open 'Envelope X'"),
              value: SharedPrefs().envelopeX,
              onChanged: (val) {
                setState(() {
                  SharedPrefs().envelopeX = val;
                });
              }),
          SettingsDivider(),
          SwitchListTile(
              subtitle: Text('Forgotten Circles'),
              title: Text('Scenario 114 Reward'),
              value: SharedPrefs().partyBoon,
              onChanged: (val) {
                setState(() {
                  SharedPrefs().partyBoon = val;
                });
              }),
        ]),
      ),
    );
  }
}

class SettingsDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: Divider(
        endIndent: 8,
        indent: 8,
        height: 1,
      ),
    );
  }
}
