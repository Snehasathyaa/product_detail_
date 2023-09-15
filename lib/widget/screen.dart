import 'package:first/widget/core/product_details.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:get/get.dart';

import 'controller/product_controller.dart';
import 'model/product.dart';

class ProductGrid extends StatefulWidget {
  @override
  _ProductGridState createState() => _ProductGridState();
}

class _ProductGridState extends State<ProductGrid> {
  ScrollController _scrollController = ScrollController();
  int _visibleProducts = 30;
  late List<dynamic> request = [].obs;
  List<Product> _products = [];
  List<Product> _foundProducts = [];
  final controller = Get.put(ProductController());

  final List<Map<String, dynamic>> dummyProductData = [];

  @override
  void initState() {
    super.initState();
    controller.getApi();

    // _loadProducts();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        _loadMoreProducts();
      }
    });
  }

  void _loadMoreProducts() {
    if (_visibleProducts < _products.length) {
      setState(() {
        _visibleProducts += 10;
      });
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isDataLoading.value) {
        return Center(child: CircularProgressIndicator());
      } else {
        return Scaffold(
          body: GetBuilder<ProductController>(
            init: ProductController(),
            builder: (controller) {
              return Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  children: [
                    const SizedBox(
                      height: 20,
                    ),
                    TextField(
                      onChanged: (value) => controller.search(value),
                      decoration: InputDecoration(
                        hintText: 'Search',
                        suffixIcon: Icon(Icons.search),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.blue, width: 0),
                          borderRadius: BorderRadius.circular(35.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.blue, width: 0),
                          borderRadius: BorderRadius.circular(35.0),
                        ),
                      ),
                    ),
                    Expanded(
                      child: GridView.builder(
                          controller: _scrollController,
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 0.75,
                          ),
                          itemCount: controller.productList?.length ?? 0,
                          itemBuilder: (context, index) {
                            if (index == controller.productList!.length - 1 &&
                                index < _visibleProducts - 1) {
                              return InkWell(
                                onTap: () {
                                  _loadMoreProducts();
                                },
                                child: Container(
                                  alignment: Alignment.center,
                                ),
                              );
                            } else {
                              return GestureDetector(
                                onTap: () {
                                  // Handle the onTap event for the Card here
                                  // For example, you can navigate to the product details screen
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          ProductDetailsScreen(
                                         product: controller.productList![index] 
                                      ),
                                    ),
                                  );
                                },
                                child: Card(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(5),
                                        child: Hero(
                                          tag:  controller
                                                    .productList![index].id??"",
                                          child: CachedNetworkImage(
                                            imageUrl: controller
                                                    .productList![index]
                                                    .thumbnail ??
                                                '',
                                            fit: BoxFit.cover,
                                            height: 120,
                                            width: 155,
                                            placeholder: (context, url) =>
                                                Center(child: CircularProgressIndicator()),
                                            errorWidget: (context, url, error) =>
                                                Icon(Icons.error),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.all(8.0),
                                        child: Text(
                                          controller
                                                  .productList![index].title ??
                                              '',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.all(8.0),
                                        child: Text(
                                          controller.productList![index]
                                                  .description ??
                                              '',
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.green,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }
                          }),
                    ),
                  ],
                ),
              );
            },
          ),
        );
      }
    });
  }
}
