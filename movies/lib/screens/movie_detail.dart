import 'package:flutter/material.dart';
import 'package:movies/modal_class/function.dart';
import 'package:movies/api/endpoints.dart';
import 'package:movies/constants/api_constants.dart';
import 'package:movies/modal_class/credits.dart';
import 'package:movies/modal_class/genres.dart';
import 'package:movies/modal_class/movie.dart';
import 'package:movies/screens/widgets.dart';
import '/utils/globals.dart' as globals;

class MovieDetailPage extends StatefulWidget {
  final Movie movie;
  final ThemeData? themeData;
  final List<Genres> genres;
  MovieDetailPage(
      {required this.movie, required this.themeData, required this.genres});
  @override
  _MovieDetailPageState createState() => _MovieDetailPageState();
}

class _MovieDetailPageState extends State<MovieDetailPage> {
  late Color _buttonColor_watched;
  late Color _buttonTextColor_watched;

  late Color _buttonColor_watching;
  late Color _buttonTextColor_watching;

  @override
  Widget build(BuildContext context) {
    if (globals.moviesWatchedList.contains(widget.movie)) {
      _buttonColor_watched = Colors.black;
      _buttonTextColor_watched = Colors.amber;
    } else {
      _buttonColor_watched = Color(0xffca7302);
      _buttonTextColor_watched = Colors.white;
    }

    if (globals.moviesWatchingList.contains(widget.movie)) {
      _buttonColor_watching = Colors.black;
      _buttonTextColor_watching = Color.fromARGB(255, 135, 7, 255);
    } else {
      _buttonColor_watching = Color.fromARGB(255, 89, 2, 202);
      _buttonTextColor_watching = Colors.white;
    }
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Column(
            children: <Widget>[
              Expanded(
                child: Stack(
                  children: <Widget>[
                    widget.movie.backdropPath == null
                        ? Image.asset(
                            'assets/images/na.jpg',
                            fit: BoxFit.cover,
                          )
                        : FadeInImage(
                            width: double.infinity,
                            height: double.infinity,
                            image: NetworkImage(TMDB_BASE_IMAGE_URL +
                                'original/' +
                                widget.movie.backdropPath!),
                            fit: BoxFit.cover,
                            placeholder:
                                AssetImage('assets/images/loading.gif'),
                          ),
                    Container(
                      decoration: BoxDecoration(
                          gradient: LinearGradient(
                              begin: FractionalOffset.bottomCenter,
                              end: FractionalOffset.topCenter,
                              colors: [
                            widget.themeData!.primaryColor,
                            widget.themeData!.primaryColor.withOpacity(0.3),
                            widget.themeData!.primaryColor.withOpacity(0.2),
                            widget.themeData!.primaryColor.withOpacity(0.1),
                          ],
                              stops: [
                            0.0,
                            0.25,
                            0.5,
                            0.75
                          ])),
                    )
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  height: MediaQuery.of(context).size.height,
                  color: widget.themeData!.primaryColor,
                ),
              )
            ],
          ),
          SizedBox(
              child: Column(
            children: <Widget>[
              AppBar(
                backgroundColor: Colors.transparent,
                elevation: 0,
                leading: IconButton(
                  icon: Icon(
                    Icons.arrow_back,
                    color: widget.themeData!.hintColor,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                    setState(() {}); // Refresh the page
                  },
                ),
              ),
              Expanded(
                child: Container(
                  color: Colors.transparent,
                  child: Stack(
                    children: <Widget>[
                      SizedBox(
                        width: double.infinity,
                        height: double.infinity,
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(16, 75, 16, 16),
                          child: Card(
                            elevation: 5,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            color: widget.themeData!.primaryColor,
                            child: Column(
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.only(left: 120.0),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text(
                                          widget.movie.title != null
                                              ? widget.movie.title!
                                              : (widget.movie.name ?? ''),
                                          style: widget
                                              .themeData!.textTheme.headline5,
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Row(
                                            children: <Widget>[
                                              Text(
                                                widget.movie.voteAverage!
                                                    .toString(),
                                                style: widget.themeData!
                                                    .textTheme.bodyText1,
                                              ),
                                              Icon(
                                                Icons.star,
                                                color: Colors.green,
                                              ),
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: SingleChildScrollView(
                                    physics: BouncingScrollPhysics(),
                                    child: Column(
                                      children: <Widget>[
                                        FutureBuilder<List<Genres>>(
                                          future: fetchGenres()
                                              .then((value) => value.genres!),
                                          builder: (context, snapshot) {
                                            if (snapshot.hasData) {
                                              return GenreList(
                                                themeData: widget.themeData!,
                                                genres:
                                                    widget.movie.genreIds ?? [],
                                                totalGenres: snapshot.data!,
                                              );
                                            } else if (snapshot.hasError) {
                                              return Text(
                                                  "Error: ${snapshot.error}");
                                            } else {
                                              return Container();
                                            }
                                          },
                                        ),
                                        Row(
                                          children: <Widget>[
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 8.0),
                                              child: Text(
                                                'Overview',
                                                style: widget.themeData!
                                                    .textTheme.bodyText1,
                                              ),
                                            ),
                                            Spacer(),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              children: [
                                                GestureDetector(
                                                  onTap: () {
                                                    if (!globals
                                                        .moviesWatchedList
                                                        .contains(
                                                            widget.movie)) {
                                                      globals.MovieLists()
                                                          .addWatched(
                                                              widget.movie);
                                                      setState(() {
                                                        if (globals
                                                            .moviesWatchingList
                                                            .contains(
                                                                widget.movie)) {
                                                          _buttonColor_watched =
                                                              Color.fromARGB(
                                                                  255,
                                                                  119,
                                                                  77,
                                                                  0);
                                                          _buttonTextColor_watched =
                                                              Color(0xff9c9c9c);
                                                        } else {
                                                          _buttonColor_watched =
                                                              Color.fromARGB(
                                                                  255,
                                                                  255,
                                                                  166,
                                                                  0);
                                                          _buttonTextColor_watched =
                                                              Colors.white;
                                                        }
                                                      });
                                                    }
                                                  },
                                                  child: Ink(
                                                    decoration: BoxDecoration(
                                                      color:
                                                          _buttonColor_watched,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              20.0),
                                                      border: Border.all(
                                                        width: 1,
                                                        style:
                                                            BorderStyle.solid,
                                                        color:
                                                            _buttonColor_watched,
                                                      ),
                                                    ),
                                                    child: Padding(
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              horizontal: 12.0,
                                                              vertical: 4.0),
                                                      child: Text(
                                                        'Watched',
                                                        style: widget
                                                            .themeData!
                                                            .textTheme
                                                            .bodyText1!
                                                            .copyWith(
                                                          color:
                                                              _buttonTextColor_watched,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                GestureDetector(
                                                  onTap: () {
                                                    if (!globals
                                                        .moviesWatchingList
                                                        .contains(
                                                            widget.movie)) {
                                                      globals.MovieLists()
                                                          .addWatching(
                                                              widget.movie);
                                                      setState(() {
                                                        if (globals
                                                            .moviesWatchingList
                                                            .contains(
                                                                widget.movie)) {
                                                          _buttonColor_watching =
                                                              Color(0xff410077);
                                                          _buttonTextColor_watching =
                                                              Color(0xff9c9c9c);
                                                        } else {
                                                          _buttonColor_watching =
                                                              Color(0xff8d00ff);
                                                          _buttonTextColor_watching =
                                                              Colors.white;
                                                        }
                                                      });
                                                    }
                                                  },
                                                  child: Ink(
                                                    decoration: BoxDecoration(
                                                      color:
                                                          _buttonColor_watching,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              20.0),
                                                      border: Border.all(
                                                        width: 1,
                                                        style:
                                                            BorderStyle.solid,
                                                        color:
                                                            _buttonColor_watching,
                                                      ),
                                                    ),
                                                    child: Padding(
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              horizontal: 12.0,
                                                              vertical: 4.0),
                                                      child: Text(
                                                        'Watching',
                                                        style: widget
                                                            .themeData!
                                                            .textTheme
                                                            .bodyText1!
                                                            .copyWith(
                                                          color:
                                                              _buttonTextColor_watching,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                InkWell(
                                                  onTap: () async {
                                                    setState(() {
                                                      globals.MovieLists()
                                                          .removeFromListsInSharedPreferences(
                                                              widget.movie);
                                                    });
                                                  },
                                                  child: Ink(
                                                    decoration: BoxDecoration(
                                                      color: Colors.transparent,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              20.0),
                                                      border: Border.all(
                                                        width: 1,
                                                        style:
                                                            BorderStyle.solid,
                                                        color: Colors.grey,
                                                      ),
                                                    ),
                                                    child: Padding(
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              horizontal: 12.0,
                                                              vertical: 4.0),
                                                      child: Text(
                                                        'Remove',
                                                        style: widget
                                                            .themeData!
                                                            .textTheme
                                                            .bodyText1,
                                                      ),
                                                    ),
                                                  ),
                                                )
                                              ],
                                            ),
                                          ],
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                            widget.movie.overview!,
                                            style: widget
                                                .themeData!.textTheme.caption,
                                          ),
                                        ),
                                        Row(
                                          children: <Widget>[
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 8.0, bottom: 4.0),
                                              child: Text(
                                                widget.movie.releaseDate != null
                                                    ? 'Release date : ' +
                                                        widget
                                                            .movie.releaseDate!
                                                    : 'Release date : ' +
                                                        widget.movie.aired!,
                                                style: widget.themeData!
                                                    .textTheme.bodyText1,
                                              ),
                                            ),
                                          ],
                                        ),
                                        ScrollingArtists(
                                          api: Endpoints.getCreditsUrl(
                                              widget.movie.id!),
                                          title: 'Cast',
                                          tapButtonText: 'See full cast & crew',
                                          themeData: widget.themeData,
                                          onTap: (Cast cast) {
                                            modalBottomSheetMenu(cast);
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        top: 0,
                        left: 40,
                        child: SizedBox(
                          width: 100,
                          height: 150,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8.0),
                            child: widget.movie.posterPath == null
                                ? Image.asset(
                                    'assets/images/na.jpg',
                                    fit: BoxFit.cover,
                                  )
                                : FadeInImage(
                                    image: NetworkImage(TMDB_BASE_IMAGE_URL +
                                        'w500/' +
                                        widget.movie.posterPath!),
                                    fit: BoxFit.cover,
                                    placeholder:
                                        AssetImage('assets/images/loading.gif'),
                                  ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ))
        ],
      ),
    );
  }

  void modalBottomSheetMenu(Cast cast) {
    // double height = MediaQuery.of(context).size.height;
    showModalBottomSheet(
        context: context,
        builder: (builder) {
          return Container(
            // height: height / 2,
            color: Colors.transparent,
            child: Stack(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 50),
                  child: Container(
                      padding: const EdgeInsets.only(top: 54),
                      decoration: BoxDecoration(
                          color: widget.themeData!.primaryColor,
                          borderRadius: new BorderRadius.only(
                              topLeft: const Radius.circular(16.0),
                              topRight: const Radius.circular(16.0))),
                      child: Center(
                        child: ListView(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                children: <Widget>[
                                  Text(
                                    '${cast.name}',
                                    style:
                                        widget.themeData!.textTheme.bodyText2,
                                  ),
                                  Text(
                                    'as',
                                    style:
                                        widget.themeData!.textTheme.bodyText2,
                                  ),
                                  Text(
                                    '${cast.character}',
                                    style:
                                        widget.themeData!.textTheme.bodyText2,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      )),
                ),
                Align(
                    alignment: Alignment.topCenter,
                    child: SizedBox(
                      width: 100,
                      height: 100,
                      child: Container(
                        decoration: BoxDecoration(
                            color: widget.themeData!.primaryColor,
                            border: Border.all(
                                color: widget.themeData!.accentColor, width: 3),
                            image: DecorationImage(
                                fit: BoxFit.cover,
                                image: (cast.profilePath == null
                                        ? AssetImage('assets/images/na.jpg')
                                        : NetworkImage(TMDB_BASE_IMAGE_URL +
                                            'w500/' +
                                            cast.profilePath!))
                                    as ImageProvider<Object>),
                            shape: BoxShape.circle),
                      ),
                    ))
              ],
            ),
          );
        });
  }
}
