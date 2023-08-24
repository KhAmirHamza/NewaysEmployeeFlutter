// import 'package:flutter/material.dart';
// import '../controllers/MentionTextEditingController.dart';
// import '../models/Mentionable.dart';
// import 'MentionableTextField.dart';
//
// class MentionableTextFieldWidget extends StatefulWidget {
//   List<Mentionable> _mentionableUsers;
//   List<Mentionable> mentionableList;
//   MentionTextEditingController messageController;
//   Function(String text) onTextChange;
//   Function(Mentionable mentionable) onSelectMention;
//   MentionableTextFieldWidget( this.mentionableList, this.messageController, this.onTextChange, this._mentionableUsers, this.onSelectMention, {super.key});
//
//   @override
//   State<MentionableTextFieldWidget> createState() => _MentionableTextFieldWidgetState();
// }
//
// class _MentionableTextFieldWidgetState extends State<MentionableTextFieldWidget> {
//   //late void Function(Mentionable mentionable) _onSelectMention;
//
//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: Column(
//         children: [
//           SizedBox(
//             height: widget._mentionableUsers.isNotEmpty? (60.0*widget._mentionableUsers.length):0,
//             child: ListView.builder(
//               reverse: true,
//               itemBuilder: (context, index) {
//                 final mentionable = widget._mentionableUsers[index];
//                 return ListTile(
//                   leading: const Icon(Icons.person),
//                   title: Text(mentionable.mentionLabel),
//                   onTap: () => widget.onSelectMention(mentionable),
//                 );
//               },
//               itemCount: widget._mentionableUsers.length,
//             ),
//           ),
//           MentionableTextField(
//             controller: widget.messageController,
//             onControllerReady: (value) =>
//             widget.onSelectMention = value.pickMentionable,
//             maxLines: null,
//             minLines: 1,
//             keyboardType: TextInputType.multiline,
//             onSubmitted: print,
//             mentionables: widget.mentionableList,
//             decoration:
//             const InputDecoration(
//                 hintText: "Type Something...",
//                 hintStyle: TextStyle(color: Colors.blueAccent),
//                 border: InputBorder.none),
//             onChanged: (text)=> widget.onTextChange(text), onMentionablesChanged: (List<Mentionable> mentionables) {  },
//           ),
//
//         ],
//       ),
//     );
//   }
// }
//
// class MentionItem extends Mentionable{
//   late String name;
//   late String photo;
//   MentionItem(this.name, this.photo);
//   @override
//   // TODO: implement mentionLabel
//   String get mentionLabel => name;
//
//   @override
//   String get mentionPhoto => photo;
// }