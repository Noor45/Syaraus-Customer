import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String? fullName;
  String? id;
  String? email;
  String? loginType;
  String? profilePic;
  String? fcmToken;
  String? countryCode;
  String? currency;
  String? gender;
  String? phoneNumber;
  String? reviewsCount;
  String? reviewsSum;
  String? walletAmount;
  bool? isActive;
  Timestamp? createdAt;

  UserModel(
      {this.fullName, this.id, this.email, this.loginType, this.gender, this.profilePic, this.fcmToken, this.countryCode, this.phoneNumber, this.reviewsCount, this.reviewsSum, this.isActive, this.walletAmount, this.createdAt, this.currency});

  UserModel.fromJson(Map<String, dynamic> json) {
    fullName = json['fullName'];
    id = json['id'];
    email = json['email'];
    gender = json['gender'];
    loginType = json['loginType'];
    profilePic = json['profilePic'];
    fcmToken = json['fcmToken'];
    countryCode = json['countryCode'];
    currency = json['currency'];
    phoneNumber = json['phoneNumber'];
    reviewsCount = json['reviewsCount'] ?? "0.0";
    reviewsSum = json['reviewsSum'] ?? "0.0";
    isActive = json['isActive'];
    walletAmount = json['walletAmount'] ?? "0";
    createdAt = json['createdAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['fullName'] = fullName;
    data['id'] = id;
    data['email'] = email;
    data['gender'] = gender;
    data['loginType'] = loginType;
    data['profilePic'] = profilePic;
    data['fcmToken'] = fcmToken;
    data['countryCode'] = countryCode;
    data['currency'] = currency;
    data['phoneNumber'] = phoneNumber;
    data['reviewsCount'] = reviewsCount;
    data['reviewsSum'] = reviewsSum;
    data['isActive'] = isActive;
    data['walletAmount'] = walletAmount;
    data['createdAt'] = createdAt;
    return data;
  }
}
