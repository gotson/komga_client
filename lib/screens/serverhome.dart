import 'package:flutter/material.dart';
import 'package:komgaclient/models/serverdetails.dart';
import 'package:dio/dio.dart';
import 'package:komgaclient/widgets/comiccard.dart';
import 'package:komga_api_client/api.dart';
import 'package:komga_api_client/api/book_controller_api.dart';
import 'package:komga_api_client/api/series_controller_api.dart';
import 'package:komga_api_client/model/book_dto.dart';
import 'package:komga_api_client/model/page_book_dto.dart';
import 'package:komgaclient/widgets/seriescard.dart';
import 'package:komga_api_client/model/page_series_dto.dart';

class ServerHome extends StatefulWidget {
  final ServerDetails sd;
  ServerHome({Key key, @required this.sd}) : super(key: key);
  @override
  _ServerHomeState createState() => _ServerHomeState();
}

class _ServerHomeState extends State<ServerHome> {

  TextStyle headingStyle = TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 20,
  );

  @override
  Widget build(BuildContext context) {

    Dio dio = Dio();
    dio.options.baseUrl = widget.sd.url;
    dio.options.headers = widget.sd.headers;
    KomgaApiClient oa = KomgaApiClient(dio: dio);

    BookControllerApi bookApi = oa.getBookControllerApi();
    SeriesControllerApi seriesApi = oa.getSeriesControllerApi();

    return Scaffold(
        appBar: AppBar(
            title: Text("Server Home")
        ),
        body: ListView(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text("Recently Added Series",
              style: headingStyle,
              ),
            ),
            SizedBox(
              height: 250.0,
              child: FutureBuilder(
                future: seriesApi.getNewSeries(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    PageSeriesDto newSeries = snapshot.data.data;
                  return ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: newSeries.numberOfElements,
                    itemBuilder: (BuildContext context, i) {
                      return Container(child: SeriesCard(newSeries.content[i], widget.sd));
                    });
                  } else {
                    return CircularProgressIndicator();
                  }
                }),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                  "Recently Updated Series",
              style: headingStyle,),
            ),
            SizedBox(
              height: 250.0,
              child: FutureBuilder(
                  future: seriesApi.getUpdatedSeries(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      PageSeriesDto updatedSeries = snapshot.data.data;
                      return ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: updatedSeries.numberOfElements,
                        itemBuilder: (BuildContext context, i) {
                          return Container(child: SeriesCard(updatedSeries.content[i], widget.sd));
                        });
                    } else {
                      return CircularProgressIndicator();
                    }
                  }),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text("Recently Added Books",
              style: headingStyle,
              ),
            ),
            SizedBox(
              height: 250.0,
              child: FutureBuilder(
                future: bookApi.getLatestBooks(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    PageBookDto latestBooks = snapshot.data.data;
                    return ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: latestBooks.numberOfElements,
                      itemBuilder: (BuildContext context, i) {
                        return Container(child: BookCard(latestBooks.content[i], widget.sd));
                      });
                  } else {
                    return CircularProgressIndicator();
                }
              }),
            ),
          ],
        ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.access_time),
            title: Text("Latest")
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            title: Text("Browse")
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            title: Text("Search")
          )
        ],
      ),
        );
//    );
  }
}


//class ServerHome extends StatefulWidget {
//  ServerDetails sd;
//  ServerHome({Key key, @required this.sd}) : super(key: key);
//
//  @override
//  Widget build(BuildContext context) {
//  }
//}

