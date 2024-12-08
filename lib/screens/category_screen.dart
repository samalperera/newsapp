import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/news_provider.dart';

class CategoryScreen extends StatelessWidget {
  final List<String> categories = [
    'business',
    'entertainment',
    'general',
    'health',
    'science',
    'sports',
    'technology'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Select Category'),
        actions: [
          IconButton(
            icon: Icon(Icons.home),
            onPressed: () {
              // Reset category to 'General' and navigate back to HomeScreen
              Provider.of<NewsProvider>(context, listen: false).setCategory('General');
              Navigator.pop(context, null);
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: categories.length,
        itemBuilder: (ctx, index) {
          return ListTile(
            title: Text(
              categories[index].toUpperCase(),
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            onTap: () {
              Provider.of<NewsProvider>(context, listen: false)
                  .fetchNews(category: categories[index]);
              Provider.of<NewsProvider>(context, listen: false)
                  .setCategory(categories[index]);
              Navigator.pop(context, categories[index]);
            },
          );
        },
      ),
    );
  }
}
