class UserModel {
  final String uid;
  final String firstName;
  final String lastName;
  final String email;
  final String phone;
  final String userImg;
  final String userDeviceToken;
  final String country;
  final String userAddress;
  final String street;
  final String Gender;
  late bool isOnline;
  late String lastActive;
  final String language;
  final String dateOfBirth;
  final bool isAdmin;
  final bool isActive;
  final String city;
  final dynamic createdOn;
  final dynamic updatedOn;
  final dynamic joinedTime;
  final dynamic updatedTime;
  UserModel(
      {required this.Gender,
      required this.isOnline,
      required this.lastActive,
      required this.dateOfBirth,
      required this.language,
      required this.updatedOn,
      required this.updatedTime,
      required this.joinedTime,
      required this.country,
      required this.createdOn,
      required this.email,
      required this.city,
      required this.isAdmin,
      required this.isActive,
      required this.phone,
      required this.lastName,
      required this.street,
      required this.uid,
      required this.userAddress,
      required this.userDeviceToken,
      required this.userImg,
      required this.firstName});

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'phone': phone,
      'language': language,
      'gender': Gender,
      'dateOfBirth': dateOfBirth,
      'is_online': isOnline,
      'userImg': userImg,
      'joinedTime': joinedTime,
      'userDeviceToken': userDeviceToken,
      'country': country,
      'userAddress': userAddress,
      'street': street,
      'city': city,
      'last_active': lastActive,
      'isAdmin': isAdmin,
      'isActive': isActive,
      'createdOn': createdOn,
      'updatedOn': updatedOn,
      'updatedTime': updatedTime,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> json) {
    return UserModel(
        country: json['country'],
        createdOn: json['createdOn'],
        city: json['city'],
        Gender: json['gender'],
        language: json['language'],
        email: json['email'],
        dateOfBirth: json['dateOfBirth'],
        isAdmin: json['isAdmin'],
        isActive: json['isActive'],
        phone: json['phone'],
        lastActive: json['last_active'],
        street: json['street'],
        uid: json['uid'],
        isOnline: json['is_online'],
        updatedOn: json['updatedOn'],
        userAddress: json['userAddress'],
        userDeviceToken: json['userDeviceToken'],
        userImg: json['userImg'],
        firstName: json['firstName'],
        updatedTime: json['updatedTime'],
        joinedTime: json['joinedTime'],
        lastName: json['lastName']);
  }
}
