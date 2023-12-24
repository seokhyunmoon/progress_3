import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:mobile2/providers/posts_provider.dart';
import 'package:mobile2/presentations/post_detail_screen.dart';
import 'package:mobile2/presentations/create_post_screen.dart';

class PostsScreen extends ConsumerStatefulWidget {
  final int categoryId;

  const PostsScreen({Key? key, required this.categoryId}) : super(key: key);

  @override
  _PostsScreenState createState() => _PostsScreenState();
}

class _PostsScreenState extends ConsumerState<PostsScreen> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scaleAnimation;
  late final Animation<Color?> _colorAnimation;
  bool isNavigating = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.5).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _colorAnimation = ColorTween(begin: Colors.blue, end: Colors.red).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _controller.reverse();
      } else if (status == AnimationStatus.dismissed && isNavigating) {
        isNavigating = false;
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CreatePostScreen(categoryId: widget.categoryId),
          ),
        );
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onCreatePostPressed() {
    _controller.forward();
    isNavigating = true;
  }

  @override
  Widget build(BuildContext context) {
    final postsAsyncValue = ref.watch(postsProvider(widget.categoryId));

    return Scaffold(
      appBar: AppBar(
        title: const Text('게시물'),
      ),
      body: postsAsyncValue.when(
        data: (posts) => ListView.builder(
          itemCount: posts.length,
          itemBuilder: (context, index) {
            final post = posts[index];
            return ListTile(
              title: Text(post.title),
              subtitle: Text(post.content),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  IconButton(
                    icon: const Icon(Icons.thumb_up),
                    onPressed: () async {
                      await http.patch(
                        Uri.parse('http://localhost:3000/posts/${post.id}'),
                        headers: {'Content-Type': 'application/json'},
                        body: jsonEncode({'upvotes': post.upvotes + 1}),
                      );
                      ref.refresh(postsProvider(widget.categoryId));
                    },
                  ),
                  Text('${post.upvotes}'), // Display the number of upvotes
                  IconButton(
                    icon: const Icon(Icons.thumb_down),
                    onPressed: () async {
                      await http.patch(
                        Uri.parse('http://localhost:3000/posts/${post.id}'),
                        headers: {'Content-Type': 'application/json'},
                        body: jsonEncode({'downvotes': post.downvotes + 1}),
                      );
                      ref.refresh(postsProvider(widget.categoryId));
                    },
                  ),
                  Text('${post.downvotes}'), // Display the number of downvotes
                ],
              ),

              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => PostDetailScreen(postId: post.id)),
                );
              },
            );
          },
        ),
        loading: () => const CircularProgressIndicator(),
        error: (error, _) => Text('Error: $error'),
      ),
      floatingActionButton: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: FloatingActionButton(
              onPressed: _onCreatePostPressed,
              child: const Icon(Icons.add),
              backgroundColor: _colorAnimation.value,
            ),
          );
        },
      ),
    );
  }
}
