import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:api/Cartoons.dart';

class ApiPage extends StatefulWidget {
  static List<Cartoons>? _cartoons; // กำหนดตัวแปร _cartoons เป็น static

  const ApiPage({Key? key}) : super(key: key);

  State<ApiPage> createState() => _ApiPageState();
}

class _ApiPageState extends State<ApiPage> {
  bool isFavorite = false;
  final _saved = Set<Cartoons>();

  void _toggleFavorite(Cartoons cartoon) {
    setState(() {
      if (_saved.contains(cartoon)) {
        _saved.remove(cartoon);
      } else {
        _saved.add(cartoon);
      }
    });
  }

  @override
  void initState() {
    super.initState();
    if (ApiPage._cartoons == null) {
      _getCartoons();
    }
  }

  void _getCartoons() async {
    var dio = Dio(BaseOptions(responseType: ResponseType.plain));
    var response =
        await dio.get('https://api.sampleapis.com/cartoons/cartoons2D');
    print('Status code: ${response.statusCode}');
    response.headers.forEach((title, value) {
      print('$title: $value');
    });
    print(response.data.toString());
    List list = jsonDecode(response.data);
    setState(() {
      ApiPage._cartoons = list.map((json) => Cartoons.fromJson(json)).toList();
      ApiPage._cartoons!.sort((a, b) => a.title!.compareTo(b.title!));
    });
  }

  @override
  Widget build(BuildContext context) {
    final alreadySaved = _saved.contains(Cartoons);
    return Scaffold(
        body: Column(
      children: [
        Expanded(
            child: ApiPage._cartoons == null
                ? SizedBox.shrink()
                : ListView.builder(
                    itemCount: ApiPage._cartoons!.length,
                    itemBuilder: (context, index) {
                      var Cartoons = ApiPage._cartoons![index];
                      return ListTile(
                          title: Text(Cartoons.title ?? ''),
                          subtitle: Text(
                              'All episodes: ' + Cartoons.episodes.toString()),
                          trailing: Row(
                            mainAxisSize: MainAxisSize
                                .min, // ปรับขนาดของ Row ให้เหมาะสมกับส่วนที่ใช้งานจริง
                            children: [
                              Cartoons.image == ''
                                  ? Icon(Icons.error, color: Colors.red)
                                  : Image.network(
                                      Cartoons.image ?? '',
                                      errorBuilder:
                                          (context, error, stackTrace) {
                                        return Icon(Icons.error,
                                            color: Colors.red);
                                      },
                                    ),
                              // SizedBox(width: 8), // เพิ่มระยะห่างระหว่างไอคอน
                              // Icon(
                              //   isFavorite
                              //       ? Icons.favorite
                              //       : Icons.favorite_border,
                              //   color: isFavorite ? Colors.red : null,
                              // ),
                            ],
                          ),
                          onTap: () {
                            _toggleFavorite(Cartoons);
                            _showMyDialog(
                                Cartoons.title ?? '',
                                Cartoons.creator ?? [],
                                Cartoons.genre ?? [],
                                Cartoons.episodes ?? 0,
                                Cartoons.image ?? '',
                                Cartoons.runtime_in_minutes ?? 0,
                                Cartoons);
                          });
                    },
                  )),
      ],
    ));
  }

  Future<void> _showMyDialog(
      String title,
      List creator,
      List genre,
      int episodes,
      String image,
      int runtime_in_minutes,
      Cartoons cartoons) async {
    return showDialog<void>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          bool localIsFavorite = cartoons.isFavorite;
          return AlertDialog(
            title: Text(title),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Text('All episodes: ' + episodes.toString()),
                  Text('Runtime_in_minutes: ' + runtime_in_minutes.toString()),
                  Text('Creator: ' + creator.toString()),
                  Text('Genre: ' + genre.toString()),
                  image.isNotEmpty
                      ? Image.network(
                          image,
                          errorBuilder: (context, error, stackTrace) {
                            return Icon(Icons.error, color: Colors.red);
                          },
                        )
                      : Text('No image available'),
                ],
              ),
            ),
            actions: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  StatefulBuilder(
                    builder: (BuildContext context, StateSetter setState) {
                      return IconButton(
                        icon: localIsFavorite
                            ? Icon(Icons.favorite, color: Colors.pink)
                            : Icon(Icons.favorite_border, color: Colors.grey),
                        onPressed: () {
                          setState(() {
                            localIsFavorite = !localIsFavorite;
                          });
                          cartoons.isFavorite = localIsFavorite;
                          Navigator.of(context).pop();
                        },
                      );
                    },
                  ),
                  TextButton(
                    child: const Text('CLOSE'),
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

