import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:news_api_app/models/categories_news_model.dart';
import 'package:news_api_app/view_model/news_view_model.dart';


class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({super.key});

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  final NewsViewModel newsViewModel = NewsViewModel();
  final DateFormat format = DateFormat('MMMM dd, yyyy');
  String categoryCode = 'general';
  List<String> btnCategories = [
    'General',
    'Entertainment',
    'Health',
    'Sports',
    'Bussiness',
    'Technology',
  ];
  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width * 1;
    final double height = MediaQuery.of(context).size.height * 1;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Categories'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            SizedBox(
              height: 50,
              child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: btnCategories.length,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () {
                        setState(() {
                        categoryCode = btnCategories[index];

                        });
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(right: 12),
                        child: Container(
                         
                          decoration: BoxDecoration(
                            color: categoryCode == btnCategories[index]
                                ? Colors.blue
                                : Colors.grey,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            child: Center(
                              child: Text(
                                btnCategories[index].toString(),
                                style: GoogleFonts.poppins(
                                  fontSize: 14,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
            ),
            const SizedBox(
              height: 20,
            ),
            Expanded(
              child: FutureBuilder<CategoriesNewsModel>(
                  future: newsViewModel.fetchCategoriesNewsApi(categoryCode),
                  builder: (BuildContext context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: SpinKitRotatingCircle(
                          size: 50,
                          color: Colors.blue,
                        ),
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
                                      children: [
                                        Text(
                                          snapshot.data!.articles![index].title
                                              .toString(),
                                              maxLines: 3,
                                          style: GoogleFonts.poppins(
                                            fontSize: 16,
                                            color: Colors.black54,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        Row(
                                          children: [
                                            Text(
                                          snapshot.data!.articles![index].source!.name
                                              .toString(),
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
                                        )
                                      ],
                                    ),
                                  ))
                                ],
                              ),
                            );
                          });
                    }
                  }),
            ),
          ],
        ),
      ),
    );
  }
}