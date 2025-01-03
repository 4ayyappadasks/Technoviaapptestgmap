import 'package:get/get.dart';
import 'package:technoviaapptest/common/Navigation/nav.dart';
import 'package:technoviaapptest/view/Homescreen/ui.dart';

class SplashScreenController extends GetxController {
  loadsplashScreen() async {
    await Future.delayed(
      Duration(seconds: 3),
      () {
        NavigationService.to(screen: HomeScreen());
      },
    );
  }

  @override
  void onInit() {
    loadsplashScreen();
    super.onInit();
  }
}
