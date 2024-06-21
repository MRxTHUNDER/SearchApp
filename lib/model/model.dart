class ImageModel {
  final List<String> imageUrls;

  ImageModel({required this.imageUrls});

  factory ImageModel.fromJson(Map<String, dynamic> json) {
    final List<dynamic> iUrls = json['images'];
    final imageUrls = iUrls.map((url) => url.toString()).toList();
    return ImageModel(imageUrls: imageUrls);
  }
}
