import 'package:cached_network_image/cached_network_image.dart';
import 'package:first/widget/model/product.dart';
import 'package:flutter/material.dart';

class ProductDetailsScreen extends StatelessWidget {
  final Products? product; // Make product nullable

  ProductDetailsScreen({required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Product Details'),
      ),
      body: Center(
        child: Column(
          children: [
            if (product != null) // Check if product is not null
              Column(
                children: [
                  SizedBox(
                    height: 300,
                    width: double.infinity,
                    child: Hero(
                      tag: product?.id ?? "",
                      child: PageView.builder(
                        itemCount: product?.images?.length ?? 0,
                        itemBuilder: (context, index) {
                          return CachedNetworkImage(
                            imageUrl: product?.images?[index] ?? '',
                            fit: BoxFit.cover,
                            height: 120,
                            width: 155,
                            placeholder: (context, url) =>
                                Center(child: CircularProgressIndicator()),
                            errorWidget: (context, url, error) =>
                                Icon(Icons.error),
                          );
                        },
                      ),
                    ),
                  ),
                  Text(product?.title ?? ''),
                  Text(product?.description ?? ''),
                  // Text(product?.price ?? ''),
                  // Text(product?.discountPercentage ?? ''),
                  Text(product?.rating ?? ''),
                  // Text(product?.stock ?? ''),
                  Text(product?.brand ?? ''),
                ],
              )
            else
              Text('Product details not available'),
          ],
        ),
      ),
    );
  }
}
