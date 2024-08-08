// ignore_for_file: prefer_const_constructors

import 'package:flexshow/screens/user-panel/all-flash-sale-products.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../utils/app-constant.dart';
import '../../widgets/banner-widget.dart';
import '../../widgets/category-widget.dart';
import '../../widgets/custom-drawer-widget.dart';
import '../../widgets/flash-sale-widget.dart';
import '../../widgets/heading-widget.dart';
import 'all-categories-screen.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: AppConstant.appSecondaryColor,
      //backgroundColor: Theme.of(context).colorScheme.primaryContainer,

      appBar: AppBar(
        iconTheme: IconThemeData(color: AppConstant.appTextColor),
        systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: AppConstant.appSecondaryColor,
            statusBarIconBrightness: Brightness.light),
        backgroundColor: AppConstant.appSecondaryColor,
        // backgroundColor: Theme.of(context).colorScheme.inversePrimary,

        title: Text(
          AppConstant.appMainName,
          style: TextStyle(
              fontWeight: FontWeight.w500, color: AppConstant.appTextColor),
        ),
        centerTitle: true,
      ),

      drawer: DrawerWidget(),

      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Container(
          child: Column(
            children: [
              SizedBox(
                height:  Get.height /90.0,
              ),
              Text('Aman'),

              // banners
              BannerWidget(),

              // heading 

              HeadingWidget(
                headingTitle: "Categories",
                headinhSubTitle: "According to your budget",
                onTap: () => Get.to(()=> AllCategoriesScreen()),
                buttonText: "See More >",
              ),

              CategoriesWidget(),

               HeadingWidget(
                headingTitle: "Flash Sale",
                headinhSubTitle: "According to your budget",
               
                  onTap: () => Get.to(()=> AllFlashSaleProductScreen()),
                
                buttonText: "See More >",
              ),
              FlashSaleWidget(),

              //  HeadingWidget(
              //   headingTitle: "Flash Sale",
              //   headinhSubTitle: "According to your budget",
              //   onTap: () {},
              //   buttonText: "See More >",
              // ),
            ],
          ),
        ),

      ),
    );
  }
}
