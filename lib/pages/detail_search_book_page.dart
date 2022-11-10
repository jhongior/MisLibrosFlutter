import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

import '../models/result.dart';

class DetailSearchBooPage extends StatelessWidget {
  final Items book;
  const DetailSearchBooPage(this.book);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(book.volumeInfo?.title ?? "Detalle"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.network(
                book.volumeInfo?.imageLinks?.smallThumbnail ?? "",
                errorBuilder: (BuildContext context, Object exception,
                    StackTrace? stackTrace) {
                  return const Image(
                    image: AssetImage('assets/images/logo.png'),
                  );
                },
              ),
              Padding(
                padding: const EdgeInsets.all(8),
                child: Text(
                  "Autor: ${book.volumeInfo?.authors?[0]}",
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      fontSize: 17, fontStyle: FontStyle.italic),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8),
                child: Text(
                  book.volumeInfo?.toString() ?? "",
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
}
