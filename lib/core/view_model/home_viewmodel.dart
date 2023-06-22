import 'package:flutter/material.dart';
import 'package:provider_api_demo/core/model/comment_post_model.dart';
import 'package:provider_api_demo/core/model/merged_post_comment.dart';
import 'package:provider_api_demo/core/model/post_model.dart';
import 'package:provider_api_demo/core/repository/user_repository.dart';

class HomeViewModel extends ChangeNotifier {

  Future<List<MergedPostComment>>? _mergedDataFuture;
  List<MergedPostComment> _filteredData = [];

  Future<List<MergedPostComment>>? get mergedDataFuture => _mergedDataFuture;
  List<MergedPostComment> get filteredData => _filteredData;

  void init() {
    _mergedDataFuture = fetchMergedData();
  }
  final UserRepository _userRepository = UserRepository();

  Future<List<MergedPostComment>> fetchMergedData() async {
    try {
        final List<PostModelClass> posts = await _userRepository.getAllPosts();

        List<MergedPostComment> mergedData = [];

        for (PostModelClass post in posts) {
          List<CommentModelClass> postComments =
          await _userRepository.fetchCommentsByPostId(post.id!);
          mergedData.add(
            MergedPostComment(
              postId: post.id!,
              postTitle: post.title!,
              postBody: post.body!,
              comments: postComments,
            ),
          );
        }
        notifyListeners();
        return mergedData;
    } catch (e) {
      notifyListeners();
      rethrow;
    }
  }

  // void filterData(int postId) {
  //   if (postId != 0) {
  //     mergedDataFuture?.then((mergedData) {
  //       final List<MergedPostComment> filteredData =
  //       mergedData.where((data) => data.postId == postId).toList();
  //       _filteredData = filteredData;
  //       notifyListeners();
  //     });
  //   } else {
  //     mergedDataFuture?.then((mergedData) {
  //       _filteredData = mergedData.toList();
  //       notifyListeners();
  //     });
  //   }
  // }

  void filterData(int postId) {
    if (postId != 0) {
      mergedDataFuture?.then((mergedData) {
        final List<MergedPostComment> filteredData =
        mergedData.where((data) => data.postId == postId).toList();
        _filteredData = filteredData;
        notifyListeners();
      });
    } else {
      mergedDataFuture?.then((mergedData) {
        if (mergedData != null) {
          _filteredData = mergedData.toList();
        } else {
          _filteredData = [];
        }
        notifyListeners();
      });
    }
  }
}
