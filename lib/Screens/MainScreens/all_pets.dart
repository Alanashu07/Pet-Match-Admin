import 'package:flutter/material.dart';
import 'package:pet_match_admin/Constants/global_variables.dart';
import 'package:pet_match_admin/Models/category_model.dart';
import 'package:pet_match_admin/Models/pet_model.dart';
import 'package:pet_match_admin/Screens/MainScreens/CategoryWisePets/category_wise_pets.dart';
import 'package:provider/provider.dart';

import '../../Widgets/search_field.dart';
import '../search_screen.dart';

class AllPets extends StatefulWidget {
  const AllPets({super.key});

  @override
  State<AllPets> createState() => _AllPetsState();
}

class _AllPetsState extends State<AllPets> {

  List<CategoryModel> getCategories() {
    GlobalVariables.getCategories();
    GlobalVariables.getPets();
    List<CategoryModel> categories = [];
    List<CategoryModel> allCategories = context.watch<GlobalVariables>().allCategories;
    List<PetModel> allPets = context.watch<GlobalVariables>().allPets;
    for(var category in allCategories) {
      for(var pet in allPets) {
        if(pet.category == category.id) {
          categories.add(category);
        }
      }
    }
    categories = categories.toSet().toList();
    return categories;
  }

  @override
  Widget build(BuildContext context) {
    final categories = getCategories();
    TextEditingController searchController = TextEditingController();
    final allPets = context.watch<GlobalVariables>().allPets;
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Pets',
          style: TextStyle(fontWeight: FontWeight.w500, fontSize: 22),
        ),
        centerTitle: true,
      ),
      body: allPets.isNotEmpty
          ? SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: SearchField(
                    controller: searchController,
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (_)=> const SearchScreen()));
                    },
                  ),
                ),
                ListView.separated(
                  shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      return CategoryWisePets(
                          category: categories[index]);
                    },
                    separatorBuilder: (context, index) => const SizedBox(
                          height: 15,
                        ),
                    itemCount: categories.length),
              ],
            ),
          )
          : const Center(
              child: Text(
                'No Pets yet!',
                style: TextStyle(fontWeight: FontWeight.w500, fontSize: 22),
              ),
            ),
    );
  }
}
