import 'dart:convert';
import 'package:provider_api_demo/core/const/app_url.dart';
import 'package:provider_api_demo/core/model/comment_post_model.dart';
import 'package:provider_api_demo/core/model/post_model.dart';
import 'package:provider_api_demo/core/services/base_api_service.dart';
import 'package:provider_api_demo/core/services/network_client.dart';

class UserRepository {
  final BaseApiServices _baseApiServices = NetworkClient();

  Future<List<PostModelClass>> getAllPosts() async {
    try {
      final response = await _baseApiServices.getApiResponse(AppUrl.postDetailsUrl);

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        List<PostModelClass> posts = data.map((postData) => PostModelClass.fromJson(postData)).toList();
        return posts;
      } else {
        throw Exception('Failed to load posts');
      }
    } catch (e) {
      rethrow;
    }
  }


  Future<List<CommentModelClass>> getAllCommentsPosts() async {
    try {
      final response = await _baseApiServices.getApiResponse(AppUrl.commentsDetailsUrl);

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        List<CommentModelClass> comments = data.map((commentData) => CommentModelClass.fromJson(commentData)).toList();
        return comments;
      } else {
        throw Exception('Failed to load comments');
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<List<CommentModelClass>> fetchCommentsByPostId(int postId) async {
    try {
      final response = await _baseApiServices.getApiResponse('${AppUrl.postDetailsUrl}/$postId/comments');

      if (response.statusCode == 200) {
        final List<dynamic> commentData = json.decode(response.body);
        List<CommentModelClass> comments = commentData.map((commentDataItem) => CommentModelClass.fromJson(commentDataItem)).toList();
        return comments;
      } else {
        throw Exception('Failed to load comments');
      }
    } catch (e) {
      rethrow;
    }
  }

}
