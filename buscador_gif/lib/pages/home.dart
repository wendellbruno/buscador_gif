import 'dart:convert';

import 'package:buscador_gif/pages/gif_page.dart';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String? _search = "";
  final int _offset = 0;
  int _limit = 10;
  Future<Map> _getGit() async {
    http.Response response;

    if (_search == "") {
      response = await http.get(Uri.parse(
          "https://api.giphy.com/v1/gifs/trending?api_key=90n6vet7lFRcKU8aq8WSD5xpZBed8Ozg&limit=$_limit&rating=g"));
    } else {
      response = await http.get(Uri.parse(
          'https://api.giphy.com/v1/gifs/search?api_key=90n6vet7lFRcKU8aq8WSD5xpZBed8Ozg&q=$_search&limit=$_limit&offset=$_offset&rating=g&lang=en'));
    }
    Map<String, dynamic> gifs = json.decode(response.body);
    return gifs;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Image.network(
            "https://developers.giphy.com/branch/master/static/header-logo-0fec0225d189bc0eae27dac3e3770582.gif"),
        centerTitle: true,
        backgroundColor: Colors.black,
      ),
      backgroundColor: Colors.black,
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10),
            child: TextField(
              onSubmitted: (txt) {
                setState(() {
                  _search = txt;
                });
              },
              decoration: const InputDecoration(
                labelText: 'Pesquisar',
                labelStyle: TextStyle(color: Colors.white),
                border: OutlineInputBorder(),
                hoverColor: Colors.amber,
              ),
              style: const TextStyle(color: Colors.white, fontSize: 18),
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
              child: FutureBuilder(
                  future: _getGit(),
                  builder: (context, snapshot) {
                    switch (snapshot.connectionState) {
                      case ConnectionState.waiting:
                      case ConnectionState.none:
                        return Container(
                          width: 200,
                          height: 200,
                          alignment: Alignment.center,
                          child: const CircularProgressIndicator(
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.white),
                            strokeWidth: 5.0,
                          ),
                        );
                      default:
                        if (snapshot.hasError)
                          return Container();
                        else {
                          return _createGifTable(context, snapshot);
                        }
                    }
                  }))
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        elevation: 5,
        child: ElevatedButton(
          style: const ButtonStyle(
            backgroundColor: MaterialStatePropertyAll(Colors.black),
            elevation: MaterialStatePropertyAll(10),
          ),
          onPressed: () {
            setState(() {
              _limit += 6;
            });
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }

  Widget _createGifTable(BuildContext context, AsyncSnapshot snapshot) {
    return GridView.builder(
        padding: const EdgeInsets.all(10),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, crossAxisSpacing: 10, mainAxisSpacing: 10),
        itemCount: snapshot.data["data"].length,
        //itemCount: snapshot.data["data"].length,
        itemBuilder: (context, index) {
          String url =
              snapshot.data["data"][index]["images"]["fixed_height"]["url"];

          return GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          GifPage(gifData: snapshot.data!["data"][index])));
            },
            child: Image.network(
              url,
              height: 300,
              fit: BoxFit.cover,
            ),
          );
        });
  }
}
