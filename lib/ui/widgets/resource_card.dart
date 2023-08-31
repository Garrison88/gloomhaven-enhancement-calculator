import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../models/resource.dart';
import '../../data/constants.dart';

class ResourceCard extends StatelessWidget {
  final Resource resource;
  final int count;
  final Function() increaseCount;
  final Function() decreaseCount;
  final bool canEdit;
  const ResourceCard({
    Key? key,
    required this.resource,
    required this.count,
    required this.increaseCount,
    required this.decreaseCount,
    required this.canEdit,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: canEdit ? 100 : 75,
      width: 100,
      child: Card(
        elevation: 4,
        child: Stack(
          children: <Widget>[
            ResourceDetails(
              resource: resource,
              count: count,
              decreaseCount: decreaseCount,
              increaseCount: increaseCount,
              canEdit: canEdit,
            ),
          ],
        ),
      ),
    );
  }
}

class ResourceDetails extends StatelessWidget {
  final Resource resource;
  final int count;
  final Function() decreaseCount;
  final Function() increaseCount;
  final bool canEdit;
  const ResourceDetails({
    Key? key,
    required this.resource,
    required this.count,
    required this.decreaseCount,
    required this.increaseCount,
    required this.canEdit,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.topCenter,
      children: [
        Padding(
          padding: const EdgeInsets.all(4),
          child: AutoSizeText(
            resource.name,
            maxLines: 1,
            maxFontSize: 18,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(6.0),
          child: Center(
            child: SvgPicture.asset(
              resource.icon,
              colorFilter: ColorFilter.mode(
                Theme.of(context).brightness == Brightness.dark
                    ? Colors.white.withOpacity(0.05)
                    : Colors.black87.withOpacity(0.05),
                BlendMode.srcIn,
              ),
            ),
          ),
        ),
        Positioned(
          bottom: canEdit ? null : 8,
          child: Center(
            child: Text(
              '$count',
            ),
          ),
        ),
        if (canEdit) ...[
          Positioned(
            bottom: -smallPadding,
            left: -2,
            child: IconButton(
              onPressed: () => decreaseCount(),
              icon: const Icon(
                Icons.remove_circle,
              ),
            ),
          ),
          Positioned(
            bottom: -smallPadding,
            right: -2,
            child: IconButton(
              onPressed: () => increaseCount(),
              icon: const Icon(
                Icons.add_circle,
              ),
            ),
          ),
        ]
      ],
    );
  }
}
