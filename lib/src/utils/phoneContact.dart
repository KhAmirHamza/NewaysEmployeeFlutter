import 'dart:async';
import 'dart:typed_data' as td;

import 'package:fast_contacts/fast_contacts.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:neways3/src/utils/httpClient.dart';
import 'package:http/http.dart' as http;

class PhoneContacta {

  List<Contact> _contacts = const [];
  String? _text;

  Future<void> getContactPermissions() async {
    await Permission.contacts.request();
  }


  Future<void> loadContacts() async {
    try {

      if(await Permission.contacts.isGranted){
      _contacts = await FastContacts.getAllContacts();
      _contacts.removeWhere((element) => element.phones.isEmpty);
      }else{
        print("Permission Not Granted!");
      }

    } on PlatformException catch (e) {
      _text = 'Failed to get contacts:\n${e.details}';
      print(_text);
    }
  }






}
//
// class PhoneContact extends StatefulWidget {
//   const PhoneContact({super.key});
//
//   @override
//   State<PhoneContact> createState() => _PhoneContactState();
// }
//
// class _PhoneContactState extends State<PhoneContact> {
//
//   bool _isLoading = false;
//
//   final _ctrl = ScrollController();
//
//   Future<void> getContactPermissions() async {
//     await Permission.contacts.request();
//   }
//
//   Future<void> loadContacts() async {
//     try {
//
//       if(! (await Permission.contacts.isGranted)){
//         await Permission.contacts.request();
//       }
//       _isLoading = true;
//       if (mounted) setState(() {});
//       final sw = Stopwatch()..start();
//       _contacts = await FastContacts.getAllContacts();
//       _contacts.removeWhere((element) => element.phones.isEmpty);
//       sw.stop();
//       _text =
//           'Contacts: ${_contacts.length}\nTook: ${sw.elapsedMilliseconds}ms';
//     } on PlatformException catch (e) {
//       _text = 'Failed to get contacts:\n${e.details}';
//     } finally {
//       _isLoading = false;
//     }
//     if (!mounted) return;
//     setState(() {});
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       theme: ThemeData(
//         scrollbarTheme: ScrollbarThemeData(
//           trackVisibility: MaterialStateProperty.all(true),
//           thumbVisibility: MaterialStateProperty.all(true),
//         ),
//       ),
//       home: Scaffold(
//         appBar: AppBar(
//           title: const Text('fast_contacts'),
//         ),
//         body: Column(
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           children: [
//             TextButton(
//               onPressed: loadContacts,
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Container(
//                     height: 24,
//                     width: 24,
//                     child: AnimatedSwitcher(
//                       duration: const Duration(milliseconds: 300),
//                       child: _isLoading
//                           ? CircularProgressIndicator()
//                           : Icon(Icons.refresh),
//                     ),
//                   ),
//                   const SizedBox(width: 8),
//                   Text('Load contacts'),
//                 ],
//               ),
//             ),
//             Text(_text ?? 'Tap to load contacts', textAlign: TextAlign.center),
//             Expanded(
//               child: Scrollbar(
//                 controller: _ctrl,
//                 interactive: true,
//                 thickness: 24,
//                 child: ListView.builder(
//                   controller: _ctrl,
//                   itemCount: _contacts.length,
//                   itemExtent: _ContactItem.height,
//                   itemBuilder: (_, index) =>
//                       _ContactItem(contact: _contacts[index]),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
// class _ContactItem extends StatelessWidget {
//   const _ContactItem({
//     Key? key,
//     required this.contact,
//   }) : super(key: key);
//
//   static final height = 86.0;
//
//   final Contact contact;
//
//   @override
//   Widget build(BuildContext context) {
//     // final phones = contact.phones.map((e) => e.number).join(', ');
//     // final emails = contact.emails.map((e) => e.address).join(', ');
//     final phones = contact.phones.isNotEmpty?contact.phones.first.number:"";
//     final emails = contact.emails.isNotEmpty?contact.emails.first.address:"";
//     //final phones = contact.phones[0].number;
//     //final emails = contact.emails[0].address;
//     final name = contact.structuredName;
//     final nameStr = name != null
//         ? [
//             if (name.namePrefix.isNotEmpty) name.namePrefix,
//             if (name.givenName.isNotEmpty) name.givenName,
//             if (name.middleName.isNotEmpty) name.middleName,
//             if (name.familyName.isNotEmpty) name.familyName,
//             if (name.nameSuffix.isNotEmpty) name.nameSuffix,
//           ].join(', ')
//         : '';
//     final organization = contact.organization;
//     final organizationStr = organization != null
//         ? [
//             if (organization.company.isNotEmpty) organization.company,
//             if (organization.department.isNotEmpty) organization.department,
//             if (organization.jobDescription.isNotEmpty)
//               organization.jobDescription,
//           ].join(', ')
//         : '';
//
//     return SizedBox(
//       height: height,
//       child: ListTile(
//         leading: _ContactImage(contact: contact),
//         title: Text(
//           contact.displayName,
//           maxLines: 1,
//           overflow: TextOverflow.ellipsis,
//         ),
//         subtitle: Column(
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           children: [
//             if (phones.isNotEmpty)
//               Text(
//                 phones,
//                 maxLines: 1,
//                 overflow: TextOverflow.ellipsis,
//               ),
//             if (emails.isNotEmpty)
//               Text(
//                 emails,
//                 maxLines: 1,
//                 overflow: TextOverflow.ellipsis,
//               ),
//             // if (nameStr.isNotEmpty)
//             //   Text(
//             //     nameStr,
//             //     maxLines: 1,
//             //     overflow: TextOverflow.ellipsis,
//             //   ),
//             // if (organizationStr.isNotEmpty)
//             //   Text(
//             //     organizationStr,
//             //     maxLines: 1,
//             //     overflow: TextOverflow.ellipsis,
//             //   ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
// class _ContactImage extends StatefulWidget {
//   const _ContactImage({
//     Key? key,
//     required this.contact,
//   }) : super(key: key);
//
//   final Contact contact;
//
//   @override
//   __ContactImageState createState() => __ContactImageState();
// }
//
// class __ContactImageState extends State<_ContactImage> {
//   late Future<td.Uint8List?> _imageFuture;
//
//   @override
//   void initState() {
//     super.initState();
//     _imageFuture = FastContacts.getContactImage(widget.contact.id);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return FutureBuilder<td.Uint8List?>(
//       future: _imageFuture,
//       builder: (context, snapshot) => Container(
//         width: 56,
//         height: 56,
//         child: snapshot.hasData
//             ? Image.memory(snapshot.data!, gaplessPlayback: true)
//             : Icon(Icons.account_box_rounded),
//       ),
//     );
//   }
// }
