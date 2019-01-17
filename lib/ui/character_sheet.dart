import 'package:flutter/material.dart';

class CharacterSheetPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return CharacterSheetPageState();
  }
}

class CharacterSheetPageState extends State<CharacterSheetPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      body: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints viewportConstraints) {
        return SingleChildScrollView(
            child: ConstrainedBox(
          constraints: BoxConstraints(minHeight: viewportConstraints.maxHeight),
          child: IntrinsicHeight(
            child: Container(
              child: Column(
                children: <Widget>[Text('HellO??')],
              ),
            ),
          ),
        ));
      }),
    );
  }
}
