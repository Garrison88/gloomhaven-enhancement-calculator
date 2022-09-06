// // database table and column names

// const String tableCharacterResources = 'CharacterResources';
// const String columnAssociatedCharacterId = 'CharacterID';
// const String columnAssociatedResourceId = 'ResourceID';
// const String columnResourceQuantity = 'ResourceQuantity';

// // data model class
// class CharacterResource {
//   int associatedCharacterId;
//   int associatedResourceId;
//   int resourceQuantity = 0;

//   CharacterResource(
//     this.associatedCharacterId,
//     this.associatedResourceId,
//     this.resourceQuantity,
//   );

//   // convenience constructor to create a CharacterResources object
//   CharacterResource.fromMap(Map<String, dynamic> map) {
//     associatedCharacterId = map[columnAssociatedCharacterId];
//     associatedResourceId = map[columnAssociatedResourceId];
//     resourceQuantity = map[columnResourceQuantity];
//   }

//   // convenience method to create a Map from this CharacterResources object
//   Map<String, dynamic> toMap() {
//     var map = <String, dynamic>{
//       columnAssociatedCharacterId: associatedCharacterId,
//       columnAssociatedResourceId: associatedResourceId,
//       columnResourceQuantity: resourceQuantity,
//     };
//     return map;
//   }
// }
