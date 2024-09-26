import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:pet_match_admin/Constants/global_variables.dart';
import 'package:pet_match_admin/Models/user_model.dart';
import 'package:pet_match_admin/Screens/Users/send_custom_notification.dart';
import 'package:pet_match_admin/Screens/Users/user_tile.dart';
import 'package:pet_match_admin/Style/app_style.dart';
import 'package:provider/provider.dart';

class CustomNotificationScreen extends StatefulWidget {
  const CustomNotificationScreen({super.key});

  @override
  State<CustomNotificationScreen> createState() =>
      _CustomNotificationScreenState();
}

class _CustomNotificationScreenState extends State<CustomNotificationScreen> {
  List<User> selectedUsers = [];
  List<User> tempUsers = [];

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context).size;
    List<User> users = context.watch<GlobalVariables>().allUsers.where(
          (element) => element.id != GlobalVariables.currentUser.id,
        ).toList();
    bool allSelected = selectedUsers.length == users.length;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Users', style: TextStyle(fontWeight: FontWeight.w500),),
        centerTitle: true,
        leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Icon(CupertinoIcons.back)),
        actions: [
          IconButton(
              onPressed: () {
                if(allSelected) {
                  setState(() {
                    selectedUsers = tempUsers;
                    selectedUsers = selectedUsers.toSet().toList();
                  });
                }else {
                  setState(() {
                    selectedUsers = users;
                    selectedUsers = selectedUsers.toSet().toList();
                  });
                }
              },
              icon: Icon(
                allSelected
                    ? CupertinoIcons.checkmark_alt_circle_fill
                    : CupertinoIcons.checkmark_alt_circle,
                color: AppStyle.ternaryColor,
              ))
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: mq.height * .1,
              width: mq.width,
              child: ListView.builder(
                itemCount: selectedUsers.length,
                scrollDirection: Axis.horizontal,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                User user = selectedUsers[index];
                return Padding(padding: EdgeInsets.all(10),
                child: Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    CircleAvatar(
                      backgroundImage: NetworkImage(user.image!),
                      radius: 35,
                    ),
                    CircleAvatar(
                      backgroundColor: AppStyle.ternaryColor,
                      radius: 10,
                      child: Icon(Icons.check, size: 15, color: Colors.white,),
                    )
                  ],
                ).animate().slideX(begin: 1, end: 0).fade(),
                );
              },),
            ),
            Divider(),
            ListView.builder(
              shrinkWrap: true,
              itemCount: users.length,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
              User user = users[index];
              bool isSelected = selectedUsers.contains(user);
              return Padding(
                padding: const EdgeInsets.all(18.0),
                child: UserTile(color: isSelected ? AppStyle.accentColor : AppStyle.mainColor, user: user, onTap: (){
                  if(isSelected) {
                    setState(() {
                      selectedUsers.remove(user);
                      tempUsers.remove(user);
                      selectedUsers = selectedUsers.toSet().toList();
                    });
                  } else {
                    setState(() {
                      selectedUsers.add(user);
                      tempUsers.add(user);
                      selectedUsers = selectedUsers.toSet().toList();
                    });
                  }
                },),
              );
            },)
          ],
        ),
      ),
      floatingActionButton: selectedUsers.isEmpty ? null : FloatingActionButton(onPressed: (){
        Navigator.push(context, MaterialPageRoute(builder: (_)=> SendCustomNotification(selectedUsers: selectedUsers)));
      }, child: Icon(CupertinoIcons.right_chevron),),
    );
  }
}
