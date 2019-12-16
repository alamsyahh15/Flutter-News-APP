// To parse this JSON data, do
//
//     final resultNews = resultNewsFromJson(jsonString);

import 'dart:convert';

ResultNews resultNewsFromJson(String str) => ResultNews.fromJson(json.decode(str));

String resultNewsToJson(ResultNews data) => json.encode(data.toJson());

class ResultNews {
  String message;
  int status;
  List<Datum> data;

  ResultNews({
    this.message,
    this.status,
    this.data,
  });

  factory ResultNews.fromJson(Map<String, dynamic> json) => ResultNews(
    message: json["message"],
    status: json["status"],
    data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "message": message,
    "status": status,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class Datum {
  String newsId;
  String newsTitle;
  String newsContent;
  String newsImage;

  Datum({
    this.newsId,
    this.newsTitle,
    this.newsContent,
    this.newsImage,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    newsId: json["news_id"],
    newsTitle: json["news_title"],
    newsContent: json["news_content"],
    newsImage: json["news_image"],
  );

  Map<String, dynamic> toJson() => {
    "news_id": newsId,
    "news_title": newsTitle,
    "news_content": newsContent,
    "news_image": newsImage,
  };
}
