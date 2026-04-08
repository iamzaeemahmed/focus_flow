

// Selected category provider
import 'package:flutter_riverpod/legacy.dart';
import 'package:focus_flow/data/model/app_block_model.dart';

final selectedCategoryProvider = StateProvider<String>((ref) => 'SOCIAL');

// Apps list provider
final appsListProvider = StateNotifierProvider<AppsNotifier, List<AppBlockModel>>(
      (ref) => AppsNotifier(),
);

class AppsNotifier extends StateNotifier<List<AppBlockModel>> {
  AppsNotifier() : super(_dummyApps);

  void toggleApp(String packageName) {
    state = state.map((app) {
      if (app.packageName == packageName) {
        return AppBlockModel(
          appName: app.appName,
          packageName: app.packageName,
          category: app.category,
          isBlocked: !app.isBlocked,
        );
      }
      return app;
    }).toList();
  }

  int get blockedCount => state.where((app) => app.isBlocked).length;
}

// Dummy apps list
final List<AppBlockModel> _dummyApps = [
  AppBlockModel(appName: 'Instagram', packageName: 'com.instagram', category: 'SOCIAL', isBlocked: true),
  AppBlockModel(appName: 'Twitter', packageName: 'com.twitter', category: 'SOCIAL', isBlocked: true),
  AppBlockModel(appName: 'Facebook', packageName: 'com.facebook', category: 'SOCIAL', isBlocked: false),
  AppBlockModel(appName: 'WhatsApp', packageName: 'com.whatsapp', category: 'SOCIAL', isBlocked: false),
  AppBlockModel(appName: 'YouTube', packageName: 'com.youtube', category: 'ENTERTAINMENT', isBlocked: true),
  AppBlockModel(appName: 'Netflix', packageName: 'com.netflix', category: 'ENTERTAINMENT', isBlocked: false),
  AppBlockModel(appName: 'PUBG Mobile', packageName: 'com.pubg', category: 'GAMES', isBlocked: false),
  AppBlockModel(appName: 'Free Fire', packageName: 'com.freefire', category: 'GAMES', isBlocked: false),
];