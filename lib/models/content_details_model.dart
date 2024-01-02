class   ContentDetailsModel {
  String? duration;
  String? dimension;
  String? definition;
  String? caption;
  bool? licensedContent;

  ContentDetailsModel(
      {this.duration,
      this.dimension,
      this.definition,
      this.caption,
      this.licensedContent});

  factory ContentDetailsModel.fromJson(Map<String, dynamic> item) {
    return ContentDetailsModel(
        duration: item['contentDetails']['duration'],
        dimension: item['contentDetails']['dimension'],
        definition: item['contentDetails']['definition'],
        caption: item['contentDetails']['caption'],
        licensedContent: item['contentDetails']['licensedContent']);
  }

  factory ContentDetailsModel.fromMap(Map<String, dynamic> item) {
    return ContentDetailsModel(
        duration: item['duration'],
        dimension: item['dimension'],
        definition: item['definition'],
        caption: item['caption'],
        licensedContent: item['licensedContent']);
  }

  Map<String, dynamic> toMap() => {
        "duration": duration,
        "dimension": dimension,
        "definition": definition,
        "caption": caption,
        "licensedContent": licensedContent,
      };
}
