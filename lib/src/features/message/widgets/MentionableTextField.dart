import 'dart:collection';
import 'dart:ui' as ui show BoxHeightStyle, BoxWidthStyle;

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:neways3/src/features/message/controllers/CustomTextEditingController.dart';

import '../controllers/MentionTextEditingController.dart';
import '../models/Mentionable.dart';
import '../utils/Constant.dart';



/// The type of callback when mentionables candidate
/// have changed.
typedef MentionablesChangedCallback = void Function(
    List<Mentionable> mentionables,
    );

/// A Widget built on top of [TextField] to add mentions feature.
/// To work, it required [mentionables] to let it know what can be mentioned.
/// When the user will start typing '@' character,
/// it will triggers mention mode.
///
/// It will call [onMentionablesChanged] each time a new character is added,
/// that will filter [mentionables] that match the query.
///
/// [onMentionablesChanged] let you decide
/// the way user will pick a [Mentionable].
///
/// To finally pick a [Mentionable],
/// keep the controller given by [onControllerReady] and
/// call [MentionTextEditingController.pickMentionable].
class MentionableTextField extends StatefulWidget {

  /// default constructor.
  MentionableTextField({
    super.key,
    required this.onMentionablesChanged,
    required this.onControllerReady,
    this.mentionStyle,
    this.expands = false,
    this.readOnly = false,
    this.toolbarOptions,
    this.scribbleEnabled = true,
    this.enableIMEPersonalizedLearning = true,
    this.cursorWidth = 2.0,
    this.selectionHeightStyle = ui.BoxHeightStyle.tight,
    this.selectionWidthStyle = ui.BoxWidthStyle.tight,
    this.scrollPadding = const EdgeInsets.all(20),
    bool? enableInteractiveSelection,
    this.clipBehavior = Clip.hardEdge,
    this.dragStartBehavior = DragStartBehavior.start,
    this.textAlign = TextAlign.start,
    this.autofocus = false,
    this.obscuringCharacter = '•',
    this.obscureText = false,
    this.autocorrect = true,
    this.smartDashesType,
    this.smartQuotesType,
    this.enableSuggestions = true,
    this.textCapitalization = TextCapitalization.none,
    this.keyboardType,
    this.mentionables = const [],
    this.onTap,
    this.escapingMentionCharacter = Constants.escapingMentionCharacter,
    this.focusNode,
    this.decoration,
    this.textInputAction,
    this.style,
    this.strutStyle,
    this.textAlignVertical,
    this.textDirection,
    this.maxLines,
    this.minLines,
    this.showCursor,
    this.maxLength,
    this.maxLengthEnforcement,
    this.onChanged,
    this.onEditingComplete,
    this.onSubmitted,
    this.onAppPrivateCommand,
    this.inputFormatters,
    this.enabled,
    this.cursorHeight,
    this.cursorRadius,
    this.cursorColor,
    this.keyboardAppearance,
    this.selectionControls,
    this.mouseCursor,
    this.buildCounter,
    this.scrollPhysics,
    this.scrollController,
    this.autofillHints,
    this.restorationId,
    required this.customTextEditingController,
    required this.onTextChange,
    required this.refreshMainPage,
  })  : assert(
  escapingMentionCharacter.length == 1,
  'escapingMentionCharacter should be a single character.',
  ),
        enableInteractiveSelection =
            enableInteractiveSelection ?? (!readOnly || !obscureText);


  final ValueChanged<MentionTextEditingController> onControllerReady;
  final List<Mentionable> mentionables;
  final String escapingMentionCharacter;
  MentionablesChangedCallback onMentionablesChanged;
  final TextStyle? mentionStyle;
  final VoidCallback? onTap;
  final FocusNode? focusNode;
  final InputDecoration? decoration;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final TextCapitalization textCapitalization;
  final TextStyle? style;
  final StrutStyle? strutStyle;
  final TextAlign textAlign;
  final TextAlignVertical? textAlignVertical;
  final TextDirection? textDirection;
  final bool autofocus;
  final String obscuringCharacter;
  final bool obscureText;
  final bool autocorrect;
  final SmartDashesType? smartDashesType;
  final SmartQuotesType? smartQuotesType;
  final bool enableSuggestions;
  final int? maxLines;
  final int? minLines;
  final bool expands;
  final bool readOnly;
  final ToolbarOptions? toolbarOptions;
  final bool? showCursor;
  static const int noMaxLength = -1;
  final int? maxLength;
  final MaxLengthEnforcement? maxLengthEnforcement;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onEditingComplete;
  final ValueChanged<String>? onSubmitted;
  final AppPrivateCommandCallback? onAppPrivateCommand;
  final List<TextInputFormatter>? inputFormatters;
  final bool? enabled;
  final double cursorWidth;
  final double? cursorHeight;
  final Radius? cursorRadius;
  final Color? cursorColor;
  final ui.BoxHeightStyle selectionHeightStyle;
  final ui.BoxWidthStyle selectionWidthStyle;
  final Brightness? keyboardAppearance;
  final EdgeInsets scrollPadding;
  final bool enableInteractiveSelection;
  final TextSelectionControls? selectionControls;
  final DragStartBehavior dragStartBehavior;
  bool get selectionEnabled => enableInteractiveSelection;
  final MouseCursor? mouseCursor;
  final InputCounterWidgetBuilder? buildCounter;
  final ScrollPhysics? scrollPhysics;
  final ScrollController? scrollController;
  final Iterable<String>? autofillHints;
  final Clip clipBehavior;
  final String? restorationId;
  final bool scribbleEnabled;
  final bool enableIMEPersonalizedLearning;
  final Function(String text) onTextChange;
  final Function() refreshMainPage;

 // MentionTextEditingController mentionTextEditingController;
  CustomTextEditingController customTextEditingController;


  @override
  State<MentionableTextField> createState() => _MentionableTextFieldState();

}

class _MentionableTextFieldState extends State<MentionableTextField> {
  // late final MentionTextEditingController _controller =
  // MentionTextEditingController(
  //   //escapingMentionCharacter: widget.escapingMentionCharacter,
  //   onMentionablesChanged: widget.onMentionablesChanged,
  //  // mentionStyle: widget.mentionStyle,
  // );


  @override
  void initState() {
    super.initState();
    //widget.onControllerReady?.call(_controller);
    //if(_controller.buildMentionedValue().isNotEmpty){
     // print("buildMentionedValue: ${_controller.buildMentionedValue()}");
    //}
  //  widget.onControllerReady!(_controller);
    //print("onControllerReady: ${widget.onControllerReady.call(_controller)}");
  }

  @override
  void dispose() {
    widget.customTextEditingController.dispose();
    super.dispose();
  }

  void _onChanged(String value) {
   final mentionables = widget.mentionables;
   //widget.customTextEditingController.onFieldChanged(value, mentionables);
    widget.onChanged?.call(value);
  }

  void _onSubmitted(_) {
    //final mentionedValue = widget.customTextEditingController.buildMentionedValue();
   // widget.onSubmitted?.call(mentionedValue);
  }

  @override
  Widget build(BuildContext context) {
  // TextEditingController textController = TextEditingController();
    // return TextField(controller: textController,
    //     maxLines: null,
    //     minLines: 1,
    //   keyboardType: TextInputType.multiline,
    //   decoration: const InputDecoration(
    //   hintText: "Type Something...",
    //   hintStyle: TextStyle(color: Colors.blueAccent),
    //   border: InputBorder.none),
    //
    // );

    return TextField(
      onTap: widget.onTap,
      controller: widget.customTextEditingController,  //_controller
      style: widget.style,
      textAlign: widget.textAlign,
      onSubmitted: (text)=>{},
      onChanged: (text){
        widget.onTextChange(text);
       // widget.customTextEditingController.onChanged(text);
        widget.refreshMainPage();
      },
      restorationId: widget.restorationId,
      inputFormatters: widget.inputFormatters,
      mouseCursor: widget.mouseCursor,
      decoration: widget.decoration,
      maxLines: widget.maxLines,
      clipBehavior: widget.clipBehavior,
      scrollController: widget.scrollController,
      autocorrect: widget.autocorrect,
      autofillHints: widget.autofillHints,
      autofocus: widget.autofocus,
      buildCounter: widget.buildCounter,
      cursorColor: widget.cursorColor,
      cursorHeight: widget.cursorHeight,
      cursorRadius: widget.cursorRadius,
      cursorWidth: widget.cursorWidth,
      dragStartBehavior: widget.dragStartBehavior,
      enabled: widget.enabled,
      enableIMEPersonalizedLearning: widget.enableIMEPersonalizedLearning,
      enableInteractiveSelection: widget.enableInteractiveSelection,
      enableSuggestions: widget.enableSuggestions,
      expands: widget.expands,
      focusNode: widget.focusNode,
      keyboardAppearance: widget.keyboardAppearance,
      keyboardType: widget.keyboardType,
      maxLength: widget.maxLength,
      maxLengthEnforcement: widget.maxLengthEnforcement,
      minLines: widget.minLines,
      obscureText: widget.obscureText,
      obscuringCharacter: widget.obscuringCharacter,
      onAppPrivateCommand: widget.onAppPrivateCommand,
      onEditingComplete: widget.onEditingComplete,
      readOnly: widget.readOnly,
      scribbleEnabled: widget.scribbleEnabled,
      scrollPadding: widget.scrollPadding,
      scrollPhysics: widget.scrollPhysics,
      selectionControls: widget.selectionControls,
      selectionHeightStyle: widget.selectionHeightStyle,
      selectionWidthStyle: widget.selectionWidthStyle,
      showCursor: widget.showCursor,
      smartDashesType: widget.smartDashesType,
      smartQuotesType: widget.smartQuotesType,
      strutStyle: widget.strutStyle,
      textAlignVertical: widget.textAlignVertical,
      textCapitalization: widget.textCapitalization,
      textDirection: widget.textDirection,
      textInputAction: widget.textInputAction,
      toolbarOptions: widget.toolbarOptions,
    );
  }
}
