import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:login_page/pages/bazar%20pages/const.dart';

class AddToCartPage extends StatefulWidget {
  final String productId;
  final String productName;
  final double productPrice;
  final String imageUrl;

  const AddToCartPage({
    super.key,
    required this.productId,
    required this.productName,
    required this.productPrice,
    required this.imageUrl,
  });

  @override
  State<AddToCartPage> createState() => _AddToCartPageState();
}

class _AddToCartPageState extends State<AddToCartPage> {
  int quantity = 1;
  bool isLoading = false;
  int cartItemCount = 0;
  List cartItems = [];

  @override
  void initState() {
    super.initState();
    fetchCartData();
  }

  Future<void> fetchCartData() async {
    try {
      final response = await Dio().get(
        'https://test.nop-station.store/api/shoppingcart/cart/',
        options: Options(headers: {
          'deviceId': "44b4d8cd-7a2d-4a5f-a0e2-798021f1e294",
          'Content-Type': 'application/json',
          'User-Agent': 'nopstationcart.flutter/v1',
        }),
      );

      if (response.statusCode == 200) {
        final List items = response.data['Data']['Cart']['Items'] ?? [];
        int totalQuantity = items.fold(0, (sum, item) => sum + (item['Quantity'] ?? 0) as int);
        // int totalQuantity = items.length;

        setState(() {
          cartItemCount = totalQuantity;
          cartItems = items;
        });
      }
    } catch (e) {
      print("Error fetching cart data: $e");
    }
  }

Future<void> addToCart() async {
  final String url = '${EndPoint.base_url}/shoppingCart/addproducttocart/catalog/${widget.productId}/1';

  final Map<String, dynamic> requestBody = {
    "FormValues": [
      {
        "Key": "addtocart_${widget.productId}.EnteredQuantity",
        "Value": quantity.toString(),
      }
    ]
  };

  setState(() => isLoading = true);

  try {
    final response = await Dio().post(
      url,
      options: Options(headers: {
        'deviceId': "44b4d8cd-7a2d-4a5f-a0e2-798021f1e294",
        'Content-Type': 'application/json',
        'User-Agent': 'nopstationcart.flutter/v1',
      }),
      data: requestBody, 
    );

    print("Response Status Code: ${response.statusCode}");
    print("Response Data: ${response.data}");

    setState(() => isLoading = false);

    if (response.statusCode == 200 || response.statusCode == 201) {
      fetchCartData(); 
      showSuccessDialog();
    }else {
      showErrorDialog("Failed to add item to the cart: ${response.data}");
    }
  } catch (e) {
    setState(() => isLoading = false);
    print("Error: $e"); // Print error for debugging
    showErrorDialog("An error occurred. Please try again later. Error: $e");
  }
}

  void showCartItemsFullScreen() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.9,
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              const Text("Cart Items", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              Expanded(
                child: ListView.builder(
                  itemCount: cartItems.length,
                  itemBuilder: (context, index) {
                    final item = cartItems[index];
                    return ListTile(
                      leading: Image.network(
                        item['Picture']['ImageUrl'],
                        height: 50,
                        width: 50,
                        fit: BoxFit.cover,
                      ),
                      title: Text(item['ProductName']),
                      subtitle: Text("Qty: ${item['Quantity']} - ${item['UnitPrice']}"),
                    );
                  },
                ),
              ),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text(
                  "Close",
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                    ),
                  ),
              ),
            ],
          ),
        );
      },
    );
  }
void showSuccessDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Item Added"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.network(widget.imageUrl, height: 150, width: 150, fit: BoxFit.cover),
              const SizedBox(height: 10),
              Text("${widget.productName} - QAR ${widget.productPrice}"),
            ],
          ),
          actions: [
            FilledButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Close"),
            ),
          ],
        );
      },
    );
  }

  void showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Error"),
          content: Text(message),
          actions: [
            FilledButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Close"),
            ),
          ],
        );
      },
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Cart Details"),
        actions: [
                GestureDetector(
                onTap: () => showCartItemsFullScreen(), // Ensure modal opens
                child: Stack(
                  clipBehavior: Clip.none, // Ensures badge is positioned correctly
                  children: [
                    IconButton(
                      icon: const Icon(
                        Icons.shopping_cart,
                        size: 50,
                      ),
                      onPressed: () => showCartItemsFullScreen(), // Also added here for safety
                    ),
              if (cartItemCount > 0) // Show badge only if cart is not empty
                Positioned(
                  right: 4, // Adjust positioning
                  top: 4,
                  child: Container(
                    padding: const EdgeInsets.all(5),
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 20,
                      minHeight: 20,
                    ),
                    child: Text(
                      '$cartItemCount',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Image.network(widget.imageUrl, height: 150, width: 150, fit: BoxFit.cover),
            ),
            const SizedBox(height: 16),
            Text(widget.productName, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text("Price: QAR ${widget.productPrice}", style: const TextStyle(fontSize: 16, color: Colors.teal)),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Quantity:", style: TextStyle(fontSize: 16)),
                Row(
                  children: [
                    IconButton(
                      onPressed: quantity > 1 ? () => setState(() => quantity--) : null,
                      icon: const Icon(Icons.remove),
                    ),
                    Text("$quantity", style: const TextStyle(fontSize: 16)),
                    IconButton(
                      onPressed: () => setState(() => quantity++),
                      icon: const Icon(Icons.add),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
                child: ElevatedButton(
                  onPressed: isLoading ? null : addToCart,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green, // Corrected
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                          "Proceed to Checkout",
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
