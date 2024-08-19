// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, sized_box_for_whitespace, avoid_unnecessary_containers


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flexshow/controllers/cart-price-controller.dart';
import 'package:flexshow/screens/user-panel/checkout-screen.dart';
import 'package:flexshow/utils/app-constant.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swipe_action_cell/core/cell.dart';
import 'package:get/get.dart';

import '../../models/cart-model.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  User? user = FirebaseAuth.instance.currentUser;
  final ProductPriceController productPriceController =
      Get.put(ProductPriceController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: AppConstant.appTextColor),
        backgroundColor: AppConstant.appMainColor,
        title: Text(
          "cart Screen",
          style: TextStyle(color: AppConstant.appTextColor),
        ),
      ),
      body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('cart')
              .doc(user!.uid)
              .collection('cartOrders')
              .snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return Center(
                child: Text("Error"),
              );
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Container(
                height: Get.height / 5,
                child: Center(
                  child: CupertinoActivityIndicator(),
                ),
              );
            }
            if (snapshot.data!.docs.isEmpty) {
              return Center(
                child: Text("No products found!"),
              );
            }
            if (snapshot.data != null) {
              return Container(
                  child: ListView.builder(
                      itemCount: snapshot.data!.docs.length,
                      shrinkWrap: true,
                      physics: BouncingScrollPhysics(),
                      itemBuilder: (context, index) {
                        final productData = snapshot.data!.docs[index];
                        CartModel cartModel = CartModel(
                          productId: productData['productId'],
                          categoryId: productData['categoryId'],
                          productName: productData['productName'],
                          categoryName: productData['categoryName'],
                          salePrice: productData['salePrice'],
                          fullPrice: productData['fullPrice'],
                          productImages: productData['productImages'],
                          deliveryTime: productData['deliveryTime'],
                          isSale: productData['isSale'],
                          productDescription: productData['productDescription'],
                          createdAt: productData['createdAt'],
                          updatedAt: productData['updatedAt'],
                          productQuantity: productData['productQuantity'],
                          productTotalPrice: productData['productTotalPrice'],
                        );

                        // calculate price 
                        productPriceController.fetchProductPrice();

                        return SwipeActionCell(
                          key: ObjectKey(cartModel.productId),
                          trailingActions: [
                            SwipeAction(
                              title: "Delete",
                              forceAlignmentToBoundary: true,
                              performsFirstActionWithFullSwipe: true,
                              onTap: (CompletionHandler handler) async {
                                print("deteled");

                                await FirebaseFirestore.instance
                                    .collection('cart')
                                    .doc(user!.uid)
                                    .collection('cartOrders')
                                    .doc(cartModel.productId)
                                    .delete();
                              },
                            )
                          ],
                          child: Card(
                            elevation: 5,
                            color: AppConstant.appTextColor,
                            child: ListTile(
                              leading: CircleAvatar(
                                  backgroundColor: AppConstant.appMainColor,
                                  backgroundImage:
                                      NetworkImage(cartModel.productImages[0])),
                              title: Text(cartModel.productName),
                              subtitle: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(cartModel.productTotalPrice.toString()),
                                  SizedBox(width: Get.width / 20.0),
                                  GestureDetector(
                                    onTap: () async {
                                      if (cartModel.productQuantity > 1) {
                                        FirebaseFirestore.instance
                                            .collection('cart')
                                            .doc(user!.uid)
                                            .collection('cartOrders')
                                            .doc('cartModel.productId')
                                            .update({
                                          'productQuantity':
                                              cartModel.productQuantity - 1,
                                              'productTotalPrice':
                                               (double.parse(cartModel.fullPrice) * 
                                               (cartModel.productQuantity -1))
                                        });
                                      }
                                    },
                                    child: CircleAvatar(
                                      radius: 14.0,
                                      backgroundColor: AppConstant.appMainColor,
                                      child: Text("-"),
                                    ),
                                  ),
                                  SizedBox(width: Get.width / 20.0),

                                  GestureDetector(
                                    onTap: () {
if (cartModel.productQuantity > 0) {
                                        FirebaseFirestore.instance
                                            .collection('cart')
                                            .doc(user!.uid)
                                            .collection('cartOrders')
                                            .doc('cartModel.productId')
                                            .update({
                                          'productQuantity':
                                              cartModel.productQuantity + 1,
                                          'productTotalPrice': 
                                          double.parse(cartModel.fullPrice) +
                                              double.parse(cartModel.fullPrice) *
                                                  (cartModel.productQuantity)
                                        });
                                      }
                                      
                                    },
                                    child: CircleAvatar(
                                      radius: 14.0,
                                      backgroundColor: AppConstant.appMainColor,
                                      child: Text("+"),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      }));
            }

            return Container();
          }),
      bottomNavigationBar: Container(
          margin: EdgeInsets.only(bottom: 5.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
             Obx(() =>  Text(
               " Total ${ productPriceController.totalPrice.value.toStringAsFixed(1)} : Rs",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Material(
                  child: Container(
                    width: Get.width / 2.0,
                    height: Get.height / 18,
                    decoration: BoxDecoration(
                      color: AppConstant.appSecondaryColor,
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    child: TextButton(
                      child: Text(
                        "Checkout",
                        style: TextStyle(color: AppConstant.appTextColor),
                      ),
                      onPressed: () {
                        Get.to(() => CheckOutScreen());
                      },
                    ),
                  ),
                ),
              ),
            ],
          )),
    );
  }
}
