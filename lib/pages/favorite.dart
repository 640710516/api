import 'dart:math';

import 'package:api/Movie.dart';
import 'package:flutter/material.dart';
import 'package:api/api.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class FavoritePage extends StatefulWidget {
  FavoritePage({Key? key}) : super(key: key);
  
  @override
  _FavoritePageState createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  ApiPage api = ApiPage();

  Movies getRandomMovie() {
    final Random random = Random();
    final int index = random.nextInt(ApiPage.saved.length);
    return ApiPage.saved.elementAt(index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorites', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 30),),
        backgroundColor: Colors.black,
      ),
      body: ListView.builder(
        itemCount: ApiPage.saved.length,
        itemBuilder: (context, index) {
          var movie = ApiPage.saved.elementAt(index);
          return ListTile(
            title: Text(
              movie.title.toString(),
              style: TextStyle(
                color: const Color.fromARGB(255, 255, 255, 255),
                fontWeight: FontWeight.w400,
                fontSize: 18, // กำหนดขนาดตัวหนงาสือ
              ),
            ),
            leading: movie.posterURL == ''
                ? Icon(Icons.error, color: Colors.red)
                : Image.network(
                    movie.posterURL ?? '',
                    errorBuilder: (context, error, stackTrace) {
                      return Icon(Icons.error, color: Colors.red);
                    },
                  ),
            trailing: IconButton(
              icon: Icon(
                  movie.isFavorite ? Icons.delete_forever : Icons.delete,
                  color: const Color.fromARGB(255, 255, 255, 255)),
              onPressed: () {
                setState(() {
                  ApiPage.toggleFavorite(movie);
                });
              },
            ),
            onTap: () {
              showMyDialog(movie);
            },
          );
        },
      ),
    );
  }

  Future<void> showMyDialog(
    Movies movie,
  ) async {
    return showDialog<void>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          bool localIsFavorite = ApiPage.isFavorite(movie);
          double currentRating = Random().nextDouble() * 6;

          print(movie.randomRating);
          return AlertDialog(
            title: Text(
              movie.title.toString(),
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
                  movie.posterURL == ''
                      ? Icon(Icons.error, color: Colors.red)
                      : Image.network(
                          movie.posterURL ?? '',
                          errorBuilder: (context, error, stackTrace) {
                            return Icon(Icons.error, color: Colors.red);
                          },
                        ),
                  SizedBox(height: 8),      
                  
                  Text('Rating:',style: TextStyle(fontWeight: FontWeight.bold,),), // เพิ่มข้อความเรตติ้ง
                  RatingBar.builder(
                    initialRating: movie.randomRating,
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
                  Row(children: [
                    Text('ดูต่อ', style: TextStyle(color: Colors.black)),
                    SizedBox(
                      width: 4,
                    ),
                    Icon(Icons.local_fire_department, color: Colors.red),
                  ]),
                  SizedBox(height: 16),
                  Row(
                    children: [
                      InkWell(
                        onTap: () {
                          showMyDialog(getRandomMovie());
                        },
                        child: Container(
                          width: 100,
                          height: 150,
                          child: Image.network(
                            getRandomMovie().posterURL ?? '',
                            errorBuilder: (context, error, stackTrace) {
                              return Icon(Icons.error, color: Colors.red);
                            },
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      SizedBox(width: 8),
                      InkWell(
                        onTap: () {
                          showMyDialog(getRandomMovie());
                        },
                        child: Container(
                          width: 100,
                          height: 150,
                          child: Image.network(
                            getRandomMovie().posterURL ?? '',
                            errorBuilder: (context, error, stackTrace) {
                              return Icon(Icons.error, color: Colors.red);
                            },
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      SizedBox(width: 8),
                      InkWell(
                        onTap: () {
                          showMyDialog(getRandomMovie());
                        },
                        child: Container(
                          width: 100,
                          height: 150,
                          child: Image.network(
                            getRandomMovie().posterURL ?? '',
                            errorBuilder: (context, error, stackTrace) {
                              return Icon(Icons.error, color: Colors.red);
                            },
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ],
                  ),
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
                        ApiPage.isFavorite(movie)
                            ? Icon(Icons.favorite, color: Colors.pink)
                            : Icon(Icons.favorite_border, color: Colors.grey),
                        Text('Favorite'),
                      ],
                    ),
                    onPressed: () {
                      setState(() {
                        ApiPage.toggleFavorite(movie);
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
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ],
          );
        });
  }
}


