class TweetDetails {

String message;
String time;

TweetDetails({this.message, this.time});

  factory TweetDetails.fromJson(Map<String, dynamic> json) {
    return new TweetDetails(
      message: json['text'] as String,
      time: json['created_at'] as String,
    );
  }
}