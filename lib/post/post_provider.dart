import 'package:flutter_sample/post/api/api_service.dart';
import 'package:flutter_sample/post/post.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'post_provider.g.dart';

@riverpod
Future<List<Post>> posts(PostsRef ref) async {
  final apiService = ref.watch(apiServiceProvider);
  final posts = await apiService.getPosts();
  return posts;
}
