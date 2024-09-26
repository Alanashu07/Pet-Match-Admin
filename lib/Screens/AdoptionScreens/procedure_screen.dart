import 'package:animations/animations.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import '../../Constants/date_format.dart';
import '../../Constants/global_variables.dart';
import '../../Models/pet_model.dart';
import '../../Models/user_model.dart';
import '../../Style/app_style.dart';
import '../../Widgets/login_button.dart';
import '../MainScreens/bottom_bar.dart';
import '../image_viewer.dart';

class ProcedureScreen extends StatelessWidget {
  final PetModel pet;
  final User user;

  const ProcedureScreen({super.key, required this.pet, required this.user});

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context).size;
    return Container(
      color: Colors.white,
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(onPressed: (){
            Navigator.pop(context);
          }, icon: const Icon(CupertinoIcons.back)),
          title: const Text(
            "Please Note!",
            style: TextStyle(
                color: Colors.red, fontSize: 22, fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(18.0),
            child: Column(
              children: [
                Text(
                  "You are willing to give ${pet.name} to ${user.name} for adoption",
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(
                  height: 15,
                ),
                Text(
                    "Please take not that this action will  is not reversible and you will lose all your control over ${pet.name}"),
                const SizedBox(
                  height: 15,
                ),
                const Text(
                    "Please refer to the user details and double check everything before giving the pet to the user"),
                const SizedBox(
                  height: 15,
                ),
                OpenContainer(
                  closedElevation: 0,
                  openElevation: 0,
                  closedColor: Colors.transparent,
                  openColor: Colors.transparent,
                  closedBuilder: (context, action) => Container(
                    height: mq.height * .3,
                    width: mq.width,
                    alignment: Alignment.topLeft,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        image: DecorationImage(
                            image: NetworkImage(
                                user.image ?? GlobalVariables.errorImage),
                            fit: BoxFit.cover)),
                  ),
                  openBuilder: (context, action) =>
                      ImageViewer(title: user.name, image: user.image!),
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  children: [
                    Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              user.name,
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 24),
                            ),
                            Text(
                              user.email,
                              style: const TextStyle(
                                  fontSize: 18, color: Colors.black54),
                            ),
                            Text(
                              user.phoneNumber,
                              style: const TextStyle(
                                  fontSize: 18, color: Colors.black54),
                            ),
                          ],
                        )),
                    user.isOnline
                        ? const Column(
                      children: [
                        CircleAvatar(
                          radius: 10,
                          backgroundColor: Colors.green,
                        ),
                        Text('Online')
                      ],
                    )
                        : Container()
                  ],
                ),
                Row(
                  children: [
                    const Spacer(),
                    !user.isOnline
                        ? Text(DateFormat.getLastActiveTime(
                        context: context, lastActive: user.lastActive))
                        : const SizedBox()
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                user.location != null && user.location!.isNotEmpty
                    ? Text(
                  "Lives at: ${user.location}",
                  style: TextStyle(
                      color: Colors.brown[900],
                      fontSize: 16,
                      fontWeight: FontWeight.w500),
                )
                    : const Text(
                  "Location not provided!",
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.red),
                ),
                const SizedBox(
                  height: 15,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    LoginButton(
                      onTap: () {
                        context.read<GlobalVariables>().updatePetStatus(pet: pet, newStatus: 'Given');
                        context.read<GlobalVariables>().giveToAdopt(petId: pet.id!, user: user);
                        Navigator.pushAndRemoveUntil(context, PageTransition(child: const BottomBar(), type: PageTransitionType.rightToLeft), (route) => false,);
                        showDialog(context: context, builder: (context) {
                          return AlertDialog(
                            title: const Text("Congratulations!😍"),
                            content: Text("You have successfully given ${pet.name} to ${user.name} for adoption, wait for ${user.name} to take ${pet.isMale ? "him" : "her"} home.✨"),
                            actions: [
                              TextButton(onPressed: (){Navigator.pop(context);}, child: const Text("OK"))
                            ],
                          );
                        },);
                      },
                      width: mq.width * .3,
                      child: const Text(
                        "Confirm",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    LoginButton(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      width: mq.width * .3,
                      colors: [AppStyle.mainColor, AppStyle.accentColor],
                      child: const Text(
                        "Cancel",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
