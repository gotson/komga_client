import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:komgaclient/screens/reader.dart';
import 'package:komgaclient/screens/seriesscreen.dart';
import 'package:komga_api_client/model/book_dto.dart';
import 'package:komgaclient/models/serverdetails.dart';
import 'package:komga_api_client/model/series_dto.dart';
import 'package:dio/dio.dart';
import 'package:komga_api_client/api.dart';

class BookScreen extends StatefulWidget {
  final ServerDetails sd;
  final BookDto book;

  BookScreen({Key key, @required this.book, @required this.sd})
      : super(key: key);
  @override
  _BookScreenState createState() => _BookScreenState();
}

class _BookScreenState extends State<BookScreen> {

  @override
  Widget build(BuildContext context) {

    Dio dio = Dio();
    dio.options.baseUrl = widget.sd.url;
    dio.options.headers = widget.sd.headers;
    KomgaApiClient oa = KomgaApiClient(dio: dio);

    return Scaffold(
        appBar: AppBar(title: Text("Book View")),
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: <Widget>[
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: <Widget>[
                          Image.network(
                            '${widget.sd.url}/api/v1/books/${widget.book.id}/thumbnail',
                            headers: widget.sd.headers,
                          ),
                          Center(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: <Widget>[
                                  Icon(Icons.chrome_reader_mode, color: Colors.grey,),
                                  SizedBox(width: 10.0,),
                                  Text('${widget.book.media.pagesCount} pages'),
                                ],
                              ),
                            )
                          ),
                          RaisedButton(
                            child: Text("Read book"),
                            onPressed: (){
                              Navigator.pushReplacement(context,
                              MaterialPageRoute(builder: (context) => BookReader(book: widget.book, sd: widget.sd)
                              ));
                            },
                          ),
                          RaisedButton(
                            child: Text("Go to series"),
                            onPressed: () async {
                              var r = await oa.getSeriesControllerApi().getOneSeries(widget.book.seriesId);
                              Navigator.push(
                                context,
                                  MaterialPageRoute(builder: (context) => SeriesScreen(series: r.data, sd: widget.sd,))
                              );
                            },
                          )
                        ],
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: <Widget>[
                            Align(
                              alignment: Alignment.bottomLeft,
                              child: Text(widget.book.metadata.title,
                                  style: Theme.of(context).textTheme.headline3),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: <Widget>[
                                  Text('#${widget.book.metadata.number}'),
                                  Spacer(),
                                  Text(widget.book.metadata.releaseDate != null ?
                                  widget.book.metadata.releaseDate.toString('MMMM dd, yyyy'):"")
                                ],
                              ),
                            ),
                            Divider(
                              height: 3.0,
                              thickness: 3.0,
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Table(
                                children: [
                                  TableRow(
                                    children: [
                                      TableCell(child: Text("PUBLISHER")),
                                      TableCell(
                                          child:
                                              Text(widget.book.metadata.publisher))
                                    ],
                                  ),
                                ],
                                textDirection: TextDirection.ltr,
                                textBaseline: TextBaseline.alphabetic,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: AuthorTable(widget.book),
                            ),
                            SizedBox(
                              height: 10.0,
                            ),
                            Text(widget.book.metadata.summary)
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 10.0,
                ),
              ],
            ),
          ),
        ));
  }
}

class AuthorTable extends StatelessWidget {
  final BookDto book;
  AuthorTable(this.book);

  @override
  Widget build(BuildContext context) {
    return Table(
        children: book.metadata.authors
            .map((a) => TableRow(children: [
                  TableCell(
                      child: Text(
                    a.role.toUpperCase(),
                  )),
                  TableCell(child: Text(a.name)),
                ]))
            .toList(),
        textDirection: TextDirection.ltr,
        textBaseline: TextBaseline.alphabetic);
  }
}
