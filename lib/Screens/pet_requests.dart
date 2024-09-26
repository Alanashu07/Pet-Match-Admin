import 'package:flutter/material.dart';
import 'package:pet_match_admin/Constants/global_variables.dart';
import 'package:pet_match_admin/Models/pet_model.dart';
import 'package:pet_match_admin/Screens/pet_details.dart';
import 'package:pet_match_admin/Services/notification_services.dart';
import 'package:provider/provider.dart';

import '../Style/app_style.dart';

class PetRequests extends StatelessWidget {
  const PetRequests({super.key});

  @override
  Widget build(BuildContext context) {
    List<PetModel> pets = context.watch<GlobalVariables>().allPets.where((element) => element.status == 'Requested',).toList();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pet Requests'),
      ),
      body: ListView.builder(itemBuilder: (context, index) {
        final pet = pets[index];
        return Padding(
          padding: const EdgeInsets.all(16),
          child: GestureDetector(
            onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (context) => MyPetsDetails(pet: pet),));
            },
            child: Container(
              height: 80,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: AppStyle.accentColor.withOpacity(.3),
                  border: Border.all(color: AppStyle.accentColor)
              ),
              child: Row(
                children: [
                  const SizedBox(width: 20,),
                  Container(
                    height: 60,
                    width: 60,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(image: NetworkImage(pet.images[0]), fit: BoxFit.cover)
                    ),
                  ),
                  const SizedBox(width: 20,),
                  Expanded(child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(pet.name, style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 20),),
                      Text(pet.breed, style: const TextStyle(fontWeight: FontWeight.normal, fontSize: 16, color: Colors.brown),),
                    ],
                  )),
                  IconButton(onPressed: (){
                    final owner = GlobalVariables.users.firstWhere((element) => element.id == pet.ownerId,);
                    context.read<GlobalVariables>().updatePetStatus(pet: pet, newStatus: 'Approved');
                    NotificationServices.petApproved(pet: pet, owner: owner);
                  }, icon: const Icon(Icons.check, color: Colors.green,)),
                  IconButton(onPressed: (){
                    final owner = GlobalVariables.users.firstWhere((element) => element.id == pet.ownerId,);
                    context.read<GlobalVariables>().updatePetStatus(pet: pet, newStatus: 'Declined');
                    NotificationServices.petDeclined(pet: pet, owner: owner);
                  }, icon: const Icon(Icons.close, color: Colors.red,)),
                ],
              ),
            ),
          ),
        );
      }, itemCount: pets.length),
    );
  }
}
