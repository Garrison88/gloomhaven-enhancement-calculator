import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gloomhaven_enhancement_calc/data/constants.dart';

import 'package:gloomhaven_enhancement_calc/models/resource.dart';

class ResourceCard extends StatelessWidget {
  final Resource resource;
  final Color color;
  final int count;
  final Function() onIncrease;
  final Function() onDecrease;
  final bool canEdit;
  const ResourceCard({
    super.key,
    required this.resource,
    required this.color,
    required this.count,
    required this.onIncrease,
    required this.onDecrease,
    required this.canEdit,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: canEdit ? 100 : 75,
      width: 100,
      child: Card(
        elevation: 4,
        child: ResourceDetails(
          resource: resource,
          color: color,
          count: count,
          decreaseCount: onDecrease,
          increaseCount: onIncrease,
          canEdit: canEdit,
        ),
      ),
    );
  }
}

class ResourceDetails extends StatelessWidget {
  final Resource resource;
  final Color color;
  final int count;
  final Function() decreaseCount;
  final Function() increaseCount;
  final bool canEdit;
  const ResourceDetails({
    super.key,
    required this.resource,
    required this.color,
    required this.count,
    required this.decreaseCount,
    required this.increaseCount,
    required this.canEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.topCenter,
      children: [
        Padding(
          padding: const EdgeInsets.all(4),
          child: AutoSizeText(resource.name, maxLines: 1, maxFontSize: 18),
        ),
        Padding(
          padding: const EdgeInsets.all(6.0),
          child: Center(
            child: SvgPicture.asset(
              resource.icon,
              colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
            ),
          ),
        ),
        Positioned(
          bottom: canEdit ? null : 8,
          child: Center(child: Text('$count')),
        ),
        if (canEdit) ...[
          Positioned(
            bottom: -mediumPadding,
            left: -2,
            child: IconButton(
              onPressed: () => decreaseCount(),
              icon: const Icon(Icons.remove_circle),
            ),
          ),
          Positioned(
            bottom: -mediumPadding,
            right: -2,
            child: IconButton(
              onPressed: () => increaseCount(),
              icon: const Icon(Icons.add_circle),
            ),
          ),
        ],
      ],
    );
  }
}

// class ResourceCard extends StatelessWidget {
//   static const double _defaultWidth = 100.0;
//   static const double _editHeight = 100.0;
//   static const double _viewHeight = 75.0;
//   static const double _padding = 4.0;
//   static const double _bottomPadding = 8.0;

//   final Resource resource;
//   final Color color;
//   final int count;
//   final VoidCallback? onIncrease;
//   final VoidCallback? onDecrease;
//   final bool canEdit;

//   const ResourceCard({
//     super.key,
//     required this.resource,
//     required this.color,
//     required this.count,
//     this.onIncrease,
//     this.onDecrease,
//     this.canEdit = false,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       height: canEdit ? _editHeight : _viewHeight,
//       width: _defaultWidth,
//       child: Card(
//         elevation: 4,
//         child: _ResourceCardContent(
//           resource: resource,
//           color: color,
//           count: count,
//           onDecrease: onDecrease,
//           onIncrease: onIncrease,
//           canEdit: canEdit,
//         ),
//       ),
//     );
//   }
// }

// class _ResourceCardContent extends StatelessWidget {
//   final Resource resource;
//   final Color color;
//   final int count;
//   final VoidCallback? onDecrease;
//   final VoidCallback? onIncrease;
//   final bool canEdit;

//   const _ResourceCardContent({
//     required this.resource,
//     required this.color,
//     required this.count,
//     this.onDecrease,
//     this.onIncrease,
//     required this.canEdit,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       mainAxisSize: MainAxisSize.min,
//       children: [
//         _ResourceName(name: resource.name),
//         Expanded(
//           child: _ResourceIcon(
//             iconPath: resource.icon,
//             color: color,
//           ),
//         ),
//         _ResourceCounter(
//           count: count,
//           canEdit: canEdit,
//           onDecrease: onDecrease,
//           onIncrease: onIncrease,
//         ),
//       ],
//     );
//   }
// }

// class _ResourceName extends StatelessWidget {
//   final String name;

//   const _ResourceName({required this.name});

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.all(ResourceCard._padding),
//       child: AutoSizeText(
//         name,
//         maxLines: 1,
//         maxFontSize: 18,
//       ),
//     );
//   }
// }

// class _ResourceIcon extends StatelessWidget {
//   final String iconPath;
//   final Color color;

//   const _ResourceIcon({
//     required this.iconPath,
//     required this.color,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.all(6.0),
//       child: Center(
//         child: SvgPicture.asset(
//           iconPath,
//           colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
//         ),
//       ),
//     );
//   }
// }

// class _ResourceCounter extends StatelessWidget {
//   final int count;
//   final bool canEdit;
//   final VoidCallback? onDecrease;
//   final VoidCallback? onIncrease;

//   const _ResourceCounter({
//     required this.count,
//     required this.canEdit,
//     this.onDecrease,
//     this.onIncrease,
//   });

//   @override
//   Widget build(BuildContext context) {
//     if (!canEdit) {
//       return Padding(
//         padding: const EdgeInsets.only(bottom: ResourceCard._bottomPadding),
//         child: Text('$count'),
//       );
//     }

//     return SizedBox(
//       height: 48, // Give enough height for the buttons
//       child: Row(
//         mainAxisSize: MainAxisSize.min, // Take minimum space needed
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           SizedBox(
//             width: 24, // Constrain button width
//             child: IconButton(
//               onPressed: onDecrease,
//               icon: const Icon(Icons.remove_circle, size: 20),
//               padding: EdgeInsets.zero,
//               constraints: const BoxConstraints(),
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 4),
//             child: Text('$count'),
//           ),
//           SizedBox(
//             width: 24, // Constrain button width
//             child: IconButton(
//               onPressed: onIncrease,
//               icon: const Icon(Icons.add_circle, size: 20),
//               padding: EdgeInsets.zero,
//               constraints: const BoxConstraints(),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
