import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'main.dart';
import 'models/bookmark_model.dart';
import 'detail_news.dart';

class PageBookmarks extends StatefulWidget {
  const PageBookmarks({Key? key}) : super(key: key);

  @override
  _PageBookmarksState createState() => _PageBookmarksState();
}

class _PageBookmarksState extends State<PageBookmarks> {
  late Box<Bookmark> _myBox;

  @override
  void initState() {
    super.initState();
    _myBox = Hive.box(boxName);
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Saved Bookmarks",
          style: TextStyle(
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: _buildBookmarkList(),
    );
  }

  Widget _buildBookmarkList() {
    return FutureBuilder(
      future: Hive.openBox<Bookmark>('bookmarks'),
      builder: (BuildContext context, AsyncSnapshot<Box<Bookmark>> snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          var box = snapshot.data;
          if (box != null && box.isNotEmpty) {
            var bookmarks = box.values.toList();
            return ListView.builder(
              itemCount: bookmarks.length,
              itemBuilder: (BuildContext context, int index) {
                var bookmark = bookmarks[index];
                return Dismissible(
                  key: UniqueKey(),
                  onDismissed: (direction) {
                    box.delete(bookmark.key); // Menghapus berdasarkan kunci unik
                  },
                  background: Container(
                    child: Icon(Icons.delete),
                    color: Colors.blueGrey,
                  ),
                  child: _buildBookmarkCard(bookmark),
                );
              },
            );
          } else {
            return Center(
              child: Text("No bookmarks yet"),
            );
          }
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }

  Widget _buildBookmarkCard(Bookmark bookmark) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PageDetailNews(news: bookmark.toResult()),
          ),
        );
      },
      child: Card(
        elevation: 4.0,
        margin: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              alignment: Alignment.bottomLeft,
              children: [
                // Gambar
                if (bookmark.imageurl != null)
                  Image.network(
                    bookmark.imageurl!,
                    height: 150.0,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                if (bookmark.publishedAt != null)
                  Container(
                    padding: EdgeInsets.symmetric(
                      vertical: 8.0,
                      horizontal: 16.0,
                    ),
                    color: Colors.black54,
                    child: Text(
                      "Publish At: ${bookmark.publishedAt}",
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    bookmark.title,
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8.0),
                  Text(
                    bookmark.url,
                    style: TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
