import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImageAddedContainer extends StatelessWidget {
  final List<XFile> images;
  const ImageAddedContainer({super.key, required this.images});

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context).size;
    return SizedBox(
      height: 200,
      child: ListView.builder(itemBuilder: (context, index) {
        return SizedBox(
          height: 200,
          width: mq.width,
          child: Image.file(File(images[index].path), fit: BoxFit.contain,),
          // child: Image.asset('images/dog.png'),
        );
      }, itemCount: images.length, shrinkWrap: true, scrollDirection: Axis.horizontal,),
    );
  }
}
