import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:pet_match_admin/Models/accessory_model.dart';
import 'package:pet_match_admin/Services/notification_services.dart';
import '../Models/category_model.dart';
import '../Models/conversation_model.dart';
import '../Models/message_model.dart';
import '../Models/notification_model.dart';
import '../Models/pet_model.dart';
import '../Models/user_model.dart';
import '../Services/firebase_services.dart';
import '../Style/app_style.dart';

class GlobalVariables extends ChangeNotifier {
  void addCategory(
      {required String icon,
      required String emptyImage,
      required String id,
      required bool isPet,
      required String name,
      required int colorIndex}) {
    categories.add(CategoryModel(
        id: id,
        name: name,
        image: icon,
        isPet: isPet,
        emptyImage: emptyImage,
        colorIndex: colorIndex));
    notifyListeners();
  }

  void updateCategory(
      {required CategoryModel category, required CategoryModel newCategory}) {
    category.name = newCategory.name;
    category.image = newCategory.image;
    category.isPet = newCategory.isPet;
    category.emptyImage = newCategory.emptyImage;
    category.colorIndex = newCategory.colorIndex;
    FirebaseServices.firestore
        .collection(FirebaseServices.categoriesCollection)
        .doc(category.id)
        .update(newCategory.toJson());
    notifyListeners();
  }

  void deleteCategory({required CategoryModel category}) {
    categories.remove(category);
    FirebaseServices.firestore
        .collection(FirebaseServices.categoriesCollection)
        .doc(category.id)
        .delete();
    notifyListeners();
  }

  void updatePet(
      {required PetModel pet,
      required String name,
      required List<String> images,
      required bool isMale,
      required String category,
      required String breed,
      required String dob,
      required String contactNumber,
      required double weight,
      required String description,
      required String lastVaccinated}) {
    pet.name = name;
    pet.images = images;
    pet.isMale = isMale;
    pet.category = category;
    pet.breed = breed;
    pet.dob = dob;
    pet.weight = weight;
    pet.description = description;
    pet.lastVaccinated = lastVaccinated;
    pet.contactNumber = contactNumber;
    notifyListeners();
  }

  void giveToAdopt({required String petId, required User user}) {
    final pet = pets.firstWhere((element) => element.id == petId,);
    FirebaseServices.firestore.collection(FirebaseServices.usersCollection).doc(user.id).update({
      'adoptedPets': FieldValue.arrayUnion([petId])
    });
    NotificationServices.favoritePetGiven(pet: pet, givenUser: user);
    user.adoptedPets.add(petId);
    notifyListeners();
  }

  void cancelAdoption({required PetModel pet}) {
    final user = users.firstWhere((element) => element.adoptedPets.contains(pet.id),);
    FirebaseServices.firestore.collection(FirebaseServices.usersCollection).doc(user.id).update({
      'adoptedPets': FieldValue.arrayRemove([pet.id])
    });
    user.adoptedPets.remove(pet.id);
    FirebaseServices.firestore
        .collection(FirebaseServices.petsCollection)
        .doc(pet.id)
        .update({'status': 'Approved'});
    NotificationServices.adoptionCancelled(pet: pet, adoptedUser: user);
    pet.status = 'Approved';
    notifyListeners();
  }

  void updatePetStatus({required PetModel pet, required String newStatus}) {
    FirebaseServices.firestore
        .collection(FirebaseServices.petsCollection)
        .doc(pet.id)
        .update({'status': newStatus});
    pet.status = newStatus;
    notifyListeners();
  }

  void updateUserType({required String id, required String newType}) {
    User user = users.firstWhere(
      (element) => element.id == id,
    );
    user.type = newType;
    FirebaseServices.firestore
        .collection(FirebaseServices.usersCollection)
        .doc(user.id)
        .update({'type': newType});
    notifyListeners();
  }

  static String errorImage =
      'https://wallup.net/wp-content/uploads/2018/10/07/8076-wall1831412-animals-dogs-puppies-pets-748x468.jpg';

  void deletePetImage({required PetModel pet, required String image}) {
    FirebaseServices.firestore
        .collection(FirebaseServices.petsCollection)
        .doc(pet.id)
        .update({
      'images': FieldValue.arrayRemove([image])
    });
    pet.images.remove(image);
    notifyListeners();
  }

  void deleteAccessoryImage(
      {required Accessory accessory, required String image}) {
    FirebaseServices.firestore
        .collection(FirebaseServices.accessoriesCollection)
        .doc(accessory.id)
        .update({
      'images': FieldValue.arrayRemove([image])
    });
    accessory.images.remove(image);
    notifyListeners();
  }

  void deletePet({required PetModel pet}) {
    FirebaseServices.firestore
        .collection(FirebaseServices.petsCollection)
        .doc(pet.id)
        .delete();
    pets.remove(pet);
    notifyListeners();
  }

  void addToFavorite({required String petId}) {
    if (currentUser.favouritePets.contains(petId)) {
      currentUser.favouritePets.remove(petId);
    } else {
      currentUser.favouritePets.add(petId);
    }
    notifyListeners();
  }

  void setRead(NotificationModel notification) {
    notification.isRead = true;
    notifyListeners();
  }

  static int getRandomColor() {
    Random random = Random();
    return random.nextInt(AppStyle.categoryColor.length);
  }

  static Future<void> getCategories() async {
    try {
      QuerySnapshot snapshot = await FirebaseServices.firestore
          .collection(FirebaseServices.categoriesCollection)
          .get();
      categories = snapshot.docs
          .map((e) => CategoryModel.fromJson(e.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  static List<CategoryModel> categories = [];

  List<CategoryModel> get allCategories => categories;

  void addAccessory({required Accessory accessory}) {
    accessories.add(accessory);
    notifyListeners();
  }

  void addPet(
      {required String name,
      required List<String> images,
      required bool isMale,
      required String dob,
      required String category,
      required String contactNumber,
      required String description,
      required User user,
      String? lastVaccinated,
      required String location,
      required double latitude,
      required double longitude,
      required double weight,
      required String status,
      required String createdAt,
      required String breed}) {
    String time = DateTime.now().millisecondsSinceEpoch.toString();
    final pet = PetModel(
        name: name,
        images: images,
        isMale: isMale,
        dob: dob,
        category: category,
        contactNumber: contactNumber,
        description: description,
        ownerId: user.id!,
        weight: weight,
        status: status,
        createdAt: createdAt,
        breed: breed,
        id: '${user.id!}-$time',
        lastVaccinated: lastVaccinated ?? '',
        latitude: latitude,
        location: location,
        longitude: longitude);
    pets.add(pet);
    notifyListeners();
  }

  static Future<void> getPets() async {
    try {
      QuerySnapshot snapshot = await FirebaseServices.firestore
          .collection(FirebaseServices.petsCollection)
          .get();
      pets = snapshot.docs
          .map((e) => PetModel.fromJson(e.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  List<PetModel> get allPets => pets;

  static List<PetModel> pets = [];

  static List<Message> messages = [];

  void sendMessage(Message message) {
    messages.add(message);
    notifyListeners();
  }

  List<Message> get allMessages => messages;

  static Future<void> getAllUsers() async {
    try {
      QuerySnapshot snapshot = await FirebaseServices.firestore
          .collection(FirebaseServices.usersCollection)
          .get();
      users = snapshot.docs
          .map((e) => User.fromJson(e.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  static List<User> users = [];
  static late User currentUser;

  List<User> get allUsers => users;

  static Future<User?> getCurrentUser() async {
    if (FirebaseServices.auth.currentUser != null) {
      final userData = await FirebaseServices.firestore
          .collection(FirebaseServices.usersCollection)
          .doc(FirebaseServices.auth.currentUser!.uid)
          .get();
      User user = User.fromJson(userData.data()!);
      currentUser = user;
      await FirebaseServices.getFirebaseMessagingToken();
      return user;
    } else {
      return null;
    }
  }

  void deleteUser(User user) {
    users.remove(user);
    FirebaseServices.firestore
        .collection(FirebaseServices.usersCollection)
        .doc(user.id)
        .delete();
    notifyListeners();
  }

  void editUser({required User user, required User newUser}) {
    FirebaseServices.firestore
        .collection(FirebaseServices.usersCollection)
        .doc(user.id)
        .update(newUser.toJson());
    user.name = newUser.name;
    user.email = newUser.email;
    user.phoneNumber = newUser.phoneNumber;
    user.image = newUser.image;
    notifyListeners();
  }

  User get user => currentUser;

  static List<ConversationModel> conversations = [
    ConversationModel(
        senderId: 'Es4WlEj2jXTysaBSOkQRZm36GFs1',
        receiverId: currentUser.id!,
        lastMessage: "Nothing much",
        petId: pets[0].id!,
        lastMessageTime: "1726466164724"),
    ConversationModel(
        senderId: 'TYY7Fj47uEa9kmX5umZn1x7ciEh2',
        receiverId: currentUser.id!,
        lastMessage: "Nothing much",
        petId: pets[0].id!,
        lastMessageTime: "1726338907952"),
  ];

  static List<Accessory> accessories = [];

  static Future<void> getAllAccessories() async {
    try {
      QuerySnapshot snapshot = await FirebaseServices.firestore
          .collection(FirebaseServices.accessoriesCollection)
          .get();
      accessories = snapshot.docs
          .map((e) => Accessory.fromJson(e.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  List<Accessory> get allAccessories => accessories;
}
