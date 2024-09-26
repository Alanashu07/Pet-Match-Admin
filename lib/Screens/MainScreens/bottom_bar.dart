import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pet_match_admin/Screens/MainScreens/all_accessories.dart';
import 'package:pet_match_admin/Screens/MainScreens/all_pets.dart';
import 'package:pet_match_admin/Screens/MainScreens/chats_screen.dart';
import 'package:pet_match_admin/Screens/MainScreens/requests_screen.dart';
import 'package:pet_match_admin/Screens/MainScreens/settings_screen.dart';
import 'package:pet_match_admin/Style/app_style.dart';
import '../../Constants/global_variables.dart';
import '../../Services/firebase_services.dart';

class BottomBar extends StatefulWidget {
  const BottomBar({super.key});

  @override
  State<BottomBar> createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {
  @override
  void initState() {
    GlobalVariables.getCurrentUser();
    SystemChannels.lifecycle.setMessageHandler(
      (message) {
        if (message!.contains("resumed")) {
          FirebaseServices.updateActiveStatus(true);
        } else {
          FirebaseServices.updateActiveStatus(false);
        }
        return Future.value(message);
      },
    );
    super.initState();
  }

  static int currentIndex = 0;
  List screens = [
    const RequestsScreen(),
    const ChatsScreen(),
    const AllPets(),
    const AllAccessories(),
    const SettingsScreen()
  ];

  List<BottomNavigationBarItem> items = [
    const BottomNavigationBarItem(
        icon: Icon(
          Icons.note_alt_outlined,
        ),
        label: 'Requests',
        activeIcon: Icon(Icons.note_alt)),
    const BottomNavigationBarItem(
        icon: Icon(CupertinoIcons.chat_bubble_text),
        label: 'Chats',
        activeIcon: Icon(CupertinoIcons.chat_bubble_text_fill)),
    const BottomNavigationBarItem(
        icon: Icon(Icons.pets_outlined),
        label: 'Pets',
        activeIcon: Icon(Icons.pets)),
    BottomNavigationBarItem(
        icon: SizedBox(
            width: 25, height: 25, child: Image.asset('images/pet-collar.png')),
        label: 'Accessories',
        activeIcon: SizedBox(
            width: 25,
            height: 25,
            child: Image.asset('images/dog-collar.png', color: AppStyle.accentColor,))),
    const BottomNavigationBarItem(
        icon: Icon(
          CupertinoIcons.settings,
        ),
        label: 'Settings',
        activeIcon: Icon(Icons.settings)),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screens[currentIndex],
      bottomNavigationBar: BottomNavigationBar(
          items: items,
          currentIndex: currentIndex,
          selectedItemColor: AppStyle.accentColor,
          unselectedItemColor: Colors.black54,
          showUnselectedLabels: true,
          onTap: (value) {
            setState(() {
              currentIndex = value;
            });
          }),
    );
  }
}
