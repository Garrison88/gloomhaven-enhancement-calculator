// import 'package:flutter/material.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import '../../models/resource.dart';
// import '../../data/constants.dart';
// import '../../shared_prefs.dart';
// import '../../viewmodels/character_model.dart';
// import 'package:provider/provider.dart';

// class ResourceCard extends StatelessWidget {
//   final Resource resource;
//   final int count;
//   final Function() increaseCount;
//   final Function() decreaseCount;
//   const ResourceCard({
//     Key key,
//     this.resource,
//     this.count,
//     this.increaseCount,
//     this.decreaseCount,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     CharacterModel characterModel = context.watch<CharacterModel>();
//     return SizedBox(
//       height: characterModel.isEditable ? 90 : 50,
//       width: 100,
//       child: Stack(
//         alignment: characterModel.isEditable
//             ? AlignmentDirectional.topStart
//             : Alignment.centerRight,
//         children: <Widget>[
//           ResourceDetails(
//             name: resource.name,
//             count: count,
//             decreaseCount: decreaseCount,
//             increaseCount: increaseCount,
//             characterModel: characterModel,
//           ),
//           Align(
//             alignment: characterModel.isEditable
//                 ? Alignment.topLeft
//                 : Alignment.centerLeft,
//             child: ResourceIcon(
//               iconPath: resource.icon,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class ResourceIcon extends StatelessWidget {
//   final String iconPath;
//   const ResourceIcon({
//     Key key,
//     this.iconPath,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       child: SvgPicture.asset(
//         iconPath,
//         color: SharedPrefs().darkTheme ? Colors.white : Colors.black87,
//         height: iconSize,
//         width: iconSize,
//       ),
//     );
//   }
// }

// class ResourceDetails extends StatelessWidget {
//   final String name;
//   final int count;
//   final Function() decreaseCount;
//   final Function() increaseCount;
//   final CharacterModel characterModel;
//   const ResourceDetails({
//     Key key,
//     this.name,
//     this.count,
//     this.decreaseCount,
//     this.increaseCount,
//     this.characterModel,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       width: characterModel.isEditable ? 100 : 65,
//       child: Card(
//         child: Stack(
//           children: [
//             Center(
//               child: Text('$count'),
//             ),
//             if (characterModel.isEditable)
//               Positioned(
//                 bottom: -smallPadding,
//                 left: -2,
//                 child: IconButton(
//                   onPressed: () => decreaseCount(),
//                   icon: const Icon(
//                     Icons.remove_circle,
//                   ),
//                 ),
//               ),
//             if (characterModel.isEditable)
//               Positioned(
//                 bottom: -smallPadding,
//                 right: -2,
//                 child: IconButton(
//                   onPressed: () => increaseCount(),
//                   icon: const Icon(
//                     Icons.add_circle,
//                   ),
//                 ),
//               ),
//           ],
//         ),
//       ),
//     );
//   }
// }
