//import 'package:flutter/material.dart';
//import 'package:gloomhaven_enhancement_calc/data/character_sheet_list_data.dart';
//import 'package:gloomhaven_enhancement_calc/data/constants.dart';
//import 'package:gloomhaven_enhancement_calc/models/item.dart';
//import 'package:gloomhaven_enhancement_calc/models/slot.dart';
//
//class AddItemDialog extends StatefulWidget {
//  const AddItemDialog({this.onValueChange, this.initialValue, this.onSave});
//
//  final Slot initialValue;
//  final void Function(Slot) onValueChange;
//  final void Function(Item) onSave;
//
//  @override
//  State createState() => AddItemDialogState();
//}
//
//class AddItemDialogState extends State<AddItemDialog> {
//  Slot _selectedSlot;
//  TextEditingController _itemNameController = TextEditingController();
//  TextEditingController _itemCostController = TextEditingController();
//
//  @override
//  void initState() {
//    super.initState();
//    _selectedSlot = widget.initialValue;
//  }
//
//  Widget build(BuildContext context) {
//    return AlertDialog(
//      title: Center(
//        child: Text(
//          'Add Item',
//          style: TextStyle(fontSize: titleFontSize),
//        ),
//      ),
//      content: SingleChildScrollView(
//          child: Column(children: <Widget>[
//        TextField(controller: _itemNameController,style: TextStyle(fontFamily: secondaryFontFamily)),
//        Row(
//          children: <Widget>[
//            Expanded(
//                flex: 2,
//                child: DropdownButtonHideUnderline(child: DropdownButton<Slot>(
//                  hint: Text(
//                    'Slot',
//                    style: TextStyle(fontFamily: secondaryFontFamily),
//                  ),
//                  value: _selectedSlot,
//                  onChanged: (Slot value) {
//                    setState(() {
//                      _selectedSlot = value;
//                    });
//                    widget.onValueChange(value);
//                  },
//                  items: slotListMenuItems,
//                ),),
//                ),
//            Expanded(
//              flex: 1,
//              child: TextField(
//                controller: _itemCostController,
//                keyboardType: TextInputType.numberWithOptions(decimal: false),
//              ),
//            )
//          ],
//        ),
//      ])),
//      actions: <Widget>[
//        new FlatButton(
//          child: new Text("Add"),
//          onPressed: () {
//            widget.onSave(Item(_itemNameController.text,
//                int.parse(_itemCostController.text), _selectedSlot));
//            Navigator.of(context).pop();
//          },
//        ),
//        FlatButton(
//          child: new Text("Cancel"),
//          onPressed: () {
//            Navigator.of(context).pop();
//          },
//        ),
//      ],
//    );
//  }
//
//  @override
//  void dispose() {
//    _itemCostController.dispose();
//    _itemNameController.dispose();
//    super.dispose();
//  }
//}
