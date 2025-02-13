import 'package:gifapp/Models/ImageModel.dart';

class GifModel{
  final String id;
  final String url;
  final String bitly_url;
  final String title;
  final String alt_text;
  final Map<String, ImageModel> images;

  GifModel({
    required this.id,
    required this.url,
    required this.bitly_url,
    required this.title,
    required this.alt_text,
    required this.images
});

  factory GifModel.fromJson(Map<String,dynamic> json){
    return GifModel(
        id: json['id'],
        url: json['url'],
        bitly_url: json['bitly_url'],
        title: json['title'],
        alt_text: json['alt_text'],
        images: ImageModel.fromMapJson(json['images'])
    );
  }
}