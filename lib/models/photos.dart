class Photos {
  Src? src;
  bool isPhotoDownloaded = false;

  Photos({required this.src, required this.isPhotoDownloaded});

  Photos.fromJson(Map<String, dynamic> json) {
    src = json['src'] != null ? Src.fromJson(json['src']) : null;
  }
}

class Src {
  String? large2x;
  String? tiny;
  Src({
    required this.large2x,
    required this.tiny,
  });

  Src.fromJson(Map<String, dynamic> json) {
    large2x = json['large2x'];
    tiny = json['tiny'];
  }
}
