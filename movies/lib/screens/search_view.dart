import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:movies/modal_class/genres.dart';
import 'package:movies/modal_class/movie.dart';
import 'package:movies/constants/api_constants.dart';
import 'package:movies/api/endpoints.dart';
import 'package:movies/screens/widgets.dart';
import '../api/endpoints.dart';
import '../modal_class/function.dart';
import 'dart:typed_data';
import '/utils/globals.dart' as globals;

class MovieSearch extends SearchDelegate<Movie?> {
  final ThemeData themeData;
  final List<Genres> genres;
  final List<Movie> searchMovies;

  MovieSearch({
    required this.themeData,
    required this.genres,
    required this.searchMovies,
  });

  @override
  ThemeData appBarTheme(BuildContext context) {
    return themeData.copyWith(
      hintColor: themeData.accentColor,
      textTheme: TextTheme(
        headline6: themeData.textTheme.bodyText1!,
      ),
    );
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear, color: themeData.accentColor),
        onPressed: () => query = '',
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back, color: themeData.accentColor),
      onPressed: () => close(context, null),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final searchUrl = Endpoints.movieSearchUrl(query);
    return Container(
      decoration: BoxDecoration(
        color: themeData.primaryColor,
      ),
      child: FutureBuilder(
        future: fetchMovies(searchUrl),
        builder: (context, AsyncSnapshot<List<Movie>> snapshot) {
          if (snapshot.hasData) {
            final filteredMovies = snapshot.data!;
            return filteredMovies.isNotEmpty
                ? TMDBSearchMovieWidget(
                    themeData: themeData,
                    movies: filteredMovies,
                    onTap: (movie) => close(context, movie),
                  )
                : Center(child: Text('No results found'));
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }

  @override
  @override
  Widget buildSuggestions(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: themeData.primaryColor, // set the background color here
      ),
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              width: 50,
              height: 50,
              child: Icon(Icons.search, size: 50, color: themeData.accentColor),
            ),
            Text('Enter and search.', style: themeData.textTheme.bodyText1!),
          ],
        ),
      ),
    );
  }
}

class TMDBSearchMovieWidget extends StatelessWidget {
  final List<Movie> movies;
  final ThemeData? themeData;
  final Function(Movie)? onTap;

  const TMDBSearchMovieWidget({
    Key? key,
    required this.movies,
    this.themeData,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: movies.length,
      itemBuilder: (BuildContext context, int index) {
        final Movie movie = movies[index];

        return GestureDetector(
          onTap: () => onTap!(movie),
          child: Container(
            height: 150,
            child: Stack(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(
                    top: 40.0,
                    left: 10,
                    right: 10,
                  ),
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: themeData!.primaryColor,
                      borderRadius: BorderRadius.circular(8.0),
                      border: Border.all(
                        width: 1,
                        color: themeData!.accentColor,
                      ),
                    ),
                    height: 100,
                    child: Padding(
                      padding: const EdgeInsets.only(
                        left: 118.0,
                        top: 8.0,
                      ),
                      child: ListView(
                        children: [
                          Text(
                            movie.title != null ? movie.title! : movie.name!,
                            style: themeData!.textTheme.bodyText2!.copyWith(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: <Widget>[
                                Text(
                                  movie.voteAverage.toString(),
                                  style: themeData!.textTheme.bodyText1,
                                ),
                                const SizedBox(width: 4),
                                Icon(
                                  Icons.star,
                                  color: Colors.green,
                                ),
                              ],
                            ),
                          ),
                          Text(
                            movie.releaseDate != null
                                ? 'Release date : ' + movie.releaseDate!
                                : 'Release date : ' + movie.aired!,
                            style: themeData!.textTheme.caption,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 0,
                  left: 8,
                  child: Hero(
                    tag: '${movie.id}',
                    child: SizedBox(
                      width: 100,
                      height: 125,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8.0),
                        child: FadeInImage(
                          image: NetworkImage(
                            movie.posterPath != null
                                ? TMDB_BASE_IMAGE_URL +
                                    'w500/' +
                                    movie.posterPath!
                                : movie.backdropPath != null
                                    ? TMDB_BASE_IMAGE_URL +
                                        'w500/' +
                                        movie.backdropPath!
                                    : 'DEFAULT_IMAGE_PATH',
                          ),
                          fit: BoxFit.cover,
                          placeholder:
                              const AssetImage('assets/images/loading.gif'),
                          imageErrorBuilder: (context, error, stackTrace) {
                            return Container(
                              color: themeData!.primaryColor,
                              child: const Center(
                                child: Icon(Icons.error_outline,
                                    size: 50, color: Color(0xFF123456)),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

enum Filter {
  all,
  watching,
  watched,
}

class MovieSearch_Planner extends SearchDelegate<Movie?> {
  final ThemeData? themeData;
  final List<Genres>? genres;
  final List<Movie>? moviesWatchingList;
  final List<Movie>? moviesWatchedList;
  MovieSearch_Planner({
    this.themeData,
    this.genres,
    this.moviesWatchingList,
    this.moviesWatchedList,
  });

  @override
  ThemeData appBarTheme(BuildContext context) {
    final ThemeData theme = themeData!.copyWith(
      hintColor: themeData!.hintColor,
      primaryColor: themeData!.primaryColor,
      textTheme: TextTheme(
        headline6: themeData!.textTheme.bodyText1,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor:
            themeData!.primaryColor, // set the background color here
      ),
    );

    return theme;
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(
          Icons.clear,
          color: themeData!.accentColor,
        ),
        onPressed: () {
          query = '';
        },
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(
        Icons.arrow_back,
        color: themeData!.accentColor,
      ),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return Container(
      color: themeData!.primaryColor,
      child: SearchMovieWidget(
        genres: genres,
        themeData: themeData,
        query: query,
        moviesWatchingList: moviesWatchingList,
        moviesWatchedList: moviesWatchedList,
        onTap: (movie) {
          close(context, movie);
        },
      ),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Container(
      color: themeData!.primaryColor,
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              width: 50,
              height: 50,
              child: Icon(
                Icons.search,
                size: 50,
                color: themeData!.accentColor,
              ),
            ),
            Text('Enter and search.', style: themeData!.textTheme.bodyText1),
          ],
        ),
      ),
    );
  }
}

class SearchMovieWidget extends StatefulWidget {
  final ThemeData? themeData;
  final String? query;
  final List<Genres>? genres;
  final List<Movie>? moviesWatchingList;
  final List<Movie>? moviesWatchedList;
  final Function(Movie)? onTap;
  SearchMovieWidget({
    this.themeData,
    this.query,
    this.genres,
    this.moviesWatchingList,
    this.moviesWatchedList,
    this.onTap,
  });

  @override
  _SearchMovieWidgetState createState() => _SearchMovieWidgetState();
}

class _SearchMovieWidgetState extends State<SearchMovieWidget> {
  List<Movie>? actualList;
  Filter selectedFilter = Filter.all;

  void _applyFilter(Filter filter) {
    setState(() {
      selectedFilter = filter;
      switch (selectedFilter) {
        case Filter.all:
          actualList = globals.moviesWatchingList + globals.moviesWatchedList;
          break;
        case Filter.watching:
          actualList = globals.moviesWatchingList;
          break;
        case Filter.watched:
          actualList = globals.moviesWatchedList;
          break;
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _applyFilter(selectedFilter);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 20,
        ),
        _buildFilters(),
        SizedBox(
          height: 20,
        ),
        Expanded(child: _buildSearchResults()),
      ],
    );
  }

  Widget _buildFilters() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildFilter(Filter.all, 'All'),
        _buildFilter(Filter.watching, 'Watching'),
        _buildFilter(Filter.watched, 'Watched'),
      ],
    );
  }

  Widget _buildFilter(Filter filter, String text) {
    return GestureDetector(
      onTap: () => _applyFilter(filter),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: selectedFilter == filter
              ? widget.themeData!.primaryColor
              : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: selectedFilter == filter
                ? widget.themeData!.accentColor // Use accent color for border
                : Colors
                    .transparent, // Make border transparent when not selected
            width: 1.5,
          ),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: selectedFilter == filter
                ? Colors.white
                : Color.fromRGBO(255, 255, 255,
                    0.5), // Make text transparent when not selected
            fontSize: 16, // Adjust font size as necessary
            fontWeight: FontWeight.bold, // Adjust font weight as necessary
          ),
        ),
      ),
    );
  }

  Widget _buildSearchResults() {
    if (widget.query == null || widget.query!.isEmpty) {
      return Center(
        child: Text(
          'Start searching for movies!',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      );
    }
    final List<Movie> searchResults = actualList!
        .where((movie) => movie.title != null
            ? movie.title!.toLowerCase().contains(widget.query!.toLowerCase())
            : movie.name!.toLowerCase().contains(widget.query!.toLowerCase()))
        .toList();

    if (searchResults.isEmpty) {
      return Center(
        child: Text(
          'No movies found.',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      );
    }

    return ListView.builder(
      itemCount: searchResults.length,
      itemBuilder: (BuildContext context, int index) {
        final Movie movie = searchResults[index];
        return GestureDetector(
          onTap: () => widget.onTap!(movie),
          child: Container(
            height: 150,
            child: Stack(
              children: <Widget>[
                Padding(
                  padding:
                      const EdgeInsets.only(top: 40.0, left: 10, right: 10),
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: widget.themeData!.primaryColor,
                      borderRadius: BorderRadius.circular(8.0),
                      border: Border.all(
                          width: 1, color: widget.themeData!.accentColor),
                    ),
                    height: 100,
                    child: Padding(
                      padding: const EdgeInsets.only(
                        left: 118.0,
                        top: 8.0,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            movie.title != null ? movie.title! : movie.name!,
                            style: Theme.of(context).textTheme.bodyText2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: <Widget>[
                                Text(
                                  movie.voteAverage.toString(),
                                  style: Theme.of(context).textTheme.bodyText1,
                                ),
                                Icon(
                                  Icons.star,
                                  color: Colors.green,
                                ),
                              ],
                            ),
                          ),
                          Text(
                            movie.releaseDate != null
                                ? 'Release date : ' + movie.releaseDate!
                                : 'Release date : ' + movie.aired!,
                            style: Theme.of(context).textTheme.bodyText1,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    left: 20,
                  ),
                  child: Positioned(
                    top: 0,
                    left: 8,
                    child: Hero(
                      tag:
                          '${movie.id}-${widget.runtimeType} - ${widget.hashCode}',
                      child: SizedBox(
                        width: 100,
                        height: 125,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8.0),
                          child: FadeInImage(
                            image: NetworkImage(
                              movie.posterPath != null
                                  ? TMDB_BASE_IMAGE_URL +
                                      'w500/' +
                                      movie.posterPath!
                                  : movie.backdropPath != null
                                      ? TMDB_BASE_IMAGE_URL +
                                          'w500/' +
                                          movie.backdropPath!
                                      : 'DEFAULT_IMAGE_PATH',
                            ),
                            fit: BoxFit.cover,
                            placeholder:
                                AssetImage('assets/images/loading.gif'),
                          ),
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
