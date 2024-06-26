import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../data/constants.dart';

class AddSubtractDialog extends StatefulWidget {
  const AddSubtractDialog(
    this.currentValue,
    this.hintText, {
    super.key,
  });

  final int currentValue;
  final String hintText;

  @override
  AddSubtractDialogState createState() => AddSubtractDialogState();
}

class AddSubtractDialogState extends State<AddSubtractDialog> {
  final TextEditingController _addSubtractTextEditingController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Container(
        constraints: const BoxConstraints(
          maxWidth: maxDialogWidth,
          minWidth: maxDialogWidth,
        ),
        // padding: const EdgeInsets.all(
        //   smallPadding,
        //   // top: smallPadding,
        //   // bottom: smallPadding,
        // ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
                'Enter a value, then tap the minus button to subtract it from your current ${widget.hintText}, or the plus button to add it to your current ${widget.hintText}'),
            Row(
              children: <Widget>[
                Expanded(
                  child: IconButton(
                    icon: const Icon(
                      Icons.remove_circle,
                    ),
                    onPressed: _addSubtractTextEditingController.text.isNotEmpty
                        ? () => Navigator.pop(
                              context,
                              widget.currentValue -
                                  int.parse(
                                    _addSubtractTextEditingController.text,
                                  ),
                            )
                        : null,
                  ),
                ),
                Expanded(
                  child: TextField(
                    onChanged: (value) {
                      setState(() {});
                    },
                    enableInteractiveSelection: false,
                    inputFormatters: [
                      FilteringTextInputFormatter.deny(
                          RegExp('[\\.|\\,|\\ |\\-]'))
                    ],
                    keyboardType: TextInputType.number,
                    autofocus: true,
                    decoration: InputDecoration(
                      hintText: widget.hintText,
                      border: const OutlineInputBorder(),
                    ),
                    controller: _addSubtractTextEditingController,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontSize: titleFontSize,
                        ),
                  ),
                ),
                Expanded(
                  child: IconButton(
                    icon: const Icon(
                      Icons.add_circle,
                    ),
                    onPressed: _addSubtractTextEditingController.text.isNotEmpty
                        ? () => Navigator.pop(
                              context,
                              widget.currentValue +
                                  int.parse(
                                    _addSubtractTextEditingController.text,
                                  ),
                            )
                        : null,
                  ),
                )
              ],
            ),
            const SizedBox(height: smallPadding),
          ],
        ),
      ),
    );
  }
}
