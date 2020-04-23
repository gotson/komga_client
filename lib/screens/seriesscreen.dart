import 'package:flutter/material.dart';
import 'package:komgaclient/models/serverdetails.dart';
import 'package:komgaclient/widgets/comiccard.dart';
import 'package:openapi/model/page_book_dto.dart';
import 'package:openapi/model/series_dto.dart';
import 'package:dio/dio.dart';
import 'package:openapi/api.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:flushbar/flushbar.dart';
import 'package:openapi/model/book_dto.dart';

class SeriesScreen extends StatefulWidget {
  final SeriesDto series;
  final ServerDetails sd;

  SeriesScreen({Key key, @required this.series, @required this.sd})
      : super(key: key);

  @override
  _SeriesScreenState createState() => _SeriesScreenState();
}

class _SeriesScreenState extends State<SeriesScreen> {
  int page = 1;

  NumberPicker pageNumberPicker;

  @override
  Widget build(BuildContext context) {
    int totalPages = (widget.series.booksCount /20).ceil();
    Dio dio = Dio();
    dio.options.baseUrl = widget.sd.url;
    dio.options.headers = widget.sd.headers;
    Openapi oa = Openapi(dio: dio);

    return Scaffold(
      appBar: AppBar(title: Text("Series View")),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          SizedBox(
            height: 200,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Image.network(
                    '${widget.sd.url}/api/v1/series/${widget.series.id}/thumbnail',
                    headers: widget.sd.headers,
                  ),
                ),
                Flexible(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            widget.series.metadata.title,
                            style: Theme.of(context).textTheme.headline3,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(widget.series.booksCount.toString()+' books',
                          style: Theme.of(context).textTheme.headline6,
                          ),
                        ),
                        totalPages > 1 ? Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            RaisedButton(
                              child: Icon(Icons.keyboard_arrow_left),
                              onPressed: () => setState(() {
                                if (page == 1) {
                                  Flushbar(
                                    message: "Already at first page",
                                    duration: Duration(seconds: 2),
                                  )..show(context);
                                } else {
                                  page--;
                                }
                              }),
                            ),
                            RaisedButton(
                              child: Text("Go to page..."),
                              onPressed: () => {},
                              //TODO some sort of page choosing dialog



                                ),
                            RaisedButton(
                              child: Icon(Icons.keyboard_arrow_right),
                              onPressed: () => setState(() {
                                if (page == totalPages){
                                  Flushbar(
                                    message: "Already at last page",
                                    duration: Duration(seconds: 2),
                                  )..show(context);
                                }else{
                                  page++;
                                }
                              }),
                            ),
                          ],
                        ):Text("All items shown below"),
                      ],
                    ),
                  ),
                )
              ]),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Divider(
              thickness: 2.0,
            ),
          ),
          FutureBuilder(
            future: oa
                .getSeriesControllerApi()
                .getAllBooksBySeries(widget.series.id, page: page-1),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                PageBookDto allBooks = snapshot.data.data;
//                if(allBooks.totalPages > 1)

                return Flexible(
                  child: GridView.builder(
                    gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                        maxCrossAxisExtent: 200.0,
//                    crossAxisCount: 4,
                      childAspectRatio: 125/180,
                      mainAxisSpacing: 2.0,
                      crossAxisSpacing: 2.0,
                    ),
                    itemCount: allBooks.numberOfElements,
                    itemBuilder: (context, index) {
                      return BookCard(allBooks.content[index], widget.sd);
                    },
                  ),
                );
              } else {
                return CircularProgressIndicator();
              }
            },
          )
        ],
      ),
    );
  }
}
