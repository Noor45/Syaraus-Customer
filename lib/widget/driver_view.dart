import 'package:cached_network_image/cached_network_image.dart';
import 'package:customer/constant/constant.dart';
import 'package:customer/model/driver_user_model.dart';
import 'package:customer/themes/app_colors.dart';
import 'package:customer/utils/fire_store_utils.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DriverView extends StatelessWidget {
  final String? driverId;
  final String? amount;

  const DriverView({Key? key, this.driverId, this.amount}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DriverUserModel?>(
        future: FireStoreUtils.getDriver(driverId.toString()),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return const SizedBox();
            case ConnectionState.done:
              if (snapshot.hasError) {
                return Text(snapshot.error.toString());
              } else {
                if (snapshot.data == null) {
                  return Column(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          ClipRRect(
                            borderRadius: const BorderRadius.all(Radius.circular(10)),
                            child: CachedNetworkImage(
                              height: 50,
                              width: 50,
                              imageUrl: Constant.userPlaceHolder,
                              fit: BoxFit.cover,
                              placeholder: (context, url) => Constant.loader(),
                              errorWidget: (context, url, error) => Image.network(Constant.userPlaceHolder),
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Asynchronous user", style: GoogleFonts.inter(fontWeight: FontWeight.w600)),
                                Row(
                                  children: [
                                    Expanded(
                                      child: Row(
                                        children: [
                                          const Icon(
                                            Icons.star,
                                            size: 22,
                                            color: AppColors.ratingColour,
                                          ),
                                          const SizedBox(
                                            width: 5,
                                          ),
                                          Text(Constant.calculateReview(reviewCount: "0.0", reviewSum: "0.0"), style: GoogleFonts.inter(fontWeight: FontWeight.w500)),
                                        ],
                                      ),
                                    ),
                                    Text(
                                      Constant.amountShow(amount: amount.toString()),
                                      style: GoogleFonts.inter(fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  );
                }
                DriverUserModel driverModel = snapshot.data!;
                return Container(
                  padding: const EdgeInsets.fromLTRB(8, 8, 8, 18),
                  decoration: BoxDecoration(
                    color: driverModel.gender == 'Female' ? Colors.pink : Colors.blue,
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(12), topRight: Radius.circular(12))
                  ),
                  child: Column(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: const BorderRadius.all(Radius.circular(10)),
                            child: CachedNetworkImage(
                              height: 50,
                              width: 50,
                              imageUrl: driverModel.profilePic.toString(),
                              fit: BoxFit.cover,
                              placeholder: (context, url) => Constant.loader(),
                              errorWidget: (context, url, error) => Image.network(Constant.userPlaceHolder),
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(driverModel.fullName.toString(), style: GoogleFonts.inter(fontWeight: FontWeight.w600, color: Colors.white)),
                                Padding(
                                  padding: const EdgeInsets.only(top: 5, bottom: 5),
                                  child: Text(driverModel.gender == null ? 'Male' : driverModel.gender.toString() , style: GoogleFonts.inter(fontWeight: FontWeight.w300, color: Colors.white)),
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                      child: Row(
                                        children: [
                                          const Icon(
                                            Icons.star,
                                            size: 22,
                                            color: AppColors.ratingColour,
                                          ),
                                          const SizedBox(
                                            width: 5,
                                          ),
                                          Text(Constant.calculateReview(reviewCount: driverModel.reviewsCount.toString(), reviewSum: driverModel.reviewsSum.toString()),
                                              style: GoogleFonts.inter(fontWeight: FontWeight.w500, color: Colors.white)),
                                        ],
                                      ),
                                    ),
                                    Text(
                                      Constant.amountShow(amount: amount.toString()),
                                      style: GoogleFonts.inter(fontWeight: FontWeight.bold, color: Colors.white),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              }
            default:
              return const Text('Error');
          }
        });
  }
}
