import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:customer/constant/constant.dart';
import 'package:customer/constant/show_toast_dialog.dart';
import 'package:customer/controller/login_controller.dart';
import 'package:customer/model/user_model.dart';
import 'package:customer/themes/app_colors.dart';
import 'package:customer/themes/button_them.dart';
import 'package:customer/themes/responsive.dart';
import 'package:customer/ui/auth_screen/information_screen.dart';
import 'package:customer/ui/dashboard_screen.dart';
import 'package:customer/ui/terms_and_condition/terms_and_condition_screen.dart';
import 'package:customer/utils/DarkThemeProvider.dart';
import 'package:customer/utils/fire_store_utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return GetX<LoginController>(
        init: LoginController(),
        builder: (controller) {
          return Scaffold(
            backgroundColor: Theme.of(context).colorScheme.background,
            body: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.asset("assets/images/login_image.png", width: Responsive.width(100, context)),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: Text("Login".tr, style: GoogleFonts.inter(fontWeight: FontWeight.w600, fontSize: 18)),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 5),
                          child: Text("Welcome Back! We are happy to have \n you back".tr, style: GoogleFonts.inter(fontWeight: FontWeight.w400)),
                        ),
                        const SizedBox(
                          height: 20,
                        ),

                        TextFormField(
                          validator: (value) => value != null && value.isNotEmpty ? null : 'Required',
                          keyboardType: TextInputType.number,
                          textCapitalization: TextCapitalization.sentences,
                          controller: controller.phoneNumberController.value,
                          textAlign: TextAlign.start,
                          style: GoogleFonts.inter(
                            color: themeChange.getThem() ? Colors.white : Colors.black,
                          ),
                          decoration: InputDecoration(
                            isDense: true,
                            filled: true,
                            fillColor: themeChange.getThem()
                                ? AppColors.darkTextField
                                : AppColors.textField,
                            contentPadding: const EdgeInsets.symmetric(vertical: 12),
                            prefixIcon: Padding(
                              padding: const EdgeInsets.only(left: 10.0), // Adds padding to the right of the prefix icon
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<String>(
                                  value: controller.countryCode.value,
                                  items: [
                                    DropdownMenuItem(
                                      value: '+44',
                                      child: Padding(
                                        padding: const EdgeInsets.only(right: 8.0, left: 8.0), // Adds padding inside the dropdown items
                                        child: Text('🇬🇧 +44'),
                                      ),
                                    ),
                                    DropdownMenuItem(
                                      value: '+1',
                                      child: Padding(
                                        padding: const EdgeInsets.only(right: 8.0, left: 8.0),
                                        child: Text('🇺🇸 +1'),
                                      ),
                                    ),
                                    DropdownMenuItem(
                                      value: '+971',
                                      child: Padding(
                                        padding: const EdgeInsets.only(right: 8.0, left: 8.0),
                                        child: Text('🇦🇪 +971'),
                                      ),
                                    ),
                                    DropdownMenuItem(
                                      value: '+92',
                                      child: Padding(
                                        padding: const EdgeInsets.only(right: 8.0, left: 8.0),
                                        child: Text('🇵🇰 +92'),
                                      ),
                                    ),
                                  ],
                                  onChanged: (value) {
                                    if (value != null) {
                                      controller.countryCode.value = value;
                                    }
                                  },
                                  dropdownColor: AppColors.background,
                                ),
                              ),
                            ),
                            disabledBorder: OutlineInputBorder(
                              borderRadius: const BorderRadius.all(Radius.circular(4)),
                              borderSide: BorderSide(
                                color: themeChange.getThem()
                                    ? AppColors.darkTextFieldBorder
                                    : AppColors.textFieldBorder,
                                width: 1,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: const BorderRadius.all(Radius.circular(4)),
                              borderSide: BorderSide(
                                color: themeChange.getThem()
                                    ? AppColors.darkTextFieldBorder
                                    : AppColors.textFieldBorder,
                                width: 1,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: const BorderRadius.all(Radius.circular(4)),
                              borderSide: BorderSide(
                                color: themeChange.getThem()
                                    ? AppColors.darkTextFieldBorder
                                    : AppColors.textFieldBorder,
                                width: 1,
                              ),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderRadius: const BorderRadius.all(Radius.circular(4)),
                              borderSide: BorderSide(
                                color: themeChange.getThem()
                                    ? AppColors.darkTextFieldBorder
                                    : AppColors.textFieldBorder,
                                width: 1,
                              ),
                            ),
                            border: OutlineInputBorder(
                              borderRadius: const BorderRadius.all(Radius.circular(4)),
                              borderSide: BorderSide(
                                color: themeChange.getThem()
                                    ? AppColors.darkTextFieldBorder
                                    : AppColors.textFieldBorder,
                                width: 1,
                              ),
                            ),
                            hintText: "Phone number".tr,
                          ),
                        ),
                        // TextFormField(
                        //   validator: (value) =>
                        //   value != null && value.isNotEmpty ? null : 'Required',
                        //   keyboardType: TextInputType.number,
                        //   textCapitalization: TextCapitalization.sentences,
                        //   controller: controller.phoneNumberController.value,
                        //   textAlign: TextAlign.start,
                        //   style: GoogleFonts.inter(
                        //       color: themeChange.getThem() ? Colors.white : Colors.black),
                        //   decoration: InputDecoration(
                        //     isDense: true,
                        //     filled: true,
                        //     fillColor: themeChange.getThem()
                        //         ? AppColors.darkTextField
                        //         : AppColors.textField,
                        //     contentPadding: const EdgeInsets.symmetric(vertical: 12),
                        //     prefixIcon: CountryCodePicker(
                        //       onChanged: (value) {
                        //         controller.countryCode.value = value.dialCode.toString();
                        //       },
                        //       dialogBackgroundColor: AppColors.background,
                        //       initialSelection: controller.countryCode.value,
                        //       comparator: (a, b) => b.name!.compareTo(a.name.toString()),
                        //       flagDecoration: const BoxDecoration(
                        //         borderRadius: BorderRadius.all(Radius.circular(2)),
                        //       ),
                        //       countryFilter: ['GB', 'US', 'AE', 'PK'], // Restrict to UK, USA, UAE, and Pakistan
                        //     ),
                        //     disabledBorder: OutlineInputBorder(
                        //       borderRadius: const BorderRadius.all(Radius.circular(4)),
                        //       borderSide: BorderSide(
                        //           color: themeChange.getThem()
                        //               ? AppColors.darkTextFieldBorder
                        //               : AppColors.textFieldBorder,
                        //           width: 1),
                        //     ),
                        //     focusedBorder: OutlineInputBorder(
                        //       borderRadius: const BorderRadius.all(Radius.circular(4)),
                        //       borderSide: BorderSide(
                        //           color: themeChange.getThem()
                        //               ? AppColors.darkTextFieldBorder
                        //               : AppColors.textFieldBorder,
                        //           width: 1),
                        //     ),
                        //     enabledBorder: OutlineInputBorder(
                        //       borderRadius: const BorderRadius.all(Radius.circular(4)),
                        //       borderSide: BorderSide(
                        //           color: themeChange.getThem()
                        //               ? AppColors.darkTextFieldBorder
                        //               : AppColors.textFieldBorder,
                        //           width: 1),
                        //     ),
                        //     errorBorder: OutlineInputBorder(
                        //       borderRadius: const BorderRadius.all(Radius.circular(4)),
                        //       borderSide: BorderSide(
                        //           color: themeChange.getThem()
                        //               ? AppColors.darkTextFieldBorder
                        //               : AppColors.textFieldBorder,
                        //           width: 1),
                        //     ),
                        //     border: OutlineInputBorder(
                        //       borderRadius: const BorderRadius.all(Radius.circular(4)),
                        //       borderSide: BorderSide(
                        //           color: themeChange.getThem()
                        //               ? AppColors.darkTextFieldBorder
                        //               : AppColors.textFieldBorder,
                        //           width: 1),
                        //     ),
                        //     hintText: "Phone number".tr,
                        //   ),
                        // ),
                        const SizedBox(
                          height: 30,
                        ),
                        ButtonThem.buildButton(
                          context,
                          title: "Next".tr,
                          onPress: () {
                            controller.sendCode();
                          },
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 40),
                          child: Row(
                            children: [
                              const Expanded(
                                  child: Divider(
                                height: 1,
                              )),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 20),
                                child: Text(
                                  "OR".tr,
                                  style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w600),
                                ),
                              ),
                              const Expanded(
                                  child: Divider(
                                height: 1,
                              )),
                            ],
                          ),
                        ),
                        ButtonThem.buildBorderButton(
                          context,
                          title: "Login with google".tr,
                          iconVisibility: true,
                          iconAssetImage: 'assets/icons/ic_google.png',
                          onPress: () async {
                            ShowToastDialog.showLoader("Please wait".tr);
                            await controller.signInWithGoogle().then((value) {
                              ShowToastDialog.closeLoader();
                              if (value != null) {
                                if (value.additionalUserInfo!.isNewUser) {
                                  print("----->new user");
                                  UserModel userModel = UserModel();
                                  userModel.id = value.user!.uid;
                                  userModel.email = value.user!.email;
                                  userModel.fullName = value.user!.displayName;
                                  userModel.profilePic = value.user!.photoURL;
                                  userModel.loginType = Constant.googleLoginType;
                                  ShowToastDialog.closeLoader();
                                  Get.to(const InformationScreen(), arguments: {
                                    "userModel": userModel,
                                  });
                                } else {
                                  print("----->old user");
                                  FireStoreUtils.userExitOrNot(value.user!.uid).then((userExit) async {
                                    if (userExit == true) {
                                      UserModel? userModel = await FireStoreUtils.getUserProfile(value.user!.uid);
                                      if (userModel != null) {
                                        if (userModel.isActive == true) {
                                          Constant.userModel = userModel;
                                          controller.loginDetailPreference.setUserData(value.user!.uid);
                                          await controller.assignCurrency(userModel.currency!);
                                          ShowToastDialog.closeLoader();
                                          Get.offAll(const DashBoardScreen());
                                        } else {
                                          await FirebaseAuth.instance.signOut();
                                          ShowToastDialog.closeLoader();
                                          ShowToastDialog.showToast("This user is disable please contact administrator".tr);
                                        }
                                      }
                                    } else {
                                      UserModel userModel = UserModel();
                                      userModel.id = value.user!.uid;
                                      userModel.email = value.user!.email;
                                      userModel.fullName = value.user!.displayName;
                                      userModel.profilePic = value.user!.photoURL;
                                      userModel.loginType = Constant.googleLoginType;
                                      Get.to(
                                          const InformationScreen(),
                                          arguments: {"userModel": userModel}
                                      );
                                    }
                                  });
                                }
                              }
                            });
                          },
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        Visibility(
                            visible: Platform.isIOS,
                            child: ButtonThem.buildBorderButton(
                              context,
                              title: "Login with apple".tr,
                              iconVisibility: true,
                              iconAssetImage: 'assets/icons/ic_apple.png',
                              onPress: () async {
                                ShowToastDialog.showLoader("Please wait".tr);
                                await controller.signInWithApple().then((value) {
                                  ShowToastDialog.closeLoader();
                                  if (value != null) {
                                    if (value.additionalUserInfo!.isNewUser) {
                                      log("----->new user");
                                      UserModel userModel = UserModel();
                                      userModel.id = value.user!.uid;
                                      userModel.email = value.user!.email;
                                      userModel.profilePic = value.user!.photoURL;
                                      userModel.loginType = Constant.appleLoginType;

                                      ShowToastDialog.closeLoader();
                                      Get.to(const InformationScreen(), arguments: {
                                        "userModel": userModel,
                                      });
                                    } else {
                                      print("----->old user");
                                      FireStoreUtils.userExitOrNot(value.user!.uid).then((userExit) async {
                                        ShowToastDialog.closeLoader();

                                        if (userExit == true) {
                                          UserModel? userModel = await FireStoreUtils.getUserProfile(value.user!.uid);
                                          if (userModel != null) {
                                            if (userModel.isActive == true) {
                                              Constant.userModel = userModel;
                                              controller.loginDetailPreference.setUserData(value.user!.uid);
                                              await controller.assignCurrency(userModel.currency!);
                                              ShowToastDialog.closeLoader();
                                              Get.offAll(const DashBoardScreen());
                                            } else {
                                              await FirebaseAuth.instance.signOut();
                                              ShowToastDialog.closeLoader();
                                              ShowToastDialog.showToast("This user is disable please contact administrator".tr);
                                            }
                                          }
                                        } else {
                                          UserModel userModel = UserModel();
                                          userModel.id = value.user!.uid;
                                          userModel.email = value.user!.email;
                                          userModel.profilePic = value.user!.photoURL;
                                          userModel.loginType = Constant.googleLoginType;
                                          Get.to(const InformationScreen(), arguments: {
                                            "userModel": userModel,
                                          });
                                        }
                                      });
                                    }
                                  }
                                });
                              },
                            )),
                      ],
                    ),
                  )
                ],
              ),
            ),
            bottomNavigationBar: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                child: Text.rich(
                  textAlign: TextAlign.center,
                  TextSpan(
                    text: 'By tapping "Next" you agree to '.tr,
                    style: GoogleFonts.inter(),
                    children: <TextSpan>[
                      TextSpan(
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              Get.to(const TermsAndConditionScreen(
                                type: "terms",
                              ));
                            },
                          text: 'Terms and conditions'.tr,
                          style: GoogleFonts.inter(decoration: TextDecoration.underline)),
                      TextSpan(text: ' and ', style: GoogleFonts.inter()),
                      TextSpan(
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              Get.to(const TermsAndConditionScreen(
                                type: "privacy",
                              ));
                            },
                          text: 'privacy policy'.tr,
                          style: GoogleFonts.inter(decoration: TextDecoration.underline)),
                      // can add more TextSpans here...
                    ],
                  ),
                )),
          );
        });
  }
}
