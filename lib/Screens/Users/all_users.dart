import 'package:flutter/material.dart';
import 'package:pet_match_admin/Constants/global_variables.dart';
import 'package:pet_match_admin/Models/user_model.dart';
import 'package:pet_match_admin/Screens/Users/user_tile.dart';
import 'package:pet_match_admin/Style/app_style.dart';
import 'package:provider/provider.dart';

class AllUsers extends StatelessWidget {
  const AllUsers({super.key});

  @override
  Widget build(BuildContext context) {
    GlobalVariables.getAllUsers();
    List<User> users = context.watch<GlobalVariables>().allUsers.where((element) => element.id != GlobalVariables.currentUser.id,).toList();
    final mq = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage users'),
      ),
      body: ListView.builder(
        padding: EdgeInsets.only(bottom: mq.height * .05),
        itemBuilder: (context, index) {
        final user = users[index];
        return Padding(
          padding: const EdgeInsets.all(18.0),
          child: UserTile(color: AppStyle.mainColor, user: user),
        );
      }, itemCount: users.length,),
    );
  }
}
