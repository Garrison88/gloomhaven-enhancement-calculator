// import 'package:flutter/material.dart';
// import '../../data/constants.dart';

// class AddSubtractButton extends StatelessWidget {
//   AddSubtractButton({this.onTap});

//   final Function onTap;

//   @override
//   Widget build(BuildContext context) {
//     return InkWell(
//       child: Padding(
//         padding: const EdgeInsets.all(smallPadding),
//         child: Center(
//           child: Row(
//             children: <Widget>[
//               Icon(
//                 Icons.remove_circle,
//                 color: Theme.of(context).colorScheme.secondary,
//                 size: 15,
//               ),
//               Text(
//                 '/',
//                 style: TextStyle(
//                   color: Theme.of(context).colorScheme.secondary,
//                 ),
//               ),
//               Icon(
//                 Icons.add_circle,
//                 color: Theme.of(context).colorScheme.secondary,
//                 size: 15,
//               ),
//             ],
//           ),
//         ),
//       ),
//       onTap: onTap,
//     );
//   }
// }
