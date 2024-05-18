class PersonaModel {
  String username;
  String password;
  String rol;
  String token;
  String cellphone;
  String ci;
  String direction;
  String id;
  String fatherId;
  String motherId;
  String lastname;
  String mail;
  String name;
  DateTime resgisterdate;
  int status;
  String surname;
  String telephone;
  String grade;
  DateTime updatedate;

  PersonaModel({
    required this.username,
    required this.password,
    required this.rol,
    this.token = '',
    required this.cellphone,
    required this.ci,
    required this.direction,
    required this.id,
    required this.fatherId,
    required this.motherId,
    required this.lastname,
    required this.grade,
    required this.mail,
    required this.name,
    required this.resgisterdate,
    required this.status,
    required this.surname,
    required this.telephone,
    required this.updatedate,
  });

  factory PersonaModel.fromJson(Map<String, dynamic> json) => PersonaModel(
        username: json['username'] ?? "",
        password: json['password'] ?? "",
        rol: json['rol'] ?? "",
        token: json['token'] ?? "",
        cellphone: json['cellphone'] ?? "",
        ci: json['ci'] ?? "",
        direction: json['direction'] ?? "",
        id: json['id'] ?? "",
        fatherId: json['fatherId'] ?? "",
        motherId: json['motherId'] ?? "",
        lastname: json['lastname'] ?? "",
        mail: json['mail'] ?? "",
        name: json['name'] ?? "",
        grade: json['grade'] ?? "",
        resgisterdate: DateTime.parse(json['registerdate']),
        status: int.tryParse(['status'].toString()) ?? 0,
        surname: json['surname'] ?? "",
        telephone: json['telephone'] ?? "",
        updatedate: DateTime.parse(json['updatedate']),
      );

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'password': password,
      'rol': rol,
      'token': token,
      'cellphone': cellphone,
      'ci': ci,
      'direction': direction,
      'id': id,
      'fatherId': fatherId,
      'motherId': motherId,
      'lastname': lastname,
      'mail': mail,
      'grade': grade,
      'name': name,
      'registerdate': resgisterdate.toIso8601String(),
      'status': status,
      'surname': surname,
      'telephone': telephone,
      'updatedate': updatedate.toIso8601String(),
    };
  }
}
