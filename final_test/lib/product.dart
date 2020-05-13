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

import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:finaltest/AppData.dart';
import 'package:path/path.dart' as path;
import 'dart:io';

FirebaseStorage storage = FirebaseStorage(
    storageBucket: storagePath
);

Future<dynamic> uploadImage(File imageFile) async {
  //Create a reference to the location you want to upload to in firebase
  StorageReference reference = storage.ref().child("images").child(path.basename(imageFile.path));
  //Upload the file to firebase
  return reference.putFile(imageFile).onComplete;
}

Future<String> getImageURL(String filename) async {

  return await storage.ref().child('images').child(filename).getDownloadURL();
}

class Product {
  Product({
    @required this.uuid,
    @required this.filename,
    @required this.name,
    @required this.price,
    @required this.desc,
    @required this.likes,
    @required this.uid,
    this.created,
    this.modified,
  }) :
        assert(uuid != null),
       assert(filename != null),
       assert(name != null),
       assert(price != null),
       assert(desc != null),
       assert(likes != null),
       assert(uid != null)
       //assert(created != null)
        //assert(modified != null)
  ;

  final String uuid;
  final String filename;
  final String name;
  final int price;
  final String desc;
  final int likes;
  final String uid;
  final Timestamp created;
  final Timestamp modified;
  DocumentReference reference;

  Product.fromMap(Map<String, dynamic> map, {this.reference})
      :
        assert(map['uuid'] != null),
        assert(map['filename'] != null),
        assert(map['name'] != null),
        assert(map['price'] != null),
        assert(map['desc'] != null),
        assert(map['likes'] != null),
        assert(map['uid'] != null),
        //assert(map['created'] != null),
        //assert(map['modified'] != null),
        uuid = map['uuid'],
        filename = map['filename'],
        name = map['name'],
        price = map['price'],
        desc = map['desc'],
        likes = map['likes'],
        uid = map['uid'],
        created = map['created']??null,
        modified = map['modified']??null
  ;

  Product.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data, reference: snapshot.reference);

  String get imagePath => 'gs://finaltest-f944a.appspot.com/images/' + filename;//'$id-0.jpg';

}
