class Endpoints {
  Endpoints._();

  // base url
  static const String baseUrl = "https://www.googleapis.com";

  // receiveTimeout
  static const int receiveTimeout = 15000;

  // connectTimeout
  static const int connectionTimeout = 30000;

  // videos trending
  static const String getVideosTrending = "/youtube/v3/videos";

  // videos search
  static const String getVideosSearch = "/youtube/v3/search";

  // avatar channel
  static const String getAvatarChannel = "/youtube/v3/channels";

  static const String getChannel = "/youtube/v3/channels";
}
