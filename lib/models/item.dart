import 'package:gloomhaven_companion/models/slot.dart';

class Item {
  String _name;
  int _price;
  Slot _slot;

  Item(this._name, this._price, this._slot);

  Item.fromJson(Map<String, dynamic> i) {
    _name = i['name'];
    _price = i['price'];
    _slot = i['slot'];
  }

  String get name => _name;

  int get price => _price;

  Slot get slot => _slot;

  Map<String, dynamic> toJson() => {
        'name': _name,
        'price': _price,
        'slot': _slot,
      };
}
