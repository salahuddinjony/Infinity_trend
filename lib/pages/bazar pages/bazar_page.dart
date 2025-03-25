import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:login_page/pages/bazar%20pages/ProductDetailsPage.dart';

class BazarPage extends StatefulWidget {
  const BazarPage({super.key});

  @override
  State<BazarPage> createState() => _BazarPageState();
}

class _BazarPageState extends State<BazarPage> {
  List<dynamic> jsonList = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    getData();
  }

  Future<void> getData() async {
    try {
      var response = await Dio().get('https://dummyjson.com/products');

      if (response.statusCode == 200) {
        setState(() {
          jsonList = response.data['products'];
          isLoading = false;
        });
      } else {
        throw Exception("Data can't be fetched!");
      }
    } on DioException catch (e) {
      print("DioError: ${e.message}, Response: ${e.response?.statusCode}");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Network error: ${e.message}")),
      );
      setState(() {
        isLoading = false;
      });
    } catch (e) {
      print("Error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Something went wrong!")),
      );
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const Center(child: CircularProgressIndicator())
        : jsonList.isEmpty
        ? const Center(child: Text("Data Not Available!"))
        : Padding(
      padding: const EdgeInsets.all(10.0),
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 10,
          childAspectRatio: 0.8,
        ),
        itemCount: jsonList.length,
        itemBuilder: (context, index) {
          var product = jsonList[index];

          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProductDetailsPage(product: product),
                ),
              );
            },
            child: Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: ClipRRect(
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
                      child: Image.network(
                        product['thumbnail'],
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Text(
                          product['title'],
                          style: const TextStyle(fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 5),
                        Text(
                          "QAR ${product['price']}",
                          style: const TextStyle(color: Colors.teal),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}