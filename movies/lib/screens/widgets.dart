import 'package:carousel_slider/carousel_slider.dart';
import 'package:empty_widget/empty_widget.dart';
import 'package:flutter/material.dart';
import 'package:movies/utils/globals.dart';
import 'package:movies/api/endpoints.dart';
import 'package:movies/constants/api_constants.dart';
import 'package:movies/modal_class/credits.dart';
import 'package:movies/modal_class/function.dart';
import 'package:movies/modal_class/genres.dart';
import 'package:movies/modal_class/movie.dart';
import 'package:movies/screens/castncrew.dart';
import 'package:movies/screens/genremovies.dart';
import 'package:movies/screens/movie_detail.dart';
import 'package:movies/screens/settings.dart';
import '/utils/globals.dart' as globals;

class DiscoverMovies extends StatefulWidget {
  final ThemeData themeData;
  final List<Genres> genres;
  DiscoverMovies({required this.themeData, required this.genres});
  @override
  _DiscoverMoviesState createState() => _DiscoverMoviesState();
}

class _DiscoverMoviesState extends State<DiscoverMovies> {
  List<Movie>? actualList;
  @override
  void initState() {
    super.initState();
    fetchMovies(Endpoints.discoverMoviesUrl(1)).then((value) {
      setState(() {
        actualList = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child:
                  Text('Discover', style: widget.themeData.textTheme.headline5),
            ),
          ],
        ),
        SizedBox(
          width: double.infinity,
          height: 400,
          child: actualList == null
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : CarouselSlider.builder(
                  options: CarouselOptions(
                    disableCenter: true,
                    viewportFraction: 0.8,
                    enlargeCenterPage: true,
                  ),
                  itemBuilder:
                      (BuildContext context, int index, pageViewIndex) {
                    return Container(
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => MovieDetailPage(
                                        movie: actualList![index],
                                        themeData: widget.themeData,
                                        genres: widget.genres,
                                      )));
                        },
                        child: Hero(
                          tag: '${actualList![index].id}discover',
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8.0),
                            child: FadeInImage(
                              image: NetworkImage(TMDB_BASE_IMAGE_URL +
                                  'w500/' +
                                  actualList![index].posterPath!),
                              fit: BoxFit.cover,
                              placeholder:
                                  AssetImage('assets/images/loading.gif'),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                  itemCount: actualList!.length,
                ),
        ),
      ],
    );
  }
}

class ScrollingMovies extends StatefulWidget {
  final ThemeData themeData;
  final String? api, title;
  final List<Genres> genres;
  ScrollingMovies(
      {required this.themeData, this.api, this.title, required this.genres});
  @override
  _ScrollingMoviesState createState() => _ScrollingMoviesState();
}

class _ScrollingMoviesState extends State<ScrollingMovies> {
  List<Movie>? actualList;
  @override
  void initState() {
    super.initState();
    fetchMovies(widget.api!).then((value) {
      if (mounted) {
        // check whether the widget is still mounted
        setState(() {
          actualList = value;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(widget.title!,
                  style: widget.themeData.textTheme.headline5),
            ),
          ],
        ),
        SizedBox(
          width: double.infinity,
          height: 200,
          child: actualList == null
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : ListView.builder(
                  physics: BouncingScrollPhysics(),
                  itemCount: actualList!.length,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (BuildContext context, int index) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => MovieDetailPage(
                                        movie: actualList![index],
                                        themeData: widget.themeData,
                                        genres: widget.genres,
                                      )));
                        },
                        child: Hero(
                          tag: '${actualList![index].id}${widget.title}',
                          child: SizedBox(
                            width: 100,
                            child: Column(
                              children: <Widget>[
                                Expanded(
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(8.0),
                                    child: FadeInImage(
                                      image: NetworkImage(TMDB_BASE_IMAGE_URL +
                                          'w500/' +
                                          (actualList![index].posterPath ??
                                              actualList![index]
                                                  .backdropPath)!),
                                      fit: BoxFit.cover,
                                      placeholder: AssetImage(
                                          'assets/images/loading.gif'),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    actualList![index].title != null
                                        ? actualList![index].title!
                                        : actualList![index].name!,
                                    style: widget.themeData.textTheme.bodyText1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }
}

class ParticularGenreMovies extends StatefulWidget {
  final ThemeData themeData;
  final String api;
  final List<Genres> genres;
  ParticularGenreMovies(
      {required this.themeData, required this.api, required this.genres});
  @override
  _ParticularGenreMoviesState createState() => _ParticularGenreMoviesState();
}

class _ParticularGenreMoviesState extends State<ParticularGenreMovies> {
  List<Movie>? actualList;
  @override
  void initState() {
    super.initState();
    fetchMovies(widget.api).then((value) {
      setState(() {
        actualList = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: widget.themeData.primaryColor.withOpacity(0.8),
      child: actualList == null
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              physics: BouncingScrollPhysics(),
              itemCount: actualList!.length,
              itemBuilder: (BuildContext context, int index) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => MovieDetailPage(
                                    movie: actualList![index],
                                    themeData: widget.themeData,
                                    genres: widget.genres,
                                  )));
                    },
                    child: Container(
                      height: 150,
                      child: Stack(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(top: 40.0),
                            child: Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                  color: widget.themeData.primaryColor,
                                  borderRadius: BorderRadius.circular(8.0),
                                  border: Border.all(
                                      width: 1,
                                      color: widget.themeData.accentColor)),
                              height: 100,
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    left: 118.0, top: 8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      actualList![index].title != null
                                          ? actualList![index].title!
                                          : actualList![index].name!,
                                      style:
                                          widget.themeData.textTheme.bodyText2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        children: <Widget>[
                                          Text(
                                            actualList![index]
                                                .voteAverage
                                                .toString(),
                                            style: widget
                                                .themeData.textTheme.bodyText1,
                                          ),
                                          Icon(
                                            Icons.star,
                                            color: Colors.green,
                                          ),
                                        ],
                                      ),
                                    ),
                                    Text(
                                      actualList![index].releaseDate != null
                                          ? 'Release date : ' +
                                              actualList![index].releaseDate!
                                          : 'Release date : ' +
                                              actualList![index].aired!,
                                      style:
                                          widget.themeData.textTheme.bodyText1,
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
                              tag: '${actualList![index].id}',
                              child: SizedBox(
                                width: 100,
                                height: 125,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(8.0),
                                  child: FadeInImage(
                                    image: NetworkImage(TMDB_BASE_IMAGE_URL +
                                        'w500/' +
                                        actualList![index].posterPath!),
                                    fit: BoxFit.cover,
                                    placeholder:
                                        AssetImage('assets/images/loading.gif'),
                                  ),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}

class ScrollingArtists extends StatefulWidget {
  final ThemeData? themeData;
  final String? api, title, tapButtonText;
  final Function(Cast)? onTap;
  ScrollingArtists(
      {this.themeData, this.api, this.title, this.tapButtonText, this.onTap});
  @override
  _ScrollingArtistsState createState() => _ScrollingArtistsState();
}

class _ScrollingArtistsState extends State<ScrollingArtists> {
  Credits? credits;
  @override
  void initState() {
    super.initState();
    fetchCredits(widget.api!).then((value) {
      setState(() {
        credits = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        credits == null
            ? Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: <Widget>[
                    Text(widget.title!,
                        style: widget.themeData!.textTheme.bodyText1),
                  ],
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(widget.title!,
                        style: widget.themeData!.textTheme.bodyText1),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => CastAndCrew(
                                    themeData: widget.themeData,
                                    credits: credits,
                                  )));
                    },
                    child: Text(widget.tapButtonText!,
                        style: widget.themeData!.textTheme.caption),
                  ),
                ],
              ),
        SizedBox(
          width: double.infinity,
          height: 120,
          child: credits == null
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : ListView.builder(
                  physics: BouncingScrollPhysics(),
                  itemCount: credits!.cast!.length,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (BuildContext context, int index) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GestureDetector(
                        onTap: () {
                          widget.onTap!(credits!.cast![index]);
                        },
                        child: SizedBox(
                          width: 80,
                          child: Column(
                            children: <Widget>[
                              Expanded(
                                child: SizedBox(
                                  width: 70,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(8.0),
                                    child: credits!.cast![index].profilePath ==
                                            null
                                        ? Image.asset(
                                            'assets/images/na.jpg',
                                            fit: BoxFit.cover,
                                          )
                                        : FadeInImage(
                                            image: NetworkImage(
                                                TMDB_BASE_IMAGE_URL +
                                                    'w500/' +
                                                    credits!.cast![index]
                                                        .profilePath!),
                                            fit: BoxFit.cover,
                                            placeholder: AssetImage(
                                                'assets/images/loading.gif'),
                                          ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  credits!.cast![index].name!,
                                  style: widget.themeData!.textTheme.caption,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }
}

class GenreList extends StatefulWidget {
  final ThemeData themeData;
  final List<int> genres;
  final List<Genres> totalGenres;
  GenreList(
      {required this.themeData,
      required this.genres,
      required this.totalGenres});

  @override
  _GenreListState createState() => _GenreListState();
}

class _GenreListState extends State<GenreList> {
  List<Genres>? _genres;
  @override
  void initState() {
    super.initState();
    _genres = [];
    Future.delayed(Duration.zero, () {
      widget.totalGenres.forEach((valueGenre) {
        widget.genres.forEach((genre) {
          if (valueGenre.id == genre) {
            _genres?.add(valueGenre);
            setState(() {});
          }
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: double.infinity,
        height: 50,
        child: Center(
          child: _genres == null
              ? CircularProgressIndicator()
              : ListView.builder(
                  shrinkWrap: true,
                  physics: BouncingScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  itemCount: _genres!.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4.0),
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => GenreMovies(
                                        themeData: widget.themeData,
                                        genre: _genres![index],
                                        genres: widget.totalGenres,
                                      )));
                        },
                        child: Chip(
                          shape: RoundedRectangleBorder(
                            side: BorderSide(
                                width: 1,
                                style: BorderStyle.solid,
                                color: widget.themeData.accentColor),
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          label: Text(
                            _genres![index].name!,
                            style: widget.themeData.textTheme.bodyText1,
                          ),
                          backgroundColor: Colors.transparent,
                        ),
                      ),
                    );
                  },
                ),
        ));
  }
}

class SearchMovieWidget extends StatefulWidget {
  final ThemeData? themeData;
  final String? query;
  final List<Genres>? genres;
  final Function(Movie)? onTap;
  SearchMovieWidget({this.themeData, this.query, this.genres, this.onTap});
  @override
  _SearchMovieWidgetState createState() => _SearchMovieWidgetState();
}

class _SearchMovieWidgetState extends State<SearchMovieWidget> {
  List<Movie>? actualList;
  @override
  void initState() {
    super.initState();
    fetchMovies(Endpoints.movieSearchUrl(widget.query!)).then((value) {
      setState(() {
        actualList = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: widget.themeData!.primaryColor,
      child: actualList == null
          ? Center(
              child: CircularProgressIndicator(),
            )
          : actualList!.length == 0
              ? Center(
                  child: Text(
                    "Oops! couldn't what you where looking for",
                    style: widget.themeData!.textTheme.bodyText1,
                  ),
                )
              : ListView.builder(
                  physics: BouncingScrollPhysics(),
                  itemCount: actualList!.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GestureDetector(
                        onTap: () {
                          widget.onTap!(actualList![index]);
                        },
                        child: Column(
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                SizedBox(
                                  width: 70,
                                  height: 80,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(8.0),
                                    child: actualList![index].posterPath == null
                                        ? Image.asset(
                                            'assets/images/na.jpg',
                                            fit: BoxFit.cover,
                                          )
                                        : FadeInImage(
                                            image: NetworkImage(
                                                TMDB_BASE_IMAGE_URL +
                                                    'w500/' +
                                                    actualList![index]
                                                        .posterPath!),
                                            fit: BoxFit.cover,
                                            placeholder: AssetImage(
                                                'assets/images/loading.gif'),
                                          ),
                                  ),
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: <Widget>[
                                        Text(
                                          actualList![index].title != null
                                              ? actualList![index].title!
                                              : actualList![index].name!,
                                          style: widget
                                              .themeData!.textTheme.bodyText2,
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 1,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: <Widget>[
                                            Text(
                                              actualList![index]
                                                  .voteAverage
                                                  .toString(),
                                              style: widget.themeData!.textTheme
                                                  .bodyText1,
                                            ),
                                            Icon(Icons.star,
                                                color: Colors.green),
                                          ],
                                        ),
                                        Text(
                                          actualList![index].releaseDate != null
                                              ? actualList![index]
                                                  .releaseDate
                                                  .toString()
                                              : actualList![index]
                                                  .aired
                                                  .toString(),
                                          style: widget
                                              .themeData!.textTheme.subtitle1,
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 24.0),
                              child: Divider(
                                color: widget.themeData!.accentColor,
                              ),
                            )
                          ],
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}

class DiscoverTVShows extends StatefulWidget {
  final ThemeData themeData;
  final List<Genres> genres;
  DiscoverTVShows({required this.themeData, required this.genres});
  @override
  _DiscoverTVShowsState createState() => _DiscoverTVShowsState();
}

class _DiscoverTVShowsState extends State<DiscoverTVShows> {
  List<Movie>? tvShowsList;
  @override
  void initState() {
    super.initState();
    fetchMovies(Endpoints.discoverTvShowsUrl(1)).then((value) {
      setState(() {
        tvShowsList = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child:
                  Text('Discover', style: widget.themeData.textTheme.headline5),
            ),
          ],
        ),
        SizedBox(
          width: double.infinity,
          height: 400,
          child: tvShowsList == null
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : CarouselSlider.builder(
                  options: CarouselOptions(
                    disableCenter: true,
                    viewportFraction: 0.8,
                    enlargeCenterPage: true,
                  ),
                  itemBuilder:
                      (BuildContext context, int index, pageViewIndex) {
                    return Container(
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => MovieDetailPage(
                                        movie: tvShowsList![index],
                                        themeData: widget.themeData,
                                        genres: widget.genres,
                                      )));
                        },
                        child: Hero(
                          tag: '${tvShowsList![index].id}discover',
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8.0),
                            child: FadeInImage(
                              image: NetworkImage(TMDB_BASE_IMAGE_URL +
                                  'w500/' +
                                  tvShowsList![index].posterPath!),
                              fit: BoxFit.cover,
                              placeholder:
                                  AssetImage('assets/images/loading.gif'),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                  itemCount: tvShowsList!.length,
                ),
        ),
      ],
    );
  }
}

class MovieCard extends StatelessWidget {
  final Movie movie;
  final Function(Movie) ifWatched;
  final ThemeData themeData;
  final List<Genres> genres;

  const MovieCard({
    Key? key,
    required this.movie,
    required this.ifWatched,
    required this.themeData,
    required this.genres,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MovieDetailPage(
              themeData: themeData,
              genres: genres,
              movie: movie,
            ),
          ),
        );
      },
      child: Container(
        height: 150,
        child: Stack(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 40.0, left: 10, right: 10),
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: themeData.primaryColor,
                  borderRadius: BorderRadius.circular(8.0),
                  border: Border.all(width: 1, color: themeData.accentColor),
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
                child: SizedBox(
                  width: 100,
                  height: 125,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: FadeInImage(
                      image: NetworkImage(
                          TMDB_BASE_IMAGE_URL + 'w500/' + movie.posterPath!),
                      fit: BoxFit.cover,
                      placeholder: AssetImage('assets/images/loading.gif'),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ScrollingMoviesHorizontally extends StatefulWidget {
  final ThemeData themeData;
  final bool isWatched;
  final List<Movie> moviesWatchedList = globals.moviesWatchedList;
  final List<Movie> moviesWatchingList = globals.moviesWatchingList;
  final bool isFiltered;
  final List<Genres> genres;

  ScrollingMoviesHorizontally({
    required this.themeData,
    required this.isWatched,
    this.isFiltered = false,
    required this.genres,
  });

  @override
  _ScrollingMoviesStateHorizontally createState() =>
      _ScrollingMoviesStateHorizontally();
}

class _ScrollingMoviesStateHorizontally
    extends State<ScrollingMoviesHorizontally> {
  List<Movie>? actualList;

  @override
  void initState() {
    super.initState();
    print("moviesWatchedList length: ${widget.moviesWatchedList.length}");
    print("moviesWatchingList length: ${widget.moviesWatchingList.length}");

    if (widget.isWatched) {
      setState(() {
        actualList = widget.moviesWatchedList;
      });
    } else {
      setState(() {
        actualList = widget.moviesWatchingList;
      });
    }
  }

  @override
  void didUpdateWidget(ScrollingMoviesHorizontally oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.isWatched != oldWidget.isWatched ||
        widget.moviesWatchedList != oldWidget.moviesWatchedList ||
        widget.moviesWatchingList != oldWidget.moviesWatchingList) {
      print("moviesWatchedList length: ${widget.moviesWatchedList.length}");
      print("moviesWatchingList length: ${widget.moviesWatchingList.length}");

      if (widget.isWatched) {
        setState(() {
          actualList = widget.moviesWatchedList;
        });
      } else {
        setState(() {
          actualList = widget.moviesWatchingList;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return actualList != null && actualList?.length != 0
        ? Column(
            children: [
              SizedBox(
                height: 20,
              ),
              Row(
                children: <Widget>[
                  SizedBox(
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    child: actualList == null
                        ? Center(
                            child: CircularProgressIndicator(),
                          )
                        : ListView.builder(
                            physics: BouncingScrollPhysics(),
                            itemCount: actualList!.length,
                            scrollDirection: Axis.vertical,
                            itemBuilder: (BuildContext context, int index) {
                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => MovieDetailPage(
                                          movie: actualList![index],
                                          themeData: widget.themeData,
                                          genres: widget.genres,
                                        ),
                                      ),
                                    );
                                  },
                                  child: Container(
                                    height: 150,
                                    child: Stack(
                                      children: <Widget>[
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 40.0),
                                          child: Container(
                                            width: double.infinity,
                                            decoration: BoxDecoration(
                                              color:
                                                  widget.themeData.primaryColor,
                                              borderRadius:
                                                  BorderRadius.circular(8.0),
                                              border: Border.all(
                                                width: 1,
                                                color: widget
                                                    .themeData.accentColor,
                                              ),
                                            ),
                                            height: 100,
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 118.0, top: 8.0),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: <Widget>[
                                                  Text(
                                                    actualList![index].title !=
                                                            null
                                                        ? actualList![index]
                                                            .title!
                                                        : actualList![index]
                                                            .name!,
                                                    style: widget.themeData
                                                        .textTheme.bodyText2,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: Row(
                                                      children: <Widget>[
                                                        Text(
                                                          actualList![index]
                                                              .voteAverage!
                                                              .toString(),
                                                          style: widget
                                                              .themeData
                                                              .textTheme
                                                              .bodyText1,
                                                        ),
                                                        Icon(
                                                          Icons.star,
                                                          color: Colors.green,
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Text(
                                                    actualList![index]
                                                                .releaseDate !=
                                                            null
                                                        ? 'Release date: ${actualList![index].releaseDate}'
                                                        : 'Release date: ${actualList![index].aired}',
                                                    style: widget.themeData
                                                        .textTheme.bodyText1,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                        Positioned(
                                          top: 0.0,
                                          left: 8.0,
                                          bottom: 0.0,
                                          child: Container(
                                            width: 100,
                                            height: 100,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(8.0),
                                              image: DecorationImage(
                                                  fit: BoxFit.cover,
                                                  image: NetworkImage(
                                                      TMDB_BASE_IMAGE_URL +
                                                          'w500/' +
                                                          actualList![index]
                                                              .posterPath!)),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                  ),
                ],
              ),
            ],
          )
        : Padding(
            padding: const EdgeInsets.only(top: 40.0),
            child: Center(
              child: EmptyWidget(
                image: null,
                packageImage: PackageImage.Image_1,
                title: 'Such Empty',
                subTitle: 'Added Content Will Appear Here',
                titleTextStyle: TextStyle(
                  fontSize: 22,
                  color: Color(0xff9da9c4),
                  fontWeight: FontWeight.bold,
                ),
                subtitleTextStyle: TextStyle(
                  fontSize: 14,
                  color: Color(0xffabb8e5),
                ),
              ),
            ),
          );
  }
}
