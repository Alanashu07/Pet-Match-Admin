import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lottie/lottie.dart';
import 'Constants/global_variables.dart';
import 'Screens/MainScreens/bottom_bar.dart';
import 'Screens/MainScreens/pending_screen.dart';
import 'Screens/login_page.dart';
import 'Services/firebase_services.dart';
import 'Style/app_style.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  Future<void> _initializeGlobalVariables() async {
    await GlobalVariables.getCurrentUser();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(future: _initializeGlobalVariables(), builder: (context, snapshot) {
      if(snapshot.connectionState == ConnectionState.waiting) {
        return Scaffold(
          body: Center(
            child: LottieBuilder.asset('assets/pet-claws.json'),
          ).animate().tint(color: AppStyle.mainColor, duration: 0.ms),
        );
      }
      final mq = MediaQuery.of(context).size;
      Widget nextScreen = FirebaseServices.auth.currentUser == null
          ? const LoginPage()
          : GlobalVariables.currentUser.type == 'admin'
          ? const BottomBar()
          : const PendingScreen();
      return AnimatedSplashScreen(
        splash: Center(
          child: LottieBuilder.asset('assets/pet-claws.json'),
        ).animate().tint(color: AppStyle.mainColor, duration: 0.ms),
        splashIconSize: mq.width,
        nextScreen: nextScreen,
        backgroundColor: AppStyle.mainColor.withOpacity(0.1),
      );
    },);
  }
}
