import 'package:flutter/material.dart';
import 'package:pet_match_admin/Screens/MainScreens/RequestWidgets/item_container.dart';
import 'package:pet_match_admin/Screens/MainScreens/reports_screen.dart';
import 'package:pet_match_admin/Screens/admin_requests.dart';
import 'package:pet_match_admin/Screens/categories_screen.dart';
import 'package:pet_match_admin/Screens/category_requests.dart';
import 'package:pet_match_admin/Screens/pet_requests.dart';
import 'package:pet_match_admin/Screens/ratings_screen.dart';
import 'package:pet_match_admin/Style/app_style.dart';

class RequestsScreen extends StatelessWidget {
  const RequestsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    List requests = [
      {'image': 'images/dog.png', 'title': 'Pet Requests', 'page': const PetRequests(),},
      {'image': 'images/categorization.png', 'title': 'Category Requests', 'page': const CategoryRequests(),},
      {'image': 'images/administrator.png', 'title': 'Admin Requests', 'page': const AdminRequests(),},
      {'image': 'images/rate.png', 'title': 'Ratings', 'page': const RatingsScreen(),},
      {'image': 'images/categories.png', 'title': 'Categories', 'page': const CategoriesScreen(),},
      {'image': 'images/report.png', 'title': 'Reports', 'page': const ReportsScreen(),},
    ];
    final mq = MediaQuery.of(context).size;

    return Scaffold(
      body: GridView.builder(
        padding: EdgeInsets.symmetric(vertical: mq.height*.05),
        itemCount: requests.length,
        gridDelegate:
            const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.all(18.0),
            child: ItemContainer(
              page: requests[index]['page'],
              child: Column(
                children: [
                  Expanded(child: Image.asset(requests[index]['image'], color: AppStyle.accentColor,)),
                  Text(
                    requests[index]['title'],
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: AppStyle.accentColor,
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
