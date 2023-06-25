import 'package:flutter/material.dart';
import 'package:provider_api_demo/core/model/comment_post_model.dart';
import 'package:provider_api_demo/core/model/merged_post_comment.dart';
import 'package:provider_api_demo/core/model/post_model.dart';
import 'package:provider_api_demo/core/repository/user_repository.dart';

class HomeViewModel extends ChangeNotifier {
  Future<List<MergedPostComment>>? _mergedDataFuture;
  List<MergedPostComment> _filteredData = [];
  Set<CommentModelClass> _selectedComments = {};

  Future<List<MergedPostComment>>? get mergedDataFuture => _mergedDataFuture;
  List<MergedPostComment> get filteredData => _filteredData;

  void init() {
    _mergedDataFuture = fetchMergedData();
  }

  final UserRepository _userRepository = UserRepository();

  Future<List<MergedPostComment>> fetchMergedData() async {
    try {
      final List<PostModelClass> posts = await _userRepository.getAllPosts();

      List<Future<List<CommentModelClass>>> commentFutures = [];

      for (PostModelClass post in posts) {
        commentFutures.add(_userRepository.fetchCommentsByPostId(post.id!));
      }

      List<List<CommentModelClass>> postComments = await Future.wait(commentFutures);

      List<MergedPostComment> mergedData = [];

      for (int i = 0; i < posts.length; i++) {
        mergedData.add(
          MergedPostComment(
            postId: posts[i].id!,
            postTitle: posts[i].title!,
            postBody: posts[i].body!,
            comments: postComments[i],
          ),
        );
      }

      return mergedData;
    } catch (e) {
      throw e;
    }
  }


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



  bool isSelected(CommentModelClass comment) {
    return _selectedComments.contains(comment);
  }

  void toggleSelection(CommentModelClass comment) {
    if (_selectedComments.contains(comment)) {
      _selectedComments.remove(comment);
    } else {
      _selectedComments.add(comment);
    }
    notifyListeners();
  }
}