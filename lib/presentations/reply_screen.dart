import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '/providers/replies_provider.dart'; // Import your replies provider

class ReplyScreen extends ConsumerWidget {
  final int postId;

  const ReplyScreen({super.key, required this.postId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final repliesAsyncValue = ref.watch(repliesProvider(postId));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Replies'),
      ),
      body: repliesAsyncValue.when(
        data: (replies) => ListView.builder(
          itemCount: replies.length,
          itemBuilder: (context, index) {
            final reply = replies[index];
            return ListTile(
              title: Text(reply.content),
              subtitle: Text(
                  'User: ${reply.userId}'), // Replace with user information if available
            );
          },
        ),
        loading: () => const CircularProgressIndicator(),
        error: (error, _) => Text('Error: $error'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Implement the logic to add a new reply
        },
        child: const Icon(Icons.reply),
      ),
    );
  }
}
