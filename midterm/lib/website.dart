
import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebSitePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => WebSiteState();

}

class WebSiteState extends State<WebSitePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(''),),
      body: WebView(
        initialUrl: 'https://www.handong.edu',
        javascriptMode: JavascriptMode.unrestricted,
        onPageFinished: (String url) {
          print('finished:' + url);
        },
      ),
    );
  }


}