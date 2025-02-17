import 'dart:convert';
import 'dart:developer';
import 'package:customer/constant/constant.dart';
import 'package:customer/model/currency_model.dart';
import 'package:customer/model/language_model.dart';
import 'package:customer/model/user_model.dart';
import 'package:customer/services/localization_service.dart';
import 'package:customer/utils/Preferences.dart';
import 'package:customer/utils/fire_store_utils.dart';
import 'package:customer/utils/notification_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import '../preference/LoginDetailPreference.dart';

class GlobalSettingController extends GetxController {
  @override
  void onInit() {
    // TODO: implement onInit
    notificationInit();
    getCurrentCurrency();

    super.onInit();
  }
  Rx<LoginDetailPreference> loginDetailPreference = LoginDetailPreference().obs;
  Rx<UserModel> userModel = UserModel().obs;
  RxString currency = "".obs;

  getCurrentCurrency() async {
    if (Preferences.getString(Preferences.languageCodeKey).toString().isNotEmpty) {
      LanguageModel languageModel = Constant.getLanguage();
      LocalizationService().changeLocale(languageModel.code.toString());
    }
    if(Preferences.containsKey(LoginDetailPreference.USER_DETAIL) == true) {
      String userId = Preferences.getString(LoginDetailPreference.USER_DETAIL);
      UserModel? userModel = await FireStoreUtils.getUserProfile(userId);
      currency.value = userModel!.currency.toString();
      await FireStoreUtils().getCurrency(currency.value).then((value) {
        if (value != null) {
          Constant.currencyModel = value;
        } else {
          Constant.currencyModel = CurrencyModel(id: "", code: "PKR", decimalDigits: 2, enable: true, name: "Rupee", symbol: "Rs", symbolAtRight: false);
        }
      });
    }
    else{
      log('eterrrrr');
      Constant.currencyModel = CurrencyModel(id: "", code: "PKR", decimalDigits: 2, enable: true, name: "Rupee", symbol: "Rs", symbolAtRight: false);
    }
    


    await FireStoreUtils().getSettings();
  }

  NotificationService notificationService = NotificationService();

  notificationInit() {
    notificationService.initInfo().then((value) async {
      String token = await NotificationService.getToken();
      log(":::::::TOEN:::::: $token");
      if (FirebaseAuth.instance.currentUser != null) {
        await FireStoreUtils.getUserProfile(FireStoreUtils.getCurrentUid()).then((value) {
          if (value != null) {
            UserModel driverUserModel = value;
            driverUserModel.fcmToken = token;
            FireStoreUtils.updateUser(driverUserModel);
          }
        });
      }
    });
  }
}
