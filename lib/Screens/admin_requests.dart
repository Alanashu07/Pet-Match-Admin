import 'package:flutter/material.dart';
import 'package:pet_match_admin/Models/user_model.dart';
import 'package:pet_match_admin/Screens/Users/user_details.dart';
import 'package:provider/provider.dart';

import '../Constants/global_variables.dart';

class AdminRequests extends StatelessWidget {
  const AdminRequests({super.key});

  @override
  Widget build(BuildContext context) {
    List<User> users = context.watch<GlobalVariables>().allUsers.where((element) => element.type == 'requested',).toList();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Requests'),
      ),
      body: ListView.builder(itemBuilder: (context, index) {
        final user = users[index];
        return Padding(
          padding: const EdgeInsets.all(16),
          child: GestureDetector(
            onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (_)=> UserDetails(user: user)));
            },
            child: Container(
              height: 80,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.red.withOpacity(.2),
                  border: Border.all(color: Colors.red)
              ),
              child: Row(
                children: [
                  const SizedBox(width: 20,),
                  Container(
                    height: 60,
                    width: 60,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(image: NetworkImage(user.image ?? GlobalVariables.errorImage), fit: BoxFit.cover)
                    ),
                  ),
                  const SizedBox(width: 20,),
                  Expanded(child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(user.name, style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 20),),
                      Text(user.phoneNumber, style: const TextStyle(fontWeight: FontWeight.normal, fontSize: 15, color: Colors.brown),),
                    ],
                  )),
                  IconButton(onPressed: (){
                    context.read<GlobalVariables>().updateUserType(id: user.id!, newType: 'admin');
                  }, icon: const Icon(Icons.check, color: Colors.green,)),
                  IconButton(onPressed: (){
                    context.read<GlobalVariables>().updateUserType(id: user.id!, newType: 'user');
                  }, icon: const Icon(Icons.close, color: Colors.red,)),
                ],
              ),
            ),
          ),
        );
      }, itemCount: users.length),
    );
  }
}
