// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, sized_box_for_whitespace, avoid_unnecessary_containers, unused_local_variable

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flexshow/controllers/cart-price-controller.dart';
import 'package:flexshow/controllers/get-customer-device-token-controller.dart';
import 'package:flexshow/utils/app-constant.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swipe_action_cell/core/cell.dart';
import 'package:get/get.dart';

import '../../models/cart-model.dart';
import '../../services/place-order-service.dart';

class CheckOutScreen extends StatefulWidget {
  const CheckOutScreen({super.key});

  @override
  State<CheckOutScreen> createState() => _CheckOutScreenState();
}

class _CheckOutScreenState extends State<CheckOutScreen> {
  User? user = FirebaseAuth.instance.currentUser;
  final ProductPriceController productPriceController =
      Get.put(ProductPriceController());
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController addressController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: AppConstant.appTextColor),
        backgroundColor: AppConstant.appMainColor,
        title: Text(
          "Check Screen",
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
                          productTotalPrice: double.parse(
                            productData['productTotalPrice'].toString(),
                          ),
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
                                          'productTotalPrice': (double.parse(
                                                  cartModel.fullPrice) *
                                              (cartModel.productQuantity - 1))
                                        });
                                      }
                                    },
                                    child: CircleAvatar(
                                      radius: 14.0,
                                      backgroundColor: AppConstant.appMainColor,
                                      child: Text("-"),
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
              Obx(
                () => Text(
                  " Total ${productPriceController.totalPrice.value.toStringAsFixed(1)} : Rs",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
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
                        "Confirm Order",
                        style: TextStyle(color: AppConstant.appTextColor),
                      ),
                      onPressed: () {
                        showCustomBottomSheet();
                      },
                    ),
                  ),
                ),
              ),
            ],
          )),
    );
  }

  void showCustomBottomSheet() {
    Get.bottomSheet(
      Container(
        height: Get.height * 0.8,
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(16.0))),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 20.0, vertical: 20.0),
                child: Container(
                  height: 55.0,
                  child: TextFormField(
                    controller: nameController,
                    decoration: InputDecoration(
                        labelText: 'Name',
                        contentPadding: EdgeInsets.symmetric(horizontal: 10.0),
                        hintStyle: TextStyle(fontSize: 12)),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 20.0, vertical: 20.0),
                child: Container(
                  height: 55.0,
                  child: TextFormField(
                    controller: phoneController,
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                        labelText: 'Phone',
                        contentPadding: EdgeInsets.symmetric(horizontal: 10.0),
                        hintStyle: TextStyle(fontSize: 12)),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 20.0, vertical: 20.0),
                child: Container(
                  height: 55.0,
                  child: TextFormField(
                    controller: addressController,
                    decoration: InputDecoration(
                        labelText: 'Address',
                        contentPadding: EdgeInsets.symmetric(horizontal: 10.0),
                        hintStyle: TextStyle(fontSize: 12)),
                  ),
                ),
              ),
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: AppConstant.appMainColor,
                      padding: EdgeInsets.fromLTRB(10, 10, 10, 10)),
                  onPressed: () async {
                    if (nameController.text != '' &&
                        phoneController.text != '' &&
                        addressController.text != '') {
                      String name = nameController.text.trim();
                      String phone = phoneController.text.trim();
                      String address = addressController.text.trim();
                      String customerToken = await getCustomerDeviceToken();

// place order service
                      placeOrder(
                        context: context,
                        customerName: name,
                        customerPhone: phone,
                        customerAddress: address,
                        customerDeviceToken: customerToken,
                      );
                    } else {
                      print("Fill the Details");
                    }
                  },
                  child: Text(
                    "Place Order",
                    style: TextStyle(color: Colors.white),
                  ))
            ],
          ),
        ),
      ),
      backgroundColor: Colors.transparent,
      isDismissible: true,
      enableDrag: true,
      elevation: 6,
    );
  }
}
