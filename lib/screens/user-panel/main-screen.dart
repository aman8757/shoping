// ignore_for_file: prefer_const_constructors, avoid_unnecessary_containers


import 'package:flexshow/screens/user-panel/all-product-screen.dart';
import 'package:flexshow/screens/user-panel/cart-screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../utils/app-constant.dart';
import '../../widgets/all-product-widget.dart';
import '../../widgets/banner-widget.dart';
import '../../widgets/category-widget.dart';
import '../../widgets/custom-drawer-widget.dart';
import '../../widgets/flash-sale-widget.dart';
import '../../widgets/heading-widget.dart';
import 'all-categories-screen.dart';
import 'all-flash-sale-products.dart';

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
        actions: [
          GestureDetector(onTap: () => Get.to(() => CartScreen()),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Icon(Icons.shopping_cart),
            ),
          ),
        ],
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

               HeadingWidget(
                headingTitle: "All products",
                headinhSubTitle: "According to your budget",
                onTap: () {
                  Get.to(()=> AllProductsScreen());           },
                buttonText: "See More >",
              ),
              AllProductsWidget(),

            ],
          ),
        ),

      ),
    );
  }
}
