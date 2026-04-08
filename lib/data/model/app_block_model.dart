class AppBlockModel {
  final String appName;
  final String packageName;
  final String category;
  bool isBlocked;

  AppBlockModel({
    required this.appName,
    required this.packageName,
    required this.category,
    this.isBlocked = false,
  });
}