class CategoriesModel {
  final String categoryId;
  final String categoryName;
  final String categoryImg;

  final dynamic createdAt;
  final dynamic updatedAt;
  CategoriesModel(
      {required this.updatedAt,
      required this.createdAt,
      required this.categoryId,
      required this.categoryImg,
      required this.categoryName});

  Map<String, dynamic> toMap() {
    return {
      'categoryId': categoryId,
      'categoryName': categoryName,
      'categoryImg': categoryImg,
      'createdAt': createdAt,
      'updatedAt': updatedAt
    };
  }

  factory CategoriesModel.fromMap(Map<String, dynamic> json) {
    return CategoriesModel(
        createdAt: json['createdAt'],
        updatedAt: json['updatedAt'],
        categoryId: json['categoryId'],
        categoryImg: json['categoryImg'],
        categoryName: json['categoryName']);
  }
}
