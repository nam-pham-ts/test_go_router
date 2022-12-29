import 'dart:developer';

import 'package:flutter/widgets.dart';

class CommonNavigatorObserver extends RouteObserver<PageRoute<dynamic>> {

  CommonNavigatorObserver();

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPush(route, previousRoute);
    log(
        '>>>>>>>>>> didPush route: ${route.settings} --- previousRoute: ${previousRoute?.settings ?? ''}');

  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPop(route, previousRoute);
    log(
        '>>>>>>>>>> didPop route: ${route.settings} --- previousRoute: ${previousRoute?.settings ?? ''}');
    final Object? args = route.settings.arguments;
  }
}