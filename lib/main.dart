// ignore_for_file: depend_on_referenced_packages

import 'dart:convert';

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
import 'package:neways3/src/features/main/MainPage.dart';
import 'package:neways3/src/features/message/ChatScreen.dart';
import 'package:neways3/src/features/message/controllers/SocketController.dart';
import 'package:neways3/src/features/splash/SplashScreen.dart';
import 'package:neways3/src/utils/LocalNotificationService.dart';
import 'package:neways3/src/utils/constants.dart';
import 'package:neways3/src/utils/functions.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:socket_io_client/socket_io_client.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationPlugin = FlutterLocalNotificationsPlugin();
final FirebaseMessaging messaging = FirebaseMessaging.instance;
const AndroidNotificationChannel androidNotificationChannel = AndroidNotificationChannel('neways3', 'Neways3', importance: Importance.high);
const AndroidNotificationDetails  androidNotificationDetails = AndroidNotificationDetails('neways3', 'Neways3',
        importance: Importance.max,
        priority: Priority.max,
        enableLights: true,
        ledColor: Colors.yellow,
        ledOnMs: 1000,
        ledOffMs: 1000,
        playSound: true,
        enableVibration: true,
        icon: '@mipmap/ic_launcher');
const NotificationDetails platformChannelSpecifics = NotificationDetails(android: androidNotificationDetails);
Future<void> _firebaseMessageHandler(RemoteMessage message) async {
  routeToGo = "chat";
  if (message.contentAvailable) {
    flutterLocalNotificationPlugin.show(
        message.notification.hashCode,
        message.notification!.title,
        message.notification!.body!,//jsonDecode(message.notification!.body!)['message'].toString(),
        platformChannelSpecifics);
  }
  // setNotification(message);
  // Initialise  localnotification
//  print("NotificationData: ${message.data.toString()}");

  if (message.data.isNotEmpty) {
    //LocalNotificationService.display(message);
    String? payload = message.data['message'];
      flutterLocalNotificationPlugin.show(
          message.notification.hashCode,
          message.data['title'],
          message.data['message'],
          platformChannelSpecifics, payload: payload);
  }
 // setNotification(message);

}
void setNotification(RemoteMessage message) async {
  routeToGo = "chat";
  //print(jsonEncode("Notification1: ${message.notification!.toMap().toString()}"));
  //print(jsonEncode("Data1: ${message.data['title'].toString()}"));

  // Box box = await openBox(name: "notifications");
  // box.add({
  //   "route": "Chat",
  //   "title": message.data['title'].toString(),
  //   "body": message.data['message'].toString(),
  //   "image": message.notification!.android!.imageUrl,
  //   "read": false,
  //   "time": DateTime.now().toIso8601String(),
  // });
  Box box = await openBox(name: "notifications");
  box.add({
    "route": "Chat",
    "title": message.data['title'].toString(),
    "body": message.data['message'].toString(),
    "image": message.data['image'].toString(),
    "read": false,
    "time": DateTime.now().toIso8601String(),
  });
  Get.snackbar(message.data['title'].toString(),
      message.data['message'].toString(),
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

final GlobalKey<NavigatorState> navigatorKey =
    GlobalKey(debugLabel: "Main Navigator");

late String routeToGo = '/';
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
FlutterLocalNotificationsPlugin();
String? payload;

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
 // print("_firebaseMessagingBackgroundHandler Clicked!");
  routeToGo = '/second';
 // print(message.notification!.body);
  flutterLocalNotificationsPlugin.show(
      message.notification.hashCode,
      message.notification?.title,
      message.notification?.body,
      NotificationDetails(
        android: AndroidNotificationDetails(
          channel.id,
          channel.name,
        ),
      ));
}

const AndroidNotificationChannel channel = AndroidNotificationChannel(
  'high_importance_channel', // id
  'High Importance Notifications', // titletion
  importance: Importance.high,
);


Future<void> selectNotification(String? payload) async {
  routeToGo = "chat";
  if (payload != null) {
    debugPrint('notification payload: $payload');
    navigatorKey.currentState?.pushNamed('/second');
  }
}

void main() async {
  SocketController socketController = SocketController();
  socket = socketController.getInstance();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  // var isEnabled = await Wakelock.enabled;
  // if (!isEnabled) {
  //   await Wakelock.enable();
  // }



  FirebaseMessaging.onBackgroundMessage(_firebaseMessageHandler);

  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    routeToGo = "chat";
  //  print("onMessageOpenedApp : called");
   // print("Data2: ${message.data['title'].toString()}");
    GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
    //Navigator.of(navigatorKey.currentState!.context).pushNamed(MainPage(socket!, 0));

    Navigator.push(
        navigatorKey.currentState!.context,
    MaterialPageRoute(
    builder: (context) => ChatScreen(socket!)));
  });

  FirebaseMessaging.onMessage.listen((RemoteMessage message) => _firebaseMessageHandler(message));



  messaging.setForegroundNotificationPresentationOptions(alert: true, badge: true, sound: true);

  flutterLocalNotificationPlugin.resolvePlatformSpecificImplementation< AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(androidNotificationChannel);

  flutterLocalNotificationPlugin.resolvePlatformSpecificImplementation<
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
  Socket? socket;

  late String token;
  getToken() async {
    token = (await FirebaseMessaging.instance.getToken())!;
    print(token);
  }

  @override
  void initState() {
    super.initState();
    SocketController socketController = SocketController();
    socket = socketController.getInstance();
    getToken();
  }

  @override
  void dispose() {
    if (socket != null) {
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
        navigatorKey: navigatorKey,
        initialRoute: routeToGo.isNotEmpty ? routeToGo : '/',
        // home: const MyHomePage(title: 'Flutter Demo Home Page'),
        onGenerateRoute: (RouteSettings settings) {
          switch (settings.name) {
            case '/':
              return MaterialPageRoute(
                builder: (_) => SplashScreen(socket!),
              );
              break;
            case '/chat':
              return MaterialPageRoute(
                builder: (_) => MainPage( socket!, 0 ),
              );
              break;
            // default:
            //   return _errorRoute();
          }
        },
       // home: SplashScreen(socket!)
    );
            // MentionableTextFieldWidget([
            //   MentionItem("Khandakar"),
            //   MentionItem("Amir"),
            //   MentionItem("Hamza")])

            //PrebookScreen()

            // InkWell(
            //   onTap: (){
            //     PhoneContactController().loadContacts("72505", "employee");
            //   },
            //   child: Center(child: Text("test")),
            // )


  }
}

/*setUpNotificationClick(FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin){
  const AndroidInitializationSettings initializationSettingsAndroid =
  AndroidInitializationSettings('app_icon');


  const InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid);
  // await flutterLocalNotificationsPlugin.initialize(initializationSettings,
  //     onSelectNotification: onSelectNotification);
}*/
