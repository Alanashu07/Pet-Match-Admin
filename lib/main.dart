import 'dart:async';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:pet_match_admin/Constants/global_variables.dart';
import 'package:pet_match_admin/Style/app_style.dart';
import 'package:pet_match_admin/firebase_options.dart';
import 'package:pet_match_admin/splash_screen.dart';
import 'package:provider/provider.dart';
import 'Screens/not_connected_screen.dart';
import 'Services/firebase_services.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform
  );
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  bool isConnectedToInternet = true;
  StreamSubscription? _internetStreamSubscription;

  @override
  void initState() {
    GlobalVariables.getCurrentUser();
    GlobalVariables.getPets();
    GlobalVariables.getAllUsers();
    GlobalVariables.getAllAccessories();
    GlobalVariables.getCategories();
    super.initState();

    _internetStreamSubscription = InternetConnection().onStatusChange.listen((event) {
      switch(event) {
        case InternetStatus.connected:
          setState(() {
            isConnectedToInternet = true;
          });
          break;
        case InternetStatus.disconnected:
          setState(() {
            isConnectedToInternet = false;
          });
          break;
        default:
          setState(() {
            isConnectedToInternet = false;
          });
          break;
      }
    },);
    SystemChannels.lifecycle.setMessageHandler((message) {
      if (message!.contains("resumed")) {
        print(true);
        FirebaseServices.updateActiveStatus(true);
      } else {
        print(false);
        FirebaseServices.updateActiveStatus(false);
      }
      return Future.value(message);
    },);
  }

  @override
  void dispose() {
    _internetStreamSubscription?.cancel();
    super.dispose();
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => GlobalVariables(),)
      ],
      child: Container(
        color: Colors.white,
        child: MaterialApp(
          title: 'Pet Match Admin',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: AppStyle.accentColor),
            scaffoldBackgroundColor: AppStyle.mainColor.withOpacity(0.1),
            appBarTheme: const AppBarTheme(backgroundColor: Colors.transparent),
            useMaterial3: true,
          ),
          home: isConnectedToInternet ? const SplashScreen() : const NotConnectedScreen()
        ),
      ),
    );
  }
}
