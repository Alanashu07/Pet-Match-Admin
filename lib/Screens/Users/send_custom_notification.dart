import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pet_match_admin/Models/notification_model.dart';
import 'package:pet_match_admin/Models/user_model.dart';
import 'package:pet_match_admin/Screens/MainScreens/bottom_bar.dart';
import 'package:pet_match_admin/Services/firebase_services.dart';
import 'package:pet_match_admin/Widgets/custom_text_field.dart';
import 'package:pet_match_admin/Widgets/login_button.dart';

import '../../Constants/global_variables.dart';
import '../../Style/app_style.dart';

class SendCustomNotification extends StatefulWidget {
  final List<User> selectedUsers;

  const SendCustomNotification({super.key, required this.selectedUsers});

  @override
  State<SendCustomNotification> createState() => _SendCustomNotificationState();
}

class _SendCustomNotificationState extends State<SendCustomNotification> {
  TextEditingController titleController = TextEditingController();
  TextEditingController beforeUserTitle = TextEditingController();
  TextEditingController afterUserTitle = TextEditingController();
  TextEditingController messageController = TextEditingController();
  TextEditingController beforeUserMessage = TextEditingController();
  TextEditingController afterUserMessage = TextEditingController();
  bool titleUsername = false;
  bool messageUsername = false;
  String imageUrl = '';
  final _formKey = GlobalKey<FormState>();
  bool isUploading = false;

  sendNotification() async {
    for (var user in widget.selectedUsers) {
      NotificationModel notification = NotificationModel(
          senderId: GlobalVariables.currentUser.id!,
          isRead: false,
          id: '${GlobalVariables.currentUser.id}-${user.id}-${DateTime.now().millisecondsSinceEpoch}',
          receiverId: user.id!,
          title: titleUsername ? '${beforeUserTitle.text.trim()} ${user.name} ${afterUserTitle.text.trim()}' : titleController.text.trim(),
          page: "custom",
          type: "none",
          image: imageUrl,
          message: messageUsername ? '${beforeUserMessage.text.trim()} ${user.name} ${afterUserMessage.text.trim()}' : messageController.text.trim(),
          sendAt: DateTime.now().millisecondsSinceEpoch.toString());
      await FirebaseServices.firestore
          .collection(FirebaseServices.usersCollection)
          .doc(user.id)
          .update({
        'notifications': FieldValue.arrayUnion([notification.toJson()])
      });
    }
  }

  uploadImage(XFile image) async {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    FirebaseStorage storage = FirebaseStorage.instance;
    Reference ref = storage
        .ref()
        .child('notifications/${GlobalVariables.currentUser.id!}-$timestamp');
    await ref.putFile(File(image.path));
    imageUrl = await ref.getDownloadURL();
  }

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Define Notification"),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: mq.height * .05),
                SizedBox(
                  height: mq.height * .1,
                  width: mq.width,
                  child: ListView.builder(
                    itemCount: widget.selectedUsers.length,
                    scrollDirection: Axis.horizontal,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      User user = widget.selectedUsers[index];
                      return Padding(
                        padding: EdgeInsets.all(10),
                        child: Stack(
                          alignment: Alignment.bottomRight,
                          children: [
                            CircleAvatar(
                              backgroundImage: NetworkImage(user.image!),
                              radius: 35,
                            ),
                            CircleAvatar(
                              backgroundColor: AppStyle.ternaryColor,
                              radius: 10,
                              child: Icon(
                                Icons.check,
                                size: 15,
                                color: Colors.white,
                              ),
                            )
                          ],
                        ).animate().slideX(begin: 1, end: 0).fade(),
                      );
                    },
                  ),
                ),
                Divider(),
                SizedBox(height: mq.height * .03),
                GestureDetector(
                  onTap: () async {
                    final picker = ImagePicker();
                    final pickedImage =
                        await picker.pickImage(source: ImageSource.gallery);
                    setState(() {
                      isUploading = true;
                    });
                    if (pickedImage != null) {
                      await uploadImage(pickedImage);
                      setState(() {
                        isUploading = false;
                      });
                    } else {
                      setState(() {
                        isUploading = false;
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text("Image is not uploaded!")));
                      });
                    }
                  },
                  child: CircleAvatar(
                    radius: 60,
                    backgroundImage: NetworkImage(imageUrl),
                    child: imageUrl.isEmpty
                        ? const Icon(
                            Icons.image,
                            size: 50,
                          )
                        : null,
                  ),
                ),
                SizedBox(height: mq.height * .03),
                Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        titleUsername ?
                            Row(
                              children: [
                                Expanded(child: CustomTextField(controller: beforeUserTitle, hintText: 'Title before username', type: 'Title before')),
                                const Text('--User Name--'),
                                Expanded(child: CustomTextField(controller: afterUserTitle, hintText: 'Title after username', type: 'Title after')),
                              ],
                            )
                            : CustomTextField(
                          controller: titleController,
                          hintText: "Enter title of the notification",
                          type: 'title',
                          labelText: 'Title',
                        ),
                        Row(
                          children: [
                            const Spacer(),
                            Checkbox(value: titleUsername, onChanged: (value) {
                              setState(() {
                                titleUsername = value!;
                              });
                            },),
                            Text("Include user name"),
                            const SizedBox(width: 25,)
                          ],
                        ),
                        messageUsername ?
                        Row(
                          children: [
                            Expanded(child: CustomTextField(controller: beforeUserMessage, hintText: 'Body before username', type: 'Message before',)),
                            const Text('--User Name--'),
                            Expanded(child: CustomTextField(controller: afterUserMessage, hintText: 'Body after username', type: 'Message after')),
                          ],
                        )
                            : CustomTextField(
                          controller: messageController,
                          hintText: "Enter body of the notification",
                          type: 'body',
                          labelText: 'Body',
                        ),
                        Row(
                          children: [
                            const Spacer(),
                            Checkbox(value: messageUsername, onChanged: (value) {
                              setState(() {
                                messageUsername = value!;
                              });
                            },),
                            Text("Include user name"),
                            const SizedBox(width: 25,)
                          ],
                        ),
                      ],
                    )),
                const SizedBox(
                  height: 50,
                ),
                Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: LoginButton(
                      onTap: () async {
                        if (_formKey.currentState!.validate()) {
                          setState(() {
                            isUploading = true;
                          });
                          await sendNotification();
                          setState(() {
                            isUploading = false;
                          });
                          Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const BottomBar(),
                              ),
                              (route) => false);
                        }
                      },
                      child: const Text(
                        "Send Notification",
                        style: TextStyle(color: Colors.white),
                      )),
                ),
                SizedBox(
                  height: mq.height * .3,
                )
              ],
            ),
          ),
          isUploading
              ? Container(
                  height: mq.height,
                  width: mq.width,
                  alignment: Alignment.center,
                  color: Colors.black54,
                  child: CircularProgressIndicator())
              : const SizedBox(),
        ],
      ),
    );
  }
}
