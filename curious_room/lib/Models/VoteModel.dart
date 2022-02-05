import 'dart:convert';
import 'package:http/http.dart' as http;

VoteModel voteModelFromJson(String str) => VoteModel.fromJson(json.decode(str));

String voteModelToJson(VoteModel data) => json.encode(data.toJson());

class VoteModel {
  VoteModel({
    this.id,
    this.voteStatus,
    this.userId,
    this.postId,
    this.createdAt,
    this.updatedAt,
    this.listVoteStatus,
  });

  int? id;
  bool? voteStatus;
  int? userId;
  int? postId;
  DateTime? createdAt;
  DateTime? updatedAt;
  List<dynamic>? listVoteStatus;

  factory VoteModel.fromJson(Map<String, dynamic> json) => VoteModel(
        id: json["id"],
        voteStatus: json["voteStatus"],
        userId: json["userId"],
        postId: json["postId"],
        createdAt: json["createdAt"] == null
            ? null
            : DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null
            ? null
            : DateTime.parse(json["updatedAt"]),
        listVoteStatus: List<dynamic>.from(
            json["listVoteStatus"].map((x) => x == null ? null : x)),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "voteStatus": voteStatus,
        "userId": userId,
        "postId": postId,
        "createdAt": createdAt == null ? null : createdAt!.toIso8601String(),
        "updatedAt": updatedAt == null ? null : updatedAt!.toIso8601String(),
        "listVoteStatus": List<dynamic>.from(
            listVoteStatus!.map((x) => x == null ? null : x)),
      };
}

Future<String> voteScore(int status, int userId, postId) async {
  final apiUrl = 'http://147.182.209.40/vote';
  final body = jsonEncode(
      <String, int>{"status": status, "userId": userId, "postId": postId});
  final res =
      await http.put(Uri.parse(apiUrl), body: body, headers: <String, String>{
    'Content-Type': 'application/json; charset=UTF-8',
  });
  if (res.statusCode == 200) {
    print(' {"message":"Vote success."}');
    return "Vote success";
  } else {
    throw Exception('Failed to check');
  }
}

Future<VoteModel> listStatus(int roomId, int userId) async {
  final apiUrl = 'http://192.168.1.36:8000/vote/room/post';
  // final apiUrl = 'http://147.182.209.40/vote/room/post';
  String body = jsonEncode(<String, int>{"roomId": roomId, "userId": userId});
  final res = await http.post(Uri.parse(apiUrl),
      body: body,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Accept': '*/*'
      });
  if (res.statusCode == 200) {
    return VoteModel.fromJson(jsonDecode(res.body));
  } else {
    throw Exception('Failed to check');
  }
}
