import 'package:firebase_auth/firebase_auth.dart';
import 'package:flexshow/controllers/get-user-data-controller.dart';
import 'package:flexshow/controllers/sign-in-controller.dart';
import 'package:flexshow/screens/admin-panel/admin-main-screen.dart';
import 'package:flexshow/screens/auth-ui/forget-password-screen.dart';

import 'package:flexshow/screens/auth-ui/sign-up-screen.dart';
import 'package:flexshow/screens/user-panel/main-screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

import '../../utils/app-constant.dart';


class SignInScreen extends StatefulWidget {
   const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final SignInController signInController = Get.put(SignInController());
  final GetUserDataController getUserDataController =
      Get.put(GetUserDataController());
  TextEditingController userEmail = TextEditingController();
  TextEditingController userPassword = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return KeyboardVisibilityBuilder(
      builder: (context, isKeyboardVisible) {
        return Scaffold(
          appBar: AppBar(
            title: Text(
              "Sign In",
              style: TextStyle(
                  color: AppConstant.appTextColor,
              fontWeight: FontWeight.bold),),
            backgroundColor: AppConstant.appSecondaryColor,centerTitle: true,
          ),

          body: Container(
            child: Column(
              
              children: [
                isKeyboardVisible?Text("Welcome to my app"):
                Column(
                  children: [
                    Container(color:AppConstant.appSecondaryColor,
                   child: Lottie.asset("assets/images/splash-icon.json"),
                    ),
                  ],
                ),
                
              

                SizedBox(height: Get.height/12,),

                Container(
                  margin: EdgeInsets.symmetric(horizontal: 5.0),
                  width: Get.width,
                  child: Padding(
                    padding: EdgeInsets.all(10.0),
                    child: TextFormField(
                      controller: userEmail,
                      cursorColor: AppConstant.appSecondaryColor,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                          hintText: "Email",
                          prefixIcon: Icon(Icons.email_outlined),
                          contentPadding: EdgeInsets.only(top: 2.0, left: 8.0),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0))),
                    ),
                  ),
                ),
              

                Container(
                  margin: EdgeInsets.symmetric(horizontal: 5.0),
                  width: Get.width,
                  child: Padding(
                    padding: EdgeInsets.all(10.0),
                    child:Obx(() =>  TextFormField(
                      controller: userPassword,
                      obscureText: signInController.isPasswordVisible.value,
                      cursorColor: AppConstant.appSecondaryColor,
                          keyboardType: TextInputType.visiblePassword,
                          decoration: InputDecoration(
                              hintText: "Password",
                              prefixIcon: Icon(Icons.password_outlined),
                              suffixIcon: GestureDetector(
                                  onTap: () {
                                    signInController.isPasswordVisible.toggle();
                                  },
                                  child: signInController
                                          .isPasswordVisible.value
                                      ? Icon(Icons.visibility_off_outlined)
                                      : Icon(Icons.visibility_off_outlined)),
                              contentPadding:
                                  EdgeInsets.only(top: 2.0, left: 8.0),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0))),
                        ),
                      )),
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 10.0),
                  alignment: Alignment.centerRight,
                  child: GestureDetector(onTap: () {
                    Get.to(()=> ForgetPasswordScreen());
                  },
                    child: Text(
                      "Forget Password?",
                      style: TextStyle(
                          color: AppConstant.appSecondaryColor,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                SizedBox(
                  height: Get.height / 20),
                Material(
                  child: Container(
                    width: Get.width / 2,
                    height: Get.height / 18,
                    decoration: BoxDecoration(
                      color: AppConstant.appSecondaryColor,
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    child: TextButton(
                     
                      child: Text(
                        "SIGN IN",
                        style: TextStyle(color: AppConstant.appTextColor),
                      ),
                      onPressed: () async {
                        String email = userEmail.text.trim();

                        String password = userPassword.text.trim();

                        if (email.isEmpty || password.isEmpty) {
                          Get.snackbar(
                            "Error",
                            "Please enter all details",
                            snackPosition: SnackPosition.BOTTOM,
                            backgroundColor: AppConstant.appSecondaryColor,
                            colorText: AppConstant.appTextColor,
                          );
                        } else {
                          UserCredential? userCredential =
                              await signInController.signInMethod(
                                  email, password);

                                 // ignore: unused_local_variable
                                 var userData = await getUserDataController
                              .getUserdata(userCredential!.user!.uid);

                          // ignore: unnecessary_null_comparison
                          if (userCredential != null) {
                            if (userCredential.user!.emailVerified) {
                              if (userData[0]['isAdmin'] == true) {
                               
                                Get.snackbar("Success Admin Login",
                                    "login Successfully!",
                                    snackPosition: SnackPosition.BOTTOM,
                                    backgroundColor:
                                        AppConstant.appSecondaryColor,
                                    colorText: AppConstant.appTextColor);
                                    Get.offAll(()=> AdminMainScreen());
                              } else {
                                Get.offAll(() => MainScreen());
                                  Get.snackbar("Success User Login",
                                    "login Successfully!",
                                    snackPosition: SnackPosition.BOTTOM,
                                    backgroundColor:
                                        AppConstant.appSecondaryColor,
                                    colorText: AppConstant.appTextColor);
                              }

                             
                           
                            } else {
                              Get.snackbar(
                                "Error",
                                "Please verify your email before login",
                                snackPosition: SnackPosition.BOTTOM,
                                backgroundColor: AppConstant.appSecondaryColor,
                                colorText: AppConstant.appTextColor,
                              );
                            }
                          }
                          else {

                            Get.snackbar("Error", "Please try again",
                            snackPosition: SnackPosition.BOTTOM,
                          backgroundColor: AppConstant.appSecondaryColor,
                          colorText: AppConstant.appTextColor);

                          }
                        }
                      },
                    ),
                  ),
                ),
                SizedBox(height: Get.height / 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  
                  
                  children: [
                    Text(
                      "Don't have an account? ",
                      style: TextStyle(color: AppConstant.appSecondaryColor),
                    ),
                    GestureDetector(
                      onTap:() => Get.offAll(() => SignUpScreen()),
                      child:Text(
                      "Sign up",
                      style: TextStyle(
                          color: AppConstant.appSecondaryColor,
                          fontWeight: FontWeight.bold),
                    )),
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
