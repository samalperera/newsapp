import 'package:sample_news_app/models/news_article.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHandler {
  Future<Database> initialiseDatabase() async {
    String path = await getDatabasesPath();

    const String tableCreateQuery = '''
    CREATE TABLE articles(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      source_id TEXT,
      source_name TEXT,
      author TEXT,
      title TEXT,
      description TEXT,
      content TEXT,
      url TEXT,
      urlToImage TEXT,
      publishedAt TEXT,
      updatedAt TEXT DEFAULT CURRENT_TIMESTAMP
    )
  ''';

    const String bookmarkTableCreateQuery = '''
    CREATE TABLE bookmarks(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      source_id TEXT,
      source_name TEXT,
      author TEXT,
      title TEXT,
      description TEXT,
      content TEXT,
      url TEXT,
      urlToImage TEXT,
      publishedAt TEXT,
      updatedAt TEXT DEFAULT CURRENT_TIMESTAMP
    )
  ''';

    return openDatabase(join(path, 'news_articles.db'),
        onCreate: (database, version) async {
      await database.execute(tableCreateQuery);
      await database.execute(bookmarkTableCreateQuery);
      print("###################################################.");
      print("table created.");
      print("###################################################.");
    }, version: 1);
  }

  Future<void> insertBookmark(NewsArticle article) async {
    final Database db = await initialiseDatabase();
    final Map<String, dynamic> dataToInsert = {
      'source_id': article.source?.id,
      'source_name': article.source?.name,
      'author': article.author,
      'title': article.title,
      'description': article.description,
      'content': article.content,
      'url': article.url,
      'urlToImage': article.urlToImage,
      'publishedAt': article.publishedAt,
    };

    await db.insert("bookmarks", dataToInsert);
  }

  Future<List<NewsArticle>> getBookmarks() async {
    final Database db = await initialiseDatabase();
    final result = await db.query("bookmarks", orderBy: "publishedAt DESC");
    List<NewsArticle> articles =
        result.map((e) => NewsArticle.fromBookmarkJson(e)).toList();

    return articles;
  }

  Future<void> deleteBookmark(NewsArticle article) async {
    final Database db = await initialiseDatabase();
    await db.delete(
      "bookmarks",
      where: "url = ?",
      whereArgs: [article.url],
    );
  }

  Future<void> insertBulkArticles(List<NewsArticle> articles) async {
    await deleteAllArticles();
    final Database db = await initialiseDatabase();
    for (final article in articles) {
      final Map<String, dynamic> dataToInsert = {
        'source_id': article.source?.id,
        'source_name': article.source?.name,
        'author': article.author,
        'title': article.title,
        'description': article.description,
        'content': article.content,
        'url': article.url,
        'urlToImage': article.urlToImage,
        'publishedAt': article.publishedAt,
      };

      await db.insert("articles", dataToInsert);
    }
  }

  Future<void> deleteAllArticles() async {
    final Database db = await initialiseDatabase();
    await db.delete("articles");
  }

  Future<List<NewsArticle>> getArticles() async {
    final Database db = await initialiseDatabase();
    final result = await db.query("articles", orderBy: "publishedAt DESC");
    List<NewsArticle> articles =
    result.map((e) => NewsArticle.fromBookmarkJson(e)).toList();

    return articles;
  }
}
