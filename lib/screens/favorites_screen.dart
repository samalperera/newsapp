import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/news_provider.dart';
import 'news_detail_screen.dart';

class FavoritesScreen extends StatefulWidget {
  @override
  _FavoritesScreenState createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  String _sortOrder = 'Latest';

  void _sortFavorites(String order) {
    final newsProvider = Provider.of<NewsProvider>(context, listen: false);
    newsProvider.favorites.sort((a, b) {
      final dateA = DateTime.tryParse(a['publishedAt'] ?? '') ?? DateTime.now();
      final dateB = DateTime.tryParse(b['publishedAt'] ?? '') ?? DateTime.now();
      return order == 'Latest' ? dateB.compareTo(dateA) : dateA.compareTo(dateB);
    });
    setState(() {
      _sortOrder = order;
    });
  }

  @override
  Widget build(BuildContext context) {
    final newsProvider = Provider.of<NewsProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Favorite Articles'),
        actions: [
          PopupMenuButton<String>(
            onSelected: _sortFavorites,
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'Latest',
                child: Text('Sort by Latest'),
              ),
              PopupMenuItem(
                value: 'Earliest',
                child: Text('Sort by Earliest'),
              ),
            ],
          ),
        ],
      ),
      body: newsProvider.favorites.isEmpty
          ? Center(
        child: Text(
          'No favorite articles yet.',
          style: TextStyle(fontSize: 18),
        ),
      )
          : ListView.builder(
        itemCount: newsProvider.favorites.length,
        itemBuilder: (ctx, index) {
          final article = newsProvider.favorites[index];
          return Card(
            margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: ListTile(
              leading: article['urlToImage'] != null
                  ? ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  article['urlToImage'],
                  width: 50,
                  height: 50,
                  fit: BoxFit.cover,
                ),
              )
                  : Container(
                width: 50,
                height: 50,
                color: Colors.grey,
                alignment: Alignment.center,
                child: Icon(Icons.image, color: Colors.white),
              ),
              title: Text(
                article['title'] ?? 'No Title',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                article['source']['name'] ?? 'Unknown Source',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(color: Colors.grey),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (ctx) => NewsDetailScreen(article: article),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
