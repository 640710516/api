import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:api/Cartoons.dart';

class ApiPage extends StatefulWidget {
  const ApiPage({Key? key}) : super(key: key);

  State<ApiPage> createState() => _ApiPageState();
}
class _ApiPageState extends State<ApiPage>{
  List<Cartoons>? _cartoons;

  void _getCartoons() async {
    var dio = Dio(BaseOptions(responseType: ResponseType.plain));
    var response = await dio.get('https://api.sampleapis.com/cartoons/cartoons2D');
    print('Status code: ${response.statusCode}');
    response.headers.forEach((title, value) {
      print('$title: $value');
    });
    print(response.data.toString());
    List list = jsonDecode(response.data);
    setState(() {
      
      _cartoons = list.map((json) => Cartoons.fromJson(json)).toList();
      _cartoons!.sort((a, b) => a.title!.compareTo(b.title!));
    });
  }
  @override
  void initState() {
    super.initState();
    _getCartoons();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cartoons List',style: TextStyle(color: Colors.white,fontSize: 30,fontWeight: FontWeight.bold),),
        centerTitle: true,
        backgroundColor: Colors.red,
      ),
      body: Column(
        children: [
          Expanded(
            child: _cartoons == null
            ? SizedBox.shrink()
            : ListView.builder(
              itemCount: _cartoons!.length,
              itemBuilder: (context, index) {
                var Cartoons = _cartoons![index];
                return ListTile(
                  title: Text(Cartoons.title ?? ''),
                  subtitle: Text('All episodes: '+Cartoons.episodes.toString()),
                  trailing: Cartoons.image == ''
                          ? null
                          : Image.network(
                              Cartoons.image ?? '',
                              errorBuilder: (context, error, stackTrace) {
                                return Icon(Icons.error, color: Colors.red);
                              },
                            ),
                  onTap: () {
                    _showMyDialog(
                          Cartoons.title ?? '',
                          Cartoons.creator ?? [],
                          Cartoons.genre ?? [],
                          Cartoons.episodes ?? 0,
                          Cartoons.image ?? '',
                          Cartoons.runtime_in_minutes ?? 0
                          
                        );
                  }
                );
              },
            )
          ),
        ],
      )
    );
  }
  Future<void> _showMyDialog(String title,  List creator,List genre,int episodes, String image, int runtime_in_minutes) async{
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('All episodes: ' + episodes.toString()),
                Text('Runtime_in_minutes: ' + runtime_in_minutes.toString()),
                Text('Creator: ' + creator.toString()),
                Text('Genre: ' + genre.toString()),
                image.isNotEmpty ? Image.network(
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
            TextButton(
              child: const Text('CLOSE'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            )
          ],
        );
      }
    );
  }
}