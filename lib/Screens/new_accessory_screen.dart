import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pet_match_admin/Models/accessory_model.dart';
import 'package:pet_match_admin/Services/firebase_services.dart';
import 'package:pet_match_admin/Services/notification_services.dart';
import 'package:provider/provider.dart';
import '../Constants/global_variables.dart';
import '../Models/category_model.dart';
import '../Style/app_style.dart';
import '../Widgets/custom_text_field.dart';
import '../Widgets/image_added_container.dart';
import '../Widgets/login_button.dart';
import '../Widgets/no_image_container.dart';

class NewAccessoryScreen extends StatefulWidget {
  const NewAccessoryScreen({super.key});

  @override
  State<NewAccessoryScreen> createState() => _NewAccessoryScreenState();
}

class _NewAccessoryScreenState extends State<NewAccessoryScreen> {
  List<XFile> images = [];
  List<String> imageUrls = [];
  bool isUploading = false;
  final _formKey = GlobalKey<FormState>();
  CategoryModel? selectedCategory;
  TextEditingController nameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController brandController = TextEditingController();
  TextEditingController quantityController = TextEditingController();
  TextEditingController priceController = TextEditingController();

  uploadImages() async {
    for (var image in images) {
      final timeStamp = DateTime.now().millisecondsSinceEpoch;
      String id = '${GlobalVariables.currentUser.id}-$timeStamp';
      FirebaseStorage storage = FirebaseStorage.instance;
      Reference ref = storage.ref().child('accessories/$id/$timeStamp');
      await ref.putFile(File(image.path));
      imageUrls.add(await ref.getDownloadURL());
    }
  }

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context).size;
    List<CategoryModel> categories = GlobalVariables.categories
        .where(
          (element) => !element.isPet,
        )
        .toList();
    bool imageAdded = images.isNotEmpty;
    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            leading: IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(CupertinoIcons.back)),
            title: const Text(
              'Add new accessory',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            centerTitle: true,
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                imageAdded
                    ? ImageAddedContainer(images: images)
                    : NoImageContainer(onTap: () async {
                        final picker = ImagePicker();
                        final List<XFile> pickedFile =
                            await picker.pickMultiImage();
                        setState(() {
                          images.addAll(pickedFile);
                        });
                      }),
                imageAdded
                    ? Row(
                        children: [
                          const Spacer(),
                          ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8))),
                              onPressed: () async {
                                final List<XFile> pickedFile =
                                    await ImagePicker().pickMultiImage();
                                setState(() {
                                  images.addAll(pickedFile);
                                });
                              },
                              child: const Text('Add more images')),
                          const SizedBox(
                            width: 16,
                          )
                        ],
                      )
                    : Container(),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      CustomTextField(
                          textCapitalization: TextCapitalization.words,
                          labelText: 'Name',
                          controller: nameController,
                          hintText: "Name of the accessory",
                          type: 'name'),
                      CustomTextField(
                          textCapitalization: TextCapitalization.words,
                          labelText: 'Brand',
                          controller: brandController,
                          hintText: "Breed of the accessory",
                          type: 'brand'),
                      CustomTextField(
                          textCapitalization: TextCapitalization.sentences,
                          labelText: 'Description',
                          controller: descriptionController,
                          hintText: "Describe the accessory",
                          type: 'description'),
                      CustomTextField(
                          textInputType: const TextInputType.numberWithOptions(
                              decimal: true, signed: true),
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(RegExp(r'[0-9.]'))
                          ],
                          labelText: 'Price',
                          controller: priceController,
                          hintText: "Enter Price",
                          type: 'price'),
                      CustomTextField(
                          textInputType: const TextInputType.numberWithOptions(
                              decimal: true, signed: true),
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(RegExp(r'[0-9.]'))
                          ],
                          labelText: 'Quantity',
                          controller: quantityController,
                          hintText: "Enter Quantity",
                          type: 'quantity'),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 18.0, vertical: 15),
                        child: DropdownMenu(
                            label: const Text('Select Category'),
                            onSelected: (value) {
                              selectedCategory =
                                  GlobalVariables.categories.firstWhere(
                                (element) => element.name == value!,
                              );
                            },
                            width: double.infinity,
                            dropdownMenuEntries: categories.map(
                              (category) {
                                return DropdownMenuEntry(
                                    label: category.name, value: category.name);
                              },
                            ).toList()),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: mq.height * .01,
                ),
                Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: LoginButton(
                    onTap: () async {
                      if (_formKey.currentState!.validate() &&
                          imageAdded &&
                          selectedCategory != null) {
                        setState(() {
                          isUploading = true;
                        });
                        await uploadImages();
                        final time =
                            DateTime.now().millisecondsSinceEpoch.toString();
                        final newAccessory = Accessory(
                            name: nameController.text.trim(),
                            price: double.parse(priceController.text.trim()),
                            id: '${GlobalVariables.currentUser.id}-$time',
                            quantity:
                                double.parse(quantityController.text.trim()),
                            brand: brandController.text.trim(),
                            category: selectedCategory!.id!,
                            description: descriptionController.text.trim(),
                            createdAt: time,
                            images: imageUrls);
                        FirebaseServices.createAccessory(accessory: newAccessory);
                        context.read<GlobalVariables>().addAccessory(accessory: newAccessory);
                        NotificationServices.newAccessoryAdded(newAccessory);
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              content: const Text('Accessory added'),
                              actions: [
                                TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                      Navigator.pop(context);
                                    },
                                    child: const Text('OK'))
                              ],
                            );
                          },
                        );
                        setState(() {
                          isUploading = false;
                        });
                      } else if (!imageAdded) {
                        showAlert(
                            title: 'Image not added',
                            content: 'Please add images to continue adding');
                      } else if (selectedCategory == null) {
                        showAlert(
                            title: 'Category not selected',
                            content:
                                'Please selected corresponding category to continue adding your pet');
                      }
                    },
                    child: const Text(
                      'Add new accessory',
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

  Future showAlert({required String title, required String content}) async {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(title),
            content: Text(content),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('OK'))
            ],
          );
        });
  }
}
