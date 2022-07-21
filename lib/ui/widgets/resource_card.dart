import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gloomhaven_enhancement_calc/viewmodels/characters_model.dart';
import '../../models/resource.dart';
import '../../data/constants.dart';
import 'package:provider/provider.dart';

class ResourceCard extends StatelessWidget {
  final Resource resource;
  final int count;
  final Function() increaseCount;
  final Function() decreaseCount;
  const ResourceCard({
    Key key,
    this.resource,
    this.count,
    this.increaseCount,
    this.decreaseCount,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    CharactersModel charactersModel = context.watch<CharactersModel>();
    return SizedBox(
      height: charactersModel.isEditMode ? 90 : 50,
      width: 100,
      child: Stack(
        alignment: charactersModel.isEditMode
            ? AlignmentDirectional.topStart
            : Alignment.centerRight,
        children: <Widget>[
          ResourceDetails(
            name: resource.name,
            count: count,
            decreaseCount: decreaseCount,
            increaseCount: increaseCount,
          ),
          Align(
            alignment: charactersModel.isEditMode
                ? Alignment.topLeft
                : Alignment.centerLeft,
            child: charactersModel.isEditMode
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      ResourceIcon(
                        iconPath: resource.icon,
                      ),
                      Text(
                        resource.name,
                        style: const TextStyle(
                          fontSize: 11.5,
                        ),
                      ),
                      const SizedBox(),
                    ],
                  )
                : ResourceIcon(
                    iconPath: resource.icon,
                  ),
          ),
        ],
      ),
    );
  }
}

class ResourceIcon extends StatelessWidget {
  final String iconPath;
  const ResourceIcon({
    Key key,
    this.iconPath,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      iconPath,
      color: Theme.of(context).brightness == Brightness.dark
          ? Colors.white
          : Colors.black87,
      height: iconSize,
      width: iconSize,
    );
  }
}

class ResourceDetails extends StatelessWidget {
  final String name;
  final int count;
  final Function() decreaseCount;
  final Function() increaseCount;
  const ResourceDetails({
    Key key,
    this.name,
    this.count,
    this.decreaseCount,
    this.increaseCount,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    CharactersModel charactersModel = context.watch<CharactersModel>();
    return SizedBox(
      width: charactersModel.isEditMode ? 100 : 65,
      child: Card(
        child: Stack(
          children: [
            Center(
              child: Text('$count'),
            ),
            if (charactersModel.isEditMode)
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
            if (charactersModel.isEditMode)
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
          ],
        ),
      ),
    );
  }
}
