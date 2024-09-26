import 'dart:io';

import 'package:animations/animations.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pet_match_admin/Screens/AdoptionScreens/adoption_screen.dart';
import 'package:pet_match_admin/Screens/edit_pet_screen.dart';
import 'package:pet_match_admin/Services/firebase_services.dart';
import 'package:pet_match_admin/Services/notification_services.dart';
import 'package:provider/provider.dart';
import '../Constants/date_format.dart';
import '../Constants/global_variables.dart';
import '../Models/pet_model.dart';
import '../Style/app_style.dart';
import '../Widgets/action_widgets.dart';
import '../Widgets/age_weight.dart';
import '../Widgets/custom_back_button.dart';
import '../Widgets/name_header.dart';
import '../Widgets/owner_header.dart';
import '../Widgets/pet_images_card.dart';

class MyPetsDetails extends StatefulWidget {
  final PetModel pet;

  const MyPetsDetails({super.key, required this.pet});

  @override
  State<MyPetsDetails> createState() => _MyPetsDetailsState();
}

class _MyPetsDetailsState extends State<MyPetsDetails> {
  bool isUploading = false;

  @override
  Widget build(BuildContext context) {
    PetModel myPet = context
        .watch<GlobalVariables>()
        .allPets
        .firstWhere((element) => widget.pet.id == element.id);
    final owner = GlobalVariables.users.firstWhere((element) => element.id == myPet.ownerId,);
    final mq = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  SizedBox(
                    height: mq.height * .05,
                  ),
                  PetImagesCard(
                    pet: myPet,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        const Spacer(),
                        ElevatedButton(
                          onPressed: () async {
                            final List<XFile> pickedFile =
                                await ImagePicker().pickMultiImage();
                            for (var image in pickedFile) {
                              setState(() {
                                isUploading = true;
                              });
                              final timeStamp =
                                  DateTime.now().millisecondsSinceEpoch;
                              FirebaseStorage storage =
                                  FirebaseStorage.instance;
                              Reference ref = storage
                                  .ref()
                                  .child('pets/${myPet.id}/$timeStamp');
                              await ref.putFile(File(image.path));
                              myPet.images.add(await ref.getDownloadURL());
                              FirebaseServices.firestore
                                  .collection(FirebaseServices.petsCollection)
                                  .doc(myPet.id)
                                  .update({'images': myPet.images});
                              setState(() {
                                isUploading = false;
                              });
                            }
                          },
                          style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8))),
                          child: const Text('Add more images'),
                        ),
                      ],
                    ),
                  ),
                  NameHeader(pet: myPet),
                  OwnerHeader(
                    pet: myPet,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: AgeWeight(pet: myPet),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10.0, horizontal: 18),
                    child: SizedBox(
                        width: double.infinity,
                        child: Text(
                          'Breed: ${myPet.breed}',
                          style: TextStyle(
                              color: AppStyle.mainColor, fontSize: 18),
                        )),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(18),
                    child: SizedBox(
                      width: double.infinity,
                      child: Text(
                        myPet.description,
                        style: const TextStyle(color: Colors.black54),
                        textAlign: TextAlign.justify,
                      ),
                    ),
                  ),
                  Container(
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.symmetric(horizontal: 18.0),
                    child: myPet.lastVaccinated != null &&
                            myPet.lastVaccinated!.isNotEmpty
                        ? Text(
                            "Last Vaccinated: ${DateFormat.getCreatedTime(context: context, time: widget.pet.lastVaccinated!)}")
                        : const Text("Not Vaccinated yet!"),
                  ),
                  myPet.status == 'Adopted' || myPet.status == 'Given'
                      ? Row(
                          children: [
                            Expanded(
                                child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(50),
                                    color: AppStyle.accentColor),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                        child: Text(
                                      myPet.status == 'Given' ? '${myPet.name} is being adopted' : '${myPet.name} is adopted',
                                      style: const TextStyle(
                                          color: Colors.white, fontSize: 18),
                                    )),
                                    Container(
                                      padding: const EdgeInsets.all(15),
                                      decoration: const BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.white,
                                      ),
                                      child: Icon(
                                        Icons.pets,
                                        color: AppStyle.accentColor,
                                        size: 30,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            )),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: ActionWidgets(
                                color: AppStyle.ternaryColor,
                                icon: Icons.edit,
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (_) =>
                                              EditPetScreen(pet: myPet)));
                                },
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: ActionWidgets(
                                color: AppStyle.accentColor,
                                icon: CupertinoIcons.delete,
                                onTap: () {
                                  showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        title: const Text('You sure?'),
                                        content: const Text(
                                            'Are you sure you want to remove this pet from being adopted?'),
                                        actions: [
                                          TextButton(
                                              onPressed: () {
                                                Navigator.pop(context);
                                                Navigator.pop(context);
                                                context
                                                    .read<GlobalVariables>()
                                                    .deletePet(pet: myPet);
                                              },
                                              child: const Text('Yes')),
                                          TextButton(
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                              child: const Text('No')),
                                        ],
                                      );
                                    },
                                  );
                                },
                              ),
                            ),
                          ],
                        )
                      : widget.pet.status == 'Requested'
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8),
                                  child: ActionWidgets(
                                      color: Colors.green,
                                      icon: Icons.check,
                                      onTap: () {
                                        context
                                            .read<GlobalVariables>()
                                            .updatePetStatus(
                                                pet: myPet,
                                                newStatus: 'Approved');
                                        NotificationServices.petApproved(pet: myPet, owner: owner);
                                      }),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8),
                                  child: ActionWidgets(
                                      color: Colors.red,
                                      icon: Icons.close,
                                      onTap: () {
                                        context
                                            .read<GlobalVariables>()
                                            .updatePetStatus(
                                                pet: myPet,
                                                newStatus: 'Declined');
                                        NotificationServices.petDeclined(pet: myPet, owner: owner);
                                      }),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: ActionWidgets(
                                    color: AppStyle.ternaryColor,
                                    icon: Icons.edit,
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (_) => EditPetScreen(
                                                  pet: widget.pet)));
                                    },
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: ActionWidgets(
                                    color: AppStyle.accentColor,
                                    icon: CupertinoIcons.delete,
                                    onTap: () {
                                      showDialog(
                                        context: context,
                                        builder: (context) {
                                          return AlertDialog(
                                            title: const Text('You sure?'),
                                            content: const Text(
                                                'Are you sure you want to remove this pet from being adopted?'),
                                            actions: [
                                              TextButton(
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                    Navigator.pop(context);
                                                    context
                                                        .read<GlobalVariables>()
                                                        .deletePet(pet: myPet);
                                                  },
                                                  child: const Text('Yes')),
                                              TextButton(
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                  },
                                                  child: const Text('No')),
                                            ],
                                          );
                                        },
                                      );
                                    },
                                  ),
                                ),
                              ],
                            )
                          : widget.pet.status == 'Approved'
                              ? Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(8),
                                          child: ActionWidgets(
                                              color: Colors.red,
                                              icon: Icons.close,
                                              onTap: () {
                                                context
                                                    .read<GlobalVariables>()
                                                    .updatePetStatus(
                                                        pet: myPet,
                                                        newStatus: 'Declined');
                                                NotificationServices.petDeclined(pet: myPet, owner: owner);
                                              }),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: ActionWidgets(
                                            color: AppStyle.ternaryColor,
                                            icon: Icons.edit,
                                            onTap: () {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (_) =>
                                                          EditPetScreen(
                                                              pet: myPet)));
                                            },
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: ActionWidgets(
                                            color: AppStyle.accentColor,
                                            icon: CupertinoIcons.delete,
                                            onTap: () {
                                              showDialog(
                                                context: context,
                                                builder: (context) {
                                                  return AlertDialog(
                                                    title:
                                                        const Text('You sure?'),
                                                    content: const Text(
                                                        'Are you sure you want to remove this pet from being adopted?'),
                                                    actions: [
                                                      TextButton(
                                                          onPressed: () {
                                                            Navigator.pop(
                                                                context);
                                                            Navigator.pop(
                                                                context);
                                                            context
                                                                .read<
                                                                    GlobalVariables>()
                                                                .deletePet(
                                                                    pet: myPet);
                                                          },
                                                          child: const Text(
                                                              'Yes')),
                                                      TextButton(
                                                          onPressed: () {
                                                            Navigator.pop(
                                                                context);
                                                          },
                                                          child:
                                                              const Text('No')),
                                                    ],
                                                  );
                                                },
                                              );
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Container(
                                        padding: const EdgeInsets.all(8),
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(50),
                                            color: AppStyle.mainColor),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            const Expanded(
                                                child: Padding(
                                              padding:
                                                  EdgeInsets.only(left: 18.0),
                                              child: Text(
                                                'Approved',
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 18),
                                              ),
                                            )),
                                            Container(
                                              padding: const EdgeInsets.all(15),
                                              decoration: const BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: Colors.white,
                                              ),
                                              child: Icon(
                                                Icons.pets,
                                                color: AppStyle.mainColor,
                                                size: 30,
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                              : Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(8),
                                          child: ActionWidgets(
                                              color: Colors.green,
                                              icon: Icons.check,
                                              onTap: () {
                                                context
                                                    .read<GlobalVariables>()
                                                    .updatePetStatus(
                                                        pet: myPet,
                                                        newStatus: 'Approved');
                                                NotificationServices.petApproved(pet: myPet, owner: owner);
                                              }),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: ActionWidgets(
                                            color: AppStyle.ternaryColor,
                                            icon: Icons.edit,
                                            onTap: () {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (_) =>
                                                          EditPetScreen(
                                                              pet: myPet)));
                                            },
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: ActionWidgets(
                                            color: AppStyle.accentColor,
                                            icon: CupertinoIcons.delete,
                                            onTap: () {
                                              showDialog(
                                                context: context,
                                                builder: (context) {
                                                  return AlertDialog(
                                                    title:
                                                        const Text('You sure?'),
                                                    content: const Text(
                                                        'Are you sure you want to remove this pet from being adopted?'),
                                                    actions: [
                                                      TextButton(
                                                          onPressed: () {
                                                            Navigator.pop(
                                                                context);
                                                            Navigator.pop(
                                                                context);
                                                            context
                                                                .read<
                                                                    GlobalVariables>()
                                                                .deletePet(
                                                                    pet: myPet);
                                                          },
                                                          child: const Text(
                                                              'Yes')),
                                                      TextButton(
                                                          onPressed: () {
                                                            Navigator.pop(
                                                                context);
                                                          },
                                                          child:
                                                              const Text('No')),
                                                    ],
                                                  );
                                                },
                                              );
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Container(
                                        padding: const EdgeInsets.all(8),
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(50),
                                            color: AppStyle.accentColor),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            const Expanded(
                                                child: Padding(
                                              padding:
                                                  EdgeInsets.only(left: 18.0),
                                              child: Text(
                                                'Declined',
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 18),
                                              ),
                                            )),
                                            Container(
                                              padding: const EdgeInsets.all(15),
                                              decoration: const BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: Colors.white,
                                              ),
                                              child: Icon(
                                                Icons.pets,
                                                color: AppStyle.accentColor,
                                                size: 30,
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                  myPet.ownerId == GlobalVariables.currentUser.id &&
                          myPet.status != 'Adopted'
                      ? myPet.status == 'Given'
                          ? Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: GestureDetector(
                                onTap: () {
                                  showDialog(context: context, builder: (context) {
                                    return AlertDialog(
                                      title: const Text('Adoption in progress'),
                                      content: Text('Adoption in progress. Do you want to cancel the procedure and take back ${myPet.name}'),
                                      actions: [
                                        TextButton(onPressed: (){
                                          Navigator.pop(context);
                                          context.read<GlobalVariables>().cancelAdoption(pet: myPet);
                                        }, child: const Text("Yes")),
                                        TextButton(onPressed: (){
                                          Navigator.pop(context);
                                        }, child: const Text("No")),
                                      ],
                                    );
                                  },);
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(50),
                                      color: Colors.green[900]),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                          child: Padding(
                                        padding:
                                            const EdgeInsets.only(left: 18.0),
                                        child: Text(
                                          'Get Back ${myPet.name}',
                                          style: const TextStyle(
                                              color: Colors.white, fontSize: 18),
                                        ),
                                      )),
                                      Container(
                                        padding: const EdgeInsets.all(15),
                                        decoration: const BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Colors.white,
                                        ),
                                        child: SizedBox(
                                          height: 30,
                                          width: 30,
                                          child: Image.asset(
                                            'images/adopted-cat.png',
                                            color: Colors.green[900],
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            )
                          : OpenContainer(
                              openElevation: 0,
                              openColor: Colors.transparent,
                              closedElevation: 0,
                              closedColor: Colors.transparent,
                              closedBuilder: (context, action) {
                                return Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(50),
                                        color: Colors.green[900]),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                            child: Padding(
                                          padding:
                                              const EdgeInsets.only(left: 18.0),
                                          child: Text(
                                            'Give ${myPet.name}',
                                            style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 18),
                                          ),
                                        )),
                                        Container(
                                          padding: const EdgeInsets.all(15),
                                          decoration: const BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: Colors.white,
                                          ),
                                          child: SizedBox(
                                            height: 30,
                                            width: 30,
                                            child: Image.asset(
                                              'images/adopted-cat.png',
                                              color: Colors.green[900],
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                );
                              },
                              openBuilder: (context, action) {
                                return AdoptionScreen(pet: myPet);
                              },
                            )
                      : const SizedBox(),
                  SizedBox(
                    height: mq.height * .03,
                  )
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(
                horizontal: mq.width * .03, vertical: mq.height * .05),
            child: CustomBackButton(onTap: () => Navigator.pop(context)),
          ),
          isUploading
              ? Container(
                  height: mq.height,
                  width: mq.width,
                  color: Colors.black38,
                  alignment: Alignment.center,
                  child: CircularProgressIndicator(
                    color: AppStyle.mainColor,
                  ),
                )
              : const SizedBox()
        ],
      ),
    );
  }
}
