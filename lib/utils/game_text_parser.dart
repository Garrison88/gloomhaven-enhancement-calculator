import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gloomhaven_enhancement_calc/data/constants.dart';
import 'package:gloomhaven_enhancement_calc/utils/asset_config.dart';

/// # Game Text Syntax Documentation
///
/// This parser supports the following syntax for rich text formatting:
///
/// - **Bold Text**: `**text**` - Text within double asterisks becomes bold
///   Example: `**Rested and Ready:**` becomes bold
///
/// - **Italic Text**: `*text*` - Text within single asterisks becomes italic
///   Example: `*Reviving Ether*` becomes italic
///
/// - **Icons**: Uppercase words that match asset names
///   Example: `ATTACK`, `MOVE`, `HEAL`, `FIRE`, `ICE`
///
/// - **XP Values**: `xpN` where N is a number
///   Example: `xp8` renders as XP icon with "8" overlay
///
/// - **Stacked Elements**: `ELEMENT&ELEMENT`
///   Example: `FIRE&ICE` renders two element icons stacked
///
/// - **Text Replacements**: Special words converted to symbols
///   - `plusone` → `+1`
///   - `plustwo` → `+2`
///   - `pluszero` → `+0`
///
/// - **Plain Text**: Any other text renders normally

// ============================================================================
// TOKEN DEFINITIONS
// ============================================================================

/// Base class for all game text tokens
abstract class GameTextToken {
  const GameTextToken();

  /// Convert this token to an InlineSpan for rendering
  InlineSpan toSpan(BuildContext context, bool darkTheme);
}

/// Token for bold text wrapped in square brackets [like this]
class BoldToken extends GameTextToken {
  final String text;

  const BoldToken(this.text);

  @override
  InlineSpan toSpan(BuildContext context, bool darkTheme) {
    return TextSpan(
      text: text,
      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            letterSpacing: 0.7,
            fontWeight: FontWeight.bold,
          ),
    );
  }
}

/// Token for game icons (ATTACK, MOVE, HEAL, etc.)
class IconToken extends GameTextToken {
  final String element;
  final String assetPath;
  final bool invertColor;

  const IconToken({
    required this.element,
    required this.assetPath,
    required this.invertColor,
  });

  @override
  InlineSpan toSpan(BuildContext context, bool darkTheme) {
    return WidgetSpan(
      alignment: PlaceholderAlignment.middle,
      child: Tooltip(
        message: _formatTooltipMessage(element),
        child: SizedBox(
          height: iconSize - 2.5,
          width: _calculateWidth(assetPath),
          child: _buildIconContent(assetPath, element, invertColor, darkTheme),
        ),
      ),
    );
  }

  String _formatTooltipMessage(String element) {
    return element
        .toLowerCase()
        .replaceAll(RegExp(r'["|,]'), '')
        .replaceAll('_', ' ')
        .split(' ')
        .map((word) =>
            word.isEmpty ? '' : '${word[0].toUpperCase()}${word.substring(1)}')
        .join(' ');
  }

  double _calculateWidth(String assetPath) {
    if (assetPath.contains('luminary_hexes') ||
        assetPath.contains('item_minus_one')) {
      return (iconSize - 2.5) * 1.5;
    }
    if (assetPath.contains('_or_') || assetPath.contains('transfer')) {
      return (iconSize - 2.5) * 2.0;
    }
    if (assetPath.contains('incarnate_all_stances')) {
      return (iconSize - 2.5) * 3.0;
    }
    return iconSize - 2.5;
  }

  Widget _buildIconContent(
      String assetPath, String element, bool invertColor, bool darkTheme) {
    // Handle XP icons
    if (assetPath == 'xp.svg') {
      final xpNumber = RegExp(r'\d+').firstMatch(element)?.group(0) ?? '';
      return Stack(
        alignment: Alignment.center,
        children: [
          _buildSvgPicture(assetPath, invertColor, darkTheme),
          Positioned(
            bottom: -1,
            child: Text(
              xpNumber,
              style: TextStyle(
                fontFamily: pirataOne,
                fontSize: 20,
                color: darkTheme ? Colors.black : Colors.white,
              ),
            ),
          ),
        ],
      );
    }

    // Handle consume icons
    if (element.toLowerCase().contains('consume')) {
      return Stack(
        fit: StackFit.expand,
        children: [
          _buildSvgPicture(assetPath, invertColor, darkTheme),
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

    // Handle +1 overlay icons
    const plusOneElements = ['ATTACK+1', 'MOVE+1', 'HEAL+1', 'Target+1,'];
    if (plusOneElements.contains(element)) {
      return Stack(
        alignment: const Alignment(1.75, -1.75),
        children: [
          _buildSvgPicture(assetPath, invertColor, darkTheme),
          SvgPicture.asset(
            'images/plus_one.svg',
            width: iconSize * 0.5,
            height: iconSize * 0.5,
          ),
        ],
      );
    }

    return _buildSvgPicture(assetPath, invertColor, darkTheme);
  }

  SvgPicture _buildSvgPicture(
      String assetPath, bool invertColor, bool darkTheme) {
    if (invertColor && darkTheme) {
      return SvgPicture.asset(
        'images/$assetPath',
        colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
      );
    }
    return SvgPicture.asset('images/$assetPath');
  }
}

/// Token for stacked element icons (FIRE&ICE)
class StackedElementToken extends GameTextToken {
  final String element1;
  final String element2;

  const StackedElementToken(this.element1, this.element2);

  @override
  InlineSpan toSpan(BuildContext context, bool darkTheme) {
    return WidgetSpan(
      alignment: PlaceholderAlignment.middle,
      child: SizedBox(
        height: iconSize,
        width: iconSize,
        child: Stack(
          children: [
            Positioned(
              top: 0,
              left: 0,
              child: SvgPicture.asset(
                'images/elem_${element1.toLowerCase()}.svg',
                width: iconSize * 0.7,
                height: iconSize * 0.7,
              ),
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: SvgPicture.asset(
                'images/elem_${element2.toLowerCase()}.svg',
                width: iconSize * 0.7,
                height: iconSize * 0.7,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Token for italic text prefixed with ~
class ItalicToken extends GameTextToken {
  final String text;

  const ItalicToken(this.text);

  @override
  InlineSpan toSpan(BuildContext context, bool darkTheme) {
    return TextSpan(
      text: text,
      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            fontStyle: FontStyle.italic,
          ),
    );
  }
}

/// Token for plain text
class PlainTextToken extends GameTextToken {
  final String text;

  const PlainTextToken(this.text);

  @override
  InlineSpan toSpan(BuildContext context, bool darkTheme) {
    return TextSpan(text: text);
  }
}

/// Token for punctuation (preserved separately for proper spacing)
class PunctuationToken extends GameTextToken {
  final String punctuation;

  const PunctuationToken(this.punctuation);

  @override
  InlineSpan toSpan(BuildContext context, bool darkTheme) {
    return TextSpan(text: punctuation);
  }
}

// ============================================================================
// TOKENIZER
// ============================================================================

/// Converts raw game text strings into a list of tokens
class GameTextTokenizer {
  static const _leadingPunctuation = ['"', "'", '('];
  static const _trailingPunctuation = ['"', "'", ',', ')', '.'];

  /// Tokenize a complete game text string
  static List<GameTextToken> tokenize(String text, bool darkTheme) {
    final List<GameTextToken> tokens = [];

    // First pass: handle formatted text sections (bold and italic)
    final segments = _splitByFormattedSections(text);

    for (final segment in segments) {
      if (segment.format == _TextFormat.bold) {
        tokens.add(BoldToken(segment.text));
      } else if (segment.format == _TextFormat.italic) {
        tokens.add(ItalicToken(segment.text));
      } else {
        // Plain text: tokenize by words
        tokens.addAll(_tokenizeWords(segment.text, darkTheme));
      }
    }

    return tokens;
  }

  /// Split text into formatted sections (bold, italic, plain)
  static List<_TextSegment> _splitByFormattedSections(String text) {
    final segments = <_TextSegment>[];

    // Match **bold** or *italic* - IMPORTANT: **bold** must come first!
    final formatRegex = RegExp(r'\*\*([^*]+)\*\*|\*([^*]+)\*');
    int lastIndex = 0;

    for (final match in formatRegex.allMatches(text)) {
      // Add text before match as plain
      if (match.start > lastIndex) {
        final beforeText = text.substring(lastIndex, match.start);
        if (beforeText.isNotEmpty) {
          segments.add(_TextSegment(beforeText, format: _TextFormat.plain));
        }
      }

      // Determine if this is bold or italic based on which group matched
      if (match.group(1) != null) {
        // Group 1 = **bold**
        segments.add(_TextSegment(match.group(1)!, format: _TextFormat.bold));
      } else if (match.group(2) != null) {
        // Group 2 = *italic*
        segments.add(_TextSegment(match.group(2)!, format: _TextFormat.italic));
      }

      lastIndex = match.end;
    }

    // Add remaining text
    if (lastIndex < text.length) {
      final remaining = text.substring(lastIndex);
      if (remaining.isNotEmpty) {
        segments.add(_TextSegment(remaining, format: _TextFormat.plain));
      }
    }

    return segments;
  }

  /// Tokenize a text segment into word-level tokens
  static List<GameTextToken> _tokenizeWords(String text, bool darkTheme) {
    final tokens = <GameTextToken>[];

    // Preserve leading spaces
    if (text.startsWith(' ')) {
      tokens.add(const PlainTextToken(' '));
      text = text.trimLeft();
    }

    final words = text.split(' ');

    for (int i = 0; i < words.length; i++) {
      final word = words[i];
      if (word.isEmpty) continue;

      // Handle stacked elements (FIRE&ICE)
      if (word.contains('&') && !word.startsWith('&') && !word.endsWith('&')) {
        final parts = word.split('&');
        if (parts.length == 2) {
          tokens.add(StackedElementToken(parts[0], parts[1]));
          if (i < words.length - 1) tokens.add(const PlainTextToken(' '));
          continue;
        }
      }

      // Handle text replacements (plusone -> +1)
      final replacement = _getTextReplacement(word);
      if (replacement != null) {
        tokens.add(PlainTextToken(replacement));
        if (i < words.length - 1) tokens.add(const PlainTextToken(' '));
        continue;
      }

      // Try to get asset config for this word
      final config = getAssetConfig(word, darkTheme);

      if (config.path != null) {
        // This is an icon token
        _addIconTokenWithPunctuation(tokens, word, config, darkTheme);
      } else {
        // Plain text token
        tokens.add(PlainTextToken(word));
      }

      // Add space between words (but not after last word)
      if (i < words.length - 1) {
        tokens.add(const PlainTextToken(' '));
      }
    }

    return tokens;
  }

  /// Add icon token with proper punctuation handling
  static void _addIconTokenWithPunctuation(
    List<GameTextToken> tokens,
    String word,
    AssetConfig config,
    bool darkTheme,
  ) {
    // Check for leading punctuation
    if (word.isNotEmpty && _leadingPunctuation.contains(word[0])) {
      tokens.add(PunctuationToken(word[0]));
      word = word.substring(1);
    }

    // Check for trailing punctuation
    String? trailingPunct;
    if (word.isNotEmpty &&
        _trailingPunctuation.contains(word[word.length - 1])) {
      trailingPunct = word[word.length - 1];
      word = word.substring(0, word.length - 1);
    }

    // Add the icon
    tokens.add(IconToken(
      element: word,
      assetPath: config.path!,
      invertColor: config.invertColor,
    ));

    // Add trailing punctuation if present
    if (trailingPunct != null) {
      tokens.add(PunctuationToken(trailingPunct));
    }
  }

  /// Get text replacement for special words
  static String? _getTextReplacement(String word) {
    // Remove punctuation to check core word
    final cleanWord = word.replaceAll(RegExp(r'[^a-zA-Z]'), '');

    String? replacement;
    switch (cleanWord) {
      case 'plusone':
        replacement = '+1';
        break;
      case 'plustwo':
        replacement = '+2';
        break;
      case 'pluszero':
        replacement = '+0';
        break;
      default:
        return null;
    }

    // Preserve punctuation
    if (cleanWord != word) {
      final leadingPunct = word.substring(0, word.indexOf(cleanWord));
      final trailingPunct =
          word.substring(word.indexOf(cleanWord) + cleanWord.length);
      return '$leadingPunct$replacement$trailingPunct';
    }

    return replacement;
  }
}

/// Helper enum for text formatting types
enum _TextFormat {
  plain,
  bold,
  italic,
}

/// Helper class for text segments with formatting
class _TextSegment {
  final String text;
  final _TextFormat format;

  const _TextSegment(this.text, {required this.format});
}

// ============================================================================
// RENDERER
// ============================================================================

/// Converts tokens to Flutter InlineSpan widgets
class GameTextRenderer {
  /// Render a list of tokens to InlineSpans
  static List<InlineSpan> render(
    BuildContext context,
    List<GameTextToken> tokens,
    bool darkTheme,
  ) {
    return tokens.map((token) => token.toSpan(context, darkTheme)).toList();
  }
}

// ============================================================================
// PUBLIC API
// ============================================================================

/// Main entry point for parsing game text
///
/// This is a facade that combines tokenization and rendering.
/// Use this class to convert game text strings to Flutter widgets.
class GameTextParser {
  /// Parse game text and return InlineSpans ready for display
  ///
  /// Example:
  /// ```dart
  /// final spans = GameTextParser.parse(
  ///   context,
  ///   '**Bold Text:** Normal text ATTACK xp8 *italic*',
  ///   darkTheme: true,
  /// );
  ///
  /// RichText(text: TextSpan(children: spans));
  /// ```
  static List<InlineSpan> parse(
    BuildContext context,
    String text,
    bool darkTheme,
  ) {
    final tokens = GameTextTokenizer.tokenize(text, darkTheme);
    return GameTextRenderer.render(context, tokens, darkTheme);
  }
}
