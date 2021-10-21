import 'package:http/http.dart' as http;
import 'dart:convert';

UserModel userModelFromJson(String str) => UserModel.fromJson(json.decode(str));
String userModelToJson(UserModel data) => json.encode(data.toJson());

class UserModel {
  UserModel({
    this.id,
    this.name,
    this.email,
    this.display,
    this.role,
    this.createdAt,
    this.updatedAt,
  });

  int? id;
  String? name;
  String? email;
  dynamic display;
  String? role;
  DateTime? createdAt;
  DateTime? updatedAt;

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        id: json["id"],
        name: json["name"],
        email: json["email"],
        display: json["display"],
        role: json["role"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "email": email,
        "display": display,
        "role": role,
        "createdAt": createdAt!.toIso8601String(),
        "updatedAt": updatedAt!.toIso8601String(),
      };
}

Future<dynamic> regischeck(String uEmail) async {
  //นำค่าเเป็น Params
  final pramsUrl = Uri.parse('http://192.168.1.48:8000/user/${uEmail}');
  print(pramsUrl);
  final res = await http.post(pramsUrl);
  if (res.statusCode == 200) {
    return UserModel.fromJson(jsonDecode(res.body));
  } else if (res.statusCode == 500) {
    return null;
  } else {
    throw Exception('Failed to check');
  }
}

Future<UserModel?> createUser(String googleName, String email) async {
  final String apiUrl = "http://192.168.1.48:8000/user";
  final bodyregis = jsonEncode({
    "user": {"name": googleName, "email": email}
  });
  final response = await http.post(Uri.parse(apiUrl),
      body: bodyregis,
      headers: {'Content-Type': 'application/json', 'Accept': '*/*'});
  if (response.statusCode != 201) {
    return null;
  }
  final String responseString = response.body;
  print(responseString);
  return userModelFromJson(responseString);
}
