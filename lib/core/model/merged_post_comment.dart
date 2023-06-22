

import 'comment_post_model.dart';

class MergedPostComment {
  final int postId;
  final String postTitle;
  final String postBody;
  final List<CommentModelClass> comments;

  MergedPostComment({
    required this.postId,
    required this.postTitle,
    required this.postBody,
    required this.comments,
  });
}
