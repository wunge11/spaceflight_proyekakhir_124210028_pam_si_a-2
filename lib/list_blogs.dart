import 'package:flutter/material.dart';
import 'api_data_source.dart';
import 'detail_blogs.dart';
import 'models/blog_models.dart';

class PageListBlogs extends StatefulWidget {
  const PageListBlogs({Key? key}) : super(key: key);

  @override
  State<PageListBlogs> createState() => _PageListBlogsState();
}

class _PageListBlogsState extends State<PageListBlogs> {
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
          "Latest Blogs",
          style: TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: _buildListBlogsBody(),
    );
  }

  Widget _buildListBlogsBody() {
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
              hintText: 'Search blog...',
              prefixIcon: Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
            ),
          ),
        ),
        Expanded(
          child: FutureBuilder(
            future: ApiDataSource.instance.loadBlogs(),
            builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
              if (snapshot.hasError) {
                return _buildErrorSection();
              }
              if (snapshot.hasData) {
                Blogs blogs = Blogs.fromJson(snapshot.data);
                return _buildSuccessSection(blogs);
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
        "oops, an error occurred",
        style: TextStyle(
          fontSize: 18.0,
          color: Colors.red,
        ),
      ),
    );
  }

  Widget _buildSuccessSection(Blogs data) {
    // Filter berita berdasarkan kata kunci
    var filteredBlogs = data.results!
        .where((blog) =>
    blog.title!
        .toLowerCase()
        .contains(_searchController.text.toLowerCase()) ||
        blog.summary!
            .toLowerCase()
            .contains(_searchController.text.toLowerCase()))
        .toList();

    return ListView.builder(
      itemCount: filteredBlogs.length,
      itemBuilder: (BuildContext context, int index) {
        return _BuildItemBlogs(filteredBlogs[index]);
      },
    );
  }

  Widget _buildLoadingSection() {
    return Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget _BuildItemBlogs(Results blog) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PageDetailBlogs(blog: blog),
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
                    blog.imageUrl!,
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
                      blog.title!,
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8.0),
                    Text(
                      blog.newsSite!,
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
