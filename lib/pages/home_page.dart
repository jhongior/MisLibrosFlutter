import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mis_libros/pages/FavoritesPage.dart';
import 'package:mis_libros/pages/login_page.dart';
import 'package:mis_libros/pages/my_books_page.dart';
import 'package:mis_libros/pages/search_book_page.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var currentPage = 0;
  late List<Widget> pages;

  @override
  void initState() {
    _loadPages();
    super.initState();
  }

  void _loadPages() {
    pages = [];
    pages.add(MyBooksPage());
    pages.add(SearchBookPage());
    pages.add(FavoritesPage());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mis Libros'),
        actions: [
          PopupMenuButton(
            onSelected: (Menu item) {
              setState(() {
                if (item == Menu.logOut) {
                  FirebaseAuth.instance.signOut();
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const LoginPage()));
                }
              });
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<Menu>>[
              const PopupMenuItem(
                child: Text('Cerrar Sesión'),
                value: Menu.logOut,
              )
            ],
          )
        ],
      ),
      body: IndexedStack(
        index: currentPage,
        children: pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
              icon: Icon(
                FontAwesomeIcons.book,
                size: 20,
              ),
              label: 'Mis Libros'),
          BottomNavigationBarItem(
              icon: Icon(
                FontAwesomeIcons.searchengin,
                size: 20,
              ),
              label: 'Buscar'),
          BottomNavigationBarItem(
              icon: Icon(
                FontAwesomeIcons.heart,
                size: 20,
              ),
              label: 'Favoritos')
        ],
        currentIndex: currentPage,
        onTap: (page) {
          _onItemTapped(page);
        },
      ),
    );
  }

  void _onItemTapped(int page) {
    setState(() {
      currentPage = page;
    });
  }
}
