import 'package:flutter/material.dart';

class NewsDetailPage extends StatelessWidget {
  final dynamic article;

  const NewsDetailPage({super.key, required this.article});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(article['title'])),
      body: SingleChildScrollView(  // Wrap the content with SingleChildScrollView
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            article['urlToImage'] != null
                ? Image.network(article['urlToImage'])
                : Container(),
            SizedBox(height: 10),
            Text(
              article['title'],
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              article['description'] ?? '',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 20),
            Text(
              'Content:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              article['content'] ?? 'No content available',
              style: TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}