import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';


extension TSGoRouterHelper on BuildContext {
  String namedLocation(String name, {
    Map<String, String> params = const <String, String>{},
    Map<String, dynamic> queryParams = const <String, dynamic>{},
  }) =>
      GoRouter.of(this)
          .namedLocation(name, params: params, queryParams: queryParams);
}
