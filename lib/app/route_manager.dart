
import 'package:flutter/material.dart';

class Routes {
  static const String splashRoute = "/";
  static const String onBoardingRoute = "/onBoarding";
  static const String loginRoute = "/login";
  static const String registerRoute = "/register";
  static const String forgotPasswordRoute = "/forgotPassword";
  static const String mainRoute = "/main";
  static const String storeDetailsRoute = "/storeDetails";
}

class RouteGenerator {
  static Route<dynamic> getRoute(RouteSettings routeSettings) {

    // switch (routeSettings.name) {
    //   case (Routes.splashRoute):
    //     return MaterialPageRoute(builder: ((context) => SplashView()));
    //   case (Routes.loginRoute):
    //     // initLoginModule();
    //     return MaterialPageRoute(builder: ((context) => LoginView()));
    //   case (Routes.onBoardingRoute):
    //     return MaterialPageRoute(builder: ((context) => OnBoardingView()));
    //   case (Routes.splashRoute):
    //     return MaterialPageRoute(builder: ((context) => ForgotPasswordView()));
    //   case (Routes.splashRoute):
    //     return MaterialPageRoute(builder: ((context) => MainView()));
    //   case (Routes.splashRoute):
    //     return MaterialPageRoute(builder: ((context) => StoreDetailsView()));
    //   default:
    //     return unDefinedRoute();
    // }
    return unDefinedRoute();

  }


  static Route<dynamic> unDefinedRoute(){
    return MaterialPageRoute(
      builder: ((_) => Scaffold(
        appBar: AppBar(
          title: Text("noRouteFound"),
        ),
        body: Center(child: Text("noRouteFound")),
      ))
    );
  }

}
