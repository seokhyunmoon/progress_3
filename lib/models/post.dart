import 'package:json_annotation/json_annotation.dart';

part 'post.g.dart';

@JsonSerializable()
class Post {
  int id;
  int userId;
  String title;
  String content;
  int upvotes;
  int downvotes;
  DateTime createdAt;

  Post({
    required this.id,
    required this.userId,
    required this.title,
    required this.content,
    this.upvotes = 0,
    this.downvotes = 0,
    required this.createdAt,
  });

  Post copyWith({
    int? upvotes,
    int? downvotes,
  }) {
    return Post(
      id: this.id,
      userId: this.userId,
      title: this.title,
      content: this.content,
      upvotes: upvotes ?? this.upvotes,
      downvotes: downvotes ?? this.downvotes,
      createdAt: this.createdAt,
    );
  }

  factory Post.fromJson(Map<String, dynamic> json) => _$PostFromJson(json);
  Map<String, dynamic> toJson() => _$PostToJson(this);
}
