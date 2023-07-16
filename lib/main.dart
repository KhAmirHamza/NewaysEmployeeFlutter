// ignore_for_file: depend_on_referenced_packages

import 'package:elastic_drawer/elastic_drawer.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:month_year_picker/month_year_picker.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:neways3/src/features/message/ChatScreen.dart';
import 'package:neways3/src/features/message/controllers/SocketController.dart';
import 'package:neways3/src/features/phone_contact/controllers/PhoneContactController.dart';
import 'package:neways3/src/features/prebook/widgets/PrebookScreen.dart';
import 'package:neways3/src/features/splash/SplashScreen.dart';
import 'package:neways3/src/utils/constants.dart';
import 'package:neways3/src/utils/functions.dart';
import 'package:neways3/src/utils/phoneContact.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:socket_io_client/socket_io_client.dart';

 
final FlutterLocalNotificationsPlugin _notificationsPlugin =
    FlutterLocalNotificationsPlugin();
final FirebaseMessaging messaging = FirebaseMessaging.instance;
const AndroidNotificationChannel androidNotificationChannel =
    AndroidNotificationChannel('neways3', 'Neways3',
        importance: Importance.high);

const AndroidNotificationDetails androidPlatformChannelSpecifics =
    AndroidNotificationDetails('neways3', 'Neways3',
        importance: Importance.max,
        priority: Priority.max,
        enableLights: true,
        ledColor: Colors.yellow,
        ledOnMs: 1000,
        ledOffMs: 1000,
        playSound: true,
        enableVibration: true,
        icon: '@mipmap/ic_launcher');

const NotificationDetails platformChannelSpecifics =
    NotificationDetails(android: androidPlatformChannelSpecifics);

Future<void> _firebaseMessageHandler(RemoteMessage message) async {
  if (message.contentAvailable) {
    _notificationsPlugin.show(
        message.notification.hashCode,
        message.notification!.title,
        message.notification!.body,
        platformChannelSpecifics);
  }
  setNotification(message);
}

void setNotification(RemoteMessage message) async {
  Box box = await openBox(name: "notifications");
  box.add({
    "title": message.notification!.title.toString(),
    "body": message.notification!.body.toString(),
    "image": message.notification!.android!.imageUrl,
    "read": false,
    "time": DateTime.now().toIso8601String(),
  });
  Get.snackbar(message.notification!.title.toString(),
      message.notification!.body.toString(),
      isDismissible: true,
      onTap: ((snack) =>  ChatScreen(socket!)),
      colorText: Colors.white,
      backgroundColor: Colors.black,
      barBlur: 60,
      icon: const Icon(
        Icons.chat,
        color: Colors.white,
        size: 28,
      ));
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  // var isEnabled = await Wakelock.enabled;
  // if (!isEnabled) {
  //   await Wakelock.enable();
  // }
  FirebaseMessaging.onBackgroundMessage(_firebaseMessageHandler);
  FirebaseMessaging.onMessage
      .listen((RemoteMessage message) => _firebaseMessageHandler(message));
  messaging.setForegroundNotificationPresentationOptions(
      alert: true, badge: true, sound: true);

  _notificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(androidNotificationChannel);

  _notificationsPlugin
      .resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin>()
      ?.requestPermissions(
        alert: true,
        badge: true,
        sound: true,
      );
  await GetStorage.init();
  await Hive.initFlutter();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();

}

class _MyAppState extends State<MyApp> {

  Socket? socket ;


  @override
  void initState() {
    super.initState();

    SocketController socketController = SocketController();
    socket =  socketController.getInstance();


  }

  @override
  void dispose() {
    if(socket!=null) {
      socket!.disconnect();
    }
    super.dispose();
  }


  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Neways3',
      theme: ThemeData(
        // primarySwatch: DFColor.primary,
        scaffoldBackgroundColor: Colors.white,
        colorScheme: ColorScheme.fromSwatch().copyWith(
          primary: DColors.primary,
          secondary: DColors.primary.withOpacity(.7),
        ),
      ),
      localizationsDelegates: const [
        GlobalWidgetsLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        MonthYearPickerLocalizations.delegate,
      ],
      builder: EasyLoading.init(),
      home:

        //PrebookScreen()

      // InkWell(
      //   onTap: (){
      //     PhoneContactController().loadContacts("72505", "employee");
      //   },
      //   child: Center(child: Text("test")),
      // )

      SplashScreen(socket!)


    );
  }
}



