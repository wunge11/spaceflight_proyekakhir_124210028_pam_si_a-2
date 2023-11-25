import 'base_network.dart';

class ApiDataSource {
  static ApiDataSource instance = ApiDataSource();

  Future<Map<String, dynamic>> loadNews() {
    return BaseNetwork.get("articles/?format=json");
  }

  Future<Map<String, dynamic>> loadDetailNews(int newsId) {
    return BaseNetwork.get("articles/?format=json/$newsId");
  }

  Future<Map<String, dynamic>> loadBlogs() {
    return BaseNetwork.get("blogs/?format=json");
  }

  Future<Map<String, dynamic>> loadDetailBlogs(int blogId) {
    return BaseNetwork.get("blogs/?format=json/$blogId");
  }

  Future<Map<String, dynamic>> loadReports() {
    return BaseNetwork.get("reports/?format=json");
  }

  Future<Map<String, dynamic>> loadDetailReports(int reportsId) {
    return BaseNetwork.get("reports/?format=json/$reportsId");
  }
}
