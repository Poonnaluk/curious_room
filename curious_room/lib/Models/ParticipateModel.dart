// To parse this JSON data, do
//
//     final participateModel = participateModelFromJson(jsonString);

import 'dart:convert';
import 'package:curious_room/Models/RoomModel.dart';
import 'package:http/http.dart' as http;
import 'package:curious_room/Models/UserModel.dart';

List<ParticipateModel> participateModelFromJson(String str) =>
    List<ParticipateModel>.from(
        json.decode(str).map((x) => ParticipateModel.fromJson(x)));

String participateModelToJson(List<ParticipateModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ParticipateModel {
  ParticipateModel({
    required this.id,
    this.joinStatus,
    required this.userId,
    required this.roomId,
    required this.createdAt,
    required this.updatedAt,
    this.userParticipate,
    this.roomParticipate,
  });

  int id;
  bool? joinStatus;
  int userId;
  int roomId;
  DateTime createdAt;
  DateTime updatedAt;
  UserModel? userParticipate;
  RoomModel? roomParticipate;

  factory ParticipateModel.fromJson(Map<String, dynamic> json) =>
      ParticipateModel(
        id: json["id"],
        joinStatus: json["joinStatus"],
        userId: json["userId"],
        roomId: json["roomId"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
        userParticipate: UserModel.fromJson(
            json["user_participate"] == null ? {} : json["user_participate"]),
        roomParticipate: RoomModel.fromJson(
            json["room_participate"] == null ? {} : json["room_participate"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "joinStatus": joinStatus,
        "userId": userId,
        "roomId": roomId,
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
        "user_participate":
            userParticipate?.toJson() == null ? [] : userParticipate?.toJson(),
        "room_participate":
            roomParticipate?.toJson() == null ? [] : roomParticipate?.toJson(),
      };
}

Future<List<ParticipateModel>> getParticipate(int roomid) async {
  final String apiUrl = "http://147.182.209.40/participate/$roomid";
  final response = await http.get(Uri.parse(apiUrl));
  if (response.statusCode == 200) {
    Iterable l = json.decode(response.body);
    List<ParticipateModel> participateModels =
        l.map((g) => ParticipateModel.fromJson(g)).toList();
    return participateModels;
  } else {
    throw Exception('Failed to load participates');
  }
}

Future<List<ParticipateModel>> getRoomParticipate(int userid) async {
  final String apiUrl = "http://147.182.209.40/participate/room/$userid";
  final response = await http.get(Uri.parse(apiUrl));
  if (response.statusCode == 200) {
    Iterable l = json.decode(response.body);
    List<ParticipateModel> garageModels =
        l.map((g) => ParticipateModel.fromJson(g)).toList();
    return garageModels;
  } else {
    throw Exception('Failed to load room participates');
  }
}

Future<dynamic> createParticipate(int userId, int roomId) async {
  final String apiUrl = "http://192.168.1.48:8000/participate";
  final body = jsonEncode({"userId": userId, "roomId": roomId});
  final response = await http.post(Uri.parse(apiUrl),
      body: body,
      headers: {'Content-Type': 'application/json', 'Accept': '*/*'});
  if (response.statusCode == 200) {
    return ParticipateModel.fromJson(jsonDecode(response.body));
  } else if (response.statusCode == 201) {
    return null;
  } else {
    throw Exception('Failed to create participate.');
  }
}
