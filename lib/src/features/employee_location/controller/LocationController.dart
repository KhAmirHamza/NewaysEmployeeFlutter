import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:location/location.dart' as MyLocation;
import 'package:geocoding/geocoding.dart' as  GeoCoding;
import 'package:location/location.dart';
import 'package:neways3/src/features/employee_location/services/MyLocationService.dart';

import '../../../utils/functions.dart';
import '../../workplace/model/EmployeeLocation.dart';

class LocationController extends GetxController{
  final box = GetStorage();
  List<EmployeeLocation> employeeLocations = [];
  final MyLocation.Location location = MyLocation.Location();
  MyLocation.PermissionStatus? _permissionGranted;
  MyLocation.LocationData? _locationData;
  bool _serviceEnabled = false;
  List<GeoCoding.Placemark>? placeMarks;
  BuildContext? buildContext;
  int previousSecond = 0;
  late bool isLoading = false;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    getEmployeesLocation();
    location.enableBackgroundMode(enable: true);
  }


  setContext(BuildContext context) {
    buildContext = context;
  }

  enableLocation() async {
    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        print("Location Disable");
        return;
      }else{
        print("Location Enabled");
        checkPermission();
      }
    }else{
      print("Location previously Enabled");
      checkPermission();
    }
  }


  checkPermission() async {
    if(_serviceEnabled) {
      _permissionGranted = await location.hasPermission();
      if (_permissionGranted == MyLocation.PermissionStatus.denied) {
        print("Permission previously granted");
        _permissionGranted = await location.requestPermission();
        if (_permissionGranted != MyLocation.PermissionStatus.granted) {
          print("Permission requested, not granted");
          checkPermission();
         // return;
        }else{
          getContinuousLocationCallback((locationData) async {

            print("getContinuousLocationCallback called");
            await getAddressFromLocationData();
            if(placeMarks !=null && placeMarks!.isNotEmpty)
            {
              Placemark element = placeMarks![0];

              String address = '${element.street!}, ${element.subLocality!}, ${element.locality!}, ${element.country!}';
              print(address);
              if(buildContext!.mounted) {
                showInSnackBar(buildContext!, address);
              }
            }
          });
        }
      }else{
        getContinuousLocationCallback((locationData) async {

          print("getContinuousLocationCallback called");
          await getAddressFromLocationData();
          if(placeMarks !=null && placeMarks!.isNotEmpty)
          {
            Placemark element = placeMarks![0];

            String address = '${element.street!}, ${element.subLocality!}, ${element.locality!}, ${element.country!}';
            print(address);
            if(buildContext!.mounted) {
              showInSnackBar(buildContext!, address);
            }
          }
        });
      }
    }
  }

  getCurrentLocation() async {
    if(_permissionGranted != null) {
      _locationData = await location.getLocation();
    }
  }

  getContinuousLocationCallback(Function(MyLocation.LocationData locationData) continuousLocationCallBack){
    location.onLocationChanged.listen((MyLocation.LocationData currentLocation) {
      _locationData = currentLocation;
      if(_locationData!=null ) {
        DateTime now = DateTime.now();

        //print("second: ${now.second}");
        if(now.second-previousSecond>29 || (now.second-previousSecond)<0) {
          //continuousLocationCallBack(currentLocation);
          updateLocation(currentLocation);
          previousSecond = now.second;
        }
      }
    });
  }

  getAddressFromLocationData() async {
    placeMarks = await GeoCoding.placemarkFromCoordinates(_locationData!.latitude!, _locationData!.longitude!);
    //for (var element in placeMarks!) { print(element.name!);}

  }



   updateLocation(LocationData locationData) async {
    String employeeId = GetStorage().read('employeeId');
    if(employeeId.isNotEmpty){
      await getAddressFromLocationData();
      if(placeMarks !=null && placeMarks!.isNotEmpty){
        Placemark element = placeMarks![0];
        String address = '${element.street!}, ${element.subLocality!}, ${element.locality!}, ${element.country!}';
        if(buildContext!.mounted) {
          await MyLocationService.updateLocation(
              data: {"user_id": employeeId ,"latitude":"${locationData.latitude}", "longitude": '${locationData.longitude}', "address": address}
          ).then((value) {
            if (value.runtimeType == String) {
              print("updateLocation Called");
            } else {
              // error
            }
          });
        }
      }
    }
  }


  getEmployeesLocation() async {
    print("getEmployeesLocation");
  EasyLoading.show();
    //String employeeId = GetStorage().read('employeeId');
    await MyLocationService.getLocations(skip: 0, limit: 20).then((result){
      if(result.runtimeType == List<EmployeeLocation>){
        employeeLocations = result;
        isLoading = false;
      }
    });

    EasyLoading.dismiss();
    isLoading = false;

    update();
  }

}