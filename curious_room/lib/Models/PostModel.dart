// To parse this JSON data, do
//
//     final postModel = postModelFromJson(jsonString);

import 'dart:convert';
import 'dart:io';
// import 'dart:html';

import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

import 'package:mime/mime.dart';

PostModel postModelFromJson(String str) => PostModel.fromJson(json.decode(str));

String postModelToJson(PostModel data) => json.encode(data.toJson());

class PostModel {
  PostModel({
    this.id,
    required this.userId,
    required this.roomId,
    this.statusPost,
    this.createdAt,
    this.updatedAt,
    this.commentId,
  });

  int? id;
  int userId;
  int roomId;
  String? statusPost;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? commentId;

  factory PostModel.fromJson(Map<String, dynamic> json) => PostModel(
        id: json["id"],
        userId: json["userId"],
        roomId: json["roomId"],
        statusPost: json["statusPost"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
        commentId: json["commentId"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "userId": userId,
        "roomId": roomId,
        "statusPost": statusPost,
        "createdAt": createdAt!.toIso8601String(),
        "updatedAt": updatedAt!.toIso8601String(),
        "commentId": commentId,
      };
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
