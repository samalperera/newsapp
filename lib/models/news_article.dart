import 'package:sample_news_app/models/source.dart';
import 'dart:convert';

NewsArticleModel newsArticleModelFromJson(String str) =>
    NewsArticleModel.fromJson(json.decode(str));

String newsArticleModelToJson(NewsArticleModel data) =>
    json.encode(data.toJson());

class NewsArticleModel {
  String status;
  List<NewsArticle> data;

  NewsArticleModel({
    required this.status,
    required this.data,
  });

  factory NewsArticleModel.fromJson(Map<String, dynamic> json) =>
      NewsArticleModel(
        status: json["status"],
        data: List<NewsArticle>.from(
            json["articles"].map((x) => NewsArticle.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class NewsArticle {
  Source? source;
  String? author;
  String? title;
  String? description;
  String? url;
  String? urlToImage;
  String? publishedAt;
  String? content;

  NewsArticle(
      {this.source,
      this.author,
      this.title,
      this.description,
      this.url,
      this.urlToImage,
      this.publishedAt,
      this.content});

  NewsArticle.fromJson(Map<String, dynamic> json) {
    source =
        json['source'] != null ? new Source.fromJson(json['source']) : null;
    author = json['author'];
    title = json['title'];
    description = json['description'];
    url = json['url'];
    urlToImage = json['urlToImage'];
    publishedAt = json['publishedAt'];
    content = json['content'];
  }

  NewsArticle.fromBookmarkJson(Map<String, dynamic> json) {
    source = json['source_name'] != null
        ? Source(id: json['source_id'], name: json['source_name'])
        : null;
    author = json['author'];
    title = json['title'];
    description = json['description'];
    url = json['url'];
    urlToImage = json['urlToImage'];
    publishedAt = json['publishedAt'];
    content = json['content'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.source != null) {
      data['source'] = this.source!.toJson();
    }
    data['author'] = this.author;
    data['title'] = this.title;
    data['description'] = this.description;
    data['url'] = this.url;
    data['urlToImage'] = this.urlToImage;
    data['publishedAt'] = this.publishedAt;
    data['content'] = this.content;
    return data;
  }
}
