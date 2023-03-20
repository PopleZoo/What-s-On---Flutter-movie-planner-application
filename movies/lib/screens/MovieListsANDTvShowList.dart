import 'package:flutter/material.dart';
import 'package:movies/screens/search_view.dart';
import 'package:movies/screens/widgets.dart';
import 'package:movies/utils/theme_states.dart';
import 'package:provider/provider.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:movies/api/endpoints.dart';
import 'package:movies/constants/api_constants.dart';
import 'package:movies/modal_class/credits.dart';
import 'package:movies/modal_class/function.dart';
import 'package:movies/modal_class/genres.dart';
import 'package:movies/modal_class/movie.dart';
import 'package:movies/screens/castncrew.dart';
import 'package:movies/screens/genremovies.dart';
import 'package:movies/screens/movie_detail.dart';

import 'settings.dart';
import '/utils/globals.dart' as globals;

class NewPage extends StatefulWidget {
  @override
  _NewPageState createState() => _NewPageState();
}

class _NewPageState extends State<NewPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  List<Genres> _genres = [];
  bool _refresh = false;

  @override
  void initState() {
    super.initState();
    _refresh = false;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _refresh = !_refresh;
  }

  @override
  Widget build(BuildContext context) {
    final state = Provider.of<ThemeState>(context);

    return DefaultTabController(
        length: 2,
        initialIndex: 0,
        child: Scaffold(
          key: _scaffoldKey,
          appBar: AppBar(
            leading: IconButton(
              icon: Icon(
                Icons.menu,
                color: state.themeData.accentColor,
              ),
              onPressed: () {
                _scaffoldKey.currentState?.openDrawer();
              },
            ),
            centerTitle: true,
            title: Text(
              'Your Planner',
              style: state.themeData.textTheme.headline5,
            ),
            backgroundColor: state.themeData.primaryColor,
            bottom: TabBar(
              indicatorColor: state.themeData.accentColor,
              tabs: <Widget>[
                Tab(
                  child: Text(
                    'Watched',
                    style: state.themeData.textTheme.headline5,
                  ),
                ),
                Tab(
                  child: Text(
                    'Watching',
                    style: state.themeData.textTheme.headline5,
                  ),
                ),
              ],
            ),
            actions: <Widget>[
              IconButton(
                color: state.themeData.accentColor,
                icon: Icon(Icons.search),
                onPressed: () async {
                  final Movie? result = await showSearch<Movie?>(
                      context: context,
                      delegate: MovieSearch_Planner(
                          themeData: state.themeData, genres: _genres));
                  if (result != null) {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => MovieDetailPage(
                                  movie: result,
                                  themeData: state.themeData,
                                  genres: _genres,
                                )));
                  }
                },
              ),
            ],
          ),
          drawer: Drawer(
            child: SettingsPage(),
          ),
          body: TabBarView(children: <Widget>[
            Container(
                color: state.themeData.primaryColor,
                child: ListView(
                  physics: BouncingScrollPhysics(),
                  children: <Widget>[
                    Row(
                      children: [
                        TextButton(
                          child: Text('Refresh'),
                          onPressed: () {
                            setState(() {});
                          },
                          style: TextButton.styleFrom(
                            primary: Colors.white,
                            backgroundColor: Colors.transparent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0),
                              side: BorderSide(
                                color: state.themeData.accentColor,
                                width: 1,
                                style: BorderStyle.solid,
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                    ScrollingMoviesHorizontally(
                      themeData: state.themeData,
                      isWatched: true,
                      genres: _genres,
                    )
                  ],
                )),
            Container(
                color: state.themeData.primaryColor,
                child: ListView(
                  children: [
                    Row(
                      children: [
                        TextButton(
                          child: Text('Refresh'),
                          onPressed: () {
                            setState(() {});
                          },
                          style: TextButton.styleFrom(
                            primary: Colors.white,
                            backgroundColor: Colors.transparent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0),
                              side: BorderSide(
                                color: state.themeData.accentColor,
                                width: 1,
                                style: BorderStyle.solid,
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                    ScrollingMoviesHorizontally(
                      themeData: state.themeData,
                      isWatched: false,
                      genres: _genres,
                    )
                  ],
                ))
          ]),
        ));
  }
}
