import 'package:movies/constants/api_constants.dart';

class Endpoints {
  static String discoverMoviesUrl(int page) {
    return '$TMDB_API_BASE_URL'
        '/discover/movie?api_key='
        '$TMDB_API_KEY'
        '&language=en-US&sort_by=popularity'
        '.desc&include_adult=false&include_video=false&page'
        '=$page';
  }

  static String nowPlayingMoviesUrl(int page) {
    return '$TMDB_API_BASE_URL'
        '/movie/now_playing?api_key='
        '$TMDB_API_KEY'
        '&include_adult=false&page=$page';
  }

  static String getCreditsUrl(int id) {
    return '$TMDB_API_BASE_URL' + '/movie/$id/credits?api_key=$TMDB_API_KEY';
  }

  static String topRatedUrl(int page) {
    return '$TMDB_API_BASE_URL'
        '/movie/top_rated?api_key='
        '$TMDB_API_KEY'
        '&include_adult=false&page=$page';
  }

  static String popularMoviesUrl(int page) {
    return '$TMDB_API_BASE_URL'
        '/movie/popular?api_key='
        '$TMDB_API_KEY'
        '&include_adult=false&page=$page';
  }

  static String upcomingMoviesUrl(int page) {
    DateTime now = DateTime.now();
    DateTime next3Months = now.add(Duration(days: 90));
    String formattedDate = next3Months.toIso8601String().split('T')[0];

    return '$TMDB_API_BASE_URL'
        '/discover/movie?api_key='
        '$TMDB_API_KEY'
        '&release_date.gte=$formattedDate'
        '&release_date.lte=${next3Months.add(Duration(days: 30)).toIso8601String().split('T')[0]}'
        '&include_adult=false&page=$page';
  }

  static String movieDetailsUrl(int movieId) {
    return '$TMDB_API_BASE_URL/movie/$movieId?api_key=$TMDB_API_KEY&append_to_response=credits,'
        'images';
  }

  static String genresUrl() {
    return '$TMDB_API_BASE_URL/genre/movie/list?api_key=$TMDB_API_KEY&language=en-US';
  }

  static String getMoviesForGenre(int genreId, int page) {
    return '$TMDB_API_BASE_URL/discover/movie?api_key=$TMDB_API_KEY'
        '&language=en-US'
        '&sort_by=popularity.desc'
        '&include_adult=false'
        '&include_video=false'
        '&page=$page'
        '&with_genres=$genreId';
  }

  static String movieReviewsUrl(int movieId, int page) {
    return '$TMDB_API_BASE_URL/movie/$movieId/reviews?api_key=$TMDB_API_KEY'
        '&language=en-US&page=$page';
  }

  static String movieSearchUrl(String query) {
    return "$TMDB_API_BASE_URL/search/multi?query=$query&api_key=$TMDB_API_KEY";
  }

  static String personSearchUrl(String query) {
    return "$TMDB_API_BASE_URL/search/person?query=$query&api_key=$TMDB_API_KEY";
  }

  static getPerson(int personId) {
    return "$TMDB_API_BASE_URL/person/$personId?api_key=$TMDB_API_KEY&append_to_response=movie_credits";
  }

  static String discoverTvShowsUrl(int page) {
    return '$TMDB_API_BASE_URL'
        '/discover/tv?api_key='
        '$TMDB_API_KEY'
        '&language=en-US&sort_by=popularity'
        '.desc&include_adult=false&include_video=false&page'
        '=$page';
  }

  static String popularTvShowsUrl(int page) {
    return '$TMDB_API_BASE_URL'
        '/tv/popular?api_key='
        '$TMDB_API_KEY'
        '&include_adult=false&page=$page';
  }

  static String upcomingTvShowsUrl(int page) {
    DateTime now = DateTime.now();
    DateTime next3Months = now.add(Duration(days: 90));
    String formattedDate = next3Months.toIso8601String().split('T')[0];

    return '$TMDB_API_BASE_URL'
        '/discover/tv?api_key='
        '$TMDB_API_KEY'
        '&air_date.gte=$formattedDate'
        '&air_date.lte=${next3Months.add(Duration(days: 30)).toIso8601String().split('T')[0]}'
        '&include_adult=false&page=$page';
  }

  static String nowPlayingTvShowsUrl(int page) {
    return '$TMDB_API_BASE_URL'
        '/tv/on_the_air?api_key='
        '$TMDB_API_KEY'
        '&include_adult=false&page=$page';
  }

  static String topRatedTvShowsUrl(int page) {
    return '$TMDB_API_BASE_URL'
        '/tv/top_rated?api_key='
        '$TMDB_API_KEY'
        '&include_adult=false&page=$page';
  }
}
