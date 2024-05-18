class User {
  String imagePath;
  final String name;
  final String email;
  String phone;
  String cellphone;
  bool isInWeb;

  User({
    required this.imagePath,
    required this.name,
    required this.email,
    required this.phone,
    required this.cellphone,
    required this.isInWeb
  });
}