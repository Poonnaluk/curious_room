import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:curious_room/Models/UserModel.dart';

List<CommentModel> commentModelFromJson(String str) => List<CommentModel>.from(
    json.decode(str).map((x) => CommentModel.fromJson(x)));

String commentModelToJson(List<CommentModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class CommentModel {
  CommentModel({
    required this.id,
    required this.postId,
    required this.userId,
    required this.statusComment,
    required this.createdAt,
    required this.updatedAt,
    required this.userComment,
    required this.commentHistory,
  });

  int id;
  int postId;
  int userId;
  String statusComment;
  DateTime createdAt;
  DateTime updatedAt;
  UserModel userComment;
  List<CommentHistory> commentHistory;

  factory CommentModel.fromJson(Map<String, dynamic> json) => CommentModel(
        id: json["id"],
        postId: json["postId"],
        userId: json["userId"],
        statusComment: json["statusComment"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
        userComment: UserModel.fromJson(json["user_comment"]),
        commentHistory: List<CommentHistory>.from(
            json["comment_history"].map((x) => CommentHistory.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "postId": postId,
        "userId": userId,
        "statusComment": statusComment,
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
        "user_comment": userComment.toJson(),
        "comment_history":
            List<dynamic>.from(commentHistory.map((x) => x.toJson())),
      };
}

class CommentHistory {
  CommentHistory({
    required this.id,
    required this.content,
    required this.commentId,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  int id;
  String content;
  int commentId;
  bool status;
  DateTime createdAt;
  DateTime updatedAt;

  factory CommentHistory.fromJson(Map<String, dynamic> json) => CommentHistory(
        id: json["id"],
        content: json["content"],
        commentId: json["commentId"],
        status: json["status"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "content": content,
        "commentId": commentId,
        "status": status,
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
      };
}

Future<List<CommentModel>> getComment(int postId) async {
  final String url = "http://147.182.209.40/comment/$postId";
  print(url);
  final res = await http.get(Uri.parse(url));
  if (res.statusCode == 200) {
    Iterable l = json.decode(res.body);
    List<CommentModel> commentModel =
        l.map((g) => CommentModel.fromJson(g)).toList();
    return commentModel;
  } else if (res.statusCode == 500) {
    return [];
  } else {
    throw Exception('Failed to get post');
  }
}
