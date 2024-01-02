class ChannelStatisticsModel {
  String? viewCount;
  String? subscriberCount;
  String? videoCount;
  bool? hiddenSubscriberCount = false;

  ChannelStatisticsModel(
      {this.viewCount,
      this.subscriberCount,
      this.videoCount,
      this.hiddenSubscriberCount});

  factory ChannelStatisticsModel.fromJson(Map<String, dynamic> item) {
    return ChannelStatisticsModel(
      viewCount: item['statistics']['viewCount'],
      subscriberCount: item['statistics']['subscriberCount'],
      videoCount: item['statistics']['videoCount'],
      hiddenSubscriberCount: item['statistics']['hiddenSubscriberCount'],
    );
  }

  Map<String, dynamic> toMap() => {
        "viewCount": viewCount,
        "subscriberCount": subscriberCount,
        "videoCount": videoCount,
        "hiddenSubscriberCount": hiddenSubscriberCount,
      };
}
