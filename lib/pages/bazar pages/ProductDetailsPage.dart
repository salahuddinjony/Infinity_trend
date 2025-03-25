import 'package:flutter/material.dart';

class ProductDetailsPage extends StatelessWidget {
  final Map<String, dynamic> product;

  const ProductDetailsPage({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(product['title'])),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Image.network(
                product['thumbnail'],
                height: 200,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              product['title'],
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              "QAR ${product['price']}",
              style: const TextStyle(fontSize: 18, color: Colors.teal),
            ),
            const SizedBox(height: 16),
            Text(
              product['description'] ?? "No description available",
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context); // Go back to the previous screen
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 12),
                  backgroundColor: Colors.green,
                ),
                child: const Text(
                  "Back",
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}