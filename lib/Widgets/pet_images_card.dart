import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../Constants/global_variables.dart';
import '../Models/pet_model.dart';
import '../Screens/image_viewer.dart';

class PetImagesCard extends StatelessWidget {
  final PetModel pet;
  final Widget? child;
  final EdgeInsetsGeometry? padding;

  const PetImagesCard({super.key, required this.pet, this.child, this.padding});

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context).size;
    return SizedBox(
      height: mq.height*.4,
      child: ListView.separated(
          scrollDirection: Axis.horizontal,
          shrinkWrap: true,
          padding: padding,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (_)=> ImageViewer(title: pet.name, image: pet.images[index])));
              },
              child: Container(
                alignment: Alignment.topRight,
                width: mq.width*.95, height: mq.height*.4,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  image: DecorationImage(image: NetworkImage(pet.images[index]), fit: BoxFit.cover),
                ),
                child: child ?? Padding(
                  padding: const EdgeInsets.all(16),
                  child: CircleAvatar(
                    radius: 20,
                    backgroundColor: Colors.white,
                    child: IconButton(onPressed: (){
                      showDialog(context: context, builder: (context) => AlertDialog(
                        title: const Text('Sure to delete?'),
                        content: const Text('Are you sure to delete the image?'),
                        actions: [
                          TextButton(onPressed: (){
                            Navigator.pop(context);
                            context.read<GlobalVariables>().deletePetImage(pet: pet, image: pet.images[index]);
                          }, child: const Text('Delete')),
                          TextButton(onPressed: (){
                            Navigator.pop(context);
                          }, child: const Text('Cancel')),
                        ],
                      ),);
                    }, icon: const Icon(CupertinoIcons.delete)),
                  )
                ),
              ),
            );
          },
          separatorBuilder: (context, index) => const SizedBox(
                width: 20,
              ),
          itemCount: pet.images.length),
    );
  }
}
