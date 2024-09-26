import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:pet_match_admin/Constants/global_variables.dart';
import 'package:pet_match_admin/Widgets/login_button.dart';
import 'package:provider/provider.dart';
import '../../Services/firebase_services.dart';
import '../login_page.dart';

class PendingScreen extends StatelessWidget {
  const PendingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    GlobalVariables.getCurrentUser();
    final user = context.watch<GlobalVariables>().user;
    // final user = GlobalVariables.currentUser;
    String pendingRequest = "Your request is pending and will be approved soon";
    String declined = "Your request has been declined, Sorry!";
    String blocked =
        "You have been permanently restricted from using Pet Match, Inconvenience caused is deeply regretted!";
    String userRequest =
        "You may be a normal user from Pet Match app, This action may cause you to be restricted from using Pet Match in the future. Or May be your request has been declined. You can return to Pet Match and use it normally or you can request again.";
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(18.0),
              child: Text(
                user.type == 'requested'
                    ? pendingRequest
                    : user.type == 'declined'
                        ? declined
                        : user.type == 'blocked'
                            ? blocked
                            : userRequest,
                textAlign: TextAlign.center,
              ),
            ),
            user.type != 'requested'
                ? Padding(
                    padding: const EdgeInsets.all(24),
                    child: LoginButton(
                      onTap: () {
                        context
                            .read<GlobalVariables>()
                            .updateUserType(id: user.id!, newType: 'requested');
                      },
                      child: const Text(
                        "Request Again",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  )
                : const SizedBox()
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          await FirebaseServices.updateActiveStatus(false);
          await FirebaseServices.auth.signOut();
          await GoogleSignIn().signOut();
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (_) => const LoginPage()),
            (route) => false,
          );
        },
        label: const Row(
          children: [
            Icon(Icons.logout),
            SizedBox(
              width: 10,
            ),
            Text("Logout")
          ],
        ),
      ),
    );
  }
}
