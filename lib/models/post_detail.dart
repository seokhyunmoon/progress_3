import 'package:json_annotation/json_annotation.dart';

part 'post_detail.g.dart';

@JsonSerializable()
class PostDetail {
  final int id;
  final String title;
  final String content;
  // Include other fields relevant for post details, like user information, comments, etc.

  PostDetail({
    required this.id,
    required this.title,
    required this.content,
  });

  factory PostDetail.fromJson(Map<String, dynamic> json) =>
      _$PostDetailFromJson(json);
  Map<String, dynamic> toJson() => _$PostDetailToJson(this);
}
