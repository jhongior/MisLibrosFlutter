import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:mis_libros/Boxes.dart';
import 'package:mis_libros/models/local_book.dart';

import '../models/result.dart';

class DetailSearchBooPage extends StatefulWidget {
  final Items book;
  const DetailSearchBooPage(this.book);

  @override
  State<DetailSearchBooPage> createState() => _DetailSearchBooPageState();
}

class _DetailSearchBooPageState extends State<DetailSearchBooPage> {
  var isFavorite = false;

  @override
  void initState() {
    _getLocalBook();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.book.volumeInfo?.title ?? "Detalle"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.network(
                widget.book.volumeInfo?.imageLinks?.smallThumbnail ?? "",
                errorBuilder: (BuildContext context, Object exception,
                    StackTrace? stackTrace) {
                  return const Image(
                    image: AssetImage('assets/images/logo.png'),
                  );
                },
              ),
              Row(
                children: [
                  Expanded(
                      child: IconButton(
                    onPressed: () {
                      _onFavoritesButtonClicked();
                    },
                    icon: Icon(
                        isFavorite ? Icons.favorite : Icons.favorite_border),
                    alignment: Alignment.topRight,
                    color: Colors.red,
                  ))
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(8),
                child: Text(
                  "Autor: ${widget.book.volumeInfo?.authors?[0]}",
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      fontSize: 17, fontStyle: FontStyle.italic),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8),
                child: Text(
                  widget.book.volumeInfo?.toString() ?? "",
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      fontSize: 17, fontStyle: FontStyle.italic),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void _onFavoritesButtonClicked() async {
    var localBook = LocalBook()
      ..id = widget.book.id
      ..name = widget.book.volumeInfo?.title
      ..author = widget.book.volumeInfo?.authors?[0]
      ..publishedData = widget.book.volumeInfo?.publishedDate
      ..description = widget.book.volumeInfo?.title
      ..imageLink = widget.book.volumeInfo?.imageLinks?.smallThumbnail;

    final box = Boxes.getFavoritesBox();
    //box.add(localBook);
    if (isFavorite)
      box.delete(localBook.id);
    else
      box.put(localBook.id, localBook);

    setState(() {
      isFavorite = !isFavorite;
    });
  }

  void _getLocalBook() {
    final box = Boxes.getFavoritesBox();
    box.values.forEach((element) {
      if (element.id == widget.book.id) isFavorite = true;
    });
  }
}
