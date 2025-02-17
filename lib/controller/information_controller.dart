import 'dart:convert';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:customer/constant/constant.dart';
import 'package:customer/model/user_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../model/currency_model.dart';
import '../preference/LoginDetailPreference.dart';
import '../utils/fire_store_utils.dart';

class InformationController extends GetxController {
  LoginDetailPreference loginDetailPreference = LoginDetailPreference();
  Rx<TextEditingController> fullNameController = TextEditingController().obs;
  Rx<TextEditingController> emailController = TextEditingController().obs;
  Rx<TextEditingController> phoneNumberController = TextEditingController().obs;
  Rx<TextEditingController> referralCodeController = TextEditingController().obs;
  Rx<String> selectedGender = "".obs;
  List<String> genderList = <String>['Male', 'Female'].obs;
  RxString countryCode = "+1".obs;
  RxString region = "".obs;
  Rx<String> selectedRegion = "".obs;
  List<String> regionList = <String>['Pakistan', 'UAE', 'UK', 'USA',].obs;
  RxString loginType = "".obs;

  @override
  void onInit() {
    getArgument();
    super.onInit();
  }

  Rx<UserModel> userModel = UserModel().obs;

  getArgument() async {
    dynamic argumentData = Get.arguments;
    if (argumentData != null) {
      userModel.value = argumentData['userModel'];
      loginType.value = userModel.value.loginType.toString();
      if (loginType.value == Constant.phoneLoginType) {
        phoneNumberController.value.text = userModel.value.phoneNumber.toString();
        countryCode.value = userModel.value.countryCode.toString();
      } else {
        emailController.value.text = userModel.value.email.toString();
        fullNameController.value.text = userModel.value.fullName.toString();
      }
      log("------->${loginType.value}");
    }
    update();
  }


  String customJsonEncode(Map<String, dynamic> data) {
    return jsonEncode(data, toEncodable: (object) {
      if (object is Timestamp) {
        return object.toDate().toIso8601String();
      }

      return object;
    });
  }

  assignCurrency(String currency) async {
    await FireStoreUtils().getCurrency(currency).then((value) {
      if (value != null) {
        Constant.currencyModel = value;
      } else {
        Constant.currencyModel = CurrencyModel(id: "", code: "PKR", decimalDigits: 2, enable: true, name: "Rupee", symbol: "Rs", symbolAtRight: false);
      }
    });
  }
}
