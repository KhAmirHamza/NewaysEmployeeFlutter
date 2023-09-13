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
    convsController.matchMentionableBySearch.clear();
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
  }
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
   }
}
