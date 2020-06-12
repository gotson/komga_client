import 'package:flutter/material.dart';
import 'package:komgaclient/models/serverdetails.dart';
import 'package:komga_api_client/model/book_dto.dart';
import 'package:komga_api_client/model/series_dto.dart';
//import 'package:transparent_image/transparent_image.dart';
import 'package:komgaclient/screens/seriesscreen.dart';

class SeriesCard extends StatelessWidget {
  final SeriesDto series;
  final ServerDetails sd;
//  final Uint8List thumb;

  SeriesCard(this.series, this.sd);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () async {
      Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => SeriesScreen(series: series, sd: sd,))
      );},
      child: SizedBox(
        height: 200.0,
        width: 125.0,
        child: Card(
          child: Container(
            margin: EdgeInsets.zero,
            width: 125.0,
            child: Column(
              children: <Widget>[
                Stack(
                  children: <Widget>[
                    Image.network(
                      '${sd.url}/api/v1/series/${series.id}/thumbnail',
                      headers: sd.headers,
                      fit: BoxFit.fitHeight,
                      width: 100.0,
                    ),
                    Positioned(
                      top: 0.0,
                      right: 0.0,
                      child: Container(
                        color: Colors.orange,
                        padding: EdgeInsets.all(5.0),
                        child: Text(series.booksCount.toString(), style: TextStyle(color: Colors.white), ),
                      ),
                    ),
                  ],
                ),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('${series.metadata.title}',
                    overflow: TextOverflow.ellipsis,
                      softWrap: true,
                    ),
                  ),
                ),
                Spacer(),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    alignment: Alignment.bottomLeft,
                    child: Text('${series.booksCount} Books',
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
