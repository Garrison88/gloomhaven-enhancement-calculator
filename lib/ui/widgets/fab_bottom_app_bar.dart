// import 'package:flutter/material.dart';

// class FABBottomAppBarItem {
//   FABBottomAppBarItem({this.icon, this.text = ''});
//   Icon icon;
//   String text;
// }

// class FABBottomAppBar extends StatefulWidget {
//   FABBottomAppBar({
//     this.items,
//     this.centerItemText,
//     // this.height = 56.0,
//     this.iconSize = 24.0,
//     this.backgroundColor,
//     this.color,
//     this.selectedColor,
//     this.onTabSelected,
//   }) {
//     assert(items.length == 2 || items.length == 4);
//   }
//   final List<FABBottomAppBarItem> items;
//   final String centerItemText;
//   // final double height;
//   final double iconSize;
//   final Color backgroundColor;
//   final Color color;
//   final Color selectedColor;
//   final ValueChanged<int> onTabSelected;

//   @override
//   State<StatefulWidget> createState() => FABBottomAppBarState();
// }

// class FABBottomAppBarState extends State<FABBottomAppBar> {
//   // int _selectedIndex = 0;

//   // _updateIndex(int index) {
//   //   widget.onTabSelected(index);
//   //   setState(() {
//   //     _selectedIndex = index;
//   //   });
//   // }

//   @override
//   Widget build(BuildContext context) {
//     List<Widget> items = List.generate(
//       widget.items.length,
//       (int index) {
//         return _buildTabItem(
//           item: widget.items[index],
//           index: index,
//           onPressed: widget.onTabSelected,
//         );
//       },
//     );
//     items.insert(
//       1,
//       SizedBox(
//         width: MediaQuery.of(context).size.width / 16,
//       ),
//     );

//     return BottomAppBar(
//       clipBehavior: Clip.antiAlias,
//       shape: const CircularNotchedRectangle(),
//       child: Row(
//         mainAxisSize: MainAxisSize.max,
//         mainAxisAlignment: MainAxisAlignment.spaceAround,
//         children: items,
//       ),
//       color: widget.backgroundColor,
//     );
//   }

//   // Widget _buildMiddleTabItem() {
//   //   return Expanded(
//   //     child: SizedBox(
//   //       width: 56,
//   //       height: widget.height,
//   //       child: Column(
//   //         mainAxisSize: MainAxisSize.min,
//   //         mainAxisAlignment: MainAxisAlignment.center,
//   //         children: <Widget>[
//   //           SizedBox(height: 30),
//   //           // Text(
//   //           //   Provider.of<CharactersModel>(context, listen: false)
//   //           //           .characters
//   //           //           .isEmpty
//   //           //       ? ''
//   //           //       : 'EDIT',
//   //           //   style: Theme.of(context).textTheme.bodyText1,
//   //           // ),
//   //         ],
//   //       ),
//   //     ),
//   //   );
//   // }

//   Widget _buildTabItem({
//     FABBottomAppBarItem item,
//     int index,
//     ValueChanged<int> onPressed,
//   }) {
//     // Color color = _selectedIndex == index ? widget.selectedColor : widget.color;
//     return Expanded(
//       child: SizedBox(
//         height: 64,
//         child: Material(
//           type: MaterialType.transparency,
//           child: Stack(
//             alignment: Alignment.center,
//             // mainAxisSize: MainAxisSize.min,
//             children: [
//               Positioned(
//                 top: -2,
//                 child: IconButton(
//                   onPressed: () => onPressed(index),
//                   icon: item.icon,
//                   // child: Column(
//                   //   // mainAxisSize: MainAxisSize.min,
//                   //   // mainAxisAlignment: MainAxisAlignment.center,
//                   //   mainAxisAlignment: MainAxisAlignment.center,
//                   //   mainAxisSize: MainAxisSize.max,
//                   //   children: <Widget>[
//                   //     item.icon,
//                   //     // Text(
//                   //     //   item.text,
//                   //     //   style: Theme.of(context).textTheme.bodyText1,
//                   //     // )
//                   //   ],
//                   // ),
//                 ),
//               ),
//               Positioned(
//                 bottom: 10,
//                 child: Text(
//                   item.text,
//                   style: Theme.of(context).textTheme.bodyText1,
//                 ),
//               )
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
