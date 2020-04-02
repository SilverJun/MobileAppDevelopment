// Copyright 2018-present the Flutter authors. All Rights Reserved.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

import 'package:flutter/material.dart';
import 'package:midterm/HotelInfo.dart';
import 'package:midterm/detailPage.dart';

Row buildStarWidget(int star, double size) {
  return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: List<Widget>.generate(star, (int index){
        return Icon(Icons.star, color: Colors.yellow, size: size,);
      })
  );
}

class HomePage extends StatelessWidget {

  List<Card> _buildGridCards(BuildContext context) {

    final ThemeData theme = Theme.of(context);

    return hotelList.map((product) {
      return Card(
        clipBehavior: Clip.antiAlias,
        child: Stack(
          alignment: Alignment.bottomRight,
          children : <Widget>[
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                AspectRatio(
                  aspectRatio: 18 / 11,
                  child: Image.asset(
                    product.image,
                    fit: BoxFit.fitWidth,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(top:28.0),
                        child: Icon(Icons.location_on, color: theme.primaryColor,),
                      ),
                      Flexible(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            buildStarWidget(product.star, 10.0),
                            Text(
                              product.name,
                              style: theme.textTheme.title.merge(TextStyle(fontWeight: FontWeight.bold)),
                              textScaleFactor: 0.8,
                              maxLines: 1,
                            ),
                            SizedBox(height: 8.0),
                            Text(
                                product.location,
                                style: theme.textTheme.body2,
                                textScaleFactor: 0.8,
                              ),
                            SizedBox(height: 8.0),
                          ],
                        ),
                      ),
                    ]
                  ),
                ),
              ]
            ),
            Positioned(
              bottom: 6,
              right: 2,
              child: Container(
                height: 20,
                width: 70,
                child: FlatButton(
                  child: Text('more', style: TextStyle(fontSize: 14),),
                  textColor: theme.primaryColor,
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>DetailPage(hotel: product,)));
                  },
                ),
              ),
            ),
          ],
        ),
      );
    }).toList();
  }

  ListTile _buildDrawerListTile(context, IconData icon, String text, String route)
  {
    return ListTile(
      leading: Icon(icon, color: Theme.of(context).primaryColor,),
      title: Text(text),
      onTap: () {
        if (route == '/home') Navigator.pop(context);
        else Navigator.popAndPushNamed(context, route);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Main'),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.search,
              semanticLabel: 'search',
            ),
            onPressed: () {
              Navigator.pushNamed(context, '/search');
            },
          ),
          IconButton(
            icon: Icon(
              Icons.language,
              semanticLabel: 'website',
            ),
            onPressed: () {
              Navigator.pushNamed(context, '/website');
            },
          )
        ],
      ),
      body: OrientationBuilder(
        builder: (context, orientation) => GridView.count(
          crossAxisCount: orientation==Orientation.landscape?3:2,
          padding: EdgeInsets.all(16.0),
          childAspectRatio: 8.0 / 9.0,
          children: _buildGridCards(context),
        ),
      ),
      resizeToAvoidBottomInset: false,
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            DrawerHeader(
              child: Flex(
                direction: Axis.vertical,
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text('Pages', style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.normal),)
                ],
              ),
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
            ),
            //search, location_city, language, person
            _buildDrawerListTile(context, Icons.home, 'Home', '/home'),
            _buildDrawerListTile(context, Icons.search, 'Search', '/search'),
            _buildDrawerListTile(context, Icons.location_city, 'Favorite Hotel', '/favorite'),
            _buildDrawerListTile(context, Icons.language, 'Website', '/website'),
            _buildDrawerListTile(context, Icons.person, 'My Page', '/mypage'),
          ],
        ),
      ),
    );
  }
}
