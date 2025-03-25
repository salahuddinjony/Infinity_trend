import 'package:flutter/material.dart';
import 'package:login_page/services/apiResponse.dart';
import '../../models/feature_product.dart';
import 'add_to_card_page.dart';
import 'home_screen_controller.dart';
import 'bazar_page.dart';

class CardPage extends StatefulWidget {
  const CardPage({super.key});

  @override
  State<CardPage> createState() => _CardPageState();
}

class _CardPageState extends State<CardPage> {
  late HomeScreenController _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = HomeScreenController();
    _bloc.fetchFeaturedProduct();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<ApiResponse<FeatureProduct>>(
      stream: _bloc.featureProductStream,
      builder: (context, snapshot) {
        if (!snapshot.hasData || snapshot.data!.status == Status.LOADING) {
          // Show only the loading indicator (without Shopping Carts title)
          return Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (snapshot.data!.status == Status.ERROR) {
          return Scaffold(
            body: Center(child: Text("Error fetching data")),
          );
        }

        var productList = snapshot.data!.data!.data;

        return Scaffold(
          appBar: AppBar(
            title: Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.only(left: 20.0),
                child: Text(
                    "Shopping Carts",
                  style: TextStyle( fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  productList.isNotEmpty
                      ? SizedBox(
                    height: 250,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: productList.length,
                      itemBuilder: (context, index) {
                        var product = productList[index];
                        String imageUrl = product.pictureModels.isNotEmpty
                            ? product.pictureModels[0].imageUrl
                            : 'https://via.placeholder.com/150';
                        double rating = product.reviewOverviewModel.totalReviews > 0
                            ? product.reviewOverviewModel.ratingSum /
                            product.reviewOverviewModel.totalReviews
                            : 0.0;

                        return Container(
                          width: 180,
                          margin: EdgeInsets.symmetric(horizontal: 8),
                          child: Card(
                            elevation: 4,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Column(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(12),
                                  ),
                                  child: Image.network(
                                    imageUrl,
                                    height: 100,
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "QAR ${product.productPrice.price}",
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                            color: Colors.teal,
                                          ),
                                        ),
                                        Text(
                                          product.name,
                                          style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 14,
                                          ),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        Row(
                                          children: [
                                            Icon(Icons.star,
                                                size: 16, color: Colors.orange),
                                            SizedBox(width: 4),
                                            Text(
                                              rating.toStringAsFixed(1),
                                              style: TextStyle(fontSize: 12),
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          width: double.infinity,
                                          height: 40,
                                          child: ElevatedButton(
                                            onPressed: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) {
                                                    return AddToCartPage(
                                                      productId: product.id.toString(),
                                                      productName: product.name,
                                                      productPrice: double.tryParse(
                                                          product.productPrice.price) ??
                                                          0.0,
                                                      imageUrl: imageUrl,
                                                    );
                                                  },
                                                ),
                                              );
                                            },
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: Colors.teal,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                BorderRadius.circular(8),
                                              ),
                                            ),
                                            child: Text(
                                              "Add to Cart",
                                              style: TextStyle(color: Colors.white),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  )
                      : Center(child: Text("No products available")),

                  SizedBox(height: 20),

                  // Title for BazarPage
                  Padding(
                    padding: const EdgeInsets.only(left: 20.0),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "ABC Bazar",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),

                  // Flexible height for BazarPage
                  Container(
                    height: 500,
                    child: BazarPage(),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}