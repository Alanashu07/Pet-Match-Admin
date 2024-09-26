import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:pet_match_admin/Constants/date_format.dart';
import 'package:pet_match_admin/Constants/global_variables.dart';
import 'package:pet_match_admin/Models/user_model.dart';
import 'package:pet_match_admin/Screens/Users/user_details.dart';

class UserTile extends StatelessWidget {
  final Color color;
  final User user;
  final bool showJoinedOn;
  final VoidCallback? onTap;
  const UserTile({super.key, required this.color, required this.user, this.showJoinedOn = true, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap ?? (){
        Navigator.push(context, MaterialPageRoute(builder: (_)=> UserDetails(user: user,)));
      },
      child: AnimatedContainer(
        duration: 300.ms,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(color: color),
          color: color.withOpacity(.2),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            CircleAvatar(
              backgroundImage: NetworkImage(user.image ?? GlobalVariables.errorImage),
            ),
            const SizedBox(width: 15,),
            Expanded(child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(user.name, style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 18),),
                Text(user.phoneNumber, style: const TextStyle(fontSize: 16, color: Colors.black54),)
              ],
            )),
            showJoinedOn ? Text(DateFormat.getCreatedTime(context: context, time: user.joinedOn)) : const SizedBox()
          ],
        ),
      ),
    );
  }
}
