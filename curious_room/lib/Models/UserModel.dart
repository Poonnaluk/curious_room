// ignore_for_file: unnecessary_brace_in_string_interps

import 'package:http/http.dart' as http;
import 'dart:convert';

UserModel userModelFromJson(String str) => UserModel.fromJson(json.decode(str));
String userModelToJson(UserModel data) => json.encode(data.toJson());

class UserModel {
  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.display,
    required this.role,
    required this.createdAt,
    required this.updatedAt,
  });

  int id;
  String name;
  String email;
  dynamic display;
  String role;
  DateTime createdAt;
  DateTime updatedAt;

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        id: json["id"],
        name: json["name"],
        email: json["email"],
        display: json["display"],
        role: json["role"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
      );

  set value(UserModel? value) {}

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "email": email,
        "display": display,
        "role": role,
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
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

// ignore: non_constant_identifier_names
Future<UserModel?> createUser(String googleName, String email,String GimageUrl) async {
  final String apiUrl = "http://192.168.1.48:8000/user";
  final bodyregis = jsonEncode({
    "name": googleName,
    "email": email,
    "display": GimageUrl
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
