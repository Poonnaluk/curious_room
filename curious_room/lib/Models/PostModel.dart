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
      this.userId,
      this.roomId,
      this.statusPost,
      this.createdAt,
      this.updatedAt,
      required this.userPost,
      this.postHistory,
      this.statist,
      this.countVote,
      this.downVote,
      this.upVote,
      this.listVoteStatus});

  int? id;
  dynamic userId;
  int? roomId;
  String? statusPost;
  dynamic createdAt;
  DateTime? updatedAt;
  late UserModel userPost;
  PostHistoryModel? postHistory;
  int? statist;
  int? upVote;
  int? downVote;
  int? countVote;
  List<dynamic>? listVoteStatus;

  factory PostModel.fromJson(Map<String, dynamic> json) => PostModel(
        id: json["id"],
        userId: json["userId"],
        roomId: json["roomId"],
        statusPost: json["statusPost"],
        createdAt: json["createdAt"] == null
            ? null
            : DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null
            ? null
            : DateTime.parse(json["updatedAt"]),
        userPost: UserModel.fromJson(
            json["user_post"] == null ? {} : json["user_post"]),
        postHistory: PostHistoryModel.fromJson(
            json["post_history"] == null ? {} : json["post_history"]),
        statist: json["statist"],
        upVote: json["upVote"],
        downVote: json["downVote"],
        countVote: json["countVote"],
        listVoteStatus: json["listVoteStatus"] == null
            ? null
            : List<dynamic>.from(json["listVoteStatus"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "userId": userId,
        "roomId": roomId,
        "statusPost": statusPost,
        "createdAt": createdAt == null ? null : createdAt!.toIso8601String(),
        "updatedAt": updatedAt == null ? null : updatedAt!.toIso8601String(),
        "user_post": userPost.toJson(),
        "post_history": postHistory == null ? null : postHistory!.toJson(),
        "statist": statist,
        "upVote": upVote,
        "downVote": downVote,
        "countVote": countVote,
        "listVoteStatus": listVoteStatus == null
            ? null
            : List<dynamic>.from(listVoteStatus!.map((x) => x)),
      };
}

Future<List<PostModel>> getPost(int roomId, int userid, bool filter) async {
  final String url = "http://157.230.240.207:8000/post/$roomId/$userid/$filter";
  print(url);
  final res = await http.get(Uri.parse(url));
  if (res.statusCode == 200) {
    Iterable l = json.decode(res.body);
    List<PostModel> postModel = l.map((g) => PostModel.fromJson(g)).toList();
    return postModel;
  } else if (res.statusCode == 500) {
    return [];
  } else {
    throw Exception('Failed to get post');
  }
}

Future<void> creatPost(
    int userId, int roomId, String content, dynamic img) async {
  final String url = "http://157.230.240.207:8000/post";
  // ignore: avoid_init_to_null
  dynamic file = null;
  if (img != null) {
    File _image = img;
    final mimeTypeData = lookupMimeType(
      img.toString(),
      headerBytes: [0xFF, 0xD8],
    )!
        .split('/');
    file = await http.MultipartFile.fromPath("image", _image.path,
        contentType: MediaType(mimeTypeData[0], mimeTypeData[1]));
  }

  final imageUpload = http.MultipartRequest('POST', Uri.parse(url));
  imageUpload.headers.addAll({
    'Content-Type': 'multipart/form-data',
    'Accept-Encoding-Type': 'gzip, deflate, br',
    'Accept-': '*/*',
  });
  imageUpload.fields["userId"] = userId.toString();
  imageUpload.fields["roomId"] = roomId.toString();
  imageUpload.fields["content"] = content.toString();

  if (img != null) {
    imageUpload.files.add(file);
  }
  final streamedResponse = await imageUpload.send();
  final res = await http.Response.fromStream(streamedResponse);
  if (res.statusCode == 200) {
    return null;
  } else if (res.statusCode == 500) {
    return null;
  } else {
    throw Exception('Failed to create post');
  }
}

Future<bool> editPost(int postId, String content, dynamic img) async {
  final String url = "http://157.230.240.207:8000/post/edit";
  // ignore: avoid_init_to_null
  dynamic file = null;
  if (img != null) {
    File _image = img;
    final mimeTypeData = lookupMimeType(
      img.toString(),
      headerBytes: [0xFF, 0xD8],
    )!
        .split('/');
    file = await http.MultipartFile.fromPath("image", _image.path,
        contentType: MediaType(mimeTypeData[0], mimeTypeData[1]));
  }

  final imageUpload = http.MultipartRequest('PUT', Uri.parse(url));
  imageUpload.headers.addAll({
    'Content-Type': 'multipart/form-data',
    'Accept-Encoding-Type': 'gzip, deflate, br',
    'Accept-': '*/*',
  });
  imageUpload.fields["postId"] = postId.toString();
  imageUpload.fields["content"] = content.toString();
  if (img != null) {
    imageUpload.files.add(file);
  }
  final streamedResponse = await imageUpload.send();
  final res = await http.Response.fromStream(streamedResponse);
  if (res.statusCode == 200) {
    return true;
  } else if (res.statusCode == 500) {
    return false;
  } else {
    throw Exception('Failed to edit post');
  }
}

Future<bool> deletePost(int postid) async {
  final String apiUrl = "http://157.230.240.207:8000/post/delete/$postid";
  final res = await http.put(Uri.parse(apiUrl));
  if (res.statusCode == 200) {
    return true;
  } else if (res.statusCode == 500) {
    return false;
  } else {
    throw Exception('Failed to delete post');
  }
}
