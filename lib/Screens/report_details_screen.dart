import 'package:flutter/material.dart';
import 'package:pet_match_admin/Constants/date_format.dart';
import 'package:pet_match_admin/Constants/global_variables.dart';
import 'package:pet_match_admin/Screens/Users/user_details.dart';
import 'package:pet_match_admin/Screens/pet_details.dart';
import 'package:pet_match_admin/Style/app_style.dart';
import 'package:pet_match_admin/Widgets/login_button.dart';
import 'package:pet_match_admin/Widgets/name_header.dart';
import 'package:pet_match_admin/Widgets/owner_header.dart';
import 'package:provider/provider.dart';

import '../Widgets/pet_images_card.dart';
import 'MainScreens/reports_screen.dart';

class ReportDetailsScreen extends StatelessWidget {
  final ReportModel report;
  const ReportDetailsScreen({super.key, required this.report});

  @override
  Widget build(BuildContext context) {
    final user = context.watch<GlobalVariables>().allUsers.firstWhere((element) => element.id == report.reportedBy,);
    final mq = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text(report.pet.name),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            PetImagesCard(
              pet: report.pet,
              padding: const EdgeInsets.all(18),
              child: const SizedBox(),
            ),
            Padding(
              padding: const EdgeInsets.all(18.0),
              child: NameHeader(pet: report.pet),
            ),
            OwnerHeader(pet: report.pet),
            Padding(
              padding: const EdgeInsets.all(18),
              child: SizedBox(
                width: double.infinity,
                child: Text(
                  report.message,
                  style: const TextStyle(color: Colors.black54),
                  textAlign: TextAlign.justify,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(18),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Reported By ${user.name}',
                        style: TextStyle(color: AppStyle.accentColor, fontWeight: FontWeight.bold, fontSize: 18),
                        textAlign: TextAlign.justify,
                      ),
                      Text(
                        DateFormat.getCreatedTime(context: context, time: report.time),
                        style: const TextStyle(color: Colors.black54,fontSize: 16),
                        textAlign: TextAlign.justify,
                      ),
                    ],
                  ),
                  CircleAvatar(
                    radius: 33,
                    backgroundImage: NetworkImage(user.image ?? GlobalVariables.errorImage),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(18.0),
              child: LoginButton(onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (_) => MyPetsDetails(pet: report.pet,)));
              }, child: const Text("View Pet Details", style: TextStyle(color: Colors.white),),),
            ),
            Padding(
              padding: const EdgeInsets.all(18.0),
              child: LoginButton(onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (_) => UserDetails(user: user,)));
              }, child: const Text("View Reported User Details", style: TextStyle(color: Colors.white),),),
            ),
            SizedBox(height: mq.height*.03,)
          ],
        ),
      ),
    );
  }
}
