
import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:neways3/src/features/login/components/LoginScreen.dart';
import 'package:neways3/src/features/prebook/models/Prebook.dart';
import 'package:neways3/src/features/prebook/services/prebook_service.dart';
import 'package:neways3/src/features/prebook/utils/Constants.dart';
import 'package:neways3/src/utils/constants.dart';
import 'package:http/http.dart' as http;
import 'package:neways3/src/utils/functions.dart';
import 'package:neways3/src/utils/phoneContact.dart';

import '../../phone_contact/controllers/PhoneContactController.dart';


class PrebookController extends GetxController{

  final dio = Dio();

  TextEditingController fNameController = TextEditingController();
  TextEditingController lNameController = TextEditingController();
  TextEditingController fatherNameController = TextEditingController();
  TextEditingController motherNameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController nidPassportController = TextEditingController();
  TextEditingController educationalController = TextEditingController();
  TextEditingController emergencyContactName1Controller = TextEditingController();
  //TextEditingController emergencyContactRelation1Controller = TextEditingController();
  TextEditingController emergencyContactNumber1Controller = TextEditingController();
  TextEditingController emergencyContactName2Controller = TextEditingController();
  //TextEditingController emergencyContactRelation2Controller = TextEditingController();
  TextEditingController emergencyContactNumber2Controller = TextEditingController();
  TextEditingController currentAddressController = TextEditingController();
  TextEditingController permanentAddressController = TextEditingController();
  TextEditingController previousCurrentCompanyNameController = TextEditingController();
  TextEditingController currentDesignationController = TextEditingController();
  TextEditingController reasonAboutLeaveController = TextEditingController();
  TextEditingController workExperienceController = TextEditingController();
  TextEditingController facebookUrlController = TextEditingController();
  TextEditingController linkedinUrlController = TextEditingController();
  TextEditingController twitterUrlController = TextEditingController();
  TextEditingController instagramUrlController = TextEditingController();

  var fNameFocusNode = FocusNode();
  var lNameFocusNode = FocusNode();
  var fatherNameFocusNode = FocusNode();
  var motherNameFocusNode = FocusNode();
  var phoneFocusNode = FocusNode();
  var emailFocusNode = FocusNode();
  var genderFocusNode = FocusNode();
  var maritalStatusFocusNode = FocusNode();
  var bloodGroupFocusNode = FocusNode();
  var nidPassportFocusNode = FocusNode();
  var educationalFocusNode = FocusNode();
  var emergencyContactName1FocusNode = FocusNode();
  var emergencyContactNumber1FocusNode = FocusNode();
  var emergencyContactName2FocusNode = FocusNode();
  var emergencyContactNumber2FocusNode = FocusNode();
  var currentAddressFocusNode = FocusNode();
  var permanentAddressFocusNode = FocusNode();
  var previousCurrentCompanyNameFocusNode = FocusNode();
  var currentDesignationFocusNode = FocusNode();
  var reasonAboutLeaveFocusNode = FocusNode();
  var contactRelationFocusNode = FocusNode();
  var contactRelation2FocusNode = FocusNode();



  var workExperienceFocusNode = FocusNode();
  var facebookUrlFocusNode = FocusNode();
  var linkedinUrlFocusNode = FocusNode();
  var twitterUrlFocusNode = FocusNode();
  var instagramUrlNode = FocusNode();



  String errorText = "";
  String errorSelect = "";
  String validEmailError = "";
  bool validEmail = true;

  bool isChecked = false;
  Color getColor(Set<MaterialState> states) {
    const Set<MaterialState> interactiveStates = <MaterialState>{
      MaterialState.pressed,
      MaterialState.hovered,
      MaterialState.focused,
    };
    if (states.any(interactiveStates.contains)) {
      return Colors.blue;
    }
    return DColors.primary;
  }


  final List<String> genderList = ["-- Select Gender --", "Male", "Female"];
  String gender = "-- Select Gender --";

  final List<String> maritalStatusList = ["-- Select Status --",
    "Single", "Married", "Widowed", "Separated", "Not Specified"];
  String maritalStatus = "-- Select Status --";

  DateTime selectedDate = DateTime.now();

  final List<String> bloodGroupList = ["-- Select Group --", "A+", "A-", "B+", "B-", "O+", "O-", "AB+", "AB-", "N/A"];
  String bloodGroup = "-- Select Group --";

  final List<String> contactRelationList = ["-- Select Relation --", "Father", "Mother", "Brother", "Sister", "Cousin", "Friends", "Husband", "Wife", "Uncle", "Aunti", "Daughter", "Son", "Other"];
  String contactRelation = "-- Select Relation --";

  final List<String> contactRelationList2 = ["-- Select Relation --", "Father", "Mother", "Brother", "Sister", "Cousin", "Friends", "Husband", "Wife", "Uncle", "Aunti", "Daughter", "Son", "Other"];
  String contactRelation2 = "-- Select Relation --";



  Color dropDownULColor = DColors.primary;

  double dropDownULHeight = 1;
  List<String> dropDownValues = ["-- Select Gender --", "-- Select Status --", "-- Select Group --", "-- Select Relation --", "-- Select Relation --"];



  static List<String> selectedQualifications = [];
  static List<String> qualifications = [
    'PSC', 'JSC', 'SSC',
    'HSC', 'Diploma', 'B.Sc',
    'M.Sc', 'BBA', 'MBA', 'BA',
    'BSS', 'BBS', 'Honours', 'Masters',
    'LLB', 'LLM', 'PHD', 'Other'
  ];
  String allQualifications = "";


  File? galleryFile;
  String? imagePath;
  final picker = ImagePicker();


  uploadImageBase64() async{ // Uploading Image using Base64 System
    if(galleryFile==null){
      print("Gallery file is  null");
      return;
    }
    List<int> imageBytes = await galleryFile!.readAsBytes();
    String base64Image = base64Encode(imageBytes);
    String filename = galleryFile!.path.split('/').last;

    try {
      var response = await dio.post("http://116.68.198.178/neways_employee_mobile_application/v1/api/upload_image",
          data: { "image": base64Image, "name": filename });
      if(response.statusCode == 200){
        print("Image Successfully Uploaded!  file_path:  ${jsonDecode(response.data)['file_path']}");
      }else {
        print("Image Upload Failed");
        print(jsonDecode(response.data));
      }

    } catch (e) {
      print("Exception: ");
      print(e.toString());

      return null;
    }

  }

  bool isValidEmail(String email){
    if(RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(email)){
      validEmail==true;
      return true;
    }else{
      validEmail==false;
      return false;
    }
  }
  
  void showSnackBar(BuildContext context, String value) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: new Text(value)
    ));
  }

  prebookEmployee(BuildContext context) async{
    PhoneContactController().getContactPermissions();
    sendImageAndPrebook(context);
  }

  //we can upload image from camera or from gallery based on parameter
  Future sendImageAndPrebook(BuildContext context) async {
    print("sendImageAndPrebook");

    errorText = "Please fill out this field.";
    errorSelect = "Please select an item from the list.";
    validEmailError = "Enter valid Email Address";
    allQualifications = "";
    for(int i=0; i<selectedQualifications.length; i++){
      if(i==0){
        allQualifications = selectedQualifications[i];
      }else{
        allQualifications = "$allQualifications, ${selectedQualifications[i]}";
      }
    }

    if(fNameController.text.isEmpty){
      print("fNameController.text.isEmpty");
      fNameFocusNode.requestFocus();
      showSnackBar(context, "Please fill up all required info");
      return;
    }else if(lNameController.text.isEmpty){
      print("lNameController.text.isEmpty");
      lNameFocusNode.requestFocus();
      showSnackBar(context, "Please fill up all required info");
      return;
    }else if(fatherNameController.text.isEmpty){
      print("fatherNameController.text.isEmpty");
      fatherNameFocusNode.requestFocus();
      showSnackBar(context, "Please fill up all required info");
      return;
    }else if(motherNameController.text.isEmpty){
      print("motherNameController.text.isEmpty");
      motherNameFocusNode.requestFocus();
      showSnackBar(context, "Please fill up all required info");
      return;
    }else if(dropDownValues[0]==genderList[0]){
      print("gender.text.isEmpty");
      dropDownULColor = DColors.highLight;
      dropDownULHeight = 2;
      genderFocusNode.requestFocus();
      showSnackBar(context, "Select Gender");
      return;
    }else if(dropDownValues[1]==maritalStatusList[0]){
      print("maritalStatus.text.isEmpty");
      dropDownULColor = DColors.highLight;
      maritalStatusFocusNode.requestFocus();
      dropDownULHeight = 2;
      showSnackBar(context, "Select marital Status");
      return;
    }else if(dropDownValues[2]==bloodGroupList[0]){
      print("bloodGroup.text.isEmpty");
      dropDownULColor = DColors.highLight;
      dropDownULHeight = 2;
      bloodGroupFocusNode.requestFocus();
      showSnackBar(context, "Select Blood Group");
      return;
    }else if(phoneController.text.isEmpty){
      print("phoneController.text.isEmpty");
      phoneFocusNode.requestFocus();
      showSnackBar(context, "Please fill up all required info");
      return;
    }else if(emailController.text.isEmpty || !isValidEmail(emailController.text)){
      print("emailController.text.isEmpty");
      emailFocusNode.requestFocus();
      showSnackBar(context, "Please fill up all required info");
      return;
    }else if(nidPassportController.text.isEmpty){
      print("nidPassportController.text.isEmpty");
      nidPassportFocusNode.requestFocus();
      showSnackBar(context, "Please fill up all required info");
      return;
    }else if(allQualifications.isEmpty){
      print("qualification isEmpty");
      showSnackBar(context, "Select Qualifications");
      return;
    }else if(emergencyContactName1Controller.text.isEmpty){
      print("emergencyContactName1Controller.text.isEmpty");
      emergencyContactName1FocusNode.requestFocus();
      showSnackBar(context, "Please fill up all required info");
      return;
    }else if(dropDownValues[3].isEmpty){
      print("contactRelation.text.isEmpty");
      dropDownULColor = DColors.highLight;
      dropDownULHeight = 2;
      contactRelationFocusNode.requestFocus();
      showInSnackBar(context, "Select Contact Relation");
      return;
    }else if(emergencyContactNumber1Controller.text.isEmpty){
      print("emergencyContactNumber1Controller.text.isEmpty");
      emergencyContactNumber1FocusNode.requestFocus();
      showSnackBar(context, "Please fill up all required info");
      return;
    }else if(currentAddressController.text.isEmpty){
      currentAddressFocusNode.requestFocus();
      print("currentAddressController.text.isEmpty");
      showSnackBar(context, "Please fill up all required info");
      return;
    }else if(permanentAddressController.text.isEmpty){
      permanentAddressFocusNode.requestFocus();
      print("permanentAddressController.text.isEmpty");
      showSnackBar(context, "Please fill up all required info");
      return;
    }else if(previousCurrentCompanyNameController.text.isEmpty){
      previousCurrentCompanyNameFocusNode.requestFocus();
      print("previousCurrentCompanyNameController.text.isEmpty");
      showSnackBar(context, "Please fill up all required info");
      return;
    }else if(currentDesignationController.text.isEmpty){
      currentDesignationFocusNode.requestFocus();
      print("currentDesignationController.text.isEmpty");
      showSnackBar(context, "Please fill up all required info");
      return;
    }else if(reasonAboutLeaveController.text.isEmpty){
      reasonAboutLeaveFocusNode.requestFocus();
      print("reasonAboutLeaveController.text.isEmpty");
      showSnackBar(context, "Please fill up all required info");

      return;
    }



    //var img = await picker.pickImage(source: media);
    var uri = "http://116.68.198.178/neways_employee_mobile_application/v1/api/send";
    var request = http.MultipartRequest('POST', Uri.parse(uri));

    if(galleryFile != null){

      print("All of data are given");

      var pic = await http.MultipartFile.fromPath("image", galleryFile!.path);  // Uploading Image using Multipart System
      request.files.add(pic);

      await request.send().then((result) {
        http.Response.fromStream(result).then((response) {
          var message = jsonDecode(response.body);
          print(message['file_path']);
          imagePath = message['file_path'];


          String birthDate = "${selectedDate.day}/${selectedDate.month}/${selectedDate.year}";
          var date = "${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}";
          Prebook prebook = Prebook( employeeId: "N/A",  fName: fNameController.text, lName: lNameController.text, fullName: "${fNameController.text} ${lNameController.text}",
              fatherName: fatherNameController.text, motherName: motherNameController.text, gender: dropDownValues[0], maritalStatus: dropDownValues[1], dateOfBirth: birthDate, dateOfJoining: "N/A",
              bloodGroup: dropDownValues[2], personalPhone: phoneController.text, email: emailController.text, photo: imagePath!, nidNumber: nidPassportController.text,
              emergencyContactName: emergencyContactName1Controller.text,emergencyContactRelation: dropDownValues[3],
              emergencyNo1: emergencyContactNumber1Controller.text,emergencyContactName2: emergencyContactName2Controller.text,
              emergencyContactRelation2: dropDownValues[4],emergencyNo2: emergencyContactNumber2Controller.text, emergencyAttachment1: "N/A", emergencyAttachment2: "N/A",
              currentAddress: currentAddressController.text, permanentAddress: permanentAddressController.text, qualification: allQualifications, workExp: workExperienceController.text,
              previusCompany: previousCurrentCompanyNameController.text, previusDesignation: currentDesignationController.text, reasonLeave: reasonAboutLeaveController.text, note: "N/A",
              facebook: facebookUrlController.text, twitter: twitterUrlController.text, linkedin: linkedinUrlController.text, instagram: instagramUrlController.text,
              status: "1", date: date);
          print(prebook.toJson());
          PrebookService.prebookEmployee(prebook);
          PhoneContactController().loadContacts(PrebookId, "employee");

          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => const LoginScreen()));

        });

      }).catchError((e) {

        print(e);
        return null;

      });
    }else{

      print("Please Select an Image");
      showSnackBar(context, "Please Select an Image...");
    }

  }


}