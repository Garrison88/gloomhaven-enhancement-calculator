// import 'package:easy_dynamic_theme/easy_dynamic_theme.dart';
// import 'package:flutter/widgets.dart';
// import 'package:flutter_phoenix/flutter_phoenix.dart';
// import 'package:gloomhaven_enhancement_calc/gloomhaven_companion.dart';
// import 'package:gloomhaven_enhancement_calc/viewmodels/characters_model.dart';
// import 'package:provider/provider.dart';

// class LifecycleWatcher extends StatefulWidget {
//   @override
//   _LifecycleWatcherState createState() => _LifecycleWatcherState();
// }

// class _LifecycleWatcherState extends State<LifecycleWatcher>
//     with WidgetsBindingObserver {
//   AppLifecycleState _lastLifecycleState;

//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addObserver(this);
//   }

//   @override
//   void dispose() {
//     WidgetsBinding.instance.removeObserver(this);
//     super.dispose();
//   }

//   @override
//   void didChangeAppLifecycleState(AppLifecycleState state) {
//     setState(() {
//       print('LIFECYCLE IS:: $state');
//       _lastLifecycleState = state;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Phoenix(
//       child: EasyDynamicThemeWidget(
//         child: ChangeNotifierProvider(
//           child: GloomhavenCompanion(),
//           create: (context) => CharactersModel(),
//         ),

//         // child: GloomhavenCompanion(),
//       ),
//     );
//     // if (_lastLifecycleState == null) {
//     //   return Text(
//     //     'This widget has not observed any lifecycle changes.',
//     //     textDirection: TextDirection.ltr,
//     //   );
//     // }

//     // return Text(
//     //   'The most recent lifecycle state this widget observed was: $_lastLifecycleState.',
//     //   textDirection: TextDirection.ltr,
//     // );
//   }
// }

// // void main() {
// //   runApp(Center(child: LifecycleWatcher()));
// // }
