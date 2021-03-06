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

import 'package:finaltest/add.dart';
import 'package:finaltest/profile.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:finaltest/product.dart';
import 'package:finaltest/AppData.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'package:finaltest/detail.dart';
import 'package:finaltest/add.dart';


class SortMenuWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => SortMenuWidgetState();
}

class SortMenuWidgetState extends State<SortMenuWidget> {
  String dropdownValue = 'ASC';

  @override
  Widget build(BuildContext context) {
    return Center(
      child: DropdownButton<String>(
        value: dropdownValue,
        icon: Icon(Icons.arrow_drop_down),
        iconSize: 24,
        elevation: 16,
        underline: Container(
          height: 2,
        ),
        onChanged: (String newValue) {
          setState(() {
            dropdownValue = newValue;
            isDescending = newValue=='DESC';
            print(isDescending);

            context.findAncestorStateOfType<HomePageState>().rebuild();
          });

          // query and sorting
        },
        items: <String>['ASC', 'DESC']
            .map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
      ),
    );
  }

}

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => HomePageState();

}

class HomePageState extends State<HomePage> {

  void rebuild() {
    setState(() {});
  }

  Widget _buildBody(BuildContext context) {
    List<DocumentSnapshot> list;
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance.collection('product').snapshots(),
      builder: (context, snapshot) {
        //print(snapshot);
        if (!snapshot.hasData) return LinearProgressIndicator();
        list = snapshot.data.documents;
        list.sort((a, b) {
          if (isDescending) return b['price'].compareTo(a['price']);
          else return a['price'].compareTo(b['price']);
        });
        return _buildGrid(context, list);
      },
    );
  }

  Widget _buildGrid(BuildContext context, List<DocumentSnapshot> snapshot) {
    return GridView.count(
      shrinkWrap: true,
      physics: ScrollPhysics(),
      crossAxisCount: 2,
      padding: EdgeInsets.all(16.0),
      childAspectRatio: 8.0 / 9.0,
      children: snapshot.map((data) => _buildCard(context, data)).toList(),
    );
  }

  Widget _buildCard(BuildContext context, DocumentSnapshot data) {
    final Product product = Product.fromSnapshot(data);
    final ThemeData theme = Theme.of(context);
    final NumberFormat formatter = NumberFormat.simpleCurrency(
        locale: Localizations.localeOf(context).toString());

    return Card(
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              AspectRatio(
                aspectRatio: 18 / 11,
                child: FutureBuilder(
                  future: getImageURL(data['filename']),
                  builder: (context, AsyncSnapshot<String> value) {
                    return Image.network(
                      value.hasData ? value.data : "http://handong.edu/site/handong/res/img/logo.png",
                      width: MediaQuery.of(context).size.width,
                      fit: BoxFit.cover,
                    );
                  }
                ),
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(16.0, 12.0, 16.0, 8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        product.name,
                        style: theme.textTheme.title,
                        maxLines: 1,
                      ),
                      SizedBox(height: 8.0),
                      Text(
                        formatter.format(product.price),
                        style: theme.textTheme.bodyText1,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Positioned(
            bottom: 2,
            right: 2,
            child: Container(
              height: 30,
              width: 70,
              child: FlatButton(
                child: Text('more', style: TextStyle(fontSize: 14),),
                textColor: theme.primaryColor,
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>DetailPage(product: product,)));
                },
              ),
            ),
          ),
        ]
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.person,
            semanticLabel: 'profile',
          ),
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => ProfilePage()));
          },
        ),
        title: Text('Main'),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.add,
              semanticLabel: 'add',
            ),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(fullscreenDialog: true, builder: (context) => AddPage()));
            },
          ),
        ],
      ),
      body: ListView(
        children: <Widget>[
          SizedBox(height: 8.0,),
          SortMenuWidget(),
          SizedBox(height: 8.0,),
          Container(child: _buildBody(context)),
        ]
      ),
      resizeToAvoidBottomInset: false,
    );
  }
}
