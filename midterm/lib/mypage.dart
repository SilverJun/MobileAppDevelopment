
import 'package:flutter/material.dart';
import 'package:midterm/HotelInfo.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:midterm/detailPage.dart';

class MyPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => MyPageState();
}

class MyPageState extends State<MyPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('My Page'),),
      body: Column(
        children: <Widget>[
          SizedBox(height: 16.0,),
          CarouselSlider(
            viewportFraction: 0.9,
            aspectRatio: 2.0,
            autoPlay: true,
            enlargeCenterPage: true,
            items: hotelList.map( (hotel) {
                return Container(
                  margin: EdgeInsets.all(5.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(5.0)),
                    child: Stack(
                      alignment: Alignment.center,
                      children: <Widget>[
                        GestureDetector(
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(fullscreenDialog: true, builder: (context) => DetailPage(index: hotelList.indexOf(hotel),)));
                          },
                          child: Image.asset(
                            hotel.image,
                            fit: BoxFit.cover,
                            width: 1000.0,
                          ),
                        ),
                        Positioned(
                          top: 4,
                          child: Text(hotel.name, style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),),
                        )
                      ]
                    ),
                  ),
                );
              },
            ).toList(),
          ),
        ]
      ),
    );
  }
}

/*
onPressed: () {
  Navigator.push(context, MaterialPageRoute(fullScreenDialog: true, builder: (context)=>DetailPage(index: hotelList.indexOf(product),)));
}
 */