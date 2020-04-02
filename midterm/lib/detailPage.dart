
import 'package:flutter/material.dart';
import 'package:midterm/home.dart';
import 'package:midterm/HotelInfo.dart';

class DetailPage extends StatelessWidget {
  final Hotel hotel;

  DetailPage({this.hotel});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(title: Text('Detail'),),
      body: ListView(
        children: <Widget>[
          Column(
            children: <Widget>[
              Stack(
                children: <Widget>[
                  Image.asset(
                    hotel.image,
                    width: MediaQuery.of(context).size.width,
                    fit: BoxFit.cover,
                  ),
                  Positioned(
                    top: 10,
                    right: 10,
                    child: FavoriteIconWidget(hotel: hotel,)
                  )
                ]
              ),
              Padding(
                padding: EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    buildStarWidget(hotel.star, 24),
                    Text(hotel.name, style: Theme.of(context).textTheme.title.merge(TextStyle(color: Color.fromRGBO(42, 88, 149, 1.0), fontWeight: FontWeight.bold)),),
                    SizedBox(height: 16.0,),
                    Row(
                      children: <Widget>[
                        Icon(Icons.location_on, color: Colors.lightBlue,),
                        Text(hotel.location, style: Theme.of(context).textTheme.subtitle.merge(TextStyle(color: Colors.blueAccent))),
                      ]
                    ),
                    SizedBox(height: 8.0,),
                    Row(
                      children: <Widget>[
                        Icon(Icons.phone, color: Colors.lightBlue,),
                        Text(hotel.tel, style: Theme.of(context).textTheme.subtitle.merge(TextStyle(color: Colors.blueAccent))),
                      ]
                    ),
                    SizedBox(height: 8.0,),
                    Divider(thickness: 1.5,),
                    SizedBox(height: 8.0,),
                    Text(hotel.detail, style: Theme.of(context).textTheme.body1.merge(TextStyle(color: Colors.blueAccent)))
                  ],
                ),
              )

            ],
          )
        ],
      ),
    );
  }
}

class FavoriteIconWidget extends StatefulWidget {
  final Hotel hotel;
  bool isContained;

  FavoriteIconWidget({this.hotel})
  {
    print(favoriteList);
    isContained = favoriteList.contains(hotel);
  }

  @override
  State<StatefulWidget> createState() => FavoriteIconState();

}

class FavoriteIconState extends State<FavoriteIconWidget> {

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(widget.isContained ? Icons.favorite : Icons.favorite_border, color: Colors.red,),
      onPressed: () {
        if (widget.isContained)
          favoriteList.remove(widget.hotel);
        else
          favoriteList.add(widget.hotel);
        setState(() {
          widget.isContained = !widget.isContained;
        });
      },
    );
  }
}