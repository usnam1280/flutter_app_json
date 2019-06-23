import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(MaterialApp(
    title: 'Json App',
    home: homeScreen(),
  ));
}

class homeScreen extends StatefulWidget {
  @override
  _homeScreenState createState() => _homeScreenState();
}

class Picture{
  String id;
  String author;
  Picture(this.id, this.author);
}

class _homeScreenState extends State<homeScreen> {
  List _data = [];

  _fetchData() {
    int page = 1;
    int limit = 20;

    http
        .get('https://picsum.photos/v2/list?page=$page&limit=$limit')
        .then((response) {
      if (response.statusCode == 200) {
        String jsonString = response.body;
        print(jsonString);

        List pictures = jsonDecode(jsonString);

        for(int i=0; i<pictures.length; i++)
          {
            var picture = pictures[i];
            Picture pictureToAdd = Picture(picture["id"], picture["author"]);
            print(pictureToAdd.author);

            setState(() {
              _data.add(pictureToAdd);
              page++;
            });
          }
      } else {
        print('Error');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Json App'),
        actions: <Widget>[
          IconButton(icon: Icon(Icons.refresh),onPressed: ()
            {
              _fetchData();
            })
        ],
      ),
      body: ListView.builder(

          itemCount: _data.length, itemBuilder: (context, index) {
                  Picture picture = _data[index];
                  return Card(child:Column(children:
                      <Widget>[
                        Text(picture.author),
                        Image.network('https://picsum.photos/id/${picture.id}/300/300')
                      ],));

      }),
    );
  }
}
