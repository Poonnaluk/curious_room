import 'package:curious_room/Models/UserModel.dart';
import 'package:http/http.dart' as http;
// To parse this JSON data, do
//
//     final roomModel = roomModelFromJson(jsonString);

import 'dart:convert';

RoomModel roomModelFromJson(String str) => RoomModel.fromJson(json.decode(str));

String roomModelToJson(RoomModel data) => json.encode(data.toJson());

class RoomModel {
  RoomModel(
      {required this.id,
      required this.name,
      required this.code,
      required this.userId,
      required this.statusRoom,
      required this.createdAt,
      required this.updatedAt,
      required this.userModel});

  int id;
  String name;
  String code;
  int userId;
  String statusRoom;
  DateTime createdAt;
  DateTime updatedAt;
  UserModel userModel;

  factory RoomModel.fromJson(Map<String, dynamic> json) => RoomModel(
        id: json["id"],
        name: json["name"],
        code: json["code"],
        userId: json["userId"],
        statusRoom: json["statusRoom"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
        userModel: UserModel.fromJson(json["user_room"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "code": code,
        "userId": userId,
        "statusRoom": statusRoom,
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
        "user_room": userModel.toJson(),
      };
}

Future<RoomModel> createRoom(String name, int userid) async {
  // final String apiUrl = "http://192.168.43.94:8000/room";
  final String apiUrl = "http://192.168.1.48:8000/room";
  final body = jsonEncode({
    "room": {"name": name, "userId": userid}
  });
  final response = await http.post(Uri.parse(apiUrl),
      body: body,
      headers: {'Content-Type': 'application/json', 'Accept': '*/*'});
  if (response.statusCode == 200) {
    print(response.body);
    RoomModel roomModel = RoomModel.fromJson(jsonDecode(response.body));
    return roomModel;
  } else {
    throw Exception('Failed to create album.');
  }
}
