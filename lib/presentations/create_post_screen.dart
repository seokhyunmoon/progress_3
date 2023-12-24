import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile2/providers/create_post_provider.dart'; // Provider for creating a post

class CreatePostScreen extends ConsumerWidget {
  final int categoryId; // Add this line

  const CreatePostScreen(
      {super.key, required this.categoryId}); // Modify this line

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final titleController = TextEditingController();
    final contentController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: const Text('글 쓰기'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            TextField(
              scrollPadding: EdgeInsets.all(10),
              controller: titleController,
              decoration: const InputDecoration(labelText: '제목'),
            ),
            TextField(
              scrollPadding: EdgeInsets.all(10),
              controller: contentController,
              decoration: const InputDecoration(labelText: '내용을 입력하세요.'),
              keyboardType: TextInputType.multiline,
              maxLines: null,
            ),
            ElevatedButton(
              onPressed: () async {
                int currentUserId = 1; // 현재 로그인한 사용자 ID

                final newPost = {
                  'title': titleController.text,
                  'content': contentController.text,
                  'userId': currentUserId,
                  'categoryId': categoryId, // 여기서 categoryId를 사용합니다
                  'upvotes': 0,
                  'downvotes': 0,
                  'createdAt': DateTime.now().toIso8601String(),
                };

                await ref.read(createPostProvider(newPost));
                Navigator.pop(context);
              },
              child: Text('완료'),
            )
          ],
        ),
      ),
    );
  }
}
