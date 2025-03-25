import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'news_details_page.dart';

class NewsPage extends StatefulWidget {
  const NewsPage({super.key});

  @override
  State<NewsPage> createState() => _NewsPageState();
}

class _NewsPageState extends State<NewsPage> {
  final TextEditingController _searchController = TextEditingController();
  bool isLoading = false;
  String? errorMessage;
  List<dynamic> articles = [];
  List<dynamic> headlines = [];

  @override
  void initState() {
    super.initState();
    fetchNews("us news");
    fetchHeadlines();
  }

  Future<void> fetchNews(String query) async {
    setState(() {
      isLoading = true;
      errorMessage = null;
      articles.clear();
    });

    try {
      final response = await Dio().get(
        'https://newsapi.org/v2/everything',
        queryParameters: {
          'q': query,
          'apiKey': '24f394d208b24df8aa7bdaef3627f009',
        },
      );

      final data = response.data;
      setState(() {
        articles = data['articles'];
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = "Could not fetch news. Try again!";
        isLoading = false;
      });
    }
  }

  Future<void> fetchHeadlines() async {
    try {
      final response = await Dio().get(
        'https://newsapi.org/v2/top-headlines',
        queryParameters: {
          'country': 'us',
          'apiKey': '24f394d208b24df8aa7bdaef3627f009',
        },
      );

      final data = response.data;
      setState(() {
        headlines = data['articles'];
      });
    } catch (e) {
      setState(() {
        errorMessage = "Could not fetch headlines.";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Check if the theme is dark mode
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDarkMode ? Colors.black : Color(0xFFECECEC),
      appBar: AppBar(
        elevation: 0,
        title: Text(
          "News Page",
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,

      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Search Bar
            Container(
              height: 50,
              decoration: BoxDecoration(
                color: isDarkMode ? Colors.grey[800] : Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(color: Colors.black12, blurRadius: 5),
                ],
              ),
              child: TextField(
                controller: _searchController,
                style: TextStyle(color: isDarkMode ? Colors.white : Colors.black),
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.search, color: isDarkMode ? Colors.white70 : Colors.black54),
                  labelText: "Search News",
                  labelStyle: TextStyle(color: isDarkMode ? Colors.white70 : Colors.black54),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 14),
                ),
                onSubmitted: (value) => fetchNews(value),
              ),
            ),

            SizedBox(height: 10),

            // Horizontal Scrolling Headlines
            if (headlines.isNotEmpty)
              SizedBox(
                height: 160,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: headlines.length,
                  itemBuilder: (context, index) {
                    var article = headlines[index];
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => NewsDetailPage(article: article),
                          ),
                        );
                      },
                      child: Container(
                        width: 300,
                        margin: EdgeInsets.only(right: 12),
                        decoration: BoxDecoration(
                          color: isDarkMode ? Colors.grey[850] : Colors.white,
                          borderRadius: BorderRadius.circular(15),
                          boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 5)],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(15),
                          child: Stack(
                            children: [
                              // News Image
                              article['urlToImage'] != null
                                  ? Image.network(article['urlToImage'], height: 160, width: 300, fit: BoxFit.cover)
                                  : Container(color: Colors.grey, height: 160, width: 300),
                              // Title Overlay
                              Positioned(
                                bottom: 10,
                                left: 10,
                                right: 10,
                                child: Container(
                                  padding: EdgeInsets.all(6),
                                  color: Colors.blue.withOpacity(0.8),
                                  child: Text(
                                    article['title'] ?? '',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),

            SizedBox(height: 20),

            // News List
            isLoading
                ? CircularProgressIndicator()
                : errorMessage != null
                ? Text(errorMessage!, style: TextStyle(color: Colors.red))
                : Expanded(
              child: ListView.builder(
                itemCount: articles.length,
                itemBuilder: (context, index) {
                  var article = articles[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => NewsDetailPage(article: article),
                        ),
                      );
                    },
                    child: Container(
                      margin: EdgeInsets.symmetric(vertical: 8),
                      decoration: BoxDecoration(
                        color: isDarkMode ? Colors.grey[850] : Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 5)],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Row(
                          children: [
                            // News Image
                            if (article['urlToImage'] != null)
                              ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image.network(article['urlToImage'],
                                    width: 80, height: 80, fit: BoxFit.cover),
                              ),
                            SizedBox(width: 12),
                            // News Details
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    article['title'],
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: isDarkMode ? Colors.white : Colors.black,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  SizedBox(height: 5),
                                  Text(
                                    article['description'] ?? '',
                                    style: TextStyle(
                                      color: isDarkMode ? Colors.white70 : Colors.black54,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}