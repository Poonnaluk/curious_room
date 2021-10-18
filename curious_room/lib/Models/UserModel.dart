import 'package:http/http.dart' as http;
import 'dart:convert';

UserModel userModelFromJson(String str) => UserModel.fromJson(json.decode(str));
String userModelToJson(UserModel data) => json.encode(data.toJson());

class UserModel {
  UserModel({
    required this.id,
    required this.name,
    required this.email,
    this.display,
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

Future<List<UserModel>?> regischeck(String uEmail) async {
  //นำค่าเเป็น Params

  final pramsUrl =
      "xxxx";

  final res = await http.post(
    Uri.parse(pramsUrl),
    body: {'email': uEmail},
  );

  if (res.statusCode == 200) {
    Iterable l = json.decode(res.body);
    List<UserModel> userModels = l.map((g) => UserModel.fromJson(g)).toList();
    if (userModels.isEmpty) {
      return null;
    } else {
      return userModels;
    }
  } else {
    return null;
  }
}

Future<UserModel?> createUser(String fName, String email) async {
    final String apiUrl = "xxx";
    final bodyregis = jsonEncode({"uFullName": fName, "u_Email": email});
    final response = await http.post(Uri.parse(apiUrl) ,
        body: bodyregis,
        headers: {'Content-Type': 'application/json', 'Accept': '*/*'});
    if (response.statusCode != 201) {
      return null;
    }

    final String responseString = response.body;
    print(responseString);
    return userModelFromJson(responseString);
  }


