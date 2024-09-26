import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:pet_match_admin/Screens/Users/all_users.dart';
import 'package:pet_match_admin/Screens/add_category.dart';
import 'package:pet_match_admin/Screens/custom_notification_screen.dart';
import 'package:pet_match_admin/Screens/login_page.dart';
import 'package:pet_match_admin/Screens/new_accessory_screen.dart';
import 'package:pet_match_admin/Screens/new_pet_screen.dart';
import 'package:pet_match_admin/Services/firebase_services.dart';
import 'package:pet_match_admin/Style/app_style.dart';
import 'package:provider/provider.dart';
import '../../Constants/global_variables.dart';
import '../../Services/location_services.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final admin = context.watch<GlobalVariables>().user;
    final mq = MediaQuery.of(context).size;
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: mq.height * .1,
            ),
            Image.asset(
              'images/admin.png',
              scale: 4,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Admin',
                style: TextStyle(
                    color: AppStyle.accentColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 24),
              ),
            ),
            Text(admin.email),
            Text(admin.phoneNumber),
            SizedBox(
              height: mq.height * .05,
            ),
            ListTile(
              leading: const Icon(
                Icons.edit,
                size: 35,
              ),
              title: const Text(
                'Send Notification',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
              ),
              subtitle: const Text(
                  'Send a notification to all users with title and body'),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (_)=> CustomNotificationScreen()));
              },
            ),
            ListTile(
              leading: const Icon(
                CupertinoIcons.location,
                size: 35,
              ),
              title: const Text('Add Location',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500)),
              subtitle: const Text(
                  'Before adding a pet, Adding location will be useful to get the pets location as well.'),
              onTap: () async {
                LocationServices locationServices = LocationServices();
                try {
                  Position position =
                      await locationServices.getCurrentPosition(context);
                  List<Placemark> placemarks = await placemarkFromCoordinates(
                      position.latitude, position.longitude);
                  Placemark place = placemarks[0];
                  final data = ({
                    'latitude': position.latitude,
                    'longitude': position.longitude,
                    'location':
                        '${place.name}, ${place.locality}, ${place.administrativeArea}, ${place.country}',
                  });
                  FirebaseServices.firestore
                      .collection(FirebaseServices.usersCollection)
                      .doc(FirebaseServices.auth.currentUser!.uid)
                      .update(data);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text("Location updated Successfully"),
                      backgroundColor: AppStyle.mainColor,
                    ),
                  );
                } catch (e) {
                  return Future.error(e);
                }
              },
            ),
            ListTile(
              leading: const Icon(
                Icons.pets,
                size: 35,
              ),
              title: const Text('Add a new pet',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500)),
              subtitle: const Text('Add a new pet to Pet Match'),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (_) => const NewPetScreen()));
              },
            ),
            ListTile(
              leading: Image.asset(
                'images/pet-carrier.png',
                scale: 15,
                fit: BoxFit.contain,
                color: Colors.black.withOpacity(.7),
              ),
              title: const Text(
                'Add a new accessory',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
              ),
              subtitle: const Text('Add a new accessory to the categories'),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => const NewAccessoryScreen()));
              },
            ),
            ListTile(
              leading: Image.asset(
                'images/categories.png',
                fit: BoxFit.contain,
                color: Colors.black.withOpacity(.7),
                scale: 15,
              ),
              title: const Text('Add a new category',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500)),
              subtitle: const Text('Add a new category to Pet Match'),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (_) => const AddCategory()));
              },
            ),
            ListTile(
              leading: const Icon(
                Icons.person,
                size: 35,
              ),
              title: const Text(
                'Manage Users',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
              ),
              subtitle: const Text(
                  'Edit/Delete users. Check user pets and manage them all.'),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (_) => const AllUsers()));
              },
            ),
            ListTile(
              leading: const Icon(
                Icons.logout,
                size: 35,
              ),
              title: const Text(
                'Log out',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
              ),
              onTap: () async {
                await FirebaseServices.updateActiveStatus(false);
                await FirebaseServices.auth.signOut();
                await GoogleSignIn().signOut();
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => const LoginPage()),
                  (route) => false,
                );
              },
            ),
            SizedBox(
              height: mq.height * .05,
            )
          ],
        ),
      ),
    );
  }
}
