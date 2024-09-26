import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pet_match_admin/Constants/global_variables.dart';
import 'package:pet_match_admin/Models/accessory_model.dart';
import 'package:pet_match_admin/Style/app_style.dart';
import 'package:pet_match_admin/Widgets/accessory_images_card.dart';
import 'package:pet_match_admin/Widgets/accessory_name_header.dart';
import 'package:pet_match_admin/Widgets/action_widgets.dart';
import 'package:provider/provider.dart';

class AccessoryDetails extends StatefulWidget {
  final Accessory accessory;
  const AccessoryDetails({super.key, required this.accessory});

  @override
  State<AccessoryDetails> createState() => _AccessoryDetailsState();
}

class _AccessoryDetailsState extends State<AccessoryDetails> {

  bool isUploading = false;

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context).size;
    final myAccessory = context.watch<GlobalVariables>().allAccessories.firstWhere((element) => element.id == widget.accessory.id);
    return Scaffold(
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(18.0),
              child: Column(
                children: [
                  SizedBox(height: mq.height*.05,),
                  AccessoryImagesCard(accessory: myAccessory,),
                  Padding(padding: const EdgeInsets.all(8), child: Row(
                    children: [
                      const Spacer(),
                      ElevatedButton(onPressed: (){},
                          style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8))),
                          child: const Text('Add more images')),
                    ],
                  ),),
                  AccessoryNameHeader(accessory: myAccessory),
                  Text('Available Quantity: ${myAccessory.quantity.round()}', style: TextStyle(color: AppStyle.mainColor, fontSize: 18),),
                  Padding(
                    padding: const EdgeInsets.all(18),
                    child: SizedBox(
                      width: double.infinity,
                      child: Text(
                        myAccessory.description,
                        style: const TextStyle(color: Colors.black54),
                        textAlign: TextAlign.justify,
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ActionWidgets(color: AppStyle.ternaryColor, icon: Icons.edit, onTap: (){}),
                      ActionWidgets(color: AppStyle.accentColor, icon: CupertinoIcons.delete, onTap: (){}),
                    ],
                  )
                ],
              ),
            ),
          ),
          isUploading ? Container(
            width: mq.width,
            height: mq.height,
            color: Colors.black54,
            alignment: Alignment.center,
            child: CircularProgressIndicator(color: AppStyle.mainColor,),
          ) : const SizedBox()
        ],
      ),
    );
  }
}
