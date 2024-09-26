import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:pet_match_admin/Constants/global_variables.dart';
import 'package:pet_match_admin/Models/rating_model.dart';
import 'package:pet_match_admin/Services/firebase_services.dart';
import 'package:pet_match_admin/Style/app_style.dart';

class RatingsScreen extends StatefulWidget {
  const RatingsScreen({super.key});

  @override
  State<RatingsScreen> createState() => _RatingsScreenState();
}

class _RatingsScreenState extends State<RatingsScreen> {

  List<RatingModel> ratings = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Ratings'),
        ),
        body: StreamBuilder(stream: FirebaseServices.firestore.collection(
            FirebaseServices.ratingsCollection).snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return const Center(child: Text("Error Fetching data"),);
            } else if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(color: AppStyle.mainColor,),);
            } else if (!snapshot.hasData) {
              return Center(
                child: Text(
                  'No ratings yet! ✨',
                  style: TextStyle(
                      color: AppStyle.mainColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 20),
                ),
              );
            }
            return ListView.builder(
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  final snap = snapshot.data!.docs;
                  ratings = snap.map((e) => RatingModel.fromJson(e.data())).toList();
                  final rating = ratings[index];
                  final user = GlobalVariables.users.firstWhere(
                        (element) => element.id == rating.userId,
                  );
                  return Padding(
                    padding: const EdgeInsets.all(16),
                    child: GestureDetector(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: Row(
                                children: [
                                  CircleAvatar(
                                    backgroundImage: NetworkImage(
                                        user.image ??
                                            GlobalVariables.errorImage),
                                    radius: 30,
                                  ),
                                  const SizedBox(
                                    width: 20,
                                  ),
                                  Text(user.name),
                                ],
                              ),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  RatingBarIndicator(
                                    itemBuilder: (context, index) =>
                                        Icon(
                                          Icons.star,
                                          color: AppStyle.accentColor,
                                        ),
                                    direction: Axis.horizontal,
                                    itemCount: 5,
                                    rating: rating.rating,
                                    itemSize: 35,
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  Text(
                                    rating.description,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.normal,
                                        fontSize: 15,
                                        color: Colors.brown),
                                    textAlign: TextAlign.justify,
                                  ),
                                ],
                              ),
                              actions: [
                                TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: const Text('OK'))
                              ],
                            );
                          },
                        );
                      },
                      child: Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: AppStyle.mainColor.withOpacity(.3),
                            border: Border.all(color: AppStyle.mainColor)),
                        child: Row(
                          children: [
                            const SizedBox(
                              width: 20,
                            ),
                            Container(
                              height: 60,
                              width: 60,
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  image: DecorationImage(
                                      image: NetworkImage(user.image ??
                                          GlobalVariables.errorImage),
                                      fit: BoxFit.cover)),
                            ),
                            const SizedBox(
                              width: 20,
                            ),
                            Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 18.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment
                                        .start,
                                    children: [
                                      RatingBarIndicator(
                                        itemBuilder: (context, index) =>
                                            Icon(
                                              Icons.star,
                                              color: AppStyle.accentColor,
                                            ),
                                        direction: Axis.horizontal,
                                        itemCount: 5,
                                        rating: rating.rating,
                                        itemSize: 25,
                                      ),
                                      const SizedBox(height: 10,),
                                      Text(
                                        rating.description,
                                        style: const TextStyle(
                                            fontWeight: FontWeight.normal,
                                            fontSize: 15,
                                            color: Colors.brown),
                                        textAlign: TextAlign.justify,
                                      ),
                                      Row(
                                        children: [
                                          const Spacer(),
                                          IconButton(onPressed: () {
                                            showDialog(context: context, builder: (context) => AlertDialog(
                                              title: const Text('Sure to delete?'),
                                              content: const Text('Are you sure to delete the rating? This action is irreversible.'),
                                              actions: [
                                                TextButton(onPressed: (){
                                                  Navigator.pop(context);
                                                }, child: const Text('No')),
                                                TextButton(onPressed: () {
                                                  FirebaseServices.firestore.collection(FirebaseServices
                                                      .ratingsCollection).doc(rating.id).delete();
                                                  Navigator.pop(context);
                                                }, child: const Text('Yes'))
                                              ],
                                            ),);
                                          },
                                              icon: const Icon(
                                                  CupertinoIcons.delete))
                                        ],
                                      )
                                    ],
                                  ),
                                )),
                            const SizedBox(width: 15,)
                          ],
                        ),
                      ),
                    ),
                  );
                },
                itemCount: snapshot.data!.docs.length);
          },)
    );
  }
}
