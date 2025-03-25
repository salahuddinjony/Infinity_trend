
import 'package:login_page/pages/bazar%20pages/const.dart';
import 'package:login_page/services/api_service.dart';

import '../../models/feature_product.dart';

class HomeScreenRepository{

  ApiBaseHelper _helper = ApiBaseHelper();

  Future<FeatureProduct> fetchFeatureList() async {
  final response = await _helper.get(EndPoint.feature);
  return FeatureProduct.fromJson(response);  
  }
}