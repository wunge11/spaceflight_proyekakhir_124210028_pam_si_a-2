import 'package:flutter/material.dart';
import 'api_data_source.dart';
import 'detail_reports.dart';
import 'models/report_models.dart';

class PageListReports extends StatefulWidget {
  const PageListReports({Key? key});

  @override
  State<PageListReports> createState() => _PageListReportsState();
}

class _PageListReportsState extends State<PageListReports> {
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
          "Latest Reports",
          style: TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: _buildListReportsBody(),
    );
  }

  Widget _buildListReportsBody() {
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
              hintText: 'Search report...',
              prefixIcon: Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
            ),
          ),
        ),
        Expanded(
          child: FutureBuilder(
            future: ApiDataSource.instance.loadReports(),
            builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
              if (snapshot.hasError) {
                return _buildErrorSection();
              }
              if (snapshot.hasData) {
                Reports reports = Reports.fromJson(snapshot.data);
                return _buildSuccessSection(reports);
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

  Widget _buildSuccessSection(Reports data) {
    // Filter reports berdasarkan kata kunci
    var filteredReports = data.results!
        .where((report) =>
    report.title!
        .toLowerCase()
        .contains(_searchController.text.toLowerCase()) ||
        report.summary!
            .toLowerCase()
            .contains(_searchController.text.toLowerCase()))
        .toList();

    return ListView.builder(
      itemCount: filteredReports.length,
      itemBuilder: (BuildContext context, int index) {
        return _BuildItemReports(filteredReports[index]);
      },
    );
  }

  Widget _buildLoadingSection() {
    return Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget _BuildItemReports(Results report) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PageDetailReports(report: report),
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
                    report.imageUrl!,
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
                      report.title!,
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8.0),
                    Text(
                      report.newsSite!,
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
