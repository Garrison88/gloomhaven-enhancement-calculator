// Create a map of resource fields to their corresponding properties
import 'package:gloomhaven_enhancement_calc/models/character.dart';

// Helper class to store resource field data
class ResourceFieldData {
  final int resourceIndex;
  final int Function(Character) getter;
  final void Function(Character, int) setter;

  ResourceFieldData({
    required this.resourceIndex,
    required this.getter,
    required this.setter,
  });
}

final Map<String, ResourceFieldData> resourceFields = {
  'resourceLumber': ResourceFieldData(
    resourceIndex: 0,
    getter: (character) => character.resourceLumber,
    setter: (character, value) => character.resourceLumber = value,
  ),
  'resourceMetal': ResourceFieldData(
    resourceIndex: 1,
    getter: (character) => character.resourceMetal,
    setter: (character, value) => character.resourceMetal = value,
  ),
  'resourceHide': ResourceFieldData(
    resourceIndex: 2,
    getter: (character) => character.resourceHide,
    setter: (character, value) => character.resourceHide = value,
  ),
  'resourceArrowvine': ResourceFieldData(
    resourceIndex: 3,
    getter: (character) => character.resourceArrowvine,
    setter: (character, value) => character.resourceArrowvine = value,
  ),
  'resourceAxenut': ResourceFieldData(
    resourceIndex: 4,
    getter: (character) => character.resourceAxenut,
    setter: (character, value) => character.resourceAxenut = value,
  ),
  'resourceCorpsecap': ResourceFieldData(
    resourceIndex: 5,
    getter: (character) => character.resourceCorpsecap,
    setter: (character, value) => character.resourceCorpsecap = value,
  ),
  'resourceFlamefruit': ResourceFieldData(
    resourceIndex: 6,
    getter: (character) => character.resourceFlamefruit,
    setter: (character, value) => character.resourceFlamefruit = value,
  ),
  'resourceRockroot': ResourceFieldData(
    resourceIndex: 7,
    getter: (character) => character.resourceRockroot,
    setter: (character, value) => character.resourceRockroot = value,
  ),
  'resourceSnowthistle': ResourceFieldData(
    resourceIndex: 8,
    getter: (character) => character.resourceSnowthistle,
    setter: (character, value) => character.resourceSnowthistle = value,
  ),
};
