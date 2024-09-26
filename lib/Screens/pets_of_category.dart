import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pet_match_admin/Models/accessory_model.dart';
import 'package:pet_match_admin/Models/category_model.dart';
import 'package:pet_match_admin/Screens/accessory_thumbnail.dart';
import 'package:pet_match_admin/Screens/pet_thumbnail.dart';
import 'package:provider/provider.dart';
import '../Constants/global_variables.dart';
import '../Models/pet_model.dart';
import '../Style/app_style.dart';

class PetsOfCategory extends StatelessWidget {
  final CategoryModel category;

  const PetsOfCategory({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    List<PetModel> pets = context
        .watch<GlobalVariables>()
        .allPets
        .where(
          (pet) => pet.category == category.id,
        )
        .toList();
    List<Accessory> accessories = context
        .watch<GlobalVariables>()
        .allAccessories
        .where((accessory) => accessory.category == category.id)
        .toList();
    final mq = MediaQuery.of(context).size;
    return Container(
      color: Colors.white,
      child: Scaffold(
        backgroundColor:
            AppStyle.categoryColor[category.colorIndex].withOpacity(0.1),
        appBar: AppBar(
          leading: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(CupertinoIcons.back)),
          title: Text(
            category.name,
            style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 22),
          ),
          centerTitle: true,
        ),
        body: category.isPet
            ? pets.isNotEmpty
                ? ListView.separated(
                    padding: EdgeInsets.only(bottom: mq.height * .05),
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return PetThumbnail(pet: pets[index]);
                    },
                    separatorBuilder: (context, index) => const SizedBox(
                          height: 15,
                        ),
                    itemCount: pets.length)
                : Center(
                    child: Padding(
                      padding: const EdgeInsets.all(28.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Image.network(category.emptyImage),
                          const SizedBox(
                            height: 35,
                          ),
                          const Text(
                            'This category seems empty! Explore other categories and come back later🙃',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 22, fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                    ),
                  )
            : accessories.isNotEmpty
                ? ListView.separated(
                    padding: EdgeInsets.only(bottom: mq.height * .05),
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return AccessoryThumbnail(accessory: accessories[index]);
                    },
                    separatorBuilder: (context, index) => const SizedBox(
                          height: 15,
                        ),
                    itemCount: accessories.length)
                : Center(
                    child: Padding(
                      padding: const EdgeInsets.all(28.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Image.network(category.emptyImage),
                          const SizedBox(
                            height: 35,
                          ),
                          const Text(
                            'This category seems empty! Explore other categories and come back later🙃',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 22, fontWeight: FontWeight.w500),
                          )
                        ],
                      ),
                    ),
                  ),
      ),
    );
  }
}
