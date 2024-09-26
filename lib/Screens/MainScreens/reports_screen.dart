import 'package:flutter/material.dart';
import 'package:pet_match_admin/Style/app_style.dart';
import 'package:pet_match_admin/Widgets/report_card.dart';

import '../../Models/pet_model.dart';
import '../../Services/firebase_services.dart';

class ReportsScreen extends StatelessWidget {
  const ReportsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Reports"),
      ),
      body: StreamBuilder(
        stream: FirebaseServices.firestore
            .collection(FirebaseServices.reportsCollection)
            .snapshots(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
            case ConnectionState.none:
              return const Center(
                child: CircularProgressIndicator(),
              );
            case ConnectionState.active:
            case ConnectionState.done:
          }
          final data = snapshot.data?.docs;
          return ListView.builder(
            itemBuilder: (context, index) {
              final snap = data[index];
              ReportModel report = ReportModel(
                  message: snap['message'],
                  pet: PetModel.fromJson(snap['pet']),
                  reportedBy: snap['reportedBy'],
                  time: snap['time']);
              return Padding(
                padding: const EdgeInsets.all(18.0),
                child: ReportCard(color: AppStyle.accentColor, report: report),
              );
            },
            itemCount: data!.length,
          );
        },
      ),
    );
  }
}

class ReportModel {
  late String message;
  late PetModel pet;
  late String reportedBy;
  late String time;

  ReportModel(
      {required this.message,
      required this.pet,
      required this.reportedBy,
      required this.time});
}
