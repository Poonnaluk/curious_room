// To parse this JSON data, do
//
//     final postHistoryModel = postHistoryModelFromJson(jsonString);

import 'dart:convert';
import 'package:http/http.dart' as http;

PostHistoryModel userModelFromJson(String str) =>
    PostHistoryModel.fromJson(json.decode(str));
String postHistoryModelToJson(PostHistoryModel data) =>
    json.encode(data.toJson());

class PostHistoryModel {
  PostHistoryModel(
      {required this.id,
      required this.content,
      this.image,
      required this.status,
      required this.postId,
      required this.createdAt,
      required this.updatedAt});

  int id;
  String content;
  String? image;
  bool status;
  int postId;
  DateTime createdAt;
  DateTime updatedAt;

  factory PostHistoryModel.fromJson(Map<String, dynamic> json) =>
      PostHistoryModel(
          id: json["id"] == null ? 0 : json["id"],
          content: json["content"] == null ? "" : json["content"],
          image: json["image"],
          status: json["status"],
          postId: json["postId"] == null ? 0 : json["postId"],
          createdAt: DateTime.parse(json["createdAt"]),
          updatedAt: DateTime.parse(json["updatedAt"]));

  Map<String, dynamic> toJson() => {
        "id": id,
        "content": content,
        "image": image,
        "status": status,
        "postId": postId,
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
      };
}

// http://147.182.209.40/post/history/
Future<List<PostHistoryModel>> getPostHistory(int postid) async {
  final String apiUrl = "http://147.182.209.40/post/history/$postid";
  final res = await http.get(Uri.parse(apiUrl));
  if (res.statusCode == 200) {
    Iterable l = json.decode(res.body);
    List<PostHistoryModel> postHistoryModel =
        l.map((g) => PostHistoryModel.fromJson(g)).toList();
    return postHistoryModel;
  } else if (res.statusCode == 500) {
    return [];
  } else {
    throw Exception('Failed to delete post');
  }
}
