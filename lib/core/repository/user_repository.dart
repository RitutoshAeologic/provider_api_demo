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
        List<PostModelClass> posts = [];

        for (var postData in data) {
          PostModelClass post = PostModelClass.fromJson(postData);
          posts.add(post);
        }
        return posts;
      } else {
        throw Exception('Failed to load posts');
      }
    }
    catch(e){
      rethrow;
    }
  }

   Future<List<CommentModelClass>> getAllCommentsPosts() async {
    try {
      dynamic response =
      await _baseApiServices.getApiResponse(AppUrl.commentsDetailsUrl);
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        List<CommentModelClass> comments = [];
        for (var postData in data) {
          CommentModelClass post = CommentModelClass.fromJson(postData);
          comments.add(post);
        }
        return comments;
      } else {
        throw Exception('Failed to load posts');
      }
    }
    catch (e){
      rethrow;
    }
  }

   Future<List<CommentModelClass>> fetchCommentsByPostId(int postId) async {
    try{
      final response = await _baseApiServices.getApiResponse('${AppUrl.postDetailsUrl}/$postId/comments');
      if (response.statusCode == 200) {
        final List<dynamic> commentData = json.decode(response.body);
        List<CommentModelClass> comments = [];
        for (var commentDataItem in commentData) {
          final comment = CommentModelClass.fromJson(commentDataItem);
          comments.add(comment);
        }
        return comments;
      } else {
        throw Exception('Failed to load comments');
      }
    }
    catch(e){
      rethrow;
    }
  }
}
