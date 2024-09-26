import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:pet_match_admin/Constants/date_format.dart';
import 'package:pet_match_admin/Constants/global_variables.dart';
import 'package:pet_match_admin/Models/pet_model.dart';
import 'package:pet_match_admin/Screens/MainScreens/CategoryWisePets/pet_card.dart';
import 'package:pet_match_admin/Screens/chatting_screen.dart';
import 'package:pet_match_admin/Screens/image_viewer.dart';
import 'package:pet_match_admin/Style/app_style.dart';
import 'package:pet_match_admin/Widgets/action_widgets.dart';
import 'package:pet_match_admin/Widgets/custom_back_button.dart';
import 'package:provider/provider.dart';

import '../../Models/user_model.dart';

class UserDetails extends StatelessWidget {
  final User user;

  const UserDetails({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    final selectedUser = context.watch<GlobalVariables>().allUsers.firstWhere(
          (element) => element.id == user.id,
        );
    List<PetModel> pets = GlobalVariables.pets
        .where(
          (element) => element.ownerId == selectedUser.id,
        )
        .toList();
    List<PetModel> adoptedPets = GlobalVariables.pets
        .where((element) => selectedUser.adoptedPets.contains(element.id!))
        .toList();
    List<PetModel> favoritePets = GlobalVariables.pets
        .where((element) => selectedUser.favouritePets.contains(element.id!))
        .toList();
    final mq = MediaQuery.of(context).size;
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: mq.height * .05,
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => ImageViewer(
                              title: selectedUser.name,
                              image: selectedUser.image ??
                                  GlobalVariables.errorImage)));
                },
                child: Container(
                  height: mq.height * .3,
                  width: mq.width,
                  alignment: Alignment.topLeft,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      image: DecorationImage(
                          image: NetworkImage(
                              selectedUser.image ?? GlobalVariables.errorImage),
                          fit: BoxFit.cover)),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child:
                        CustomBackButton(onTap: () => Navigator.pop(context)),
                  ),
                ),
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
                        selectedUser.name,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 24),
                      ),
                      Text(
                        selectedUser.email,
                        style: const TextStyle(
                            fontSize: 18, color: Colors.black54),
                      ),
                      Text(
                        selectedUser.phoneNumber,
                        style: const TextStyle(
                            fontSize: 18, color: Colors.black54),
                      ),
                    ],
                  )),
                  selectedUser.isOnline
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
                  !selectedUser.isOnline
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
              pets.isNotEmpty
                  ? Text(
                      'Pets of ${selectedUser.name}',
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold),
                    )
                  : const SizedBox(),
              pets.isNotEmpty
                  ? GridView.builder(
                      itemCount: pets.length,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: (mq.width / mq.height) * 1.3),
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: PetCard(pet: pets[index]),
                        );
                      },
                    )
                  : const SizedBox(),
              const SizedBox(
                height: 30,
              ),
              adoptedPets.isEmpty
                  ? const SizedBox()
                  : Text(
                      'Pets adopted by ${selectedUser.name}',
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold),
                    ),
              adoptedPets.isEmpty
                  ? const SizedBox()
                  : GridView.builder(
                      itemCount: adoptedPets.length,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: (mq.width / mq.height) * 1.3),
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: PetCard(pet: adoptedPets[index]),
                        );
                      },
                    ),
              const SizedBox(
                height: 30,
              ),
              favoritePets.isEmpty
                  ? const SizedBox()
                  : Text(
                      'Favorite Pets of ${selectedUser.name}',
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold),
                    ),
              favoritePets.isEmpty
                  ? const SizedBox()
                  : GridView.builder(
                      itemCount: favoritePets.length,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: (mq.width / mq.height) * 1.3),
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: PetCard(pet: favoritePets[index]),
                        );
                      },
                    ),
              Row(
                children: [
                  const Spacer(),
                  ActionWidgets(
                    color: selectedUser.type == 'admin'
                        ? Colors.red
                        : Colors.green,
                    onTap: () {
                      context.read<GlobalVariables>().updateUserType(
                          id: selectedUser.id!,
                          newType:
                              selectedUser.type == 'admin' ? 'user' : 'admin');
                    },
                    isCircle: false,
                    child: AnimatedDefaultTextStyle(
                        style: TextStyle(
                            color: selectedUser.type == 'admin'
                                ? Colors.red[900]
                                : Colors.green[900]),
                        duration: 300.ms,
                        child: AnimatedSwitcher(
                          duration: 300.ms,
                          child: selectedUser.type == 'admin'
                              ? const Text(
                                  'Disapprove as admin',
                                  key: Key('1'),
                                )
                              : const Text(
                                  'Promote to admin',
                                  key: Key('2'),
                                ),
                        )),
                  ),
                  const SizedBox(
                    width: 18,
                  )
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ActionWidgets(
                        color: AppStyle.mainColor,
                        icon: CupertinoIcons.chat_bubble_text,
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => ChattingScreen(
                                      user: GlobalVariables.currentUser,
                                      chatUser: selectedUser)));
                        }),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ActionWidgets(
                        color: AppStyle.ternaryColor,
                        icon: Icons.edit,
                        onTap: () {}),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ActionWidgets(
                        color: AppStyle.accentColor,
                        icon: CupertinoIcons.delete,
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: const Text('Delete User?'),
                                content: const Text(
                                  'You sure you want to delete this user? This will not restrict them from using the application. Instead it will just delete their interactions. They can still use the app as new user. If you want to restrict their activity, Block instead!.',
                                  textAlign: TextAlign.justify,
                                ),
                                actions: [
                                  TextButton(
                                      onPressed: () {
                                        context
                                            .read<GlobalVariables>()
                                            .deleteUser(selectedUser);
                                        Navigator.pop(context);
                                      },
                                      child: const Text('Delete')),
                                  TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: const Text('Cancel')),
                                ],
                              );
                            },
                          );
                        }),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: GestureDetector(
                  onTap: () {
                    context.read<GlobalVariables>().updateUserType(
                        id: selectedUser.id!,
                        newType: selectedUser.type == 'blocked'
                            ? 'user'
                            : 'blocked');
                  },
                  child: AnimatedContainer(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        color: selectedUser.type == 'blocked'
                            ? Colors.green[900]
                            : AppStyle.accentColor),
                    duration: const Duration(milliseconds: 500),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                            child: Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: AnimatedSwitcher(
                            duration: 300.ms,
                            child: selectedUser.type == 'blocked'
                                ? Text(
                                    'Unblock ${selectedUser.name}',
                                    key: const Key('1'),
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                        color: Colors.white, fontSize: 18),
                                  )
                                : Text(
                                    'Block ${selectedUser.name}',
                                    key: const Key('2'),
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                        color: Colors.white, fontSize: 18),
                                  ),
                          ),
                        )),
                        AnimatedRotation(
                          turns: selectedUser.type == 'blocked' ? 0 : 1,
                          duration: const Duration(milliseconds: 300),
                          child: Container(
                            padding: const EdgeInsets.all(15),
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white,
                            ),
                            child: Icon(
                              Icons.pets,
                              color: selectedUser.type == 'blocked'
                                  ? Colors.green[900]
                                  : AppStyle.accentColor,
                              size: 30,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
