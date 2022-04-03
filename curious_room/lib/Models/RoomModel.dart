import 'package:curious_room/Models/UserModel.dart';
import 'package:http/http.dart' as http;

import 'dart:convert';

RoomModel roomModelFromJson(String str) => RoomModel.fromJson(json.decode(str));

String roomModelToJson(RoomModel data) => json.encode(data.toJson());

class RoomModel {
  RoomModel(
      {required this.id,
      required this.name,
      required this.code,
      required this.userId,
      this.statusRoom,
      required this.createdAt,
      required this.updatedAt,
      required this.ownerModel,
      this.userPost,
      this.userComment,
      this.statist,
      this.score,
      this.mostLike});

  int id;
  String name;
  String code;
  int userId;
  late String? statusRoom;
  DateTime createdAt;
  DateTime updatedAt;
  late UserModel ownerModel;
  UserModel? userPost;
  UserModel? userComment;
  int? statist;
  int? score;
  String? mostLike;

  factory RoomModel.fromJson(Map<String, dynamic> json) => RoomModel(
        id: json["id"] == null ? 0 : json["id"],
        name: json["name"] == null ? "" : json["name"],
        code: json["code"] == null ? "" : json["code"],
        userId: json["userId"] == null ? 0 : json["userId"],
        statusRoom: json["statusRoom"] as String?,
        createdAt: DateTime.parse(json["createdAt"] == null
            ? "1969-07-20 20:18:04Z"
            : json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"] == null
            ? "1969-07-20 20:18:04Z"
            : json["updatedAt"]),
        ownerModel: UserModel.fromJson(
            json["user_room"] == null ? {} : json["user_room"]),
        userPost: UserModel.fromJson(
            json["user_post"] == null ? {} : json["user_post"]),
        userComment: UserModel.fromJson(
            json["user_comment"] == null ? {} : json["user_comment"]),
        statist: json["statist"],
        score: json["score"],
        mostLike: json["mostLike"],
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
        "user_post": userPost == null ? null : userPost!.toJson(),
        "statist": statist,
        "score": score,
        "mostLike": mostLike,
      };
}

Future<RoomModel> createRoom(String name, int userid) async {
  final String apiUrl = "http://157.230.240.207:8000/room";
  final body = jsonEncode({
    "room": {"name": name, "userId": userid}
  });
  final response = await http.post(Uri.parse(apiUrl),
      body: body,
      headers: {'Content-Type': 'application/json', 'Accept': '*/*'});
  if (response.statusCode == 200) {
    return RoomModel.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Failed to create room.');
  }
}

Future<RoomModel> getRoom(int roomid) async {
  final String apiUrl = "http://157.230.240.207:8000/room/$roomid";
  final response = await http.get(Uri.parse(apiUrl));
  if (response.statusCode == 200) {
    return RoomModel.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Failed to load about room');
  }
}

Future<List<RoomModel>> getMyRoom(int userid) async {
  final String apiUrl = "http://157.230.240.207:8000/room/user/$userid";
  final response = await http.get(Uri.parse(apiUrl));
  if (response.statusCode == 200) {
    Iterable l = json.decode(response.body);
    List<RoomModel> roomModels = l.map((g) => RoomModel.fromJson(g)).toList();
    return roomModels;
  } else if (response.statusCode == 500) {
    return [];
  } else {
    throw Exception('Failed to load your rooms');
  }
}

Future<RoomModel> updateRoom(String name, int id) async {
  final String apiUrl = "http://157.230.240.207:8000/room/$id";
  final body = jsonEncode(<String, String>{
    'name': name,
  });
  final response =
      await http.put(Uri.parse(apiUrl), body: body, headers: <String, String>{
    'Content-Type': 'application/json; charset=UTF-8',
  });
  if (response.statusCode == 200) {
    print(response.body);
    return RoomModel.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Failed to update room.');
  }
}

Future<List<RoomModel>> getAllRooms() async {
  final String apiUrl = "http://157.230.240.207:8000/room";
  final response = await http.get(Uri.parse(apiUrl));
  if (response.statusCode == 200) {
    Iterable l = json.decode(response.body);
    List<RoomModel> roomModels = l.map((g) => RoomModel.fromJson(g)).toList();
    return roomModels;
  } else {
    throw Exception('Failed to load room participates');
  }
}

Future<dynamic> getRoomByCode(String code) async {
  final String apiUrl = "http://157.230.240.207:8000/room/$code";
  final response = await http.get(Uri.parse(apiUrl));
  if (response.statusCode == 200) {
    Iterable l = json.decode(response.body);
    List<RoomModel> roomWithOwnerUser =
        l.map((g) => RoomModel.fromJson(g)).toList();
    return roomWithOwnerUser;
  } else if (response.statusCode == 500) {
    return null;
  } else {
    throw Exception('Failed to load participates');
  }
}

Future<dynamic> deleteMyRoom(int id) async {
  final String apiUrl = "http://157.230.240.207:8000/room/delete/$id";
  final response = await http.put(Uri.parse(apiUrl));
  if (response.statusCode == 200) {
    print(response.body);
    return jsonDecode(response.body);
  } else {
    throw Exception('Failed to delete room.');
  }
}

Future<List<RoomModel>> getStatistPost(int roomid) async {
  String apiUrl = "http://192.168.1.108:8000/room/stat/post/$roomid";
  var res = await http.get(Uri.parse(apiUrl));
  if (res.statusCode == 200) {
    Iterable l = json.decode(res.body);
    List<RoomModel> roomModel = l.map((g) => RoomModel.fromJson(g)).toList();
    return roomModel;
  } else if (res.statusCode == 500) {
    return [];
  } else {
    throw Exception('Failed to get score');
  }
}

Future<List<RoomModel>> getStatistAns(int roomid) async {
  String apiUrl = "http://192.168.1.108:8000/room/stat/ans/$roomid";
  var res = await http.get(Uri.parse(apiUrl));
  if (res.statusCode == 200) {
    Iterable l = json.decode(res.body);
    List<RoomModel> roomModel = l.map((g) => RoomModel.fromJson(g)).toList();
    return roomModel;
  } else if (res.statusCode == 500) {
    return [];
  } else {
    throw Exception('Failed to get score');
  }
}

Future<List<RoomModel>> getChart(int roomid) async {
  String apiUrl = "http://192.168.1.108:8000/room/statChart/$roomid";
  var res = await http.get(Uri.parse(apiUrl));
  if (res.statusCode == 200) {
    Iterable l = json.decode(res.body);
    List<RoomModel> roomModel = l.map((g) => RoomModel.fromJson(g)).toList();
    return roomModel;
  } else if (res.statusCode == 500) {
    return [];
  } else {
    throw Exception('Failed to get score');
  }
}
