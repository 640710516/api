import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:api/Movie.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class ApiPage extends StatefulWidget {
  static final Set<Movies> saved = <Movies>{};
  static List<Movies>? PMovies;
  static List<Movies>? Panimation;
  static List<Movies>? Pcomedy;

  const ApiPage({Key? key}) : super(key: key);

  @override
  _ApiPageState createState() => _ApiPageState();

  static void toggleFavorite(Movies Movies) {
    if (saved.contains(Movies)) {
      saved.remove(Movies);
    } else {
      saved.add(Movies);
    }
    Movies.isFavorite = !Movies.isFavorite;
  }

  static bool isFavorite(Movies Movies) {
    return saved.contains(Movies);
  }
}

class _ApiPageState extends State<ApiPage> {
  List<Movies>? MoviesList;
  List<Movies>? cartoons;
  List<Movies>? movie;
  List<Movies>? comedy;
  @override
  void initState() {
    super.initState();
    if (ApiPage.PMovies == null) {
      _getMoviess();
      _getComedyApi();
      _getMovieApi();
    } else {
      MoviesList = ApiPage.PMovies;
      
    }
  }

  void _getMoviess() async {
    var dio = Dio(BaseOptions(responseType: ResponseType.plain));
    var response = await dio.get('https://api.sampleapis.com/movies/animation');
    if (response.statusCode == 200) {
      List list = jsonDecode(response.data);
      setState(() {
        MoviesList = list.map((json) => Movies.fromJson(json)).toList();
        MoviesList!.sort((a, b) => a.title!.compareTo(b.title!));
        ApiPage.PMovies = MoviesList;
        cartoons = MoviesList;
      });
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
          ApiPage.Panimation = movie;
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
          ApiPage.Pcomedy = comedy;
        });
      } else {
        print('Failed to load data: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching API: $e');
    }
  }

  Movies getRandomMovies() {
    final Random random = Random();
    final int index = random.nextInt(MoviesList!.length);
    return MoviesList![index];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'All Movies',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w800,
            fontSize: 30,
          ),
        ),
        backgroundColor: Colors.black,
      ),
      body: MoviesList == null
          ? const Center(child: CircularProgressIndicator())
          : CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: Column(
                    children: MoviesList!.map((Movies) {
                      return ListTile(
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        title: Text(
                          Movies.title.toString(),
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w400,
                            fontSize: 18,
                          ),
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Movies.posterURL == ''
                                ? Icon(Icons.error, color: Colors.red)
                                : Image.network(
                                    Movies.posterURL ?? '',
                                    errorBuilder: (context, error, stackTrace) {
                                      return Icon(Icons.error,
                                          color: Colors.red);
                                    },
                                    width: 50,
                                  ),
                            SizedBox(width: 8),
                          ],
                        ),
                        onTap: () {
                          showMoviesDialog(Movies);
                        },
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
    );
  }

  Future<void> showMoviesDialog(
    Movies movie,
  ) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        Movies randomMovies1 = getRandomMovies();
        Movies randomMovies2 = getRandomMovies();
        Movies randomMovies3 = getRandomMovies();
        return AlertDialog(
          title: Text(
            movie.title.toString(),
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w400,
              fontSize: 30,
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
                Text(
                  'Rating:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
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
                  onRatingUpdate: (rating) {},
                ),
                SizedBox(height: 8),
                ElevatedButton(
                  onPressed: () => {},
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.play_arrow, color: Colors.black),
                      SizedBox(width: 4),
                      Text('Play', style: TextStyle(color: Colors.black)),
                    ],
                  ),
                ),
                SizedBox(height: 8),
                ElevatedButton(
                  onPressed: () => {},
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                      Colors.black,
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.file_download_outlined, color: Colors.white),
                      SizedBox(width: 4),
                      Text('Download', style: TextStyle(color: Colors.white)),
                    ],
                  ),
                ),
                SizedBox(height: 16),
                Row(
                  children: [
                    Text('Hot', style: TextStyle(color: Colors.black)),
                    SizedBox(width: 4),
                    Icon(Icons.local_fire_department, color: Colors.red),
                  ],
                ),
                SizedBox(height: 16),
                Row(
                  children: [
                    InkWell(
                      onTap: () {
                        showMoviesDialog(
                          randomMovies1,
                        );
                      },
                      child: Container(
                        width: 100,
                        height: 150,
                        child: Image.network(
                          randomMovies1.posterURL ?? '',
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
                        showMoviesDialog(
                          randomMovies2,
                        );
                      },
                      child: Container(
                        width: 100,
                        height: 150,
                        child: Image.network(
                          randomMovies2.posterURL ?? '',
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
                        showMoviesDialog(
                          randomMovies3,
                        );
                      },
                      child: Container(
                        width: 100,
                        height: 150,
                        child: Image.network(
                          randomMovies3.posterURL ?? '',
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
                      Icon(
                        ApiPage.isFavorite(movie)
                            ? Icons.favorite
                            : Icons.favorite_border,
                        color: ApiPage.isFavorite(movie)
                            ? Colors.pink
                            : Colors.grey,
                      ),
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
                    Navigator.of(context).pop(); // Close the dialog
                  },
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
