import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_sample/post/api/api_service.dart';
import 'package:flutter_sample/post/post.dart';

final postsProvider = FutureProvider<List<Post>>((ref) async {
  final apiService = ref.watch(apiServiceProvider);
  final posts = await apiService.getPosts();
  return posts;
});
