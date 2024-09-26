import 'package:flutter/material.dart';
import 'package:pet_match_admin/Screens/edit_category.dart';
import 'package:pet_match_admin/Screens/pets_of_category.dart';
import 'package:provider/provider.dart';
import '../Constants/global_variables.dart';
import '../Models/category_model.dart';
import '../Style/app_style.dart';

class CategoriesList extends StatelessWidget {
  final CategoryModel category;

  const CategoriesList({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) => PetsOfCategory(category: category)));
        },
        child: Container(
          height: 80,
          alignment: Alignment.center,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color:
                  AppStyle.categoryColor[category.colorIndex].withOpacity(.3),
              border: Border.all(
                  color: AppStyle.categoryColor[category.colorIndex])),
          child: Row(
            children: [
              const SizedBox(
                width: 20,
              ),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.white,
                ),
                child: Image.network(
                  category.image,
                  scale: 15,
                ),
              ),
              const SizedBox(
                width: 20,
              ),
              Expanded(
                  child: Text(
                category.name,
                style:
                    const TextStyle(fontWeight: FontWeight.w500, fontSize: 20),
              )),
              PopupMenuButton(
                itemBuilder: (context) {
                  return [
                    PopupMenuItem(
                        value: 'edit',
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (_)=> EditCategory(category: category)));
                        },
                        child: const Text('Edit')),
                    PopupMenuItem(
                        value: 'delete',
                        onTap: () {
                          showDialog(context: context, builder: (context) {
                            return AlertDialog(
                              title: const Text('Delete Category?'),
                              content: const Text('Are you sure you want to delete this category? This action cannot be undone.'),
                              actions: [
                                TextButton(onPressed: (){
                                  final categoryPets = GlobalVariables.pets.where((pet) => pet.category == category.id).toList();
                                  Navigator.pop(context);
                                  if(categoryPets.isEmpty) {
                                    context.read<GlobalVariables>().deleteCategory(category: category);
                                  }
                                  else {
                                    showDialog(context: context, builder: (context) {
                                      return AlertDialog(
                                        title: const Text('Action Failed'),
                                        content: const Text('Cannot delete a category while some items are assigned to it.'),
                                        actions: [
                                          TextButton(onPressed: (){
                                            Navigator.pop(context);
                                          }, child: const Text('OK'))
                                        ],
                                      );
                                    },);
                                  }
                                }, child: const Text("Confirm")),
                                TextButton(onPressed: (){
                                  Navigator.pop(context);
                                }, child: const Text("Cancel")),
                              ],
                            );
                          },);
                        },
                        child: const Text('Delete')),
                  ];
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
