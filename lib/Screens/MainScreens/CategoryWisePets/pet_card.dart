import 'package:flutter/material.dart';
import 'package:pet_match_admin/Constants/global_variables.dart';
import 'package:pet_match_admin/Models/pet_model.dart';
import 'package:pet_match_admin/Screens/pet_details.dart';
import 'package:pet_match_admin/Style/app_style.dart';
import 'package:provider/provider.dart';

class PetCard extends StatelessWidget {
  final double borderRadius;
  final double height;
  final double width;
  final PetModel pet;

  const PetCard(
      {super.key,
      this.borderRadius = 12,
      this.height = 100,
      this.width = double.infinity,
      required this.pet});

  @override
  Widget build(BuildContext context) {
    final owner = context.watch<GlobalVariables>().allUsers.firstWhere(
          (element) => element.id == pet.ownerId,
        );
    return GestureDetector(
      onTap: () {
        Navigator.push(context,
            MaterialPageRoute(builder: (_) => MyPetsDetails(pet: pet)));
      },
      child: Container(
        width: width,
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: AppStyle.mainColor.withOpacity(0.2),
          borderRadius: BorderRadius.circular(borderRadius),
          border: Border.all(color: AppStyle.mainColor),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 15,
            ),
            SizedBox(
                height: height,
                width: width,
                child: Image.network(
                  pet.images[0],
                  fit: BoxFit.cover,
                )),
            Text(
              pet.name,
              style: TextStyle(
                  color: AppStyle.mainColor,
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
            ),
            Text(
              pet.breed,
              style:
                  const TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
            ),
            Row(
              children: [
                const Text('Owner: '),
                Text(
                  owner.name,
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.normal),
                ),
              ],
            ),
            Row(
              children: [
                const Text('Status: '),
                Text(
                  pet.status,
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.normal,
                      color: pet.status == 'Requested'
                          ? AppStyle.mainColor
                          : pet.status == 'Approved'
                              ? Colors.green
                              : pet.status == 'Declined'
                                  ? Colors.red
                                  : Colors.black),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
