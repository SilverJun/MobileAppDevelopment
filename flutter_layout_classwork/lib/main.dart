import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      title: 'Flutter layout demo',
      theme: ThemeData(primaryColor: Colors.black),
      home: Scaffold(
//        appBar: AppBar(
//          title: Text('Flutter layout demo'),
//        ),
        body: ListView(
          children: <Widget>[
            Image.asset(
              'images/lake.jpg',
              width: 600,
              height: 240,
              fit: BoxFit.cover,
            ),
            TitleSection(),
            Divider(height: 1.0, color: Colors.black,),
            ButtonSection(),
            Divider(height: 1.0, color: Colors.black,),
            BottomSection(),
          ],
        ),
      ),
    );
  }
}


class _FavoriteWidgetState extends State<FavoriteWidget> {
  bool _isFavorited = true;
  int _favoriteCount = 41;

  void _toggleFavorite() {
    setState(() {
      if (_isFavorited) {
        _favoriteCount -= 1;
        _isFavorited = false;
      } else {
        _favoriteCount += 1;
        _isFavorited = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Container(
            padding: EdgeInsets.all(0),
            child: IconButton(
              icon: (_isFavorited ? Icon(Icons.star) : Icon(Icons.star_border)),
              color: Colors.red[500],
              onPressed: _toggleFavorite,
            )
        ),
        SizedBox(
            width: 18,
            child: Container(
                child: Text("$_favoriteCount")
            )
        )
      ],
    );
  }
}

class FavoriteWidget extends StatefulWidget {
  @override
  _FavoriteWidgetState createState() => _FavoriteWidgetState();
}

class TitleSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.all(32),
        child: Row(
          children: <Widget>[
            Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Text(
                      'EUNJUN JANG',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    )
                ),
                Text(
                  '21800633',
                  style: TextStyle(
                    color: Colors.grey[500],
                  ),
                )
              ],
            )
            ),
            FavoriteWidget(),
          ]
        )
    );
  }
}


class ButtonSection extends StatelessWidget {
  Column _buildButtonColumn(Color color, IconData icon, String label) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Icon(icon, color: color),
        Container(
            margin: const EdgeInsets.only(top: 8),
            child: Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w400,
                color: color,
              ),
            )
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    Color color = Theme.of(context).primaryColor;

    return Container(
        padding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
        child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildButtonColumn(color, Icons.call, 'CALL'),
              _buildButtonColumn(color, Icons.message, 'MESSAGE'),
              _buildButtonColumn(color, Icons.email, 'EAMIL'),
              _buildButtonColumn(color, Icons.share, 'SHARE'),
              _buildButtonColumn(color, Icons.description, 'ETC'),
            ]
        )
    );
  }
}

class BottomSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    return Container(
      padding: const EdgeInsets.all(32),
      child: Row(
        children: <Widget>[
          Icon(
            Icons.message,
            color: Theme.of(context).primaryColor,
            size: 40.0,
          ),
          Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                      padding: EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
                      child: Text(
                        'Recent Message',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      )
                  ),
                  Container(
                      padding: EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
                      child: Text(
                        'Long time no see!',
                        style: TextStyle(
                          color: Colors.grey[500],
                        ),
                      )
                  )
                ],
              )
          ),
        ],
      ),
    );
  }
}