

import 'dart:async';

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
@override
void initState() {
  super.initState();
  Timer(Duration(seconds: 5), () {
    Get.offAll(()=>  WelcomeScreen());
   });
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