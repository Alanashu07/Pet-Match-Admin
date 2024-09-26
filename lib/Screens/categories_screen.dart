import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../Constants/global_variables.dart';
import '../Widgets/categories_list.dart';

class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    GlobalVariables.getCategories();
    final mq = MediaQuery.of(context).size;
    final categories = context.watch<GlobalVariables>().allCategories;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(onPressed: ()=> Navigator.pop(context), icon: const Icon(CupertinoIcons.back)),
        title: const Text('Categories'),
        centerTitle: true,
      ),
      body: ListView.separated(
          padding: EdgeInsets.only(bottom: mq.height*.05),
          itemBuilder: (context, index) {
        return CategoriesList(category: categories[index]);
      }, separatorBuilder: (context, index) => const SizedBox(height: 10,), itemCount: categories.length),
    );
  }
}
