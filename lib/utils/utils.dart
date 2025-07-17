import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gloomhaven_enhancement_calc/data/constants.dart';
import 'package:gloomhaven_enhancement_calc/utils/asset_config.dart';

class Utils {
  static List<InlineSpan> generateCheckRowDetails(
    BuildContext context,
    String details,
    bool darkTheme,
  ) {
    List<InlineSpan> inlineList = [];
    // This makes Perk description text bold if it's [surrounded by square brackets]
    if (details.startsWith('[')) {
      String perkDescription =
          details.substring(details.indexOf('[') + 1, details.lastIndexOf(']'));
      details = details.substring(details.lastIndexOf(']') + 1);
      inlineList.add(
        TextSpan(
          text: perkDescription,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                letterSpacing: 0.7,
                fontWeight: FontWeight.bold,
              ),
        ),
      );
    }
    List<String> list = details.split(' ');
    for (String element in list) {
      String? assetPath;
      bool invertColor = false;
      if (element.contains('&')) {
        // Stack both Elements
        List<String> elements = element.split('&');
        element = '';
        inlineList.add(
          WidgetSpan(
            child: SizedBox(
              height: iconSize,
              width: iconSize,
              child: Stack(
                children: [
                  Positioned(
                    top: 0,
                    left: 0,
                    child: SvgPicture.asset(
                      'images/elem_${elements[0].toLowerCase()}.svg',
                      width: iconSize * 0.7,
                      height: iconSize * 0.7,
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: SvgPicture.asset(
                      'images/elem_${elements[1].toLowerCase()}.svg',
                      width: iconSize * 0.7,
                      height: iconSize * 0.7,
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      } else {
        final config = getAssetConfig(
          element,
          darkTheme,
        );
        assetPath = config.path;
        invertColor = config.invertColor;
      }
      IconWidgetBuilder.addContent(
        context,
        inlineList: inlineList,
        element: element,
        invertColor: invertColor,
        darkTheme: darkTheme,
        assetPath: assetPath,
      );
    }
    return inlineList;
  }
}

extension StringCasingExtension on String {
  String toCapitalized() =>
      length > 0 ? '${this[0].toUpperCase()}${substring(1)}' : '';
  String get toTitleCase => replaceAll(RegExp(' +'), ' ')
      .split(" ")
      .map((str) => str.toCapitalized())
      .join(" ");
}

class SizeProviderWidget extends StatefulWidget {
  final Widget child;
  final Function(Size?) onChildSize;

  const SizeProviderWidget({
    super.key,
    required this.onChildSize,
    required this.child,
  });
  @override
  SizeProviderWidgetState createState() => SizeProviderWidgetState();
}

class SizeProviderWidgetState extends State<SizeProviderWidget> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (mounted) {
        widget.onChildSize(context.size);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}

class HighlightedWidget extends StatefulWidget {
  final Widget child;
  final Color color;
  final Duration duration;
  final bool animateBorder;

  const HighlightedWidget({
    super.key,
    required this.child,
    this.color = Colors.grey,
    this.duration = const Duration(milliseconds: 350),
    this.animateBorder = false,
  });

  @override
  HighlightedWidgetState createState() => HighlightedWidgetState();
}

class HighlightedWidgetState extends State<HighlightedWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Color?> _colorAnimation;

  @override
  void initState() {
    super.initState();

    // Create an animation controller with a duration of 500 milliseconds
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );

    // Create a color tween animation to interpolate between the starting color and the target color
    _colorAnimation = ColorTween(
      begin: widget.animateBorder ? Colors.transparent : null,
      // end: widget.color.withValues(alpha: 0.5),
      end: widget.color.withValues(alpha: 0.5),
    ).animate(_controller);

    // Start the animation when the widget is created
    _controller.forward().then((_) {
      _controller.reverse();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Container(
          decoration: widget.animateBorder && _colorAnimation.value != null
              ? BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: _colorAnimation.value!,
                    width: 2,
                  ),
                )
              : BoxDecoration(
                  color: _colorAnimation.value,
                ),
          child: widget.child,
        );
      },
    );
  }
}

class IconWidgetBuilder {
  static const _leadingPunctuation = [
    '"',
    "'",
    '(',
  ];
  static const _trailingPunctuation = [
    '"',
    "'",
    ',',
    ')',
    '.',
  ];
  static const _plusOneElements = [
    'ATTACK+1',
    'MOVE+1',
    'HEAL+1',
    'Target+1,',
  ];

  static double _calculateWidth(String assetPath) {
    if (assetPath.contains('luminary_hexes') ||
        assetPath.contains('item_minus_one')) {
      return (iconSize - 2.5) * 1.5; // 1.5x wide
    }
    if (assetPath.contains('_or_') || assetPath.contains('transfer')) {
      return (iconSize - 2.5) * 2.0; // Double wide
    }
    if (assetPath.contains('incarnate_all_stances')) {
      return (iconSize - 2.5) * 3.0; // Triple wide
    }
    return iconSize - 2.5; // Standard width
  }

  static SvgPicture _buildSvgPicture(
    String assetPath, {
    bool invertInDarkTheme = false,
    bool darkTheme = false,
  }) {
    if (invertInDarkTheme && darkTheme) {
      return SvgPicture.asset(
        'images/$assetPath',
        colorFilter: const ColorFilter.mode(
          Colors.white,
          BlendMode.srcIn,
        ),
      );
    }
    return SvgPicture.asset('images/$assetPath');
  }

  static Widget _buildIconContent(
    String assetPath,
    String element,
    bool invertColor,
    bool darkTheme,
  ) {
    if (element.toLowerCase().contains('consume')) {
      return Stack(
        fit: StackFit.expand,
        children: [
          _buildSvgPicture(
            assetPath,
            invertInDarkTheme: invertColor,
            darkTheme: darkTheme,
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: SizedBox(
              height: 12,
              width: 12,
              child: SvgPicture.asset('images/consume.svg'),
            ),
          ),
        ],
      );
    }

    if (_plusOneElements.contains(element)) {
      return Stack(
        alignment: const Alignment(1.75, -1.75),
        children: [
          _buildSvgPicture(
            assetPath,
            invertInDarkTheme: invertColor,
            darkTheme: darkTheme,
          ),
          SvgPicture.asset(
            'images/plus_one.svg',
            width: iconSize * 0.5,
            height: iconSize * 0.5,
          ),
        ],
      );
    }

    return _buildSvgPicture(
      assetPath,
      invertInDarkTheme: invertColor,
      darkTheme: darkTheme,
    );
  }

  static String _formatTooltipMessage(String element) {
    return element
        .toLowerCase()
        .replaceAll(RegExp(r'["|,]'), '')
        .replaceAll('_', ' ')
        .toTitleCase;
  }

  /// Adds appropriate content to the inline list based on element type
  static void addContent(
    BuildContext context, {
    required List<InlineSpan> inlineList,
    required String element,
    required bool invertColor,
    required bool darkTheme,
    String? assetPath,
  }) {
    (assetPath != null)
        ? _addIconContent(
            inlineList: inlineList,
            element: element,
            assetPath: assetPath,
            invertColor: invertColor,
            darkTheme: darkTheme,
          )
        : _addTextContent(
            context,
            inlineList: inlineList,
            element: element,
          );
    // Add space after each element
    inlineList.add(
      const TextSpan(text: ' '),
    );
  }

  /// Handles adding icon-based content
  static void _addIconContent({
    required List<InlineSpan> inlineList,
    required String element,
    required String assetPath,
    required bool invertColor,
    required bool darkTheme,
  }) {
    // Add leading punctuation if present
    if (_leadingPunctuation.contains(element.characters.first)) {
      inlineList.add(TextSpan(text: element.characters.first));
    }

    // Calculate width based on asset type
    final sizedBoxWidth = _calculateWidth(assetPath);

    // Add the main icon widget
    inlineList.add(
      WidgetSpan(
        alignment: PlaceholderAlignment.middle,
        child: Tooltip(
          message: _formatTooltipMessage(element),
          child: SizedBox(
            height: iconSize - 2.5,
            width: sizedBoxWidth,
            child: _buildIconContent(
              assetPath,
              element,
              invertColor,
              darkTheme,
            ),
          ),
        ),
      ),
    );

    // Add trailing punctuation if present
    if (_trailingPunctuation.contains(element.characters.last)) {
      inlineList.add(TextSpan(text: element.characters.last));
    }
  }

  /// Handles adding text-based content
  static void _addTextContent(
    BuildContext context, {
    required List<InlineSpan> inlineList,
    required String element,
  }) {
    switch (element) {
      case '"plusone':
        inlineList.add(
          const TextSpan(text: '"+1'),
        );
        break;
      case 'plusone':
        inlineList.add(
          const TextSpan(text: '+1'),
        );
        break;
      case 'plustwo':
        inlineList.add(
          const TextSpan(text: '+2'),
        );
        break;
      default:
        inlineList.add(
          element.startsWith('~')
              ? TextSpan(
                  text: element.substring(1),
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontStyle: FontStyle.italic,
                      ),
                )
              : TextSpan(text: element),
        );
    }
  }
}
