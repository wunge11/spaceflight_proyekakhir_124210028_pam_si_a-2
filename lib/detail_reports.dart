import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:hive/hive.dart';
import 'models/bookmark_model.dart';
import 'models/report_models.dart';

class PageDetailReports extends StatefulWidget {
  final Results report;

  const PageDetailReports({Key? key, required this.report}) : super(key: key);

  @override
  _PageDetailReportsState createState() => _PageDetailReportsState();
}

class _PageDetailReportsState extends State<PageDetailReports> {
  bool isBookmarked = false;
  late Box<Bookmark> _myBox;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Detail Report",
          style: TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(
              isBookmarked ? Icons.bookmark : Icons.bookmark_border,
              color: Colors.black,
            ),
            onPressed: () {
              setState(() {
                isBookmarked = !isBookmarked;
                if (isBookmarked) {
                  _addBookmark(
                    widget.report.title!,
                    widget.report.url!,
                    widget.report.imageUrl!,
                    widget.report.summary!,
                    widget.report.newsSite!,
                    widget.report.publishedAt!,
                  );
                  _showSnackbar(context, 'Added to bookmark');
                } else {
                  _removeBookmark(widget.report.url!);
                  _showSnackbar(context, 'Delete from bookmark');
                }
              });
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildReportImage(widget.report.imageUrl),
              SizedBox(height: 16),
              _buildReportTitle(widget.report.title),
              SizedBox(height: 8),
              _buildReportSummary(widget.report.summary),
              SizedBox(height: 16),
              _buildNewsSite(widget.report.newsSite),
              _buildPublishedAt(widget.report.publishedAt),
            ],
          ),
        ),
      ),
      floatingActionButton: _buildSeeMoreButton(widget.report.url),
    );
  }

  Widget _buildReportImage(String? imageUrl) {
    return Container(
      height: 200,
      width: double.infinity,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8.0),
        child: imageUrl != null
            ? Image.network(
          imageUrl,
          fit: BoxFit.cover,
        )
            : Placeholder(), // Placeholder jika imageUrl null
      ),
    );
  }

  Widget _buildReportTitle(String? title) {
    return Text(
      title ?? '',
      style: TextStyle(
        fontSize: 24.0,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildReportSummary(String? summary) {
    return Text(
      summary ?? '',
      style: TextStyle(
        fontSize: 16.0,
        color: Colors.grey,
      ),
    );
  }

  Widget _buildNewsSite(String? newsSite) {
    return Text(
      'News Site: ${newsSite ?? ''}',
      style: TextStyle(
        fontSize: 16.0,
        color: Colors.blue,
      ),
    );
  }

  Widget _buildPublishedAt(String? publishedAt) {
    return Text(
      'Published At: ${publishedAt ?? ''}',
      style: TextStyle(
        fontSize: 16.0,
        color: Colors.blue,
      ),
    );
  }

  Widget _buildSeeMoreButton(String? url) {
    return FloatingActionButton.extended(
      onPressed: () {
        _launchURL(url ?? '');
      },
      icon: Icon(Icons.open_in_browser),
      label: Text(
        "See More",
        style: TextStyle(
          fontSize: 16.0,
        ),
      ),
    );
  }

  void _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  void _addBookmark(
      String title,
      String url,
      String imageUrl,
      String summary,
      String newsSite,
      String publishedAt,
      ) async {
    var box = await Hive.openBox<Bookmark>('bookmarks');
    box.add(
      Bookmark(
        title: title,
        url: url,
        imageurl: imageUrl,
        summary: summary,
        newsSite: newsSite,
        publishedAt: publishedAt,
      ),
    );
  }

  void _removeBookmark(String url) async {
    var box = await Hive.openBox<Bookmark>('bookmarks');
    var bookmarkIndex = box.values.toList().indexWhere((bookmark) => bookmark.url == url);
    if (bookmarkIndex != -1) {
      // Hapus data bookmark dari Hive
      box.deleteAt(bookmarkIndex);
      // Hapus data bookmark dari _myBox
      _myBox.deleteAt(bookmarkIndex);
    }
  }


  void _showSnackbar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: Duration(seconds: 2),
      ),
    );
  }
}
