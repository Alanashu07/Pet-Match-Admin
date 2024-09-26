import 'package:flutter/material.dart';

import '../Constants/date_format.dart';
import '../Constants/global_variables.dart';
import '../Models/message_model.dart';
import '../Screens/image_viewer.dart';
import '../Services/firebase_services.dart';
import '../Style/app_style.dart';

class ChatBubble extends StatefulWidget {
  final Message message;

  const ChatBubble({super.key, required this.message});

  @override
  State<ChatBubble> createState() => _ChatBubbleState();
}

class _ChatBubbleState extends State<ChatBubble> {

  @override
  Widget build(BuildContext context) {
    final user = GlobalVariables.currentUser;
    return user.id == widget.message.sender ? sendBubble() : receiveBubble();
  }

  Widget sendBubble() {
    final mq = MediaQuery.of(context).size;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              widget.message.readAt!.isNotEmpty
                  ? Icon(
                  Icons.done_all,
                  color: AppStyle.mainColor
              )
                  : widget.message.sentAt.isNotEmpty
                  ? Icon(
                  Icons.done,
                  color: AppStyle.mainColor
              )
                  : const SizedBox(),
              const SizedBox(
                width: 10,
              ),
              Text(DateFormat.getFormattedTime(
                  context: context, time: widget.message.sentAt)),
            ],
          ),
        ),
        Flexible(
          child: Container(
            padding: EdgeInsets.all(mq.width * .04),
            margin: EdgeInsets.symmetric(
                horizontal: mq.width * .04, vertical: mq.height * .01),
            decoration: BoxDecoration(
                color: AppStyle.mainColor.withOpacity(0.3),
                border: Border.all(
                    color: AppStyle.mainColor),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                  bottomLeft: Radius.circular(30),
                )),
            child:
            widget.message.type == 'image' || widget.message.type == 'gif'
                ? GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => ImageViewer(
                              title: 'Image',
                              image: widget.message.text)));
                },
                child: SizedBox(
                  height: mq.height*.25,
                  width: mq.height*.25,
                  child: Image.network(
                    widget.message.text,
                    fit: BoxFit.cover,
                  ),
                ))
                : Text(
              widget.message.text,
              style: const TextStyle(
                  color: Colors.black,
                  fontSize: 15),
            ),
          ),
        )
      ],
    );
  }

  Widget receiveBubble() {
    final mq = MediaQuery.of(context).size;
    if (widget.message.readAt.isEmpty) {
      FirebaseServices.updateReadStatus(widget.message);
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Flexible(
          child: Container(
            padding: EdgeInsets.all(mq.width * .04),
            margin: EdgeInsets.symmetric(
                horizontal: mq.width * .04, vertical: mq.height * .01),
            decoration: BoxDecoration(
                color:
                AppStyle.accentColor.withOpacity(0.2),
                border: Border.all(
                    color: AppStyle.accentColor),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                )),
            child:
            widget.message.type == 'image' || widget.message.type == 'gif'
                ? GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => ImageViewer(
                              title: 'Image',
                              image: widget.message.text)));
                },
                child: SizedBox(
                  height: mq.height*.25,
                  width: mq.height*.25,
                  child: Image.network(
                    widget.message.text,
                    fit: BoxFit.cover,
                  ),
                ))
                : Text(
              widget.message.text,
              style: const TextStyle(color: Colors.black, fontSize: 15),
            ),
          ),
        ),
        Text(DateFormat.getFormattedTime(
            context: context, time: widget.message.sentAt))
      ],
    );
  }
}