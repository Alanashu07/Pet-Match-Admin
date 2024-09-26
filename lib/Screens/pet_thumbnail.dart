import 'package:flutter/material.dart';
import 'package:pet_match_admin/Models/pet_model.dart';
import 'package:pet_match_admin/Screens/pet_details.dart';

import '../Constants/date_format.dart';
import '../Constants/global_variables.dart';

class PetThumbnail extends StatelessWidget {
  final PetModel pet;
  const PetThumbnail({super.key, required this.pet});

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context).size;
    final owner = GlobalVariables.users.firstWhere((element) => element.id == pet.ownerId,);
    return GestureDetector(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(builder: (_)=> MyPetsDetails(pet: pet)));
      },
      child: Column(
        children: [
          SizedBox(
              width: mq.width,
              height: mq.height*.3,
              child: Image.network(pet.images[0],fit: BoxFit.cover,)),
          ListTile(
            leading: CircleAvatar(
              backgroundImage: NetworkImage(owner.image ?? GlobalVariables.errorImage),
            ),
            title: Text(pet.name,style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
            subtitle: Text('${pet.breed} • Owned by ${owner.name} • ${DateFormat.getCreatedTime(context: context, time: pet.createdAt)}'),
            trailing: PopupMenuButton(itemBuilder: (context) {
              return [
                const PopupMenuItem(child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('First Option'),
                    SizedBox(width: 25,),
                    Text('1')
                  ],
                )),
                const PopupMenuItem(child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('First Option'),
                    SizedBox(width: 25,),
                    Text('1')
                  ],
                )),
                const PopupMenuItem(child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('First Option'),
                    SizedBox(width: 25,),
                    Text('1')
                  ],
                )),
                const PopupMenuItem(child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('First Option'),
                    SizedBox(width: 25,),
                    Text('1')
                  ],
                )),
              ];
            },),
          ),
        ],
      ),
    );
  }
}
