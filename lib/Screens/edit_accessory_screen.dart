import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../Constants/global_variables.dart';
import '../Models/accessory_model.dart';
import '../Models/category_model.dart';

class EditAccessoryScreen extends StatefulWidget {
  final Accessory accessory;
  const EditAccessoryScreen({super.key, required this.accessory});

  @override
  State<EditAccessoryScreen> createState() => _EditAccessoryScreenState();
}

class _EditAccessoryScreenState extends State<EditAccessoryScreen> {

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

  initialValue() {
    nameController.text = widget.accessory.name;
    descriptionController.text = widget.accessory.description;
    brandController.text = widget.accessory.brand;
    quantityController.text = widget.accessory.quantity.toString();
    priceController.text = widget.accessory.price.toString();
    selectedCategory = GlobalVariables.categories.firstWhere((element) => widget.accessory.category == element.id,);
    imageUrls = widget.accessory.images;
  }
  @override
  void initState() {
    initialValue();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}
