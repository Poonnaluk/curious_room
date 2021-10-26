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

  var now = new DateTime.now();

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        id: json["id"] == null ? 0 : json["id"],
        name: json["name"] == null ? "" : json["name"],
        email: json["email"] == null ? "" : json["email"],
        display: json["display"] == null ? "" : json["display"],
        role: json["role"] == null ? "" : json["role"],
        createdAt: DateTime.parse(json["createdAt"] == null
            ? "1969-07-20 20:18:04Z"
            : json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"] == null
            ? "1969-07-20 20:18:04Z"
            : json["updatedAt"]),
      );

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
  final pramsUrl = Uri.parse('http://147.182.209.40/user/$uEmail');
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
Future<UserModel?> createUser(
    String googleName, String email, String imageUrl) async {
  final String apiUrl = "http://147.182.209.40/user";
  final bodyregis =
      jsonEncode({"name": googleName, "email": email, "display": imageUrl});
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
