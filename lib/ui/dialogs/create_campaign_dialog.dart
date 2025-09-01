import 'package:flutter/material.dart';
import 'package:gloomhaven_enhancement_calc/models/player_class.dart';

class CreateCampaignDialog extends StatefulWidget {
  final Function(
    String name,
    Variant variant,
  ) onCreateCampaign;

  const CreateCampaignDialog({
    super.key,
    required this.onCreateCampaign,
  });

  @override
  State<CreateCampaignDialog> createState() => _CreateCampaignDialogState();
}

class _CreateCampaignDialogState extends State<CreateCampaignDialog> {
  final _formKey = GlobalKey<FormState>();
  final _partyNameController = TextEditingController();
  Variant _selectedVariant = Variant.base;

  @override
  void dispose() {
    _partyNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Create New Campaign'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _partyNameController,
              decoration: const InputDecoration(
                labelText: 'Party Name',
                hintText: 'Enter your party name',
                prefixIcon: Icon(Icons.group),
              ),
              textCapitalization: TextCapitalization.words,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter a party name';
                }
                if (value.trim().length > 50) {
                  return 'Party name is too long';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<Variant>(
              value: _selectedVariant,
              decoration: const InputDecoration(
                labelText: 'Game Version',
                prefixIcon: Icon(Icons.gamepad),
              ),
              items: [
                DropdownMenuItem(
                  value: Variant.base,
                  child: const Text('Gloomhaven'),
                ),
                if (Variant.values.contains(Variant.jotl))
                  DropdownMenuItem(
                    value: Variant.jotl,
                    child: const Text('Jaws of the Lion'),
                  ),
                if (Variant.values.any((v) => v.name == 'frosthaven'))
                  DropdownMenuItem(
                    value: Variant.values
                        .firstWhere((v) => v.name == 'frosthaven'),
                    child: const Text('Frosthaven'),
                  ),
              ],
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _selectedVariant = value;
                  });
                }
              },
            ),
            const SizedBox(height: 8),
            Text(
              'You can switch between campaigns at any time',
              style: Theme.of(context).textTheme.bodySmall,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              widget.onCreateCampaign(
                _partyNameController.text.trim(),
                _selectedVariant,
              );
              Navigator.pop(context);
            }
          },
          child: const Text('Create'),
        ),
      ],
    );
  }
}
