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
      height: canEdit ? 90 : 70,
      width: 100,
      child: Stack(
        alignment:
            canEdit ? AlignmentDirectional.topStart : Alignment.centerRight,
        children: <Widget>[
          ResourceDetails(
            name: resource.name,
            count: count,
            decreaseCount: decreaseCount,
            increaseCount: increaseCount,
            canEdit: canEdit,
          ),
          Align(
            alignment: canEdit ? Alignment.topLeft : Alignment.centerLeft,
            child: canEdit
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      SvgPicture.asset(
                        resource.icon,
                        colorFilter: ColorFilter.mode(
                          Theme.of(context).brightness == Brightness.dark
                              ? Colors.white
                              : Colors.black87,
                          BlendMode.srcIn,
                        ),
                        height: iconSize,
                        width: iconSize,
                      ),
                      Text(
                        resource.name,
                        style: const TextStyle(
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(),
                    ],
                  )
                : SvgPicture.asset(
                    resource.icon,
                    colorFilter: ColorFilter.mode(
                      Theme.of(context).brightness == Brightness.dark
                          ? Colors.white
                          : Colors.black87,
                      BlendMode.srcIn,
                    ),
                    height: iconSize,
                    width: iconSize,
                  ),
          ),
        ],
      ),
    );
  }
}

class ResourceDetails extends StatelessWidget {
  final String name;
  final int count;
  final Function() decreaseCount;
  final Function() increaseCount;
  final bool canEdit;
  const ResourceDetails({
    Key? key,
    required this.name,
    required this.count,
    required this.decreaseCount,
    required this.increaseCount,
    required this.canEdit,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: canEdit ? 100 : 80,
      child: Card(
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  if (!canEdit)
                    Text(
                      name,
                      style: const TextStyle(fontSize: 12),
                    ),
                  Text('$count'),
                ],
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
        ),
      ),
    );
  }
}
