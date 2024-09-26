import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:pet_match_admin/Constants/alert_option.dart';
import 'package:pet_match_admin/Screens/sign_up.dart';
import 'package:pet_match_admin/splash_screen.dart';
import '../Services/firebase_services.dart';
import '../Style/app_style.dart';
import '../Widgets/custom_text_field.dart';
import '../Widgets/login_button.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool isSecurePassword = true;
  final formKey = GlobalKey<FormState>();

  bool isValidEmail(String email) {
    final emailRegExp = RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
    return emailRegExp.hasMatch(email);
  }

  Future googleSignIn() async {
    try {
      final google = GoogleSignIn();
      final user = await google.signIn();
      if (user == null) return;
      final auth = await user.authentication;
      final credential = GoogleAuthProvider.credential(
          idToken: auth.idToken, accessToken: auth.accessToken);
      await FirebaseAuth.instance.signInWithCredential(credential);
      if(await FirebaseServices.userExists()) {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (_) => const SplashScreen()));
      } else {
        await FirebaseServices.createUser().then((value) {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (_) => const SplashScreen()));
        },);
      }
    }on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.code)));
    }
  }

  Future forgotPassword() async {
    try {
      if (emailController.text.isEmpty) {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text("Please Enter your email ID")));
      } else {
        if(await FirebaseServices.userExists()) {
          FirebaseAuth.instance.sendPasswordResetEmail(email: emailController.text);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("User with this email is not found!")));
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  signInWithEmail()async {
    if(isValidEmail(emailController.text)) {
      try{
        await FirebaseServices.auth.signInWithEmailAndPassword(email: emailController.text, password: passwordController.text);
        if(await FirebaseServices.userExists()) {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (_) => const SplashScreen()));
        } else {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('User not found! Please try signing in')));
        }
      } on FirebaseAuthException catch(e) {
        final msg = e.code;
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg), backgroundColor: AppStyle.accentColor,));
      }
    } else {
      showAlert(context: context, title: "Invalid Email", content: "Please enter a valid email to continue");
    }
  }

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context).size;
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: mq.height*.05,),
              Container(
                height: mq.height * .35,
                alignment: Alignment.topCenter,
                width: double.infinity,
                decoration: BoxDecoration(
                  image: const DecorationImage(
                      image: AssetImage("images/pets.jpg"), fit: BoxFit.cover),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  "Until one has loved an animal a part of one's soul remains unawakened.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.normal,
                      fontSize: 24),
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(top: 18.0),
                child: Text(
                  "Welcome Back",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
              ),
              const Text("Enter details to get back your account",
                  style: TextStyle(color: Colors.black54, fontSize: 18)),
              Form(
                  key: formKey,
                  child: Column(
                    children: [
                      CustomTextField(
                        textInputType: TextInputType.emailAddress,
                        controller: emailController,
                        hintText: 'Email Id',
                        suffixIcon: Icon(
                          Icons.email_outlined,
                          color: AppStyle.accentColor,
                        ),
                        type: 'Email',
                      ),
                      CustomTextField(
                        controller: passwordController,
                        hideText: isSecurePassword,
                        hintText: 'Password',
                        suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                isSecurePassword = !isSecurePassword;
                              });
                            },
                            icon: Icon(
                              isSecurePassword
                                  ? CupertinoIcons.eye
                                  : CupertinoIcons.eye_slash,
                              color: AppStyle.accentColor,
                            )),
                        type: 'Password',
                      ),
                    ],
                  )),
              Row(
                children: [
                  const Spacer(),
                  TextButton(
                      onPressed: forgotPassword,
                      child: Text(
                        "Forgot Password?",
                        style: TextStyle(
                            color: AppStyle.accentColor,
                            fontSize: 18,
                            fontWeight: FontWeight.w500),
                      ))
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: LoginButton(
                  onTap: () {
                    formKey.currentState!.save();
                    if(formKey.currentState!.validate()) {
                      signInWithEmail();
                    }
                  },
                  child: const Text(
                    "Login",
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                ),
              ),
              const Center(
                child: Text(
                  "OR",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
                ),
              ),
              GestureDetector(
                onTap: googleSignIn,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Continue with  ",
                      style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 18,
                          color: AppStyle.accentColor),
                    ),
                    Image.asset(
                      "images/social.png",
                      scale: 8,
                    )
                  ],
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (_)=> const SignUpScreen()));
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Don't have an account?  ",
                      style: TextStyle(color: Colors.black),
                    ),
                    Text(
                      "Sign up",
                      style: TextStyle(color: AppStyle.accentColor),
                    ),
                  ],
                ),
              ),
              SizedBox(height: mq.height*.05,)
            ],
          ),
        ),
      ),
    );
  }
}
