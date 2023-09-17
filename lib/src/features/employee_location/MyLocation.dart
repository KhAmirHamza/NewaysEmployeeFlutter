// import 'dart:async';
//
// import 'package:flutter/foundation.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:geolocator_apple/geolocator_apple.dart';
// import 'package:geolocator_android/geolocator_android.dart';
// import 'package:neways3/src/utils/functions.dart';
//
//
// class MyLocation{
//
//
//
//   /// Determine the current position of the device.
//   ///
//   /// When the location services are not enabled or permissions
//   /// are denied the `Future` will return an error.
//   Future<Position> determinePosition() async {
//     bool serviceEnabled;
//     LocationPermission permission;
//
//     // Test if location services are enabled.
//     serviceEnabled = await Geolocator.isLocationServiceEnabled();
//     if (!serviceEnabled) {
//       // Location services are not enabled don't continue
//       // accessing the position and request users of the
//       // App to enable the location services.
//       return Future.error('Location services are disabled.');
//     }
//
//     permission = await Geolocator.checkPermission();
//     if (permission == LocationPermission.denied) {
//       permission = await Geolocator.requestPermission();
//       if (permission == LocationPermission.denied) {
//         // Permissions are denied, next time you could try
//         // requesting permissions again (this is also where
//         // Android's shouldShowRequestPermissionRationale
//         // returned true. According to Android guidelines
//         // your App should show an explanatory UI now.
//         return Future.error('Location permissions are denied');
//       }
//     }
//
//     if (permission == LocationPermission.deniedForever) {
//       // Permissions are denied forever, handle appropriately.
//       return Future.error(
//           'Location permissions are permanently denied, we cannot request permissions.');
//     }
//
//     // When we reach here, permissions are granted and we can
//     // continue accessing the position of the device.
//     Position? position =  await Geolocator.getCurrentPosition();
//     print(position == null ? 'Unknown' : '${position.latitude.toString()}, ${position.longitude.toString()}');
//     return position;
//   }
//
//
//   static getLocationUpdates(Function onUpdates){
//     late LocationSettings locationSettings;
//
//     if (defaultTargetPlatform == TargetPlatform.android) {
//       locationSettings = AndroidSettings(
//           accuracy: LocationAccuracy.high,
//           distanceFilter: 1,
//           forceLocationManager: true,
//           intervalDuration: const Duration(seconds: 10),
//           //(Optional) Set foreground notification config to keep the app alive
//           //when going to the background
//           foregroundNotificationConfig: const ForegroundNotificationConfig(
//             notificationText:
//             "Example app will continue to receive your location even when you aren't using it",
//             notificationTitle: "Running in Background",
//             enableWakeLock: true,
//           )
//       );
//     } else if (defaultTargetPlatform == TargetPlatform.iOS || defaultTargetPlatform == TargetPlatform.macOS) {
//       locationSettings = AppleSettings(
//         accuracy: LocationAccuracy.high,
//         activityType: ActivityType.fitness,
//         distanceFilter: 100,
//         pauseLocationUpdatesAutomatically: true,
//         // Only set to true if our app will be started up in the background.
//         showBackgroundLocationIndicator: false,
//       );
//     } else {
//       locationSettings = const LocationSettings(
//         accuracy: LocationAccuracy.high,
//         distanceFilter: 100,
//       );
//     }
//
//     StreamSubscription<Position> positionStream = Geolocator.getPositionStream(locationSettings: locationSettings).listen(
//             (Position? position) {
//
//           if(position!=null){
//             print('1: ${position.latitude.toString()}, ${position.longitude.toString()}');
//             onUpdates(position);
//           }
//
//         });
//   }
//
//
//
//
//
//   static const String _kLocationServicesDisabledMessage =
//       'Location services are disabled.';
//   static const String _kPermissionDeniedMessage = 'Permission denied.';
//   static const String _kPermissionDeniedForeverMessage =
//       'Permission denied forever.';
//   static const String _kPermissionGrantedMessage = 'Permission granted.';
//
//   final GeolocatorPlatform _geolocatorPlatform = GeolocatorPlatform.instance;
//   final List<_PositionItem> _positionItems = <_PositionItem>[];
//   StreamSubscription<Position>? _positionStreamSubscription;
//   StreamSubscription<ServiceStatus>? _serviceStatusStreamSubscription;
//   bool positionStreamStarted = false;
//
//
//
//
//   void _updatePositionList(_PositionItemType type, String displayValue) {
//     _positionItems.add(_PositionItem(type, displayValue));
//     //setState(() {});
//   }
//
//   Future<bool> _handlePermission() async {
//     bool serviceEnabled;
//     LocationPermission permission;
//
//     // Test if location services are enabled.
//     serviceEnabled = await _geolocatorPlatform.isLocationServiceEnabled();
//     if (!serviceEnabled) {
//       // Location services are not enabled don't continue
//       // accessing the position and request users of the
//       // App to enable the location services.
//       _updatePositionList(
//         _PositionItemType.log,
//         _kLocationServicesDisabledMessage,
//       );
//
//       return false;
//     }
//
//     permission = await _geolocatorPlatform.checkPermission();
//     if (permission == LocationPermission.denied) {
//       permission = await _geolocatorPlatform.requestPermission();
//       if (permission == LocationPermission.denied) {
//         // Permissions are denied, next time you could try
//         // requesting permissions again (this is also where
//         // Android's shouldShowRequestPermissionRationale
//         // returned true. According to Android guidelines
//         // your App should show an explanatory UI now.
//         _updatePositionList(
//           _PositionItemType.log,
//           _kPermissionDeniedMessage,
//         );
//
//         return false;
//       }
//     }
//
//     if (permission == LocationPermission.deniedForever) {
//       // Permissions are denied forever, handle appropriately.
//       _updatePositionList(
//         _PositionItemType.log,
//         _kPermissionDeniedForeverMessage,
//       );
//
//       return false;
//     }
//
//     // When we reach here, permissions are granted and we can
//     // continue accessing the position of the device.
//     _updatePositionList(
//       _PositionItemType.log,
//       _kPermissionGrantedMessage,
//     );
//     return true;
//   }
//
//   Future<void> _getCurrentPosition() async {
//     final hasPermission = await _handlePermission();
//
//     if (!hasPermission) {
//       return;
//     }
//
//     final position = await _geolocatorPlatform.getCurrentPosition();
//     _updatePositionList(
//       _PositionItemType.position,
//       position.toString(),
//     );
//   }
//
//
//
//   }
//
//
// enum _PositionItemType {
//   log,
//   position,
// }
//
// class _PositionItem {
//   _PositionItem(this.type, this.displayValue);
//
//   final _PositionItemType type;
//   final String displayValue;
// }
//
//
