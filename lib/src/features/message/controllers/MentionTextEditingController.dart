
import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../models/Mentionable.dart';
import '../models/MessageTextItem.dart';
import '../utils/Constant.dart';
import '../widgets/MentionableTextField.dart';

///
/// A [TextEditingController] that displays the mentions
/// with a specific style using [_mentionStyle].
/// Mentions are stored in controller
/// as an unique character [escapingMentionCharacter].
/// Internally, [value] contains only [escapingMentionCharacter],
/// but the user will see mentions.
/// To get the real content of the text field
/// use [buildMentionedValue].
///
class MentionTextEditingController extends TextEditingController {
  /// default constructor.
  MentionTextEditingController({
    required MentionablesChangedCallback onMentionablesChanged,
    this.escapingMentionCharacter = Constants.escapingMentionCharacter,
    TextStyle? mentionStyle,
  })  : _onMentionablesChanged = onMentionablesChanged,
        _storedMentionables = [],
        _mentionStyle =
            mentionStyle ?? const TextStyle(fontWeight: FontWeight.bold);

  /// Character that is excluded from keyboard
  /// to replace the mentions (not visible to users).
  final String escapingMentionCharacter;

  /// [TextStyle] applied to mentionables in Text Field.
  final TextStyle _mentionStyle;

  /// List of [Mentionable] present in the [TextField].
  /// Order of elements is the same as in the [TextField].
  final List<Mentionable> _storedMentionables;
  final MentionablesChangedCallback _onMentionablesChanged;

  String? _getMentionCandidate(String value) {
    const mentionCharacter = Constants.mentionCharacter;
    final indexCursor = selection.base.offset;
    var indexAt = value.substring(0, indexCursor).split('').reversed.toString().indexOf(mentionCharacter);
    if (indexAt != -1) {
      if (value.length == 1) return mentionCharacter;
      indexAt = indexCursor - indexAt;
      if (indexAt != -1 && indexAt >= 0 && indexAt <= indexCursor) {
        return value.substring(indexAt - 1, indexCursor);
      }
    }
    return null;
  }

  Queue<Mentionable> _mentionQueue() =>
      Queue<Mentionable>.from(_storedMentionables);

  void _addMention(String candidate, Mentionable mentionable) {
    _storedMentionables.first.fullMentionLabel;
    final indexSelection = selection.base.offset;
    final textPart = text.substring(0, indexSelection);
    final indexInsertion = textPart.allMatches(escapingMentionCharacter).length;
    _storedMentionables.insert(indexInsertion, mentionable);
    text = '${text.replaceAll(candidate, escapingMentionCharacter)} ';
    selection = TextSelection.collapsed(offset: indexSelection - candidate.length + 2);
  }



  @override
  TextSpan buildTextSpan({
    required BuildContext context,
    TextStyle? style,
    required bool withComposing,
  }) {
    final regexp =
    RegExp('(?=$escapingMentionCharacter)|(?<=$escapingMentionCharacter)');
    // split result on "Hello ∞ where is ∞?" is: [Hello,∞, where is ,∞,?]
    final res = text.split(regexp);
    final mentionQueue = _mentionQueue();

    return TextSpan(
      style: style,
      children: res.map((e) {
        if (e == escapingMentionCharacter) {
          final mention = mentionQueue.removeFirst();


          // Mandatory WidgetSpan so that it takes the appropriate char number.
          return WidgetSpan(
            child: Text(
              mention.fullMentionLabel,
              style: _mentionStyle,
            ),
          );
        }
        return TextSpan(text: e, style: style);
      }).toList(),
    );
  }

  /// Add the mention to this controller.
  /// [_onMentionablesChanged] is called with empty list,
  /// yet there are no candidates anymore.
  void pickMentionable(Mentionable mentionable) {

    print("pickMentionable called");
    final candidate = _getMentionCandidate(text);
    if (candidate != null) {
      _addMention(candidate, mentionable);
      _onMentionablesChanged(_storedMentionables);
    }
  }

  /// Get the real value of the field with the mentions transformed
  /// thanks to [Mentionable.buildMention].
  String buildMentionedValue() {
    final mentionQueue = _mentionQueue();
    return text.replaceAllMapped(
      escapingMentionCharacter,
          (_) => mentionQueue.removeFirst().fullMentionLabel,
    );
  }
  List<MessageTextItem> buildMessageTextArray(){
    List<MessageTextItem> items = [];
    _storedMentionables.forEach((element) { items.add(MessageTextItem(value: element.mentionLabel, type: "mention"));  });
    return items;
  }
  void onFieldChanged(
      String value,
      List<Mentionable> mentionables,
      ) {
    final candidate = _getMentionCandidate(value);
    print("onFieldChanged called: $candidate");

    if (candidate != null) {
      final isMentioningRegexp = RegExp(r'^@[a-zA-Z ]*$');
      print("isMentioningRegexp: $isMentioningRegexp");

      final mention = isMentioningRegexp.stringMatch(candidate)?.substring(1);
      print("mention Available: $mention");
      if (mention != null) {
        final perfectMatch = mentionables.firstWhereOrNull(
              (element) =>
          element.match(mention) && element.mentionLabel == mention,
        );
        if (perfectMatch != null) {
          pickMentionable(perfectMatch);
        } else {
          final matchList =
          mentionables.where((element) => element.match(mention)).toList();
          _onMentionablesChanged(matchList);
        }
      }
    } else {
      _onMentionablesChanged([]);
    }
  }

  //void _onFieldChanged(String value, List<Mentionable> mentionables) {}
  //onFieldChanged(String value, List<Mentionable> mentionables){}
}

