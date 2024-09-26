import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pet_match_admin/Constants/global_variables.dart';
import 'package:pet_match_admin/Models/category_model.dart';
import 'package:pet_match_admin/Services/firebase_services.dart';
import 'package:pet_match_admin/Services/notification_services.dart';
import 'package:pet_match_admin/Style/app_style.dart';
import 'package:pet_match_admin/Widgets/custom_text_field.dart';
import 'package:pet_match_admin/Widgets/login_button.dart';
import 'package:pet_match_admin/Widgets/no_image_container.dart';
import 'package:provider/provider.dart';

import '../Models/user_model.dart';

class AddCategory extends StatefulWidget {
  final String? request;
  final String? id;
  final User? requestedUser;

  const AddCategory({super.key, this.request, this.id, this.requestedUser});

  @override
  State<AddCategory> createState() => _AddCategoryState();
}

class _AddCategoryState extends State<AddCategory> {
  String? icon;
  XFile? selectedIcon;
  XFile? selectedEmptyImage;
  String? emptyImage;
  bool isPet = true;
  bool isUploading = false;
  TextEditingController controller = TextEditingController();

  uploadImages() async {
    String id =
        '${controller.text.trim()}-${DateTime.now().millisecondsSinceEpoch}'
            .toLowerCase()
            .split(' ')
            .join('-');
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    FirebaseStorage storage = FirebaseStorage.instance;
    Reference iconRef = storage.ref().child('categories/$id/icon/$timestamp');
    await iconRef.putFile(File(selectedIcon!.path));
    icon = await iconRef.getDownloadURL();
    Reference imageRef = storage.ref().child('categories/$id/empty/$timestamp');
    await imageRef.putFile(File(selectedEmptyImage!.path));
    emptyImage = await imageRef.getDownloadURL();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.request != null) {
      controller.text = widget.request!;
    }
    final mq = MediaQuery.of(context).size;
    bool imageAdded = selectedEmptyImage != null;
    bool iconAdded = selectedIcon != null;
    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            leading: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(CupertinoIcons.back)),
            title: const Text('Add new category'),
            centerTitle: true,
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                Text(
                  'Select Image for icon',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: AppStyle.mainColor, fontSize: 20),
                ),
                iconAdded
                    ? GestureDetector(
                        onTap: () async {
                          final imagePicker = ImagePicker();
                          final XFile? pickedImage = await imagePicker
                              .pickImage(source: ImageSource.gallery);
                          if (pickedImage != null) {
                            setState(() {
                              selectedIcon = pickedImage;
                            });
                          }
                        },
                        child: SizedBox(
                          height: 200,
                          width: mq.width,
                          child: Image.file(
                            File(selectedIcon!.path),
                            fit: BoxFit.contain,
                          ),
                        ),
                      )
                    : NoImageContainer(onTap: () async {
                        final imagePicker = ImagePicker();
                        final XFile? pickedImage = await imagePicker.pickImage(
                            source: ImageSource.gallery);
                        if (pickedImage != null) {
                          setState(() {
                            selectedIcon = pickedImage;
                          });
                        }
                      }),
                Text(
                  'Select Image when the category is empty',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: AppStyle.mainColor, fontSize: 20),
                ),
                imageAdded
                    ? GestureDetector(
                        onTap: () async {
                          final imagePicker = ImagePicker();
                          final XFile? pickedImage = await imagePicker
                              .pickImage(source: ImageSource.gallery);
                          if (pickedImage != null) {
                            setState(() {
                              selectedEmptyImage = pickedImage;
                            });
                          }
                        },
                        child: SizedBox(
                          height: 200,
                          width: mq.width,
                          child: Image.file(
                            File(selectedEmptyImage!.path),
                            fit: BoxFit.contain,
                          ),
                        ),
                      )
                    : NoImageContainer(onTap: () async {
                        final imagePicker = ImagePicker();
                        final XFile? pickedImage = await imagePicker.pickImage(
                            source: ImageSource.gallery);
                        if (pickedImage != null) {
                          setState(() {
                            selectedEmptyImage = pickedImage;
                          });
                        }
                      }),
                CustomTextField(
                    textCapitalization: TextCapitalization.words,
                    controller: controller,
                    hintText: 'Enter name for new category',
                    type: 'category'),
                Row(
                  children: [
                    const Spacer(),
                    Checkbox(
                      value: isPet,
                      onChanged: (value) {
                        setState(() {
                          isPet = value!;
                        });
                      },
                    ),
                    Text(
                      'Pet category',
                      style: TextStyle(color: Colors.brown[800]),
                    ),
                    const SizedBox(
                      width: 18,
                    )
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: LoginButton(
                    onTap: () async {
                      if (iconAdded &&
                          imageAdded &&
                          controller.text.trim().isNotEmpty) {
                        setState(() {
                          isUploading = true;
                        });
                        final category = CategoryModel(
                            isPet: isPet,
                            id: '${controller.text.trim()}-${DateTime.now().millisecondsSinceEpoch}'
                                .toLowerCase()
                                .split(' ')
                                .join('-'),
                            name: controller.text.trim(),
                            image: icon!,
                            emptyImage: emptyImage!,
                            colorIndex: GlobalVariables.getRandomColor());
                        await uploadImages();
                        FirebaseServices.addCategory(
                            image: category.image,
                            name: category.name,
                            colorIndex: category.colorIndex,
                            emptyImage: emptyImage!,
                            id: category.id!,
                            isPet: category.isPet);
                        context.read<GlobalVariables>().addCategory(
                            isPet: category.isPet,
                            icon: category.image,
                            emptyImage: category.emptyImage,
                            name: category.name,
                            id: category.id!,
                            colorIndex: category.colorIndex);

                        NotificationServices.newCategoryAdded(category);
                        if (widget.request != null) {
                          FirebaseServices.firestore
                              .collection(
                                  FirebaseServices.categoryRequestsCollection)
                              .doc(widget.id)
                              .delete();
                          NotificationServices.requestedCategoryAdded(
                              category: category,
                              requestedUser: widget.requestedUser!);
                        }
                        setState(() {
                          isUploading = false;
                        });
                        Navigator.pop(context);
                      } else {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: const Text('Fill all fields'),
                              content: const Text(
                                  'Please fill all the fields to continue'),
                              actions: [
                                TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: const Text("OK")),
                              ],
                            );
                          },
                        );
                      }
                    },
                    child: const Text(
                      'Add new category',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                SizedBox(
                  height: mq.height * .05,
                )
              ],
            ),
          ),
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
    );
  }
}
