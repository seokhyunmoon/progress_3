import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:mobile2/providers/post_detail_provider.dart';
import 'package:mobile2/providers/replies_provider.dart'; // Import the replies provider

class PostDetailScreen extends ConsumerWidget {
  final int postId;

  const PostDetailScreen({super.key, required this.postId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final postDetailAsyncValue = ref.watch(postDetailProvider(postId));
    final repliesAsyncValue = ref.watch(repliesProvider(postId));
    final replyController = TextEditingController();

    return Scaffold(
      appBar: AppBar(),
      body: postDetailAsyncValue.when(
        data: (postDetail) => SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(postDetail.title,
                  style: const TextStyle(
                      fontSize: 24, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              Text(postDetail.content),
              const SizedBox(height: 20),
              TextField(
                controller: replyController,
                decoration: const InputDecoration(labelText: '댓글을 입력하세요.'),
                keyboardType: TextInputType.multiline,
                maxLines: null,
              ),
              ElevatedButton(
                onPressed: () async {
                  final newReply = {
                    'postId': postId,
                    'userId': 1, // Replace with actual user ID retrieval logic
                    'content': replyController.text,
                    'createdAt': DateTime.now().toIso8601String(),
                  };

                  await http.post(
                    Uri.parse('http://localhost:3000/replies'),
                    headers: {'Content-Type': 'application/json'},
                    body: jsonEncode(newReply),
                  );

                  replyController.clear();
                  ref.refresh(repliesProvider(postId));
                },
                child: const Text('확인'),
              ),
              const SizedBox(height: 10),
              const Text('Replies:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              repliesAsyncValue.when(
                data: (replies) => ListView.builder(
                  shrinkWrap: true,
                  physics:
                      const NeverScrollableScrollPhysics(), // to disable ListView's scrolling
                  itemCount: replies.length,
                  itemBuilder: (context, index) {
                    final reply = replies[index];
                    return ListTile(
                      title: Text(reply.content),
                      subtitle: Text(
                          'User ${reply.userId}'), // Replace with user info if available
                    );
                  },
                ),
                loading: () => const CircularProgressIndicator(),
                error: (error, _) => Text('Error: $error'),
              ),
            ],
          ),
        ),
        loading: () => const CircularProgressIndicator(),
        error: (error, _) => Text('Error: $error'),
      ),
    );
  }
}
