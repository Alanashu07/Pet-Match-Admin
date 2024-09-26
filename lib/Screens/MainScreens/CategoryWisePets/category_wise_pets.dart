import 'package:flutter/material.dart';
import 'package:pet_match_admin/Constants/global_variables.dart';
import 'package:pet_match_admin/Models/category_model.dart';
import 'package:pet_match_admin/Models/pet_model.dart';
import 'package:pet_match_admin/Screens/MainScreens/CategoryWisePets/pet_card.dart';
import 'package:provider/provider.dart';

class CategoryWisePets extends StatelessWidget {
  final CategoryModel category;

  const CategoryWisePets({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    List<PetModel> pets = context.watch<GlobalVariables>().allPets;
    final categoryPets = pets
        .where(
          (element) => element.category == category.id,
        )
        .toList();
    final mq = MediaQuery.of(context).size;
    return categoryPets.isNotEmpty
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
                child: Text(
                  category.name,
                  style: const TextStyle(
                      fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ),
              GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(18.0),
                      child: PetCard(pet: categoryPets[index]),
                    );
                  },
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: (mq.width / mq.height) * 1.3),
                  itemCount: categoryPets.length)
            ],
          )
        : Container();
  }
}
