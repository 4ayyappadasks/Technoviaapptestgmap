import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:technoviaapptest/common/Commonimageviewer/cacheimage.dart';
import 'package:technoviaapptest/common/commonscaffold/CommonScaffold.dart';
import 'package:technoviaapptest/controller/SplashScreen/controller.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    SplashScreenController splashScreenController =
        Get.put(SplashScreenController());
    return CommonScaffold(
      useSafeArea: false,
      body: Center(
        child: CommonCachedImage(
            imageUrl:
                "https://img.freepik.com/premium-vector/street-map-with-pin-middle_163786-12.jpg?w=826"),
      ),
    );
  }
}
