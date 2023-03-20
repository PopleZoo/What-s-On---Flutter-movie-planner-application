library globals;

import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:movies/modal_class/movie.dart';

const String kMoviesWatchingListKey = 'Watching_list_Key_';
const String kMoviesWatchedListKey = 'Watched_list_Key_';

late List<Movie> moviesWatchingList;
late List<Movie> moviesWatchedList;

class MovieLists {
  MovieLists() {
    moviesWatchingList = [];
    moviesWatchedList = [];
    _initListsFromSharedPreferences();
  }

  Future<void> _initListsFromSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? watchingList = prefs.getStringList(kMoviesWatchingListKey);
    List<String>? watchedList = prefs.getStringList(kMoviesWatchedListKey);

    if (watchingList != null) {
      moviesWatchingList = watchingList
          .map((movie) => Movie.fromJson(json.decode(movie)))
          .toList();
    }

    if (watchedList != null) {
      moviesWatchedList = watchedList
          .map((movie) => Movie.fromJson(json.decode(movie)))
          .toList();
    }
  }

  Future<void> loadListsFromSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    List<String>? moviesWatchingListJson =
        prefs.getStringList(kMoviesWatchingListKey);
    if (moviesWatchingListJson != null) {
      moviesWatchingList = moviesWatchingListJson
          .map((movieJson) => Movie.fromJson(json.decode(movieJson)))
          .toList();
    }

    List<String>? moviesWatchedListJson =
        prefs.getStringList(kMoviesWatchedListKey);
    if (moviesWatchedListJson != null) {
      moviesWatchedList = moviesWatchedListJson
          .map((movieJson) => Movie.fromJson(json.decode(movieJson)))
          .toList();
    }
  }

  Future<void> addWatched(Movie? movie) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (movie == null) {
      return;
    }

    if (!moviesWatchedList.contains(movie) &&
        !moviesWatchingList.contains(movie)) {
      moviesWatchedList.add(movie);
    }

    if (!moviesWatchedList.contains(movie) &&
        moviesWatchingList.contains(movie)) {
      removeFromListsInSharedPreferences(movie);
      moviesWatchedList.add(movie);
    }

    await prefs.setStringList(
      kMoviesWatchedListKey,
      moviesWatchedList.map((movie) => json.encode(movie.toJson())).toList(),
    );
    await prefs.setStringList(
      kMoviesWatchingListKey,
      moviesWatchingList.map((movie) => json.encode(movie.toJson())).toList(),
    );

    print(
        'moviesWatchingList after adding to Watched List: $moviesWatchingList');
    print('moviesWatchedList after adding to Watched List: $moviesWatchedList');
  }

  Future<void> addWatching(Movie? movie) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (movie == null) {
      return;
    }

    if (!moviesWatchedList.contains(movie) &&
        !moviesWatchingList.contains(movie)) {
      moviesWatchingList.add(movie);
    }

    if (moviesWatchedList.contains(movie) &&
        !moviesWatchingList.contains(movie)) {
      removeFromListsInSharedPreferences(movie);
      moviesWatchingList.add(movie);
    }

    await prefs.setStringList(
      kMoviesWatchedListKey,
      moviesWatchedList.map((movie) => json.encode(movie.toJson())).toList(),
    );
    await prefs.setStringList(
      kMoviesWatchingListKey,
      moviesWatchingList.map((movie) => json.encode(movie.toJson())).toList(),
    );

    print(
        'moviesWatchingList after adding to Watching List: $moviesWatchingList');
    print(
        'moviesWatchedList after adding to Watching List: $moviesWatchedList');
  }

  Future<void> removeFromListsInSharedPreferences(Movie? movie) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print(movie!.title);
    if (movie == null) {
      print('movie is null');
      return;
    }

    bool isMovieRemoved = false;

    // check if movie is present in watching list
    if (moviesWatchingList.contains(movie)) {
      moviesWatchingList.remove(movie);
      isMovieRemoved = true;
    }

    // check if movie is present in watched list
    if (moviesWatchedList.contains(movie)) {
      moviesWatchedList.remove(movie);
      isMovieRemoved = true;
    }

    // if movie is not present in any list, return
    if (!isMovieRemoved) {
      print('movie is not removed');
      return;
    }

    // update the shared preferences with the modified lists
    await prefs.setStringList(
      kMoviesWatchedListKey,
      moviesWatchedList.map((movie) => json.encode(movie.toJson())).toList(),
    );
    await prefs.setStringList(
      kMoviesWatchingListKey,
      moviesWatchingList.map((movie) => json.encode(movie.toJson())).toList(),
    );

    print('moviesWatchingList after removing movie: $moviesWatchingList');
    print('moviesWatchedList after removing movie: $moviesWatchedList');
  }
}
