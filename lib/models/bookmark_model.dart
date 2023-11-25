import 'package:hive/hive.dart';
import 'news_models.dart';
part 'bookmark_model.g.dart';

@HiveType(typeId: 0)
class Bookmark extends HiveObject {

  @HiveField(0)
  late String title;

  @HiveField(1)
  late String url;

  @HiveField(2)
  late String imageurl;

  @HiveField(3)
  late String summary;

  @HiveField(4)
  late String newsSite;

  @HiveField(5)
  late String publishedAt;

  Bookmark({
    required this.title,
    required this.url,
    required this.imageurl,
    required this.summary,
    required this.newsSite,
    required this.publishedAt,});

  Results toResult() {
    return Results(
      id: null,
      title: title,
      url: url,
      imageUrl: imageurl,
      newsSite: newsSite,
      summary: summary,
      publishedAt: publishedAt,
       );
  }
}
