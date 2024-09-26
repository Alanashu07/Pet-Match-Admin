import 'package:flutter/material.dart';
import 'package:pet_match_admin/Constants/global_variables.dart';
import 'package:pet_match_admin/Screens/MainScreens/reports_screen.dart';
import 'package:pet_match_admin/Style/app_style.dart';
import 'package:provider/provider.dart';
import '../Constants/date_format.dart';
import '../Screens/report_details_screen.dart';

class ReportCard extends StatelessWidget {
  final Color color;
  final ReportModel report;
  const ReportCard({super.key, required this.color, required this.report});

  @override
  Widget build(BuildContext context) {
    final user = context.watch<GlobalVariables>().allUsers.firstWhere((element) => element.id == report.reportedBy,);
    return GestureDetector(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(builder: (_)=> ReportDetailsScreen(report: report,)));
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: color.withOpacity(0.2),
          border: Border.all(color: color)
        ),
        child: Row(
          children: [
            CircleAvatar(
              backgroundImage: NetworkImage(report.pet.images[0]),
            ),
            const SizedBox(width: 15,),
            Expanded(child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(report.pet.name, style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 18),),
                Text(report.message, style: const TextStyle(fontSize: 16, color: Colors.black54), maxLines: 3, overflow: TextOverflow.ellipsis, textAlign: TextAlign.justify,),
                Text("Reported By: ${user.name}", style: TextStyle(color: Colors.red[900]),)
              ],
            )),
            const SizedBox(width: 10,),
            Text(DateFormat.getFormattedTime(context: context, time: report.time))
          ],
        ),
      ),
    );
  }
}
