import 'dart:math';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter/material.dart';
import 'package:api/api.dart';
import 'package:dio/dio.dart';
import 'dart:convert';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:api/Movie.dart';

class History extends StatefulWidget {
  const History({Key? key}) : super(key: key);

  @override
  _HistoryState createState() => _HistoryState();
}

class _HistoryState extends State<History> {
  List<Movies>? cartoons;
  List<Movies>? movie;
  List<Movies>? comedy;
  List<Movies>? drama;

  @override
  void initState() {
    super.initState();
    if (ApiPage.PMovies != null) {
      setState(() {
        _getApi();
        _getMovieApi();
        _getComedyApi();
        _getDramaApi();
      });
    } else {
      _getApi();
      _getMovieApi();
      _getComedyApi();
      _getDramaApi();
    }
  }

  void _getApi() async {
    try {
      var dio = Dio(BaseOptions(responseType: ResponseType.plain));
      var response =
          await dio.get('https://api.sampleapis.com/movies/animation');
      if (response.statusCode == 200) {
        List list = jsonDecode(response.data);
        setState(() {
          cartoons = list.map((json) => Movies.fromJson(json)).toList();
          cartoons!.sort((a, b) => a.title!.compareTo(b.title!));
          
        });
      } else {
        print('Failed to load data: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching API: $e');
    }
  }

  void _getMovieApi() async {
    try {
      var dio = Dio(BaseOptions(responseType: ResponseType.plain));
      var response = await dio.get('https://api.sampleapis.com/movies/horror');
      if (response.statusCode == 200) {
        List list = jsonDecode(response.data);
        setState(() {
          movie = list.map((json) => Movies.fromJson(json)).toList();
          movie!.sort((a, b) => a.title!.compareTo(b.title!));
        });
      } else {
        print('Failed to load data: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching API: $e');
    }
  }

  void _getComedyApi() async {
    try {
      var dio = Dio(BaseOptions(responseType: ResponseType.plain));
      var response = await dio.get('https://api.sampleapis.com/movies/comedy');
      if (response.statusCode == 200) {
        List list = jsonDecode(response.data);
        setState(() {
          comedy = list.map((json) => Movies.fromJson(json)).toList();
          comedy!.sort((a, b) => a.title!.compareTo(b.title!));
        });
      } else {
        print('Failed to load data: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching API: $e');
    }
  }
  void _getDramaApi() async {
    try {
      var dio = Dio(BaseOptions(responseType: ResponseType.plain));
      var response = await dio.get('https://api.sampleapis.com/movies/drama');
      if (response.statusCode == 200) {
        List list = jsonDecode(response.data);
        setState(() {
          drama = list.map((json) => Movies.fromJson(json)).toList();
          drama!.sort((a, b) => a.title!.compareTo(b.title!));
        });
      } else {
        print('Failed to load data: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching API: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    int index = 1;

    return CustomScrollView(
      slivers: [
        SliverFillRemaining(
          hasScrollBody: true,
          child: Stack(
            children: [
              if (cartoons != null &&
                  cartoons!.length > 8 &&
                  cartoons![8].posterURL != null)
                Container(
                  height: 800,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(cartoons![8].posterURL!),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              Container(
                height: 800,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.black,
                      Colors.transparent,
                    ],
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                  ),
                ),
              ),
              Positioned(
                left: 0,
                right: 0,
                bottom: 40,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    IconButton(
                      icon: Column(
                        children: [
                          cartoons != null &&
                                  cartoons!.length > 8 &&
                                  ApiPage.saved.contains(cartoons![8])
                              ? Icon(Icons.favorite, color: Colors.pink)
                              : Icon(Icons.favorite_border,
                                  color: Colors.white),
                          Text('Favorite',
                              style: TextStyle(color: Colors.white)),
                        ],
                      ),
                      onPressed: () {
                        if (cartoons != null && cartoons!.length > 8) {
                          setState(() {
                            ApiPage.toggleFavorite(cartoons![8]);
                          });
                        }
                      },
                    ),
                    ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.all(
                              20), // ปรับขนาดพื้นที่สัมผัสด้วย Padding
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.play_arrow, color: Colors.black),
                            Text('Play', style: TextStyle(color: Colors.black)),
                          ],
                        )),
                    IconButton(
                      icon: Column(
                        children: [
                          cartoons != null &&
                                  cartoons!.length > 8 &&
                                  ApiPage.saved.contains(cartoons![8])
                              ? Icon(Icons.info_outline, color: Colors.white)
                              : Icon(Icons.info_outline, color: Colors.white),
                          Text('Info', style: TextStyle(color: Colors.white)),
                        ],
                      ),
                      onPressed: () {
                        if (cartoons != null && cartoons!.length > 8) {
                          setState(() {
                            showMyDialog(cartoons![8]);
                          });
                        }
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.only(top: 20),
          sliver: SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      'Trending Now',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 25,
                          fontWeight: FontWeight.bold),
                    )),
                SizedBox(
                  height: 165,
                  child: CarouselSlider.builder(
                    itemCount: cartoons?.length ?? 0,
                    itemBuilder:
                        (BuildContext context, int index, int realIndex) {
                      final cartoon = cartoons![index];
                      return GestureDetector(
                        onTap: () {
                          showMyDialog(cartoon);
                        },
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Container(
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              height: 130,
                              width: 130,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border:
                                    Border.all(color: Colors.white, width: 4),
                                image: cartoon.posterURL != null &&
                                        cartoon.posterURL!.isNotEmpty
                                    ? DecorationImage(
                                        image: NetworkImage(cartoon.posterURL!),
                                        fit: BoxFit.cover,
                                        onError: (exception, stackTrace) {},
                                      )
                                    : null,
                              ),
                            ),
                            Container(
                              height: 130,
                              width: 130,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border:
                                    Border.all(color: Colors.white, width: 4),
                                gradient: const LinearGradient(
                                  colors: [
                                    Colors.black87,
                                    Colors.black45,
                                    Colors.transparent,
                                  ],
                                  stops: [0, 0.25, 1],
                                  begin: Alignment.bottomCenter,
                                  end: Alignment.topCenter,
                                ),
                              ),
                            ),
                            Positioned(
                              left: 10,
                              right: 0,
                              bottom: 0,
                              child: SizedBox(
                                height: 60,
                                child: Text(
                                  (index + 1).toString(),
                                  style: TextStyle(
                                    color: Colors.red,
                                    fontSize: 50,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                    options: CarouselOptions(
                      height: 130,
                      viewportFraction: 0.4,
                      initialPage: 0,
                      enableInfiniteScroll: true,
                      reverse: false,
                      autoPlay: true,
                      autoPlayInterval: Duration(seconds: 3),
                      autoPlayAnimationDuration: Duration(milliseconds: 800),
                      autoPlayCurve: Curves.fastOutSlowIn,
                      enlargeCenterPage: true,
                      scrollDirection: Axis.horizontal,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.only(top: 10),
          sliver: SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      'Animations',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 25,
                          fontWeight: FontWeight.bold),
                    )),
                SizedBox(
                  height: 300,
                  child: CarouselSlider.builder(
                    itemCount: cartoons?.length ?? 0,
                    itemBuilder:
                        (BuildContext context, int index, int realIndex) {
                      final cartoon = cartoons![index];
                      return GestureDetector(
                        onTap: () {
                          showMyDialog(cartoon);
                        },
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Container(
                              margin: const EdgeInsets.symmetric(horizontal: 8),
                              decoration: BoxDecoration(
                                image: cartoon.posterURL != null &&
                                        cartoon.posterURL!.isNotEmpty
                                    ? DecorationImage(
                                        image: NetworkImage(cartoon.posterURL!),
                                        fit: BoxFit.contain,
                                        onError: (exception, stackTrace) {},
                                      )
                                    : null,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                    options: CarouselOptions(
                      height: 500, // ปรับความสูงของ CarouselSlider.builder
                      viewportFraction: 0.4,
                      initialPage: 0,
                      enableInfiniteScroll: true,
                      reverse: false,
                      autoPlay: false,
                      scrollDirection: Axis.horizontal,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.only(top: 10),
          sliver: SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      'Horror',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 25,
                          fontWeight: FontWeight.bold),
                    )),
                SizedBox(
                  height: 300,
                  child: CarouselSlider.builder(
                    itemCount: movie?.length ?? 0,
                    itemBuilder:
                        (BuildContext context, int index, int realIndex) {
                      final movies = movie![index];
                      return GestureDetector(
                        onTap: () {
                          showMyDialog(movies);
                        },
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Container(
                              margin: const EdgeInsets.symmetric(horizontal: 8),
                              decoration: BoxDecoration(
                                image: movies.posterURL != null &&
                                        movies.posterURL!.isNotEmpty
                                    ? DecorationImage(
                                        image: NetworkImage(movies.posterURL!),
                                        fit: BoxFit.contain,
                                        onError: (exception, stackTrace) {},
                                      )
                                    : null,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                    options: CarouselOptions(
                      height: 500, // ปรับความสูงของ CarouselSlider.builder
                      viewportFraction: 0.4,
                      initialPage: 0,
                      enableInfiniteScroll: true,
                      reverse: false,
                      autoPlay: false,
                      scrollDirection: Axis.horizontal,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.only(top: 10),
          sliver: SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      'Comedy',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 25,
                          fontWeight: FontWeight.bold),
                    )),
                SizedBox(
                  height: 300,
                  child: CarouselSlider.builder(
                    itemCount: comedy?.length ?? 0,
                    itemBuilder:
                        (BuildContext context, int index, int realIndex) {
                      final comedys = comedy![index];
                      return GestureDetector(
                        onTap: () {
                          showMyDialog(comedys);
                        },
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Container(
                              margin: const EdgeInsets.symmetric(horizontal: 8),
                              decoration: BoxDecoration(
                                image: comedys.posterURL != null &&
                                        comedys.posterURL!.isNotEmpty
                                    ? DecorationImage(
                                        image: NetworkImage(comedys.posterURL!),
                                        fit: BoxFit.contain,
                                        onError: (exception, stackTrace) {},
                                      )
                                    : null,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                    options: CarouselOptions(
                      height: 500, // ปรับความสูงของ CarouselSlider.builder
                      viewportFraction: 0.4,
                      initialPage: 0,
                      enableInfiniteScroll: true,
                      reverse: false,
                      autoPlay: false,
                      scrollDirection: Axis.horizontal,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.only(top: 10),
          sliver: SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      'Drama',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 25,
                          fontWeight: FontWeight.bold),
                    )),
                SizedBox(
                  height: 300,
                  child: CarouselSlider.builder(
                    itemCount: drama?.length ?? 0,
                    itemBuilder:
                        (BuildContext context, int index, int realIndex) {
                      final dramas = drama![index];
                      return GestureDetector(
                        onTap: () {
                          showMyDialog(dramas);
                        },
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Container(
                              margin: const EdgeInsets.symmetric(horizontal: 8),
                              decoration: BoxDecoration(
                                image: dramas.posterURL != null &&
                                        dramas.posterURL!.isNotEmpty
                                    ? DecorationImage(
                                        image: NetworkImage(dramas.posterURL!),
                                        fit: BoxFit.contain,
                                        onError: (exception, stackTrace) {},
                                      )
                                    : null,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                    options: CarouselOptions(
                      height: 500, // ปรับความสูงของ CarouselSlider.builder
                      viewportFraction: 0.4,
                      initialPage: 0,
                      enableInfiniteScroll: true,
                      reverse: false,
                      autoPlay: false,
                      scrollDirection: Axis.horizontal,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Future<void> showMyDialog(
    Movies cartoon,
  ) async {
    return showDialog<void>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          bool localIsFavorite = ApiPage.isFavorite(cartoon);
          double currentRating = Random().nextDouble() * 6;
          print(cartoon.randomRating);
          return AlertDialog(
            title: Text(
              cartoon.title.toString(),
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w400,
                fontSize: 30, // กำหนดขนาดตัวหนงาสือ
              ),
            ),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  SizedBox(
                    height: 8,
                  ),
                  cartoon.posterURL == ''
                      ? Icon(Icons.error, color: Colors.red)
                      : Image.network(
                          cartoon.posterURL ?? '',
                          errorBuilder: (context, error, stackTrace) {
                            return Icon(Icons.error, color: Colors.red);
                          },
                        ),
                  

                  Text(
                    'Rating:',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ), // เพิ่มข้อความเรตติ้ง
                  RatingBar.builder(
                    initialRating: cartoon.randomRating,
                    minRating: 1,
                    direction: Axis.horizontal,
                    allowHalfRating: true,
                    itemCount: 5,
                    itemPadding: EdgeInsets.symmetric(horizontal: 1.0),
                    itemSize: 30,
                    itemBuilder: (context, _) => Icon(
                      Icons.star,
                      color: Colors.amber,
                    ),
                    onRatingUpdate: (rating) {
                      setState(() {
                        currentRating = rating;
                      });
                    },
                  ),
                  SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: () => {},
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.play_arrow, color: Colors.black),
                          SizedBox(
                            width: 4,
                          ),
                          Text('Play', style: TextStyle(color: Colors.black)),
                        ]),
                  ),
                  SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: () => {},
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                          Colors.black), // ตั้งสีพื้นหลังของปุ่มเป็นสีดำ
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.file_download_outlined,
                            color: Colors.white), // ตั้งสีของไอคอนเป็นสีเทา
                        SizedBox(width: 4),
                        Text('Download',
                            style: TextStyle(
                                color:
                                    Colors.white)), // ตั้งสีของข้อความเป็นสีเทา
                      ],
                    ),
                  ),
                  SizedBox(height: 16),
                ],
              ),
            ),
            actions: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: Column(
                      children: [
                        ApiPage.saved.contains(cartoon)
                            ? Icon(Icons.favorite, color: Colors.pink)
                            : Icon(Icons.favorite_border, color: Colors.grey),
                        Text('Favorite'),
                      ],
                    ),
                    onPressed: () {
                      setState(() {
                        ApiPage.toggleFavorite(cartoon);
                      });
                      Navigator.of(context).pop(); // Close the dialog
                    },
                  ),
                  TextButton(
                    child: Icon(
                      Icons.close,
                      size: 30,
                      color: const Color.fromARGB(255, 0, 0, 0),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop(); // Close the dialog
                    },
                  ),
                ],
              ),
            ],
          );
        });
  }
}
