import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pet_match_admin/Models/pet_model.dart';
import 'package:pet_match_admin/Services/firebase_services.dart';
import 'package:provider/provider.dart';
import '../Constants/date_format.dart';
import '../Constants/global_variables.dart';
import '../Models/category_model.dart';
import '../Widgets/custom_text_field.dart';
import '../Widgets/login_button.dart';
import '../Widgets/no_image_container.dart';

class EditPetScreen extends StatefulWidget {
  final PetModel pet;

  const EditPetScreen({super.key, required this.pet});

  @override
  State<EditPetScreen> createState() => _EditPetScreenState();
}

class _EditPetScreenState extends State<EditPetScreen> {
  List<String> images = [];
  final _formKey = GlobalKey<FormState>();
  String gender = 'Male';
  bool isVaccinated = false;
  String dob = '';
  TextEditingController nameController = TextEditingController();
  TextEditingController dobController = TextEditingController();
  TextEditingController contactNumController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController weightController = TextEditingController();
  TextEditingController breedController = TextEditingController();
  TextEditingController lastVaccinatedController = TextEditingController();
  TextEditingController categoryController = TextEditingController();
  String vaccinatedDate = '';
  CategoryModel? category;
  CategoryModel? selectedCategory;

  @override
  void initState() {
    category = GlobalVariables.categories.firstWhere(
      (element) => element.id == widget.pet.category,
    );
    nameController.text = widget.pet.name;
    dob = widget.pet.dob;
    vaccinatedDate = widget.pet.lastVaccinated ?? '';
    images = widget.pet.images;
    isVaccinated = widget.pet.lastVaccinated != null &&
        widget.pet.lastVaccinated!.isNotEmpty;
    gender = widget.pet.isMale ? 'Male' : 'Female';
    descriptionController.text = widget.pet.description;
    weightController.text = widget.pet.weight.toString();
    breedController.text = widget.pet.breed;
    dobController.text =
        DateFormat.getDate(context: context, date: widget.pet.dob);
    if (widget.pet.lastVaccinated != null &&
        widget.pet.lastVaccinated!.isNotEmpty) {
      lastVaccinatedController.text = DateFormat.getDate(
          context: context, date: widget.pet.lastVaccinated!);
    }
    selectedCategory = category;
    contactNumController.text = widget.pet.contactNumber;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    PetModel myPet = context.watch<GlobalVariables>().allPets.firstWhere(
          (element) => element.id == widget.pet.id,
        );
    final mq = MediaQuery.of(context).size;
    List<CategoryModel> categories = GlobalVariables.categories;
    bool isMale = gender == 'Male';
    bool imageAdded = images.isNotEmpty;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(CupertinoIcons.back)),
        title: Text(
          'Edit ${nameController.text.trim()}',
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            imageAdded
                ? SizedBox(
                    height: 200,
                    child: ListView.builder(
                      itemBuilder: (context, index) {
                        return SizedBox(
                          height: 200,
                          width: mq.width,
                          child: Image.network(
                            images[index],
                            fit: BoxFit.contain,
                          ),
                        );
                      },
                      itemCount: images.length,
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                    ),
                  )
                : NoImageContainer(onTap: () async {
                    final List<String> uploadedUrl = [];
                    final List<XFile> pickedFile =
                        await ImagePicker().pickMultiImage();
                    for (var file in pickedFile) {
                      final timestamp =
                          DateTime.now().millisecondsSinceEpoch.toString();
                      FirebaseStorage storage = FirebaseStorage.instance;
                      Reference ref = storage.ref().child('pets/${myPet.id}/$timestamp');
                      await ref.putFile(File(file.path));
                      uploadedUrl.add(await ref.getDownloadURL());
                    }
                    setState(() {
                      images.addAll(uploadedUrl);
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
                            final List<String> uploadedUrl = [];
                            final List<XFile> pickedFile =
                                await ImagePicker().pickMultiImage();
                            for (var file in pickedFile) {
                              final timestamp = DateTime.now()
                                  .millisecondsSinceEpoch
                                  .toString();
                              FirebaseStorage storage =
                                  FirebaseStorage.instance;
                              Reference ref = storage.ref().child('pets/${myPet.id}/$timestamp');
                              await ref.putFile(File(file.path));
                              uploadedUrl.add(await ref.getDownloadURL());
                            }
                            setState(() {
                              images.addAll(uploadedUrl);
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
                      hintText: "Name of your pet",
                      type: 'name'),
                  CustomTextField(
                      textCapitalization: TextCapitalization.words,
                      labelText: 'Breed',
                      controller: breedController,
                      hintText: "Breed of your pet",
                      type: 'breed'),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 18.0),
                    child: Row(
                      children: [
                        Expanded(
                            child: Row(
                          children: [
                            Radio(
                              value: 'Male',
                              groupValue: gender,
                              onChanged: (value) {
                                setState(() {
                                  gender = value!;
                                });
                              },
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            const Text('Male')
                          ],
                        )),
                        Expanded(
                            child: Row(
                          children: [
                            Radio(
                              value: 'Female',
                              groupValue: gender,
                              onChanged: (value) {
                                setState(() {
                                  gender = value!;
                                });
                              },
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            const Text('Female')
                          ],
                        ))
                      ],
                    ),
                  ),
                  CustomTextField(
                      textCapitalization: TextCapitalization.sentences,
                      labelText: 'Description',
                      controller: descriptionController,
                      hintText: "Describe your pet",
                      type: 'description'),
                  CustomTextField(
                      readOnly: true,
                      onTap: () async {
                        DateTime now = DateTime.now();
                        final pickedDate = await showDatePicker(
                            context: context,
                            firstDate: DateTime(now.year)
                                .subtract(const Duration(days: 10000)),
                            lastDate: now);
                        if (pickedDate != null) {
                          setState(() {
                            dob = pickedDate.millisecondsSinceEpoch.toString();
                            dobController.text = DateFormat.getDate(
                                context: context,
                                date: pickedDate.millisecondsSinceEpoch
                                    .toString());
                          });
                        }
                      },
                      labelText: 'DOB',
                      controller: dobController,
                      hintText: "Enter Date of birth",
                      type: 'DOB'),
                  CustomTextField(
                      textInputType: const TextInputType.numberWithOptions(
                          decimal: true, signed: true),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp(r'[0-9.]'))
                      ],
                      labelText: 'Weight',
                      controller: weightController,
                      hintText: isMale
                          ? "How much does he weigh"
                          : "How much does she weigh",
                      type: 'weight'),
                  Row(
                    children: [
                      const Spacer(),
                      Checkbox(
                        value: isVaccinated,
                        onChanged: (value) {
                          setState(() {
                            isVaccinated = value!;
                          });
                        },
                      ),
                      const Text(
                        'Vaccinated',
                        style: TextStyle(color: Colors.brown),
                      ),
                      const SizedBox(
                        width: 18,
                      )
                    ],
                  ),
                  isVaccinated
                      ? CustomTextField(
                          readOnly: true,
                          onTap: () async {
                            DateTime now = DateTime.now();
                            if (dob.isEmpty) {
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: const Text('Dob not picked'),
                                    content: const Text(
                                        'Please select Date of birth first!'),
                                    actions: [
                                      TextButton(
                                          onPressed: () =>
                                              Navigator.pop(context),
                                          child: const Text('OK'))
                                    ],
                                  );
                                },
                              );
                            } else {
                              final pickedDate = await showDatePicker(
                                  context: context,
                                  firstDate:
                                      DateTime.fromMillisecondsSinceEpoch(
                                          int.parse(dob)),
                                  lastDate: now);
                              if (pickedDate != null) {
                                setState(() {
                                  vaccinatedDate = pickedDate
                                      .millisecondsSinceEpoch
                                      .toString();
                                  lastVaccinatedController.text =
                                      DateFormat.getDate(
                                          context: context,
                                          date: pickedDate
                                              .millisecondsSinceEpoch
                                              .toString());
                                });
                              }
                            }
                          },
                          controller: lastVaccinatedController,
                          hintText: 'Last Vaccinated date',
                          type: 'vaccination')
                      : Container(),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 18.0, vertical: 15),
                    child: DropdownMenu(
                        label: const Text('Select Category'),
                        initialSelection: selectedCategory!.name,
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
                  CustomTextField(
                      textInputType: const TextInputType.numberWithOptions(
                          decimal: true, signed: true),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp(r'[0-9+]'))
                      ],
                      labelText: 'Contact Number',
                      controller: contactNumController,
                      hintText: "Your Contact number",
                      type: 'phone Number'),
                ],
              ),
            ),
            SizedBox(
              height: mq.height * .01,
            ),
            Padding(
              padding: const EdgeInsets.all(18.0),
              child: LoginButton(
                onTap: () {
                  if (_formKey.currentState!.validate() &&
                      imageAdded &&
                      selectedCategory != null) {
                    Navigator.pop(context);
                    FirebaseServices.updatePet(
                        name: nameController.text.trim(),
                        images: images,
                        isMale: isMale,
                        dob: dob,
                        category: selectedCategory!.id!,
                        lastVaccinated: vaccinatedDate,
                        contactNumber: contactNumController.text.trim(),
                        description: descriptionController.text.trim(),
                        weight: double.parse(weightController.text.trim()),
                        breed: breedController.text.trim(),
                        pet: myPet);
                    context.read<GlobalVariables>().updatePet(
                        pet: myPet,
                        name: nameController.text.trim(),
                        images: images,
                        isMale: isMale,
                        category: selectedCategory!.id!,
                        breed: breedController.text.trim(),
                        dob: dob,
                        contactNumber: contactNumController.text.trim(),
                        weight: double.parse(weightController.text.trim()),
                        description: descriptionController.text.trim(),
                        lastVaccinated: vaccinatedDate);
                  } else if (!imageAdded) {
                    showAlert(
                        title: 'Image not added',
                        content: 'Please add images to continue adding');
                  } else if (selectedCategory == null) {
                    showAlert(
                        title: 'Category not selected',
                        content:
                            'Please selected corresponding category to continue adding your pet');
                  } else if (isVaccinated &&
                      lastVaccinatedController.text.trim().isEmpty) {
                    showAlert(
                        title: 'Vaccinated Date',
                        content:
                            'Please enter last vaccinated date to continue adding your pet. Otherwise please unselect vaccinated checkbox');
                  } else if (contactNumController.text.length != 10) {
                    showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: const Text("Invalid Phone Number"),
                            content: const Text(
                                "Please enter a valid Phone number to continue."),
                            actions: [
                              TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text("OK"))
                            ],
                          );
                        });
                  } else {
                    showAlert(
                        title: 'Unknown Error',
                        content: 'Something bad happened');
                  }
                },
                child: const Text(
                  'Make changes to the pet',
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
