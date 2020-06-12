import 'package:flutter/material.dart';
import 'package:komgaclient/models/serverdetails.dart';
import 'package:komga_api_client/model/book_dto.dart';
import 'package:komgaclient/screens/bookscreen.dart';
//import 'package:transparent_image/transparent_image.dart';

class BookCard extends StatelessWidget {
  final BookDto book;
  final ServerDetails sd;
  String shortMediaType;
  Color mediaBoxColor;

  BookCard(this.book, this.sd) {
    switch (book.media.mediaType) {
      case 'application/x-rar-compressed':
      case 'application/x-rar-compressed; version=4':
        this.shortMediaType = 'CBR';
        this.mediaBoxColor = Color.fromARGB(255, 3, 169, 244);
        break;
      case 'application/zip':
        this.shortMediaType = 'CBZ';
        this.mediaBoxColor = Color.fromARGB(255, 76, 175, 80);
        break;
      case 'application/pdf':
        this.shortMediaType = 'PDF';
        this.mediaBoxColor = Color.fromARGB(255, 255, 87, 34);
        break;
      case 'application/epub+zip':
        this.shortMediaType = 'EPUB';
        this.mediaBoxColor = Color.fromARGB(255, 255, 90, 177);
        break;
      default:
        this.shortMediaType = '?';
        this.mediaBoxColor = Color.fromARGB(255, 255, 0, 0);
        break;
    }
    ;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => BookScreen(
                      book: book,
                      sd: sd,
                    )));
      },
      child: SizedBox(
        width: 125.0,
        height: 200.0,
        child: Card(
          child: Container(
            padding: EdgeInsets.zero,
            margin: EdgeInsets.zero,
//          width: 125.0,
//          height: 200,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Stack(
                  children: <Widget>[
                    Image.network(
                      '${sd.url}/api/v1/books/${book.id}/thumbnail',
                      headers: sd.headers,
                      fit: BoxFit.fitHeight,
                      width: 100.0,
                    ),
                    Positioned(
                      top: 0.0,
                      right: 0.0,
                      child: Container(
                        color: mediaBoxColor,
                        padding: EdgeInsets.all(5.0),
                        child: Text(shortMediaType,
                            style: TextStyle(color: Colors.white)),
                      ),
                    ),
                  ],
                ),
                Spacer(),
                Flexible(
                  child: FittedBox(
                    child: Text(
                      '#${book.metadata.number} - ${book.metadata.title}',
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
                Spacer(),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    alignment: Alignment.bottomLeft,
                    child: Text(
                      book.size.toString() +
                          '\n${book.media.pagesCount.toString()} Pages',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
