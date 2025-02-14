class ImageModel {
  final String url;
  final String width;
  final String height;
  final String mp4;
  final String webp;

  ImageModel({
    required this.url,
    required this.width,
    required this.height,
    required this.mp4,
    required this.webp,
  });

  factory ImageModel.fromJson(Map<String, dynamic> json) {
    return ImageModel(
        url: json['url'] ?? '',
        width: json['width'] ?? '',
        height: json['height'] ?? '',
        mp4: json['mp4'] ?? '',
        webp: json['webp'] ?? '');
  }

  static Map<String, ImageModel> fromMapJson(Map<String, dynamic> json) {
    return json.map((key, value) => MapEntry(key, ImageModel.fromJson(value)));
  }
}
