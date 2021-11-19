// To parse this JSON data, do
//
//     final userStatsModel = userStatsModelFromJson(jsonString);

import 'dart:convert';
import 'package:http/http.dart' as http;

UserStatsModel userStatsModelFromJson(String str) =>
    UserStatsModel.fromJson(json.decode(str));

String userStatsModelToJson(UserStatsModel data) => json.encode(data.toJson());

class UserStatsModel {
  UserStatsModel({
    required this.userPost,
    required this.userComment,
    required this.bestComment,
    required this.userVote,
  });

  int? userPost;
  int? userComment;
  int? bestComment;
  int? userVote;

  factory UserStatsModel.fromJson(Map<String, dynamic> json) => UserStatsModel(
        userPost: json["user_post"] == null ? 0 : json["user_post"],
        userComment: json["user_comment"] == null ? 0 : json["user_comment"],
        bestComment: json["best_comment"] == null ? 0 : json["best_comment"],
        userVote: json["user_vote"] == null ? 0 : json["user_vote"],
      );

  Map<String, dynamic> toJson() => {
        "user_post": userPost,
        "user_comment": userComment,
        "best_comment": bestComment,
        "user_vote": userVote,
      };
}

Future<UserStatsModel> getStats(int userId, String role) async {
  final apiUrl = 'http://147.182.209.40/user/stat/all';
  final body = jsonEncode({"id": userId, "role": role});
  final res = await http.post(Uri.parse(apiUrl),
      body: body,
      headers: {'Content-Type': 'application/json', 'Accept': '*/*'});

  if (res.statusCode == 200) {
    return UserStatsModel.fromJson(jsonDecode(res.body));
  } else {
    throw Exception('Failed to check');
  }
}
