import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../utils/app-constant.dart';
import '../auth-ui/welcome-screen.dart';


class MainScreen extends StatelessWidget {
    MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(  //backgroundColor: AppConstant.appSecondaryColor,
      //backgroundColor: Theme.of(context).colorScheme.primaryContainer,
   
      appBar: AppBar(backgroundColor: AppConstant.appSecondaryColor,  
        // backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        
        title: Text(
          AppConstant.appMainName,
          style: TextStyle(fontWeight: FontWeight.w500),
        ),
        centerTitle: true,
        actions: [ 
          GestureDetector(
            onTap: () async {
              GoogleSignIn googleSignIn = GoogleSignIn();
              FirebaseAuth _auth = FirebaseAuth.instance;
             await _auth.signOut();

              await googleSignIn.signOut();
              Get.offAll(() => WelcomeScreen());
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Icon(Icons.logout_outlined),
            ),
          ),
        ],
      ),
      
      //  centerTitle: true,
    );
  }
}
