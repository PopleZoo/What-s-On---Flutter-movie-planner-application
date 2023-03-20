import 'package:flutter/material.dart';
import 'package:movies/api/endpoints.dart';
import 'package:movies/modal_class/function.dart';
import 'package:movies/modal_class/genres.dart';
import 'package:movies/modal_class/movie.dart';
import 'package:movies/screens/movie_detail.dart';
import 'package:movies/screens/search_view.dart';
import 'package:movies/screens/settings.dart';
import 'package:movies/screens/widgets.dart';
import 'package:movies/utils/theme_states.dart';
import 'package:provider/provider.dart';
import '../constants/api_constants.dart';

import 'utils/globals.dart' as globals;

void main() async {
  // Load the lists from shared preferences
  WidgetsFlutterBinding.ensureInitialized();
  await globals.MovieLists().loadListsFromSharedPreferences();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ThemeState>(
      create: (_) => ThemeState(),
      child: MaterialApp(
        title: 'Whats On?',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
            primarySwatch: Colors.blue, canvasColor: Colors.transparent),
        home: MyHomePage(),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  List<Genres> _genres = [];
  @override
  void initState() {
    super.initState();
    fetchGenres().then((value) {
      _genres = value.genres ?? [];
    });
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
                'Whats On?',
                style: state.themeData.textTheme.headline5,
              ),
              backgroundColor: state.themeData.primaryColor,
              actions: <Widget>[
                IconButton(
                  color: state.themeData.accentColor,
                  icon: Icon(Icons.search),
                  onPressed: () async {
                    final String url =
                        "${TMDB_API_BASE_URL}/discover/?api_key=${TMDB_API_KEY}&sort_by=popularity.desc"; //alter here soon
                    final List<Movie> movies = await fetchMovies(url);
                    final Movie? result = await showSearch<Movie?>(
                      context: context,
                      delegate: MovieSearch(
                        themeData: state.themeData,
                        genres: _genres,
                        searchMovies: movies,
                      ),
                    );

                    if (result != null) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => MovieDetailPage(
                                  movie: result,
                                  themeData: state.themeData,
                                  genres: _genres,
                                )),
                      );
                    }
                  },
                ),
              ],
              bottom: TabBar(
                indicatorColor: state.themeData.accentColor,
                tabs: <Widget>[
                  Tab(
                    child: Text(
                      'Movies',
                      style: state.themeData.textTheme.headline5,
                    ),
                  ),
                  Tab(
                    child: Text(
                      'Shows',
                      style: state.themeData.textTheme.headline5,
                    ),
                  ),
                ],
              ),
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
                      DiscoverMovies(
                        themeData: state.themeData,
                        genres: _genres,
                      ),
                      ScrollingMovies(
                        themeData: state.themeData,
                        title: 'Top Rated',
                        api: Endpoints.topRatedUrl(1),
                        genres: _genres,
                      ),
                      ScrollingMovies(
                        themeData: state.themeData,
                        title: 'Now Playing',
                        api: Endpoints.nowPlayingMoviesUrl(1),
                        genres: _genres,
                      ),
                      ScrollingMovies(
                        themeData: state.themeData,
                        title: 'Upcoming Movies',
                        api: Endpoints.upcomingMoviesUrl(1),
                        genres: _genres,
                      ),
                      ScrollingMovies(
                        themeData: state.themeData,
                        title: 'Popular',
                        api: Endpoints.popularMoviesUrl(1),
                        genres: _genres,
                      ),
                    ],
                  )),
              Container(
                  color: state.themeData.primaryColor,
                  child: ListView(
                    children: [
                      DiscoverTVShows(
                        themeData: state.themeData,
                        genres: _genres,
                      ),
                      ScrollingMovies(
                        themeData: state.themeData,
                        title: 'Top Rated',
                        api: Endpoints.topRatedTvShowsUrl(1),
                        genres: _genres,
                      ),
                      ScrollingMovies(
                        themeData: state.themeData,
                        title: 'Out Now',
                        api: Endpoints.nowPlayingTvShowsUrl(1),
                        genres: _genres,
                      ),
                      ScrollingMovies(
                        themeData: state.themeData,
                        title: 'Upcoming TV shows',
                        api: Endpoints.upcomingTvShowsUrl(1),
                        genres: _genres,
                      ),
                      ScrollingMovies(
                        themeData: state.themeData,
                        title: 'Popular',
                        api: Endpoints.popularTvShowsUrl(1),
                        genres: _genres,
                      ),
                    ],
                  ))
            ])));
  }
}
