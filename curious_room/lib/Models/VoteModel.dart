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
  });

  int? id;
  bool? voteStatus;
  int? userId;
  int? postId;
  DateTime? createdAt;
  DateTime? updatedAt;

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
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "voteStatus": voteStatus,
        "userId": userId,
        "postId": postId,
        "createdAt": createdAt == null ? null : createdAt!.toIso8601String(),
        "updatedAt": updatedAt == null ? null : updatedAt!.toIso8601String(),
      };
}

Future<String> voteScore(int status, int userId, postId) async {
  final apiUrl = 'http://157.230.240.207:8000/vote';
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
