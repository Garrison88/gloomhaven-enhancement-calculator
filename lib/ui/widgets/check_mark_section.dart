// import 'package:auto_size_text/auto_size_text.dart';
// import 'package:flutter/material.dart';
// import 'package:gloomhaven_enhancement_calc/data/constants.dart';
// import 'package:gloomhaven_enhancement_calc/providers/character_state.dart';
// import 'package:provider/provider.dart';

// class CheckMarkSection extends StatefulWidget {
//   @override
//   _CheckMarkSectionState createState() => _CheckMarkSectionState();
// }

// class _CheckMarkSectionState extends State<CheckMarkSection> {
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: <Widget>[
//         Container(
//           padding: EdgeInsets.all(smallPadding),
//           child: AutoSizeText(
//             'Battle Goal Checkmarks',
//             textAlign: TextAlign.center,
//             minFontSize: titleFontSize,
//           ),
//         ),
//         Row(
//           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//           children: <Widget>[
//             RaisedButton(
//               shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(30.0)),
//               elevation: 5.0,
//               color: Theme.of(context).accentColor,
//               onPressed: () => Provider.of<CharacterState>(context, listen: false).decreaseCheckmark(_character),
//               child: Icon(Icons.remove),
//             ),
//             Row(
//               children: <Widget>[
//                 Text(
//                   '${Provider.of<CharacterState>(context, listen: false).character.checkMarks} ',
//                   style: TextStyle(fontSize: titleFontSize),
//                 ),
//                 Text('/ 18'),
//               ],
//             ),
//             RaisedButton(
//                 shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(30.0)),
//                 elevation: 5.0,
//                 color: Theme.of(context).accentColor,
//                 onPressed: () => null,
//                 child: Icon(Icons.add))
//           ],
//         )
//         // Container(
//         //   padding: EdgeInsets.only(
//         //       left: MediaQuery.of(context).size.width / 4,
//         //       right: MediaQuery.of(context).size.width / 4),
//         //   child: GridView.builder(
//         //     physics: NeverScrollableScrollPhysics(),
//         //     shrinkWrap: true,
//         //     itemCount: 18,
//         //     gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//         //         crossAxisCount: 3, childAspectRatio: 1),
//         //     itemBuilder: (context, index) {
//         //       // return CheckMarkRow(index);
//         //       // for(var x = 0; x < characterState.character.checkMarks; x++)
//         //       return Checkbox(
//         //         value: false,
//         //         onChanged: (_) => null,
//         //       );
//         //     },
//         //   ),
//         // )
//       ],
//     );
//   }
// }
