import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:news_api_app/models/news_channel_headline_model.dart';
import 'package:news_api_app/models/categories_news_model.dart';
import 'package:news_api_app/view_model/news_view_model.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:news_api_app/views/categories_screen.dart';
import 'package:news_api_app/views/news_details_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

enum FiltersList {
  india,
  us,
  indonesia,
  china,
  usa,
}

class _HomeScreenState extends State<HomeScreen> {
  final NewsViewModel newsViewModel = NewsViewModel();
  final DateFormat format = DateFormat('MMMM dd, yyyy');

  FiltersList? selectedMenu;

  String name = 'in';

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Image.asset(
            'images/category_icon.png',
            height: 30,
            width: 25,
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const CategoriesScreen(),
              ),
            );
          },
        ),
        actions: [
          PopupMenuButton<FiltersList>(
            initialValue: selectedMenu,
            onSelected: (FiltersList item) {
              if (FiltersList.india == item) {
                name = 'in';
              }
               else if (FiltersList.indonesia == item) {
                name = 'id';
              }
               else if (FiltersList.usa == item) {
                name = 'us';
              }
               else if (FiltersList.china == item) {
                name = 'cn';
              }

              setState(() {
                selectedMenu = item;
              });
            },
            itemBuilder: (context) => <PopupMenuEntry<FiltersList>>[
              const PopupMenuItem<FiltersList>(
                value: FiltersList.india,
                child: Text('India'),
              ),
              const PopupMenuItem<FiltersList>(
                value: FiltersList.indonesia,
                child: Text('Indonesia'),
              ),
              const PopupMenuItem<FiltersList>(
                value: FiltersList.usa,
                child: Text('USA'),
              ),
              const PopupMenuItem<FiltersList>(
                value: FiltersList.china,
                child: Text('China'),
              ),
            ],
          ),
        ],
        title: Text(
          'News',
          style: GoogleFonts.poppins(
            fontSize: 24,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: FutureBuilder<NewsChannelHeadlinesModel>(
        future: newsViewModel.fetchNewsChannelHeadlinesApi(name),
        builder: (BuildContext context,
            AsyncSnapshot<NewsChannelHeadlinesModel> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: SpinKitRotatingCircle(
                size: 50,
                color: Colors.blue,
              ),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else if (!snapshot.hasData || snapshot.data!.articles!.isEmpty) {
            return const Center(
              child: Text('No articles found'),
            );
          } else {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text(
                    'Top Headlines',
                    style: GoogleFonts.poppins(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(
                  height: height * 0.45,
                  child: ListView.separated(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    scrollDirection: Axis.horizontal,
                    itemCount: snapshot.data!.articles!.length,
                    separatorBuilder: (context, index) =>
                        const SizedBox(width: 10), // Adjust spacing here
                    itemBuilder: (context, index) {
                      var article = snapshot.data!.articles![index];
                      DateTime dateTime =
                          DateTime.parse(article.publishedAt.toString());
                      String? imageUrl = article.urlToImage;

                      return GestureDetector(
                        onTap: (){
                           Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => NewsDetailScreen(
              article.urlToImage ?? '',
              article.title ?? '',
              article.publishedAt ?? '',
              article.author ?? '',
              article.description ?? '',
              article.content ?? '',
              article.source!.name ?? '',
            ),
          ),
        );
                        },
                        child: SizedBox(
                          width: width * 0.9,
                          child: Stack(
                            children: [
                              AspectRatio(
                                aspectRatio: 16 / 9,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(20),
                                  child: CachedNetworkImage(
                                    imageUrl: imageUrl ?? '',
                                    fit: BoxFit.cover,
                                    placeholder: (context, url) =>
                                        const SpinKitRotatingCircle(
                                      color: Colors.amber,
                                      size: 50,
                                    ),
                                    errorWidget: (context, url, error) =>
                                        const Icon(
                                      Icons.error_outline,
                                      color: Colors.red,
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                bottom: 0,
                                left: 0,
                                right: 0,
                                child: Card(
                                  margin: const EdgeInsets.all(10),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(12.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          article.title.toString(),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: GoogleFonts.poppins(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w300,
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              article.source!.name.toString(),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: GoogleFonts.poppins(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w300,
                                              ),
                                            ),
                                            Text(
                                              format.format(dateTime),
                                              style: GoogleFonts.poppins(
                                                fontSize: 10,
                                                fontWeight: FontWeight.w300,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Expanded(
                  child: FutureBuilder<CategoriesNewsModel>(
                    future: newsViewModel.fetchCategoriesNewsApi('technology'),
                    builder: (BuildContext context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: SpinKitRotatingCircle(
                            size: 50,
                            color: Colors.blue,
                          ),
                        );
                      } else if (snapshot.hasError) {
                        return Center(
                          child: Text('Error: ${snapshot.error}'),
                        );
                      } else if (!snapshot.hasData ||
                          snapshot.data!.articles!.isEmpty) {
                        return const Center(
                          child: Text('No articles found'),
                        );
                      } else {
                        return ListView.builder(
                          itemCount: snapshot.data!.articles!.length,
                          itemBuilder: (context, index) {
                            var article = snapshot.data!.articles![index];
                            String? imageUrl = article.urlToImage;
                            DateTime dateTime = DateTime.parse(snapshot
                                .data!.articles![index].publishedAt
                                .toString());
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 15),
                              child: Row(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(20),
                                    child: CachedNetworkImage(
                                      imageUrl: imageUrl ?? '',
                                      fit: BoxFit.cover,
                                      height: height * 0.18,
                                      width: width * 0.3,
                                      placeholder: (context, url) =>
                                          const SpinKitRotatingCircle(
                                        color: Colors.amber,
                                        size: 50,
                                      ),
                                      errorWidget: (context, url, error) =>
                                          const Icon(
                                        Icons.error_outline,
                                        color: Colors.red,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Container(
                                      height: height * 0.18,
                                      padding: const EdgeInsets.only(left: 15),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            snapshot
                                                .data!.articles![index].title
                                                .toString(),
                                            maxLines: 3,
                                            overflow: TextOverflow.ellipsis,
                                            style: GoogleFonts.poppins(
                                              fontSize: 16,
                                              color: Colors.black54,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          const Spacer(),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                snapshot.data!.articles![index]
                                                    .source!.name
                                                    .toString(),
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                style: GoogleFonts.poppins(
                                                  fontSize: 12,
                                                  color: Colors.black54,
                                                  fontWeight: FontWeight.w400,
                                                ),
                                              ),
                                              Text(
                                                format.format(dateTime),
                                                style: GoogleFonts.poppins(
                                                  fontSize: 12,
                                                  color: Colors.black54,
                                                  fontWeight: FontWeight.w400,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      }
                    },
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }
}
