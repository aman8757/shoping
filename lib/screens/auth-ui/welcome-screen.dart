import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';


import '../../controllers/google-sign-in-controller.dart';
import '../../utils/app-constant.dart';
import 'sign-in-screen.dart';

class WelcomeScreen extends StatelessWidget {
   WelcomeScreen({super.key});

  final GoogleSignInController _googleSignInController =
  Get.put(GoogleSignInController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar( 
        elevation: 0,
        centerTitle: true,
        backgroundColor: AppConstant.appSecondaryColor,
        title: Text(
          "Welcome to my app",
          style: TextStyle(
              color: AppConstant.appTextColor, fontWeight: FontWeight.bold),
        ),
        
      
      //  backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),

      body: Container(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(color:AppConstant.appSecondaryColor,
            child: Lottie.asset('assets/images/splash-icon.json'),
          ),
          Container(
              margin: EdgeInsets.only(top: 20.0),
              child: Text(
                "Happy Shopping",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              )),
          SizedBox(
            height: Get.height / 12,
          ),
          Material(
            child: Container(
              width: Get.width / 1.2,
              height: Get.height / 12,
              decoration: BoxDecoration(
                color: AppConstant.appSecondaryColor,
                borderRadius: BorderRadius.circular(20.0),
              ),
              child: TextButton.icon(
                icon: Image.asset(
                  'assets/images/google-logo.png',
                  width: Get.width / 12,
                  height: Get.height / 12,
                ),
                label: Text(
                  "Sign in with google",
                  style: TextStyle(color: AppConstant.appTextColor),
                ),
                onPressed: () {
                _googleSignInController.signInWithGoogle();
                }, 
              ),
            ),
          ),

           SizedBox(
            height: Get.height / 50,
          ),

           Material(
            child: Container(
              width: Get.width / 1.2,
              height: Get.height / 12,
              decoration: BoxDecoration(
                color: AppConstant.appSecondaryColor,
                borderRadius: BorderRadius.circular(20.0),
              ),
             child: TextButton.icon(
                  icon: Icon(
                    Icons.email_outlined,
                    color: AppConstant.appTextColor,
                  ),
                  label: Text(
                    "sign in with email",
                    style: TextStyle(color: AppConstant.appTextColor),
                  ),
                  onPressed: () {
                    Get.to(()=> SignInScreen());
             //     Navigator.push(context,
            //  MaterialPageRoute(builder: (context) => SignInScreen()));
                  }),
            ),
          )

        ],
      )),
    );
  }
}
