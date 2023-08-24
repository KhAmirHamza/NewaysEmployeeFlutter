import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:neways3/src/features/contacts/models/employee_response_model.dart';
import 'package:neways3/src/features/message/controllers/CustomTextEditingController.dart';
import 'package:neways3/src/utils/constants.dart';

import '../controllers/ConvsCntlr.dart';
import '../controllers/MentionTextEditingController.dart';
import '../models/Mentionable.dart';
import 'MentionableTextField.dart';

class MentionableTextFieldWidget extends StatefulWidget {
  //final List<Mentionable> _mentionableUsers;
  CustomTextEditingController customTextEditingController;
  ConversationController convsController;
  Function(String text) onTextChange;
  MentionableTextFieldWidget(this.customTextEditingController,this.convsController,
      this.onTextChange,
      {super.key});

  @override
  State<MentionableTextFieldWidget> createState() => _MentionableTextFieldWidgetState();
}
getMentionViewMaxHeight(List<Mentionable> mentionableUsers){
  double height = 0;
  if(mentionableUsers.isNotEmpty){
    height = ((36.0 * (mentionableUsers.length>4? 4: mentionableUsers.length)) + 2);
  }
  return height;
}
class _MentionableTextFieldWidgetState extends State<MentionableTextFieldWidget> {
  late void Function(Mentionable mentionable) _onSelectMention;

  @override
  Widget build(BuildContext context) {

    refreshMainPage(){
      setState(() {
      });
    }


    return SafeArea(

      child: Column(
        children: [
          SizedBox(
            height: getMentionViewMaxHeight(widget.convsController.matchMentionableBySearch), //  widget._mentionableUsers.isNotEmpty? (36.0*widget._mentionableUsers.length + 2):0,
            child: ListView.builder(
              itemCount: widget.convsController.matchMentionableBySearch.length,
              reverse: true,
              itemBuilder: (context, index) {
                final mentionable = widget.convsController.matchMentionableBySearch[index];

                return InkWell(
                  onTap: (){
                    //_onSelectMention(mentionable);
                    //widget.onSelectMention(mentionable);
                    widget.customTextEditingController.onSelectMention(context, mentionable);
                    setState(() {
                    });
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: const EdgeInsets.fromLTRB(0, 2, 0, 2),
                        padding: const EdgeInsets.fromLTRB(0, 3, 0, 3),
                        //width: 30,
                        decoration: const BoxDecoration(

                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                          ClipOval(child: Image.network(mentionable.mentionPhoto, height: 25, width: 25, fit: BoxFit.cover,),),
                          const WidthSpace(width: 5,),
                          Expanded(
                            child: Text(mentionable.mentionLabel, style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold, overflow: TextOverflow.ellipsis
                            ),),
                          )],),
                      ),
                      Divider(height: 1, thickness: 1, color: Colors.grey.shade300,),
                    ],
                  ),
                );

                return ListTile(

                  leading: const Icon(Icons.person),
                  title: Text(mentionable.mentionLabel),
                  onTap: (){
                    _onSelectMention(mentionable);
                    //widget.onSelectMention(mentionable);
                  },
                );
              },
            ),
          ),
          // TextField(controller: widget.customTextEditingController,
          //   maxLines: null,
          //   minLines: 1,keyboardType: TextInputType.multiline,
          //   onSubmitted: print,decoration:
          //   const InputDecoration(
          //   hintText: "Type Something...",
          //   hintStyle: TextStyle(color: Colors.blueAccent),
          //   border: InputBorder.none),
          //   onChanged: (text)
          //   {
          //     widget.customTextEditingController.onChanged(text);
          //     widget.customTextEditingController.buildTextSpan(context: context, withComposing: true);
          //     },
          //   ),
          MentionableTextField(
           onTextChange: widget.onTextChange,
            refreshMainPage: refreshMainPage,
            customTextEditingController: widget.customTextEditingController,
            onControllerReady: (value) =>{
              print("onControllerReady called")
            },
            maxLines: null,
            minLines: 1,
            keyboardType: TextInputType.multiline,
            onSubmitted: print,
            mentionables: widget.customTextEditingController.mentionableList!,
            decoration:
            const InputDecoration(
                hintText: "Type Something...",
                hintStyle: TextStyle(color: Colors.blueAccent),
                border: InputBorder.none),
            onChanged: (text)
              {
                // widget.customTextEditingController.onChanged(text);
                widget.onTextChange(text);
                //widget.customTextEditingController.buildTextSpan(context: context, withComposing: true);
                },
            onMentionablesChanged: (List<Mentionable> mentionables) {
              mentionables.forEach((element) {});
            },
          ),

        ],
      ),
    );
  }
}

