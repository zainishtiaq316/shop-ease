class CartModel {
  final String productId;
  final String categoryId;
  final String productName;
  final String categoryName;
  final String salePrice;
  final String fullPrice;
  final List productImages;
  final String deliveryTime;
  final bool isSale;
  final String productDescription;
  final dynamic createdAt;
  final dynamic updatedAt;
  final int productQuantity;
  final double productTotalPrice;

  CartModel(
      {required this.categoryId,
      required this.categoryName,
      required this.createdAt,
      required this.deliveryTime,
      required this.fullPrice,
      required this.isSale,
      required this.productDescription,
      required this.productId,
      required this.productImages,
      required this.productName,
      required this.productQuantity,
      required this.productTotalPrice,
      required this.salePrice,
      required this.updatedAt});

  Map<String, dynamic> toMap() {
    return {
      'productId': productId,
      'categoryId': categoryId,
      'productName': productName,
      'categoryName': categoryName,
      'salePrice': salePrice,
      'fullPrice': fullPrice,
      'productImages': productImages,
      'deliveryTime': deliveryTime,
      'isSale': isSale,
      'productDescription': productDescription,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'productTotalPrice': productTotalPrice,
      'productQuantity': productQuantity,
    };
  }

  factory CartModel.fromMap(Map<String, dynamic> json) {
    return CartModel(
        categoryId: json["categoryId"],
        categoryName: json["categoryName"],
        createdAt: json["createdAt"],
        deliveryTime: json["deliveryTime"],
        fullPrice: json["fullPrice"],
        isSale: json["isSale"],
        productDescription: json["productDescription"],
        productId: json["productId"],
        productImages: json["productImages"],
        productName: json["productName"],
        productQuantity: json["productQuantity"],
        productTotalPrice: json["productTotalPrice"],
        salePrice: json["salePrice"],
        updatedAt: json["updatedAt"]);
  }
}
