
import 'package:flutter/material.dart';
import 'package:midterm/HotelInfo.dart';

class FavoritePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => FavoritePageState();

}

class FavoritePageState extends State<FavoritePage> {
  final items = favoriteList.toList();

  @override
  Widget build(BuildContext context) {
    final Iterable<Dismissible> tiles = favoriteList.map((Hotel hotel) {
      return Dismissible(
        key: Key(hotel.name),
        onDismissed: (direction) {
          setState(() {
            items.remove(hotel);
          });
          favoriteList.remove(hotel);
        },
        background: Container(color: Colors.red),
        child: ListTile(
          title: Text(
            hotel.name,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      );
    });

    final List<Widget> divided = ListTile.divideTiles(
      context: context,
      tiles: tiles,
    ).toList();

    return Scaffold(
        appBar: AppBar(title: Text('Favorite'),),
        body: ListView(children: divided)
    );
  }
}