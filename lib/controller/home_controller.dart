import 'dart:convert';

import 'package:customer/constant/constant.dart';
import 'package:customer/controller/dash_board_controller.dart';
import 'package:customer/model/airport_model.dart';
import 'package:customer/model/banner_model.dart';
import 'package:customer/model/contact_model.dart';
import 'package:customer/model/order/location_lat_lng.dart';
import 'package:customer/model/payment_model.dart';
import 'package:customer/model/service_model.dart';
import 'package:customer/themes/app_colors.dart';
import 'package:customer/utils/Preferences.dart';
import 'package:customer/utils/fire_store_utils.dart';
import 'package:customer/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

import '../services/currency_converter.dart';


class HomeController extends GetxController {
  DashBoardController dashboardController = Get.put(DashBoardController());

  Rx<TextEditingController> sourceLocationController = TextEditingController().obs;
  Rx<TextEditingController> destinationLocationController = TextEditingController().obs;
  Rx<TextEditingController> offerYourRateController = TextEditingController().obs;
  Rx<ServiceModel> selectedType = ServiceModel().obs;
  RxBool preferFemaleDriver = false.obs;

  Rx<LocationLatLng> sourceLocationLAtLng = LocationLatLng().obs;
  Rx<LocationLatLng> destinationLocationLAtLng = LocationLatLng().obs;
  Rx<LatLng> originCurrentLocationLAtLng = const LatLng(0, 0).obs;
  Rx<LatLng> stopCurrentLocationLAtLng = const LatLng(0, 0).obs;

  RxString currentLocation = "".obs;
  RxBool isLoading = true.obs;
  RxList serviceList = <ServiceModel>[].obs;
  RxList bannerList = <BannerModel>[].obs;
  final PageController pageController = PageController(viewportFraction: 0.96, keepPage: true);

  var colors = [
    AppColors.serviceColor1,
    AppColors.serviceColor2,
    AppColors.serviceColor3,
  ];

  @override
  void onInit() {
    // TODO: implement onInit
    getServiceType();
    getPaymentData();
    getContact();
    getCurrentLocation();
    super.onInit();
  }

  Future<void> getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Check if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled, don't continue
      return;
    }

    // Check for location permissions
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever

      return;
    }
    // 594147
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    originCurrentLocationLAtLng.value =  LatLng(position.latitude, position.longitude);
    stopCurrentLocationLAtLng.value =  LatLng(position.latitude, position.longitude);
  }

  getServiceType() async {
    await FireStoreUtils.getService().then((value) {
      serviceList.value = value;
      if (serviceList.isNotEmpty) {
        selectedType.value = serviceList.first;
      }
    });

    await FireStoreUtils.getBanner().then((value) {
      bannerList.value = value;
    });

    isLoading.value = false;

    await Utils.getCurrentLocation().then((value) {
      Constant.currentLocation = value;
    });
    await placemarkFromCoordinates(Constant.currentLocation!.latitude, Constant.currentLocation!.longitude).then((value) {
      Placemark placeMark = value[0];

      currentLocation.value = "${placeMark.name} ${placeMark.subLocality} ${placeMark.locality} ${placeMark.administrativeArea} ${placeMark.postalCode} ${placeMark.country}";
    }).catchError((error) {
      debugPrint("------>${error.toString()}");
    });
  }

  RxString duration = "".obs;
  RxString distance = "".obs;
  RxString amount = "".obs;

  calculateAmount() async {
    if (sourceLocationLAtLng.value.latitude != null && destinationLocationLAtLng.value.latitude != null) {
      await Constant.getDurationDistance(
          LatLng(sourceLocationLAtLng.value.latitude!, sourceLocationLAtLng.value.longitude!),
          LatLng(destinationLocationLAtLng.value.latitude!, destinationLocationLAtLng.value.longitude!)
      ).then((value) async {
        if (value != null) {
          duration.value = value.rows!.first.elements!.first.duration!.text.toString();
          if (Constant.distanceType == "Km") {
            distance.value = (value.rows!.first.elements!.first.distance!.value!.toInt() / 1000).toString();
          } else {
            distance.value = (value.rows!.first.elements!.first.distance!.value!.toInt() / 1609.34).toString();
          }

          // Update conversion rates before calculating the amount
          CurrencyConverter currencyConverter = CurrencyConverter();

          // Get the km charge based on selected type
          double baseAmount = double.parse(selectedType.value.kmCharge.toString());

          // Apply currency conversion based on the currency code
          double conversionRate = await currencyConverter.updateConversionRates(Constant.currencyModel!.code!);

          // Calculate the final amount using distance and conversion rate
          double finalAmount = baseAmount * double.parse(distance.value) * conversionRate;

          amount.value = finalAmount.toStringAsFixed(Constant.currencyModel!.decimalDigits!);
        }
      });
    }
  }


  // calculateAmount() async {
  //   if (sourceLocationLAtLng.value.latitude != null && destinationLocationLAtLng.value.latitude != null) {
  //     await Constant.getDurationDistance(
  //             LatLng(sourceLocationLAtLng.value.latitude!, sourceLocationLAtLng.value.longitude!), LatLng(destinationLocationLAtLng.value.latitude!, destinationLocationLAtLng.value.longitude!))
  //         .then((value) {
  //       if (value != null) {
  //         duration.value = value.rows!.first.elements!.first.duration!.text.toString();
  //         if (Constant.distanceType == "Km") {
  //           distance.value = (value.rows!.first.elements!.first.distance!.value!.toInt() / 1000).toString();
  //           amount.value = Constant.amountCalculate(selectedType.value.kmCharge.toString(), distance.value).toStringAsFixed(Constant.currencyModel!.decimalDigits!);
  //         } else {
  //           distance.value = (value.rows!.first.elements!.first.distance!.value!.toInt() / 1609.34).toString();
  //           amount.value = Constant.amountCalculate(selectedType.value.kmCharge.toString(), distance.value).toStringAsFixed(Constant.currencyModel!.decimalDigits!);
  //         }
  //       }
  //     });
  //   }
  // }

  Rx<PaymentModel> paymentModel = PaymentModel().obs;

  RxString selectedPaymentMethod = "".obs;

  RxList airPortList = <AriPortModel>[].obs;

  getPaymentData() async {
    await FireStoreUtils().getPayment().then((value) {
      if (value != null) {
        paymentModel.value = value;
      }
    });
  }

  RxList<ContactModel> contactList = <ContactModel>[].obs;
  Rx<ContactModel> selectedTakingRide = ContactModel(fullName: "Myself", contactNumber: "").obs;
  Rx<AriPortModel> selectedAirPort = AriPortModel().obs;

  setContact() {
    print(jsonEncode(contactList));
    Preferences.setString(Preferences.contactList, json.encode(contactList.map<Map<String, dynamic>>((music) => music.toJson()).toList()));
    getContact();
  }

  getContact() {
    String contactListJson = Preferences.getString(Preferences.contactList);

    if (contactListJson.isNotEmpty) {
      print("---->");
      contactList.clear();
      contactList.value = (json.decode(contactListJson) as List<dynamic>).map<ContactModel>((item) => ContactModel.fromJson(item)).toList();
    }
  }
}
