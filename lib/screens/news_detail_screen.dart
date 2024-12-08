import 'package:flutter/material.dart';

class NewsDetailScreen extends StatelessWidget {
  final dynamic article;

  NewsDetailScreen({required this.article});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('News Detail'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // Go back to the previous screen
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Display the news image
            article['urlToImage'] != null
                ? ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                article['urlToImage'],
                fit: BoxFit.cover,
                width: double.infinity,
              ),
            )
                : Container(
              height: 200,
              color: Colors.grey,
              alignment: Alignment.center,
              child: Text('No Image Available'),
            ),
            SizedBox(height: 16),

            // Display the title
            Text(
              article['title'] ?? 'No Title',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),

            // Display the source and publication date
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  article['source']['name'] ?? 'Unknown Source',
                  style: TextStyle(color: Colors.grey, fontSize: 16),
                ),
                Text(
                  article['publishedAt']?.split('T')[0] ?? 'No Date',
                  style: TextStyle(color: Colors.grey, fontSize: 16),
                ),
              ],
            ),
            SizedBox(height: 20),

            // Display the description
            Text(
              article['description'] ?? 'No Description Available',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 10),

            // Display the full content
            Text(
              article['content'] ?? 'Full content not available.',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
