// To parse this JSON data, do
//
//     final postHistoryModel = postHistoryModelFromJson(jsonString);

import 'dart:convert';

PostHistoryModel postHistoryModelFromJson(String str) => PostHistoryModel.fromJson(json.decode(str));

String postHistoryModelToJson(PostHistoryModel data) => json.encode(data.toJson());

class PostHistoryModel {
    PostHistoryModel({
        required this.id,
        required this.content,
        this.image,
        required this.status,
        required this.postId,
        required this.createdAt,
        required this.updatedAt,
    });

    int id;
    String content;
    String? image;
    String status;
    int postId;
    DateTime createdAt;
    DateTime updatedAt;

    factory PostHistoryModel.fromJson(Map<String, dynamic> json) => PostHistoryModel(
        id: json["id"],
        content: json["content"],
        image: json["image"],
        status: json["status"],
        postId: json["postId"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
    );

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
