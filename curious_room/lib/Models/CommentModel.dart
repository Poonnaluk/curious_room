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
    required this.confirmStatus,
    required this.createdAt,
    required this.updatedAt,
    required this.userComment,
    required this.commentHistory,
    required this.roomId,
  });

  int id;
  int postId;
  int userId;
  String statusComment;
  bool confirmStatus;
  DateTime createdAt;
  DateTime updatedAt;
  UserModel userComment;
  List<CommentHistory> commentHistory;
  int roomId;

  factory CommentModel.fromJson(Map<String, dynamic> json) => CommentModel(
        id: json["id"],
        postId: json["postId"],
        userId: json["userId"],
        statusComment: json["statusComment"],
        confirmStatus: json["confirmStatus"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
        userComment: UserModel.fromJson(json["user_comment"]),
        commentHistory: List<CommentHistory>.from(
            json["comment_history"].map((x) => CommentHistory.fromJson(x))),
        roomId: json["roomId"] == null ? 0 : json["roomId"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "postId": postId,
        "userId": userId,
        "statusComment": statusComment,
        "confirmStatus": confirmStatus,
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
        "user_comment": userComment.toJson(),
        "comment_history":
            List<dynamic>.from(commentHistory.map((x) => x.toJson())),
        "roomId": roomId == null ? null : roomId.toInt(),
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
  final String url = "http://157.230.240.207:8000/comment/$postId";
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

Future<dynamic> createComment(int? postid, int userid, String content) async {
  final url = "http://157.230.240.207:8000/comment";
  print(url);
  final body =
      jsonEncode({"postId": postid, "userId": userid, "content": content});
  final response = await http.post(Uri.parse(url),
      body: body,
      headers: {'Content-Type': 'application/json', 'Accept': '*/*'});
  if (response.statusCode == 200) {
    return jsonDecode(response.body);
  } else {
    throw Exception('Failed to create comment.');
  }
}

Future<bool> delComment(int commentid) async {
  final url = "http://157.230.240.207:8000/comment/delete/$commentid";
  final res = await http.put(Uri.parse(url));
  if (res.statusCode == 200) {
    return true;
  } else if (res.statusCode == 500) {
    return false;
  } else {
    throw Exception('Failed to delete comment.');
  }
}

Future<bool> editComment(int commentid, String content) async {
  final url = "http://157.230.240.207:8000/comment/edit";
  final body = jsonEncode({"commentId": commentid, "content": content});
  final res = await http.put(Uri.parse(url),
      body: body,
      headers: {'Content-Type': 'application/json', 'Accept': '*/*'});
  if (res.statusCode == 200) {
    return true;
  } else if (res.statusCode == 500) {
    return false;
  } else {
    throw Exception('Failed to edit comment.');
  }
}

Future<bool> confirmComment(int? postid, int commentid) async {
  final url = "http://157.230.240.207:8000/comment/editConfirm";
  print(commentid);
  final body = jsonEncode({"postId": postid, "commentId": commentid});
  final res = await http.put(Uri.parse(url),
      body: body,
      headers: {'Content-Type': 'application/json', 'Accept': '*/*'});
  if (res.statusCode == 200) {
    return true;
  } else if (res.statusCode == 500) {
    return false;
  } else {
    throw Exception('Failed to confirm comment.');
  }
}

Future<bool> unConfirmComment(int commentid) async {
  final url = "http://157.230.240.207:8000/comment/confirm/$commentid";
  print(commentid);
  final res = await http.put(Uri.parse(url));
  if (res.statusCode == 200) {
    return true;
  } else if (res.statusCode == 500) {
    return false;
  } else {
    throw Exception('Failed to un confirm comment.');
  }
}
