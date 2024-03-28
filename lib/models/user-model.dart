class UserModel{
  final String uid;
  final String username;
  final String email;
  final String phone;
  final String userImg;
  final String userDeviceToken;
  final String country;
  final String userAddress;
  final String street;
  final bool isAdmin;
  final bool isActive;
  final String city;
  final dynamic createdOn;
  UserModel({
    required this.country,
    required this.createdOn, required this.email, required this.city, required this.isAdmin, required this.isActive, required this.phone, required this.street, required this.uid, required this.userAddress, required this.userDeviceToken, required this.userImg, required this.username
  });

  Map<String, dynamic> toMap(){
    return{
     'uid' : uid,
     'username' : username,
     'email' : email,
     'phone': phone,
     'userImg' : userImg,
     'userDeviceToken' : userDeviceToken,
     'country': country,
     'userAddress': userAddress,
     'street':street,
     'city' : city,
     'isAdmin': isAdmin,
     'isActive':isActive,
     'createdOn':createdOn
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> json){
    return UserModel(country: json['uid'], createdOn: json['createdOn'],   city : json['city'],email: json['email'], isAdmin: json['isAdmin'], isActive: json['isActive'], phone: json['phone'], street: json['street'], uid: json['uid'], userAddress: json['userAddress'], userDeviceToken: json['userDeviceToken'], userImg: json['userImg'], username: json['username']);
  }
  
}