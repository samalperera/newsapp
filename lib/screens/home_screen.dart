import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'favorites_screen.dart';
import 'news_detail_screen.dart';
import 'category_screen.dart';
import '../providers/news_provider.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();
  bool _isSearchVisible = false;
  bool _isBackToTopVisible = false;

  @override
  void initState() {
    super.initState();
    _fetchLatestNews();
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _fetchLatestNews() {
    Provider.of<NewsProvider>(context, listen: false).fetchNews();
  }

  void _searchNews() {
    final query = _searchController.text.trim();
    if (query.isNotEmpty) {
      Provider.of<NewsProvider>(context, listen: false).fetchNews(query: query);
    }
    setState(() {
      _isSearchVisible = false;
      _searchController.clear();
    });
  }

  void _sortNews(String order) {
    final articles = Provider.of<NewsProvider>(context, listen: false).articles;
    articles.sort((a, b) {
      final dateA = DateTime.tryParse(a['publishedAt'] ?? '') ?? DateTime.now();
      final dateB = DateTime.tryParse(b['publishedAt'] ?? '') ?? DateTime.now();
      return order == 'Latest' ? dateB.compareTo(dateA) : dateA.compareTo(dateB);
    });
    setState(() {});
  }

  void _scrollToTop() {
    _scrollController.animateTo(
      0.0,
      duration: Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  void _scrollListener() {
    if (_scrollController.offset > 100) {
      if (!_isBackToTopVisible) {
        setState(() {
          _isBackToTopVisible = true;
        });
      }
    } else {
      if (_isBackToTopVisible) {
        setState(() {
          _isBackToTopVisible = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final newsProvider = Provider.of<NewsProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: _isSearchVisible
            ? TextField(
          controller: _searchController,
          decoration: InputDecoration(
            hintText: 'Search news...',
            border: InputBorder.none,
            hintStyle: TextStyle(color: Colors.grey),
          ),
          style: TextStyle(color: Colors.black),
          onSubmitted: (_) => _searchNews(),
        )
            : Text(
          'Global News - ${newsProvider.currentCategory}',
          style: TextStyle(fontSize: 14),
        ),
        actions: [
          IconButton(
            icon: Icon(_isSearchVisible ? Icons.close : Icons.search),
            onPressed: () {
              setState(() {
                _isSearchVisible = !_isSearchVisible;
              });
            },
          ),
          PopupMenuButton<String>(
            onSelected: _sortNews,
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
          IconButton(
            icon: Icon(Icons.category),
            onPressed: () async {
              final categorySelected = await Navigator.push(
                context,
                MaterialPageRoute(builder: (ctx) => CategoryScreen()),
              );
              if (categorySelected == null) {
                _fetchLatestNews();
              }
            },
          ),
          IconButton(
            icon: Icon(Icons.favorite),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (ctx) => FavoritesScreen()),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: newsProvider.isLoading
                ? Center(child: CircularProgressIndicator())
                : Stack(
              children: [
                ListView.builder(
                  controller: _scrollController,
                  itemCount: newsProvider.articles.length,
                  itemBuilder: (ctx, index) {
                    final article = newsProvider.articles[index];
                    final isFavorite =
                    newsProvider.isFavorite(article);

                    return Card(
                      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [

                          article['urlToImage'] != null
                              ? ClipRRect(
                            borderRadius: BorderRadius.vertical(
                                top: Radius.circular(8)),
                            child: Image.network(
                              article['urlToImage'],
                              height: 200,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            ),
                          )
                              : Container(
                            height: 200,
                            color: Colors.grey,
                            alignment: Alignment.center,
                            child: Text('No Image Available'),
                          ),
                          // Article Details
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  article['title'] ?? 'No Title',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                ),
                                SizedBox(height: 8),
                                Text(
                                  article['description'] ?? 'No Description',
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                SizedBox(height: 8),
                                Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      article['source']['name'] ?? 'Unknown Source',
                                      style: TextStyle(color: Colors.grey),
                                    ),
                                    Text(
                                      article['publishedAt']?.split('T')[0] ??
                                          'No Date',
                                      style: TextStyle(color: Colors.grey),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          // Action Buttons
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              TextButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (ctx) =>
                                          NewsDetailScreen(article: article),
                                    ),
                                  );
                                },
                                child: Text('Read More'),
                              ),
                              IconButton(
                                icon: Icon(
                                  isFavorite
                                      ? Icons.favorite
                                      : Icons.favorite_border,
                                  color: isFavorite ? Colors.red : null,
                                ),
                                onPressed: () {
                                  newsProvider.toggleFavorite(article);
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                ),
                // Back to Top Button
                if (_isBackToTopVisible)
                  Positioned(
                    bottom: 16,
                    right: 16,
                    child: FloatingActionButton(
                      onPressed: _scrollToTop,
                      child: Icon(Icons.arrow_upward),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
