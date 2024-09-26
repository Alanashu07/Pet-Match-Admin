import 'package:flutter/material.dart';
import 'package:pet_match_admin/Constants/global_variables.dart';
import 'package:pet_match_admin/Models/accessory_model.dart';
import 'package:pet_match_admin/Models/category_model.dart';
import 'package:pet_match_admin/Models/pet_model.dart';
import 'package:pet_match_admin/Screens/MainScreens/CategoryWisePets/category_wise_accessories.dart';
import 'package:pet_match_admin/Screens/MainScreens/CategoryWisePets/category_wise_pets.dart';
import 'package:provider/provider.dart';

import '../../Widgets/search_field.dart';
import '../search_screen.dart';

class AllAccessories extends StatefulWidget {
  const AllAccessories({super.key});

  @override
  State<AllAccessories> createState() => _AllAccessoriesState();
}

class _AllAccessoriesState extends State<AllAccessories> {

  List<CategoryModel> getCategories() {
    GlobalVariables.getCategories();
    GlobalVariables.getAllAccessories();
    List<CategoryModel> categories = [];
    List<CategoryModel> allCategories = context.watch<GlobalVariables>().allCategories;
    List<Accessory> allAccessories = context.watch<GlobalVariables>().allAccessories;
    for(var category in allCategories) {
      for(var accessory in allAccessories) {
        if(accessory.category == category.id) {
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
    final allAccessories = context.watch<GlobalVariables>().allAccessories;
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Accessories',
          style: TextStyle(fontWeight: FontWeight.w500, fontSize: 22),
        ),
        centerTitle: true,
      ),
      body: allAccessories.isNotEmpty
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
                  return CategoryWiseAccessories(
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
          'No Accessories yet!',
          style: TextStyle(fontWeight: FontWeight.w500, fontSize: 22),
        ),
      ),
    );
  }
}
