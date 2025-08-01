import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:get_flow_kit/config/routes/app_routes.dart';
import 'package:get_flow_kit/presentation/widgets/scaffolds/safe_scaffold.dart';

class AppRouter {
  static final List<GetPage> pages = [
    GetPage(
      name: AppRoutes.home,
      page: () {
        return const SafeScaffold(child: Placeholder());
      },
    ),
  ];
}
