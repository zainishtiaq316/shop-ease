class OrderModel {
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
  final String customerId;
  final bool status;
  final String customerName;
  final String customerPhone;
  final String customerStreet;
  final String customerCity;
  final String customerCountry;
  final String customerZipCode;
  final String customerDeviceToken;

  final String customerAddress;
  final String paymentMethod;
  final bool paymentStatus;

  OrderModel(
      {required this.categoryId,
      required this.categoryName,
      required this.createdAt,
      required this.deliveryTime,
      required this.fullPrice,
      required this.isSale,
      required this.customerAddress,
      required this.paymentMethod,
      required this.paymentStatus,
      required this.productDescription,
      required this.productId,
      required this.productImages,
      required this.productName,
      required this.productQuantity,
      required this.productTotalPrice,
      required this.salePrice,
      required this.customerStreet,
      required this.customerDeviceToken,
      required this.customerId,
      required this.customerCity,
      required this.customerCountry,
      required this.customerName,
      required this.customerPhone,
      required this.status,
      required this.customerZipCode,
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
      'customerId': customerId,
      'status': status,
      'customerName': customerName,
      'customerPhone': customerPhone,
      'customerCountry' : customerCountry,
      'customerStreet': customerStreet,
      'customerCity' : customerCity,
      'customerZipCode' : customerZipCode,
      'customerAddress' : customerAddress,
      'paymentMethod' : paymentMethod,
      'paymentStatus' : paymentStatus,
      'customerDeviceToken': customerDeviceToken
    };
  }

  factory OrderModel.fromMap(Map<String, dynamic> json) {
    return OrderModel(
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
        updatedAt: json["updatedAt"],
        customerId: json['customerId'],
        status: json['status'],
        customerCountry : json['customerCountry'],
        customerCity : json['customerCity'],
        customerName: json['customerName'],
        customerPhone: json['customerPhone'],
        customerStreet: json['customerStreet'],
        customerZipCode : json['customerZipCode'],
        customerAddress :json['customerAddress'],
        paymentMethod : json['paymentMethod'],
        paymentStatus : json['paymentStatus'],
        customerDeviceToken: json['customerDeviceToken']);
  }
}
