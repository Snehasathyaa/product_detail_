import 'dart:convert';
import 'dart:developer';
import 'package:first/widget/model/product.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';

class ProductController extends GetxController {
  late Rx<Product> request;
   RxList<Products>?  productList;

  var isLoading = false.obs;
  var isdataLoading = false.obs;
  var isDataLoading = false.obs;
  // Rx<Product> get requests {
  //   return [...request];
  // }
  

  @override
  Future<void> onInit() async {
    super.onInit();
  }

  @override
  Future<void> onReady() async {
    super.onReady();
  }

  @override
  void onClose() {}


  search(String keyWord){
    refresh();
    if (keyWord=='') {
      productList= request.value.products?.obs;
    } else {
       productList = productList!
          .where((element) =>
              element.title!.toLowerCase().contains(keyWord.toLowerCase()))
          .toList().obs;
    }

  }

  getApi() async {
    try {
      isDataLoading(true);
      http.Response response = await http.get(
        Uri.tryParse("https://dummyjson.com/products")!,
      );

      if (response.statusCode == 200) {
        final result = jsonDecode(response.body);
        print("prooocontrolllerrr===" + response.body);
        request= Product.fromJson(result).obs;
        productList= request.value.products?.obs;
      } else {
      }
    } catch (e) {
      log('Error while getting data is $e');
      print('Error while getting data is $e');
    } finally {
      isDataLoading(false);
    }
  }
}
