import 'package:flutter/material.dart';
import 'api_data_source.dart';
import 'detail_news.dart';
import 'models/news_models.dart';

class PageListNews extends StatefulWidget {
  const PageListNews({Key? key});

  @override
  State<PageListNews> createState() => _PageListNewsState();
}

class _PageListNewsState extends State<PageListNews> {
  late TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Latest Articles",
          style: TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: _buildListNewsBody(),
    );
  }

  Widget _buildListNewsBody() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: TextField(
            controller: _searchController,
            onChanged: (value) {
              setState(() {});
            },
            decoration: InputDecoration(
              hintText: 'Search News...',
              prefixIcon: Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
            ),
          ),
        ),
        Expanded(
          child: FutureBuilder(
            future: ApiDataSource.instance.loadNews(),
            builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
              if (snapshot.hasError) {
                return _buildErrorSection();
              }
              if (snapshot.hasData) {
                News news = News.fromJson(snapshot.data);
                return _buildSuccessSection(news);
              }
              return _buildLoadingSection();
            },
          ),
        ),
      ],
    );
  }

  Widget _buildErrorSection() {
    return Center(
      child: Text(
        "Oops, an error occurred",
        style: TextStyle(
          fontSize: 18.0,
          color: Colors.red,
        ),
      ),
    );
  }

  Widget _buildSuccessSection(News data) {
    // Filter berita berdasarkan kata kunci
    var filteredNews = data.results!
        .where((news) =>
    news.title!
        .toLowerCase()
        .contains(_searchController.text.toLowerCase()) ||
        news.summary!
            .toLowerCase()
            .contains(_searchController.text.toLowerCase()))
        .toList();

    return ListView.builder(
      itemCount: filteredNews.length,
      itemBuilder: (BuildContext context, int index) {
        return _BuildItemNews(filteredNews[index]);
      },
    );
  }

  Widget _buildLoadingSection() {
    return Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget _BuildItemNews(Results news) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PageDetailNews(news: news),
          ),
        );
      },
      child: Card(
        elevation: 4.0,
        margin: EdgeInsets.all(16.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                width: 100,
                height: 100,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: Image.network(
                    news.imageUrl!,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(
                width: 20,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      news.title!,
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8.0),
                    Text(
                      news.newsSite!,
                      style: TextStyle(
                        fontSize: 14.0,
                        color: Colors.blueGrey,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
