import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:provider_api_demo/core/model/comment_post_model.dart';
import 'package:provider_api_demo/core/model/merged_post_comment.dart';
import 'package:provider_api_demo/core/view_model/home_viewmodel.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    final homeProvider = Provider.of<HomeViewModel>(context, listen: false);
    homeProvider.init();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<HomeViewModel>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Posts'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.all(8),
              child: TextField(
                maxLength: 3,
                onChanged: (value) => provider.filterData(int.tryParse(value) ?? 0),
              ),
            ),
            Expanded(
              child: FutureBuilder<List<MergedPostComment>>(
                future: provider.mergedDataFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else {
                    final List<MergedPostComment>? mergedData = snapshot.data;
                    final List<MergedPostComment>? displayedData =
                    provider.filteredData.isNotEmpty
                        ? provider.filteredData
                        : mergedData;
                    return
                      ListView.builder(
                      itemCount: displayedData?.length,
                      itemBuilder: (context, index) {
                        final MergedPostComment data = displayedData![index];
                        return
                          Container(
                          width: MediaQuery.of(context).size.width,
                          padding: EdgeInsets.all(8),
                          margin: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.black, width: 1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: ListTile(
                            title: Text('ID: ${data.postId}'),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Title: ${data.postTitle}'),
                                Text('Body: ${data.postBody}'),
                                SizedBox(height: 8),
                                Text(
                                    'Comments (${data.comments.length}):'),
                                Container(
                                  width: MediaQuery.of(context).size.width,
                                  padding: EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Colors.grey,
                                      width: 0.5,
                                    ),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: ListView.builder(
                                    shrinkWrap: true,
                                    physics: NeverScrollableScrollPhysics(),
                                    itemCount: data.comments.length,
                                    itemBuilder: (context, commentIndex) {
                                      final CommentModelClass comment =
                                      data.comments[commentIndex];
                                      return Container(
                                        width:
                                        MediaQuery.of(context).size.width,
                                        padding: EdgeInsets.all(8),
                                        margin: EdgeInsets.all(8),
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                            color: Colors.black,
                                            width: 0.2,
                                          ),
                                          borderRadius:
                                          BorderRadius.circular(12),
                                        ),
                                        child: Column(
                                          crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                          children: [
                                            Text('Post ID: ${comment.postId}'),
                                            Text('Name: ${comment.name}'),
                                            Text('Email: ${comment.email}'),
                                            Text('Body: ${comment.body}'),
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
