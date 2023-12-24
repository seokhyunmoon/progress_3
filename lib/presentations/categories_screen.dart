import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '/providers/categories_provider.dart';
import '/presentations/posts_screen.dart';

class CategoriesScreen extends ConsumerWidget {
  const CategoriesScreen({Key? key}) : super(key: key);

  void _showAddBoardDialog(BuildContext context, WidgetRef ref) {
    final TextEditingController _controller = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('새 게시판 추가'),
          content: TextField(
            controller: _controller,
            decoration: InputDecoration(hintText: '게시판 이름'),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('취소'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: Text('추가'),
              onPressed: () async {
                String boardName = _controller.text;
                await _addBoardToServer(boardName, ref, context);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _addBoardToServer(String boardName, WidgetRef ref, BuildContext context) async {
      final response = await http.post(
        Uri.parse('http://localhost:3000/categories'), 
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'name': boardName}),
      );

      if (response.statusCode == 201) {
        // 성공적으로 게시판을 추가했을 때 애니메이션 (스낵바)
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('게시판 "$boardName" 추가 성공'), duration: Duration(seconds: 2)),
        );
        ref.refresh(categoriesProvider);
      } else {
        // 게시판 추가 실패시 스낵바
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('게시판 추가 실패'), duration: Duration(seconds: 2)),
        );
      }
  }


  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categoriesAsyncValue = ref.watch(categoriesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('게시판 목록'),
      ),
      body: categoriesAsyncValue.when(
        data: (categories) => ListView.builder(
          itemCount: categories.length,
          itemBuilder: (context, index) {
            final category = categories[index];
            return ListTile(
              title: Text(category.name),
              leading: Icon(Icons.push_pin_outlined),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          PostsScreen(categoryId: category.id)),
                );
              },
            );
          },
        ),
        loading: () => const CircularProgressIndicator(),
        error: (error, _) => Text('Error: $error'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddBoardDialog(context, ref),
        child: const Icon(Icons.add),
      ),
    );
  }
}
