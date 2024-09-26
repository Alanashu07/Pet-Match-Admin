import 'package:flutter/material.dart';
import 'package:pet_match_admin/Models/accessory_model.dart';
import 'package:pet_match_admin/Screens/accessory_details.dart';
import 'package:pet_match_admin/Style/app_style.dart';

class AccessoryCard extends StatelessWidget {
  final double borderRadius;
  final double height;
  final double width;
  final Accessory accessory;

  const AccessoryCard(
      {super.key,
      this.borderRadius = 12,
      this.height = 100,
      this.width = double.infinity,
      required this.accessory});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (_) => AccessoryDetails(accessory: accessory)));
      },
      child: Container(
        width: width,
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: AppStyle.mainColor.withOpacity(0.2),
          borderRadius: BorderRadius.circular(borderRadius),
          border: Border.all(color: AppStyle.mainColor),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 15,
            ),
            SizedBox(
                height: height,
                width: width,
                child: Image.network(
                  accessory.images[0],
                  fit: BoxFit.cover,
                )),
            Text(
              accessory.name,
              style: TextStyle(
                  color: AppStyle.mainColor,
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
            ),
            Text(
              accessory.brand,
              style:
                  const TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
            ),
            Row(
              children: [
                const Text('Price: '),
                Text(
                  '₹ ${accessory.price}',
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.normal),
                ),
              ],
            ),
            Row(
              children: [
                const Text('Quantity: '),
                Text(
                  accessory.quantity.toString(),
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.normal,
                      color:
                          accessory.quantity >= 15 ? Colors.green : Colors.red),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
