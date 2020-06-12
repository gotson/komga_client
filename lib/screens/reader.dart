import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:komgaclient/models/serverdetails.dart';
import 'package:komgaclient/screens/bookscreen.dart';
import 'package:komga_api_client/model/book_dto.dart';

class BookReader extends StatefulWidget {
  final BookDto book;
  final ServerDetails sd;
  BookReader({Key key, @required this.book, @required this.sd})
      : super(key: key);

  @override
  _BookReaderState createState() => _BookReaderState();
}

class _BookReaderState extends State<BookReader> {
  @override
  void initState() {
    SystemChrome.setEnabledSystemUIOverlays([]);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    return WillPopScope(
      //intercept back and go to the book screen of the book currently being read
      //this is deal with when you move on to the next book and then go back
      onWillPop: () async {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    BookScreen(book: widget.book, sd: widget.sd))
        );
        SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
        return true;
      },
      child: CarouselSlider.builder(
        itemCount: widget.book.media.pagesCount,
        options: CarouselOptions(
          height: height,
          autoPlay: false,
          enlargeCenterPage: false,
          viewportFraction: 1.0,
          enableInfiniteScroll: false,
          initialPage: 0,
        ),
        itemBuilder: (context, index) {

          return Container(
            child: Image.network(
              '${widget.sd.url}/api/v1/books/${widget.book.id}/pages/${index + 1}',
              headers: widget.sd.headers,
            ),
          );
        },
      ),
    );
  }
}
