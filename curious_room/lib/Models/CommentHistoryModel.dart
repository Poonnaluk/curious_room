import 'dart:convert';
import 'package:http/http.dart' as http;

List<CommentHistoryModel> commentHistoryModelFromJson(String str) =>
    List<CommentHistoryModel>.from(
        json.decode(str).map((x) => CommentHistoryModel.fromJson(x)));

String commentHistoryModelToJson(List<CommentHistoryModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class CommentHistoryModel {
  CommentHistoryModel({
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

  factory CommentHistoryModel.fromJson(Map<String, dynamic> json) =>
      CommentHistoryModel(
        id: json["id"] == null ? 0 : json["id"],
        content: json["content"] == null ? "" : json["content"],
        commentId: json["commentId"] == null ? 0 : json["commentId"],
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

Future<List<CommentHistoryModel>> getCommentHistory(int commentid) async {
  final String apiUrl = "http://157.230.240.207:8000/comment/history/$commentid";
  final res = await http.get(Uri.parse(apiUrl));
  if (res.statusCode == 200) {
    Iterable l = json.decode(res.body);
    List<CommentHistoryModel> postHistoryModel =
        l.map((g) => CommentHistoryModel.fromJson(g)).toList();
    return postHistoryModel;
  } else if (res.statusCode == 500) {
    return [];
  } else {
    throw Exception('Failed to get comment history');
  }
}
