import 'package:flutter/material.dart';

import '../Models/pet_model.dart';
import '../Style/app_style.dart';

class NameHeader extends StatelessWidget {
  final PetModel pet;
  const NameHeader({super.key, required this.pet});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(pet.name, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Icon(Icons.location_on_outlined, size: 35,),
                    ),
                    Expanded(child: Text(pet.location!, style: const TextStyle(color: Colors.grey, fontSize: 18), overflow: TextOverflow.ellipsis, maxLines: 3,))
                  ],
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: CircleAvatar(
              radius: 30,
              backgroundColor: AppStyle.mainColor,
              child: Image.asset(pet.isMale ? 'images/male.png' : 'images/female.png', scale: 15, color: pet.isMale ? Colors.brown : AppStyle.accentColor,),
            ),
          )
        ],
      ),
    );
  }
}
