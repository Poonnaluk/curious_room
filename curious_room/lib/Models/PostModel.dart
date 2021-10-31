// To parse this JSON data, do
//
//     final postModel = postModelFromJson(jsonString);

import 'dart:convert';
import 'dart:io';
import 'package:curious_room/Models/PostHistory.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';
import 'UserModel.dart';

List<PostModel> postModelFromJson(String str) =>
    List<PostModel>.from(json.decode(str).map((x) => PostModel.fromJson(x)));

String postModelToJson(List<PostModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class PostModel {
  PostModel(
      {this.id,
      required this.userId,
      required this.roomId,
      this.statusPost,
      required this.createdAt,
      this.updatedAt,
      this.commentId,
      required this.userPost,
      required this.postHistory});

  int? id;
  int userId;
  int roomId;
  String? statusPost;
  DateTime createdAt;
  DateTime? updatedAt;
  int? commentId;
  late UserModel userPost;
  late List<PostHistoryModel> postHistory;

  factory PostModel.fromJson(Map<String, dynamic> json) => PostModel(
        id: json["id"],
        userId: json["userId"],
        roomId: json["roomId"],
        statusPost: json["statusPost"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
        commentId: json["commentId"],
        userPost: UserModel.fromJson(
            json["user_post"] == null ? {} : json["user_post"]),
        postHistory: List<PostHistoryModel>.from(
            json["post_history"].map((x) => PostHistoryModel.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "userId": userId,
        "roomId": roomId,
        "statusPost": statusPost,
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt!.toIso8601String(),
        "commentId": commentId,
        "user_post": userPost.toJson(),
        "post_history": List<dynamic>.from(postHistory.map((x) => x.toJson())),
      };
}

Future<List<PostModel>> getPost(int roomId) async {
  final String url = "http://147.182.209.40/post/$roomId";
  // final String url = "http://147.182.209.40/post/$roomId";
  print(url);
  final res = await http.get(Uri.parse(url));
  if (res.statusCode == 200) {
    Iterable l = json.decode(res.body);
    List<PostModel> postModel = l.map((g) => PostModel.fromJson(g)).toList();
    return postModel;
    // Map<String, dynamic> map = json.decode(res.body);
    // List<dynamic> data = map["post_history"];
  } else {
    throw Exception('Failed to check');
  }
}

Future<void> creatPost(int userId, int roomId, String content, File img) async {
  final String url = "http://147.182.209.40/post";
  final mimeTypeData = lookupMimeType(
    img.toString(),
    headerBytes: [0xFF, 0xD8],
  )!
      .split('/');
  final imageUpload = http.MultipartRequest('POST', Uri.parse(url));
  final file = await http.MultipartFile.fromPath("image", img.toString(),
      contentType: MediaType(mimeTypeData[0], mimeTypeData[1]));
  imageUpload.headers.addAll({
    'Content-Type': 'multipart/form-data',
    'Accept-Encoding-Type': 'gzip, deflate, br',
    'Accept-': '*/*',
  });
  imageUpload.fields["userId"] = userId.toString();
  imageUpload.fields["roomId"] = roomId.toString();
  imageUpload.fields["content"] = content.toString();
  imageUpload.files.add(file);
  final streamedResponse = await imageUpload.send();
  final res = await http.Response.fromStream(streamedResponse);
  if (res.statusCode == 200) {
    return null;
  } else if (res.statusCode == 500) {
    return null;
  } else {
    throw Exception('Failed to check');
  }
}
