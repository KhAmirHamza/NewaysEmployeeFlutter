import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:neways3/src/features/message/controllers/ConvsCntlr.dart';
import 'package:neways3/src/features/message/models/MessageTextItem.dart';

import '../../../utils/constants.dart';
import '../models/Mentionable.dart';

class CustomTextEditingController extends TextEditingController{
  bool searchMentionable = true;
  ConversationController convsController;
  String convsId;
  List<Mentionable>? mentionableList;
  List<Mentionable> selectedMentions = [];

  List<MessageTextItem> messageTextItems = [];

  CustomTextEditingController(this.convsController, this.convsId,){
    mentionableList = generateMentionsIncludingConst(
        participants: convsController.conversations.firstWhere((element) => element.id ==convsId).participants!, asMentionable: true);
  }




  onSelectMention(BuildContext context, Mentionable mentionable){
    text = "${text.substring(0, text.lastIndexOf("@"))} ∞ ";
    selectedMentions.add(mentionable);
    convsController.selectedMentionsIndexList.add(text.lastIndexOf("∞"));
    print("mentionable.mentionLabel: ${mentionable.mentionLabel}");
    convsController.matchMentionableBySearch.clear();

    //int startIndex = text.length;
    //print("text.length-1+mentionText.length:${text+mentionable} => ${text.length-1+mentionText.length}");
   // text+= "$mentionText";
    //int endIndex = text.length-1 ;
    //print("text.length-1: $text => : ${text.length-1}");
    //buildTextSpan(context: context, withComposing: true);
   // selection = TextSelection.collapsed(offset: text.length);
  }


  onSearchMention(){
    if(searchMentionable){
      convsController.matchMentionableBySearch.clear();
      convsController.selectedMentionsIndexList.clear();
      String searchText = text.substring(text.lastIndexOf("@")+1);
       for (Mentionable e in mentionableList!) {

         e.mentionLabel.isCaseInsensitiveContainsAny(searchText)?
         {
           convsController.matchMentionableBySearch.add(e),
         }:{};
       }
      if(convsController.matchMentionableBySearch.isEmpty){
        searchMentionable = false;
      }
    }
    print("onSearchMention: convsController.matchMentionableBySearch: ${convsController.matchMentionableBySearch.length}");

  }

  // onChanged(String text){
  //   if(text.isNotEmpty && text[text.length-1]=="@"){
  //     searchMentionable = true;
  //     onSearchMention();
  //   }else if(text.isNotEmpty && text.lastIndexOf("@")>-1){
  //     searchMentionable = true;
  //     onSearchMention();
  //   }
  //  // refreshTypingFieldOnTextChange(text);
  // }

  @override
  TextSpan buildTextSpan(
      {required BuildContext context,
      TextStyle? style,
      required bool withComposing}) {
    var textArray = [];
    String item = "";
    //int f = 0;
    for(int i=0; i<text.length; i++){
      if(text[i]=="∞"){
        //f++;
        if(item.isNotEmpty) {
          textArray.add(item);
          item = "";
        }
        textArray.add("∞");
      }else{
        item+= text[i];
        if(i==(text.length-1)){
          textArray.add(item);
        }
      }
    }

    print("textArray:${jsonEncode(textArray)}");
  //  print("Found: $f");

   // print("text: $text");
   // print("res: $textArray");
   // print("convsController.matchMentionableBySearch: ${selectedMentions.length}");
  // List<Mentionable> copySelectedMentions = selectedMentions;
    messageTextItems.clear();
    int  f=0;
   List<InlineSpan> spans = [];
   for(int i=0; i<textArray.length; i++){
      if (textArray[i] == "∞") {

        Mentionable mention = selectedMentions[f];
        messageTextItems.add(MessageTextItem(type: "mention", value: mention.fullMentionLabel));
        f++;

          // Mandatory WidgetSpan so that it takes the appropriate char number.
          spans.add(WidgetSpan(
            alignment: PlaceholderAlignment.middle,
            child: Text(
              mention.fullMentionLabel,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          )) ;
      }else{
        spans.add(TextSpan(text: textArray[i], style: style));
        messageTextItems.add(MessageTextItem(type: "text", value: textArray[i]));
      }
   }
    return TextSpan(
        style: style,
        children: spans,
    );


/*    if(convsController.selectedMentionsIndexList.isNotEmpty && convsController.selectedMentionsIndexList[0]==0){
      print("Step:1");
      inlineSpans.add(TextSpan(text: text.substring(0), style: style));
    }else if(convsController.selectedMentionsIndexList.isNotEmpty){
      for(int i=0; i<convsController.selectedMentionsIndexList.length; i++){
        text = text.replaceFirst(RegExp('∞'), convsController.matchMentionableBySearch[i].mentionLabel);
        print("Step:2: ${convsController.matchMentionableBySearch[i].mentionLabel}");
        //inlineSpans.add(TextSpan(text: mention, style: style)) ;
        inlineSpans.add(WidgetSpan(
          child: Text(
            mention,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        )) ;
        if((text.length-1)!=sMentionItemIndexes.lastIndex
           // || (convsController.selectedMentionsIndexesList.length -1)!=i
           // && (sMentionItemIndexes.lastIndex+1)!= convsController.selectedMentionsIndexesList[i+1].firstIndex
        ){
          print("Step:3");
          inlineSpans.add(TextSpan(text: text, style: style)) ;
        }
      }
    }
    else{
      print("Step:4");
      inlineSpans.add(TextSpan(text: text, style: style)) ;
    }

    return TextSpan(
      style: style,
      children: inlineSpans
    );*/
   }
}
