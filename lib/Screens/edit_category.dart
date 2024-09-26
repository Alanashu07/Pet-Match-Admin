import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pet_match_admin/Models/category_model.dart';
import 'package:provider/provider.dart';

import '../Constants/global_variables.dart';
import '../Style/app_style.dart';
import '../Widgets/custom_text_field.dart';
import '../Widgets/login_button.dart';

class EditCategory extends StatefulWidget {
  final CategoryModel category;

  const EditCategory({super.key, required this.category});

  @override
  State<EditCategory> createState() => _EditCategoryState();
}

class _EditCategoryState extends State<EditCategory> {
  String? icon;
  XFile? selectedIcon;
  XFile? selectedEmptyImage;
  String? emptyImage;
  bool isPet = true;
  bool isUploading = false;
  TextEditingController controller = TextEditingController();

  uploadImages() async {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    FirebaseStorage storage = FirebaseStorage.instance;
    Reference iconRef = storage.ref().child('categories/${widget.category.id}/icon/$timestamp');
    await iconRef.putFile(File(selectedIcon!.path));
    icon = await iconRef.getDownloadURL();
    Reference imageRef =
        storage.ref().child('categories/${widget.category.id}/empty/$timestamp');
    await imageRef.putFile(File(selectedEmptyImage!.path));
    emptyImage = await imageRef.getDownloadURL();
  }

  @override
  void initState() {
    icon = widget.category.image;
    emptyImage = widget.category.emptyImage;
    controller.text = widget.category.name;
    isPet = widget.category.isPet;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
                    : GestureDetector(
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
                          child: Image.network(
                            icon!,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
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
                          // child: Image.asset('images/dog.png'),
                        ),
                      )
                    : GestureDetector(
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
                          child: Image.network(
                            emptyImage!,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
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
                      if (controller.text.trim().isNotEmpty) {
                        setState(() {
                          isUploading = true;
                        });
                        if(selectedIcon != null && selectedEmptyImage != null) {
                          await uploadImages();
                        }
                        context.read<GlobalVariables>().updateCategory(
                            category: widget.category,
                            newCategory: CategoryModel(
                                name: controller.text.trim(),
                                image: icon!,
                                emptyImage: emptyImage!,
                                colorIndex: widget.category.colorIndex, id: widget.category.id, isPet: isPet));
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
