import 'package:curious_room/Models/UserModel.dart';
import 'package:http/http.dart' as http;

import 'dart:convert';

RoomModel roomModelFromJson(String str) => RoomModel.fromJson(json.decode(str));

String roomModelToJson(RoomModel data) => json.encode(data.toJson());

class RoomModel {
  RoomModel({
    required this.id,
    required this.name,
    required this.code,
    required this.userId,
    this.statusRoom,
    required this.createdAt,
    required this.updatedAt,
    required this.ownerModel,
  });

  int id;
  String name;
  String code;
  int userId;
  late String? statusRoom;
  DateTime createdAt;
  DateTime updatedAt;
  late UserModel ownerModel;

  factory RoomModel.fromJson(Map<String, dynamic> json) => RoomModel(
        id: json["id"],
        name: json["name"],
        code: json["code"],
        userId: json["userId"],
        statusRoom: json["statusRoom"] as String?,
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
        ownerModel: UserModel.fromJson(json["user_room"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "code": code,
        "userId": userId,
        "statusRoom": statusRoom,
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
        "user_room": ownerModel,
      };
}

Future<RoomModel> createRoom(String name, int userid) async {
  final String apiUrl = "http://192.168.43.94:8000/room";
  //final String apiUrl = "http://192.168.1.48:8000/room";
  final body = jsonEncode({
    "room": {"name": name, "userId": userid}
  });
  final response = await http.post(Uri.parse(apiUrl),
      body: body,
      headers: {'Content-Type': 'application/json', 'Accept': '*/*'});
  if (response.statusCode == 200) {
    print(response.body);

    return RoomModel.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Failed to create album.');
  }
}

Future<RoomModel> getRoom(int roomid) async {
  final String apiUrl = "http://192.168.43.94:8000/room/$roomid";
  final response = await http.get(Uri.parse(apiUrl));
  if (response.statusCode == 200) {
    return RoomModel.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Failed to load about room');
  }
}
