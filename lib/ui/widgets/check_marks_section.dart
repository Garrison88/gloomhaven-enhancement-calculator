// import 'package:flutter/material.dart';
// import 'package:gloomhaven_enhancement_calc/ui/widgets/check_mark_row.dart';

// class CheckMarksSection extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return CustomScrollView(
//       slivers: <Widget>[
        
//       ],
//     );
//     // return CustomScrollView(slivers: <Widget>[
//     //   SliverList(
//     //     delegate: SliverChildListDelegate([
//     //       SliverGrid(
//     //           gridDelegate:
//     //               SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
//     //           delegate:
//     //               SliverChildBuilderDelegate((BuildContext context, int index) {
//     //             return Card(
//     //               child: Container(
//     //                 // padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
//     //                 child: Row(
//     //                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//     //                   children: <Widget>[
//     //                     Checkbox(
//     //                       onChanged: (_) => null,
//     //                       value: false,
//     //                     ),
//     //                     Checkbox(
//     //                       onChanged: (_) => null,
//     //                       value: true,
//     //                     ),
//     //                     Checkbox(
//     //                       onChanged: (_) => null,
//     //                       value: false,
//     //                     ),
//     //                     // Text(subjectList[index]["topic"],
//     //                     //     style: Theme.of(context)
//     //                     //         .textTheme
//     //                     //         .title
//     //                     //         .merge(TextStyle(fontSize: 14.0)))
//     //                   ],
//     //                 ),
//     //               ),
//     //             );
//     //           }, childCount: 6))
//     //     ]),
//     //   )
//     // ]);
//   }

//   // children: <Widget>[
//   //   List<CheckMarkRow>.generate(6, (generator) => )
//   //   Expanded(
//   //     child: Column(
//   //       mainAxisAlignment: MainAxisAlignment.start,
//   //       children: <Widget>[
//   //         Card(
//   //           child: Row(
//   //             mainAxisAlignment:
//   //                 MainAxisAlignment.spaceEvenly,
//   //             children: <Widget>[
//   //               Checkbox(
//   //                 value: _firstCheck,
//   //                 onChanged: (bool value) =>
//   //                     setState(() {
//   //                   _firstCheck = value;
//   //                   _secondCheck = false;
//   //                   _thirdCheck = false;
//   //                 }),
//   //               ),
//   //               Checkbox(
//   //                 value: _secondCheck,
//   //                 onChanged: (bool value) =>
//   //                     setState(() {
//   //                   _firstCheck = true;
//   //                   _secondCheck = value;
//   //                   _thirdCheck = false;
//   //                 }),
//   //               ),
//   //               Checkbox(
//   //                 value: _thirdCheck,
//   //                 onChanged: (bool value) =>
//   //                     setState(() {
//   //                   _firstCheck = true;
//   //                   _secondCheck = true;
//   //                   _thirdCheck = value;
//   //                 }),
//   //               )
//   //             ],
//   //           ),
//   //         ),
//   //         Card(
//   //           child: Row(
//   //             mainAxisAlignment:
//   //                 MainAxisAlignment.spaceEvenly,
//   //             children: <Widget>[
//   //               Checkbox(
//   //                 value: _2FirstCheck,
//   //                 onChanged: (bool value) =>
//   //                     setState(() {
//   //                   _2FirstCheck = value;
//   //                   _2SecondCheck = false;
//   //                   _2ThirdCheck = false;
//   //                 }),
//   //               ),
//   //               Checkbox(
//   //                 value: _2SecondCheck,
//   //                 onChanged: (bool value) =>
//   //                     setState(() {
//   //                   _2FirstCheck = true;
//   //                   _2SecondCheck = value;
//   //                   _2ThirdCheck = false;
//   //                 }),
//   //               ),
//   //               Checkbox(
//   //                 value: _2ThirdCheck,
//   //                 onChanged: (bool value) =>
//   //                     setState(() {
//   //                   _2FirstCheck = true;
//   //                   _2SecondCheck = true;
//   //                   _2ThirdCheck = value;
//   //                 }),
//   //               )
//   //             ],
//   //           ),
//   //         ),
//   //         Card(
//   //           child: Row(
//   //             mainAxisAlignment:
//   //                 MainAxisAlignment.spaceEvenly,
//   //             children: <Widget>[
//   //               Checkbox(
//   //                 value: _3FirstCheck,
//   //                 onChanged: (bool value) =>
//   //                     setState(() {
//   //                   _3FirstCheck = value;
//   //                   _3SecondCheck = false;
//   //                   _3ThirdCheck = false;
//   //                 }),
//   //               ),
//   //               Checkbox(
//   //                 value: _3SecondCheck,
//   //                 onChanged: (bool value) =>
//   //                     setState(() {
//   //                   _3FirstCheck = true;
//   //                   _3SecondCheck = value;
//   //                   _3ThirdCheck = false;
//   //                 }),
//   //               ),
//   //               Checkbox(
//   //                 value: _3ThirdCheck,
//   //                 onChanged: (bool value) =>
//   //                     setState(() {
//   //                   _3FirstCheck = true;
//   //                   _3SecondCheck = true;
//   //                   _3ThirdCheck = value;
//   //                 }),
//   //               )
//   //             ],
//   //           ),
//   //         ),
//   //       ],
//   //     ),
//   //   ),
//   //   Expanded(
//   //       child: Column(
//   //     children: <Widget>[
//   //       Card(
//   //         child: Row(
//   //           mainAxisAlignment:
//   //               MainAxisAlignment.spaceEvenly,
//   //           children: <Widget>[
//   //             Checkbox(
//   //               value: _4FirstCheck,
//   //               onChanged: (bool value) => setState(() {
//   //                 _4FirstCheck = value;
//   //                 _4SecondCheck = false;
//   //                 _4ThirdCheck = false;
//   //               }),
//   //             ),
//   //             Checkbox(
//   //               value: _4SecondCheck,
//   //               onChanged: (bool value) => setState(() {
//   //                 _4FirstCheck = true;
//   //                 _4SecondCheck = value;
//   //                 _4ThirdCheck = false;
//   //               }),
//   //             ),
//   //             Checkbox(
//   //               value: _4ThirdCheck,
//   //               onChanged: (bool value) => setState(() {
//   //                 _4FirstCheck = true;
//   //                 _4SecondCheck = true;
//   //                 _4ThirdCheck = value;
//   //               }),
//   //             )
//   //           ],
//   //         ),
//   //       ),
//   //       Card(
//   //         child: Row(
//   //           mainAxisAlignment:
//   //               MainAxisAlignment.spaceEvenly,
//   //           children: <Widget>[
//   //             Checkbox(
//   //               value: _5FirstCheck,
//   //               onChanged: (bool value) => setState(() {
//   //                 _5FirstCheck = value;
//   //                 _5SecondCheck = false;
//   //                 _5ThirdCheck = false;
//   //               }),
//   //             ),
//   //             Checkbox(
//   //               value: _5SecondCheck,
//   //               onChanged: (bool value) => setState(() {
//   //                 _5FirstCheck = true;
//   //                 _5SecondCheck = value;
//   //                 _5ThirdCheck = false;
//   //               }),
//   //             ),
//   //             Checkbox(
//   //               value: _5ThirdCheck,
//   //               onChanged: (bool value) => setState(() {
//   //                 _5FirstCheck = true;
//   //                 _5SecondCheck = true;
//   //                 _5ThirdCheck = value;
//   //               }),
//   //             )
//   //           ],
//   //         ),
//   //       ),
//   //       Card(
//   //         child: Row(
//   //           mainAxisAlignment:
//   //               MainAxisAlignment.spaceEvenly,
//   //           children: <Widget>[
//   //             Checkbox(
//   //               value: _6FirstCheck,
//   //               onChanged: (bool value) => setState(() {
//   //                 _6FirstCheck = value;
//   //                 _6SecondCheck = false;
//   //                 _6ThirdCheck = false;
//   //               }),
//   //             ),
//   //             Checkbox(
//   //               value: _6SecondCheck,
//   //               onChanged: (bool value) => setState(() {
//   //                 _6FirstCheck = true;
//   //                 _6SecondCheck = value;
//   //                 _6ThirdCheck = false;
//   //               }),
//   //             ),
//   //             Checkbox(
//   //               value: _6ThirdCheck,
//   //               onChanged: (bool value) => setState(() {
//   //                 _6FirstCheck = true;
//   //                 _6SecondCheck = true;
//   //                 _6ThirdCheck = value;
//   //               }),
//   //             )
//   //           ],
//   //         ),
//   //       ),
//   //     ],
//   //   ))
//   // ],
// //   ),
// // );
// //   }

// }
