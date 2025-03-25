class FeatureProduct {
  List<Datum> data;
  dynamic message;
  List<dynamic> errorList;

  FeatureProduct({
    required this.data,
    required this.message,
    required this.errorList,
  });

  factory FeatureProduct.fromJson(Map<String, dynamic> json) => FeatureProduct(
    data: List<Datum>.from(json["Data"].map((x) => Datum.fromJson(x))),
    message: json["Message"],
    errorList: List<dynamic>.from(json["ErrorList"].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "Data": List<dynamic>.from(data.map((x) => x.toJson())),
    "Message": message,
    "ErrorList": List<dynamic>.from(errorList.map((x) => x)),
  };
}

class Datum {
  String name;
  String shortDescription;
  String fullDescription;
  String seName;
  String sku;
  int productType;
  bool markAsNew;
  ProductPrice productPrice;
  List<PictureModel> pictureModels;
  ProductSpecificationModel productSpecificationModel;
  ReviewOverviewModel reviewOverviewModel;
  int id;
  CustomProperties customProperties;

  Datum({
    
    required this.name,
    required this.shortDescription,
    required this.fullDescription,
    required this.seName,
    required this.sku,
    required this.productType,
    required this.markAsNew,
    required this.productPrice,
    required this.pictureModels,
    required this.productSpecificationModel,
    required this.reviewOverviewModel,
    required this.id,
    required this.customProperties,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    name: json["Name"],
    shortDescription: json["ShortDescription"],
    fullDescription: json["FullDescription"],
    seName: json["SeName"],
    sku: json["Sku"],
    productType: json["ProductType"],
    markAsNew: json["MarkAsNew"],
    productPrice: ProductPrice.fromJson(json["ProductPrice"]),
    pictureModels: List<PictureModel>.from(json["PictureModels"].map((x) => PictureModel.fromJson(x))),
    productSpecificationModel: ProductSpecificationModel.fromJson(json["ProductSpecificationModel"]),
    reviewOverviewModel: ReviewOverviewModel.fromJson(json["ReviewOverviewModel"]),
    id: json["Id"],
    customProperties: CustomProperties.fromJson(json["CustomProperties"]),
  );

  get price => null;

  String? get imageUrl => null;

  get rating => null;

  Map<String, dynamic> toJson() => {
    "Name": name,
    "ShortDescription": shortDescription,
    "FullDescription": fullDescription,
    "SeName": seName,
    "Sku": sku,
    "ProductType": productType,
    "MarkAsNew": markAsNew,
    "ProductPrice": productPrice.toJson(),
    "PictureModels": List<dynamic>.from(pictureModels.map((x) => x.toJson())),
    "ProductSpecificationModel": productSpecificationModel.toJson(),
    "ReviewOverviewModel": reviewOverviewModel.toJson(),
    "Id": id,
    "CustomProperties": customProperties.toJson(),
  };
}

class CustomProperties {
  CustomProperties();

  factory CustomProperties.fromJson(Map<String, dynamic> json) => CustomProperties(
  );

  Map<String, dynamic> toJson() => {
  };
}

class PictureModel {
  String imageUrl;
  dynamic thumbImageUrl;
  String fullSizeImageUrl;
  String title;
  String alternateText;
  int id;
  CustomProperties customProperties;

  PictureModel({
    required this.imageUrl,
    required this.thumbImageUrl,
    required this.fullSizeImageUrl,
    required this.title,
    required this.alternateText,
    required this.id,
    required this.customProperties,
  });

  factory PictureModel.fromJson(Map<String, dynamic> json) => PictureModel(
    imageUrl: json["ImageUrl"],
    thumbImageUrl: json["ThumbImageUrl"],
    fullSizeImageUrl: json["FullSizeImageUrl"],
    title: json["Title"],
    alternateText: json["AlternateText"],
    id: json["Id"],
    customProperties: CustomProperties.fromJson(json["CustomProperties"]),
  );

  Map<String, dynamic> toJson() => {
    "ImageUrl": imageUrl,
    "ThumbImageUrl": thumbImageUrl,
    "FullSizeImageUrl": fullSizeImageUrl,
    "Title": title,
    "AlternateText": alternateText,
    "Id": id,
    "CustomProperties": customProperties.toJson(),
  };
}

class ProductPrice {
  dynamic oldPrice;
  dynamic oldPriceValue;
  String price;
  double priceValue;
  dynamic basePricePAngV;
  double basePricePAngVValue;
  bool disableBuyButton;
  bool disableWishlistButton;
  bool disableAddToCompareListButton;
  bool availableForPreOrder;
  dynamic preOrderAvailabilityStartDateTimeUtc;
  bool isRental;
  bool forceRedirectionAfterAddingToCart;
  bool displayTaxShippingInfo;
  String currencyCode;
  dynamic priceWithDiscount;
  dynamic priceWithDiscountValue;
  bool customerEntersPrice;
  bool callForPrice;
  int productId;
  bool hidePrices;
  dynamic rentalPrice;
  dynamic rentalPriceValue;
  CustomProperties customProperties;

  ProductPrice({
    required this.oldPrice,
    required this.oldPriceValue,
    required this.price,
    required this.priceValue,
    required this.basePricePAngV,
    required this.basePricePAngVValue,
    required this.disableBuyButton,
    required this.disableWishlistButton,
    required this.disableAddToCompareListButton,
    required this.availableForPreOrder,
    required this.preOrderAvailabilityStartDateTimeUtc,
    required this.isRental,
    required this.forceRedirectionAfterAddingToCart,
    required this.displayTaxShippingInfo,
    required this.currencyCode,
    required this.priceWithDiscount,
    required this.priceWithDiscountValue,
    required this.customerEntersPrice,
    required this.callForPrice,
    required this.productId,
    required this.hidePrices,
    required this.rentalPrice,
    required this.rentalPriceValue,
    required this.customProperties,
  });

  factory ProductPrice.fromJson(Map<String, dynamic> json) => ProductPrice(
    oldPrice: json["OldPrice"],
    oldPriceValue: json["OldPriceValue"],
    price: json["Price"],
    priceValue: json["PriceValue"],
    basePricePAngV: json["BasePricePAngV"],
    basePricePAngVValue: json["BasePricePAngVValue"],
    disableBuyButton: json["DisableBuyButton"],
    disableWishlistButton: json["DisableWishlistButton"],
    disableAddToCompareListButton: json["DisableAddToCompareListButton"],
    availableForPreOrder: json["AvailableForPreOrder"],
    preOrderAvailabilityStartDateTimeUtc: json["PreOrderAvailabilityStartDateTimeUtc"],
    isRental: json["IsRental"],
    forceRedirectionAfterAddingToCart: json["ForceRedirectionAfterAddingToCart"],
    displayTaxShippingInfo: json["DisplayTaxShippingInfo"],
    currencyCode: json["CurrencyCode"],
    priceWithDiscount: json["PriceWithDiscount"],
    priceWithDiscountValue: json["PriceWithDiscountValue"],
    customerEntersPrice: json["CustomerEntersPrice"],
    callForPrice: json["CallForPrice"],
    productId: json["ProductId"],
    hidePrices: json["HidePrices"],
    rentalPrice: json["RentalPrice"],
    rentalPriceValue: json["RentalPriceValue"],
    customProperties: CustomProperties.fromJson(json["CustomProperties"]),
  );

  Map<String, dynamic> toJson() => {
    "OldPrice": oldPrice,
    "OldPriceValue": oldPriceValue,
    "Price": price,
    "PriceValue": priceValue,
    "BasePricePAngV": basePricePAngV,
    "BasePricePAngVValue": basePricePAngVValue,
    "DisableBuyButton": disableBuyButton,
    "DisableWishlistButton": disableWishlistButton,
    "DisableAddToCompareListButton": disableAddToCompareListButton,
    "AvailableForPreOrder": availableForPreOrder,
    "PreOrderAvailabilityStartDateTimeUtc": preOrderAvailabilityStartDateTimeUtc,
    "IsRental": isRental,
    "ForceRedirectionAfterAddingToCart": forceRedirectionAfterAddingToCart,
    "DisplayTaxShippingInfo": displayTaxShippingInfo,
    "CurrencyCode": currencyCode,
    "PriceWithDiscount": priceWithDiscount,
    "PriceWithDiscountValue": priceWithDiscountValue,
    "CustomerEntersPrice": customerEntersPrice,
    "CallForPrice": callForPrice,
    "ProductId": productId,
    "HidePrices": hidePrices,
    "RentalPrice": rentalPrice,
    "RentalPriceValue": rentalPriceValue,
    "CustomProperties": customProperties.toJson(),
  };
}

class ProductSpecificationModel {
  List<dynamic> groups;
  CustomProperties customProperties;

  ProductSpecificationModel({
    required this.groups,
    required this.customProperties,
  });

  factory ProductSpecificationModel.fromJson(Map<String, dynamic> json) => ProductSpecificationModel(
    groups: List<dynamic>.from(json["Groups"].map((x) => x)),
    customProperties: CustomProperties.fromJson(json["CustomProperties"]),
  );

  get pictureModels => null;

  String? get name => null;

  get productPrice => null;

  Map<String, dynamic> toJson() => {
    "Groups": List<dynamic>.from(groups.map((x) => x)),
    "CustomProperties": customProperties.toJson(),
  };
}

class ReviewOverviewModel {
  int productId;
  int ratingSum;
  int totalReviews;
  bool allowCustomerReviews;
  bool canAddNewReview;
  bool canCurrentCustomerLeaveReview;
  CustomProperties customProperties;

  ReviewOverviewModel({
    required this.productId,
    required this.ratingSum,
    required this.totalReviews,
    required this.allowCustomerReviews,
    required this.canAddNewReview,
    required this.canCurrentCustomerLeaveReview,
    required this.customProperties,
  });

  factory ReviewOverviewModel.fromJson(Map<String, dynamic> json) => ReviewOverviewModel(
    productId: json["ProductId"],
    ratingSum: json["RatingSum"],
    totalReviews: json["TotalReviews"],
    allowCustomerReviews: json["AllowCustomerReviews"],
    canAddNewReview: json["CanAddNewReview"],
    canCurrentCustomerLeaveReview: json["CanCurrentCustomerLeaveReview"],
    customProperties: CustomProperties.fromJson(json["CustomProperties"]),
  );

  Map<String, dynamic> toJson() => {
    "ProductId": productId,
    "RatingSum": ratingSum,
    "TotalReviews": totalReviews,
    "AllowCustomerReviews": allowCustomerReviews,
    "CanAddNewReview": canAddNewReview,
    "CanCurrentCustomerLeaveReview": canCurrentCustomerLeaveReview,
    "CustomProperties": customProperties.toJson(),
  };
}
