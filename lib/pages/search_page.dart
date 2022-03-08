import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';

class SearchPage extends StatefulWidget {
  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  AlgoliaAPI algoliaAPI = AlgoliaAPI();

  String _searchText = "";
  List<SearchHit> _hitsList = [];

  TextEditingController _textFieldController = TextEditingController();

  Future<void> _getSearchResult(String query) async {
    var response = await algoliaAPI.search(query);
    var hitsList = (response['hits'] as List).map((json) {
      return SearchHit.fromJson(json);
    }).toList();
    setState(() {
      _hitsList = hitsList;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Algolia & Flutter'),
        ),
        body: Column(children: <Widget>[
          Container(
              padding: EdgeInsets.symmetric(horizontal: 1),
              height: 44,
              child: TextField(
                controller: _textFieldController,
                decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Enter a search term',
                    prefixIcon: Icon(Icons.search, color: Colors.deepPurple),
                    suffixIcon: _searchText.isNotEmpty
                        ? IconButton(
                            onPressed: () {
                              setState(() {
                                _textFieldController.clear();
                              });
                            },
                            icon: Icon(Icons.clear),
                          )
                        : null),
              )),
          Expanded(
              child: _hitsList.isEmpty
                  ? Center(child: Text('No results'))
                  : ListView.builder(
                      padding: const EdgeInsets.all(8),
                      itemCount: _hitsList.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Container(
                            height: 50,
                            padding: EdgeInsets.all(8),
                            child: Row(children: <Widget>[
                              Container(
                                  width: 50,
                                  child: Image.network(
                                      '${_hitsList[index].albumImageString}')),
                              SizedBox(width: 10),
                              Expanded(child: Text('${_hitsList[index].songString}'))
                            ]));
                      }))
        ]));
  }

  @override
  void initState() {
    super.initState();
    _textFieldController.addListener(() {
      if (_searchText != _textFieldController.text) {
        setState(() {
          _searchText = _textFieldController.text;
        });
        _getSearchResult(_searchText);
      }
    });
    _getSearchResult('');
  }

  @override
  void dispose() {
    _textFieldController.dispose();
    super.dispose();
  }
}

class AlgoliaAPI {
  static const platform = const MethodChannel('com.algolia/api');

  Future<dynamic> search(String query) async {
    try {
      var response =
          await platform.invokeMethod('search', ['jazz', query]);
      return jsonDecode(response);
    } on PlatformException catch (_) {
      return null;
    }
  }
}

class SearchHit {
  final String songString;
  final String albumImageString;

  SearchHit(this.songString, this.albumImageString);

  static SearchHit fromJson(Map<String, dynamic> json) {
    return SearchHit(json['songString'], json['albumImageString']);
  }
}
