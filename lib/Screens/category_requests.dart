import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pet_match_admin/Screens/Users/user_details.dart';
import 'package:pet_match_admin/Screens/add_category.dart';
import 'package:pet_match_admin/Style/app_style.dart';
import '../Models/user_model.dart';
import '../Services/firebase_services.dart';

class CategoryRequests extends StatelessWidget {
  const CategoryRequests({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Category Requests"),
      ),
      body: StreamBuilder(
          stream: FirebaseServices.firestore
              .collection(FirebaseServices.categoryRequestsCollection)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return const Center(
                child: Text("Error Fetching data"),
              );
            } else if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(
                  color: AppStyle.mainColor,
                ),
              );
            } else {
              return ListView.separated(
                  itemBuilder: (context, index) {
                    final snap = snapshot.data!.docs[index];
                    final user = User.fromJson(snap['user']);
                    return ListTile(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => UserDetails(user: user)));
                      },
                      leading: IconButton(
                          onPressed: () {
                            FirebaseServices.firestore
                                .collection(
                                    FirebaseServices.categoryRequestsCollection)
                                .doc(snap.id)
                                .delete();
                          },
                          icon:
                              const Icon(CupertinoIcons.minus_rectangle_fill)),
                      title: Text(snap['request']),
                      trailing: IconButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => AddCategory(
                                          request: snap['request'],
                                          id: snap.id,
                                        )));
                          },
                          icon: const Icon(
                            Icons.add_box_rounded,
                            size: 30,
                          )),
                    );
                  },
                  separatorBuilder: (context, index) => const Divider(),
                  itemCount: snapshot.data!.docs.length);
            }
          }),
    );
  }
}
