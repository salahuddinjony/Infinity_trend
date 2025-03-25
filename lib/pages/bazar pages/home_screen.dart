
import 'package:flutter/material.dart';
import 'package:login_page/services/apiResponse.dart';
import '../../models/feature_product.dart';
import 'home_screen_controller.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late HomeScreenController _bloc;
  @override
  void initState() {
    _bloc=HomeScreenController();
    _bloc.fetchFeaturedProduct();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Home Screen"),),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: StreamBuilder<ApiResponse<FeatureProduct>>(
          stream: _bloc.featureProductStream,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              switch (snapshot.data!.status) {
                case Status.LOADING:
                  return Container(
                    width: double.infinity,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator()
                      ],
                    ),
                  );
                case Status.COMPLETED:
                  return Container(
                    width: double.infinity,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: snapshot.data!.data!.data.map((el)=>Text(el.sku,style: TextStyle(fontSize: 17),)).toList(),
                    ),
                  );
                case Status.ERROR:
                  return Text("error");
                default:
                  return SizedBox.shrink();
              }
            }
            return SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
