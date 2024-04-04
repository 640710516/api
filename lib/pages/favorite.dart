import 'package:flutter/material.dart';
import 'package:api/api.dart';
import 'package:api/Cartoons.dart';
class Favorite extends StatelessWidget {
  
  const Favorite({super.key});

  @override
  Widget build(BuildContext context) {
    // ใช้ isFavorite จาก ApiPage
    bool isFavorite = ApiPage()._saved.contains(Cartoons); // นี่เป็นตัวอย่างเท่านั้น อาจต้องแก้ไขตามการใช้งานจริง

    return Scaffold(
      appBar: AppBar(
        title: Text('New Page'),
      ),
      body: Center(
        child: Text(
          'Is Favorite: $isFavorite',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
