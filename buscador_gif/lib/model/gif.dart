class Gif {
  String? url;

  Gif({this.url});

  factory Gif.fromJson(Map<String, dynamic> json) {
    return Gif(
      url: json["data"]["images"]["fixed_height"],
    );
  }
}
