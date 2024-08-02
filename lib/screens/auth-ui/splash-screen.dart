

import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flexshow/controllers/get-user-data-controller.dart';
import 'package:flexshow/screens/admin-panel/admin-main-screen.dart';
import 'package:flexshow/screens/user-panel/main-screen.dart';

import '../../utils/app-constant.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

import 'welcome-screen.dart';





class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  User? user = FirebaseAuth.instance.currentUser; 
@override
void initState() {
  super.initState();
  Timer(Duration(seconds: 5), () {
  loggdin(context);
   });
}
Future<void> loggdin(BuildContext context) async {

  if (user !=null) {
       final GetUserDataController getUserDataController = Get.put(GetUserDataController());
   var  userData = await getUserDataController.getUserdata(user!.uid);

if (userData[0]['isAdmin'] == true) {
  Get.offAll(()=> AdminMainScreen());
}
else {
  Get.offAll(()=> MainScreen());
}

  }
  else {
    Get.to(()=> WelcomeScreen());
  }
}

  @override
  Widget build(BuildContext context) {
    // final size=MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: AppConstant.appSecondaryColor,
      //  backgroundColor: Theme.of(context).colorScheme.inversePrimary,

      appBar: AppBar(
        backgroundColor: AppConstant.appSecondaryColor,
        //   backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      ),
      

      body: Container(
          child: Column(
        children: <Widget>[
          Expanded(
            child: Container(
              width: Get.width,
              alignment: Alignment.center,
              child: Lottie.asset('assets/images/splash-icon.json'),
            ),
          ),
          Container(
          //  width: size.width,
          margin: EdgeInsets.only(bottom: 20.0),
          width: Get.width,
          alignment: Alignment.center,
            child: Text(
              AppConstant.appPoweredBy,
              style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: AppConstant.appTextColor),
            ),
          ),
        ],
      )),
    );
  }
}