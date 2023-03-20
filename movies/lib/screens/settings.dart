import 'package:flutter/material.dart';
import 'package:movies/main.dart';
import 'package:movies/utils/theme_states.dart';
import 'package:provider/provider.dart';
import 'package:movies/modal_class/movie.dart';
import 'package:movies/screens/MovieListsANDTvShowList.dart';
import '/utils/globals.dart' as globals;

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  int? option;
  final List<Color> colors = [Colors.white, Color(0xff242248), Colors.black];
  final List<Color> borders = [Colors.black, Colors.white, Colors.white];
  final List<String> themes = ['Light', 'Dark', 'Amoled'];

  bool _isWatched = false;

  void _toggleWatched() {
    setState(() {
      _isWatched = !_isWatched;
    });
  }

  void _addToWatchList(Movie movie) {
    setState(() {
      globals.moviesWatchingList.remove(movie);
      globals.moviesWatchedList.add(movie);
    });
  }

  void _addToWatchingList(Movie movie) {
    setState(() {
      globals.moviesWatchedList.remove(movie);
      globals.moviesWatchingList.add(movie);
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final state = Provider.of<ThemeState>(context);
    return Theme(
        data: state.themeData,
        child: Container(
          color: state.themeData.primaryColor,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Expanded(
                  child: Center(
                child: Column(children: [
                  AppBar(
                    title: Text(
                      'Options',
                      style: state.themeData.textTheme.headline5,
                      textAlign: TextAlign.left,
                    ),
                    backgroundColor: state.themeData.primaryColor,
                  ),
                  TextButton(
                    style: ButtonStyle(
                      foregroundColor:
                          MaterialStateProperty.all<Color>(Colors.white),
                      alignment: Alignment.centerLeft,
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => MyHomePage()),
                      );
                    },
                    child: Text(
                      'Home',
                      style: state.themeData.textTheme.headline5
                          ?.copyWith(fontSize: 24),
                      textAlign: TextAlign.left,
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TextButton(
                    style: ButtonStyle(
                      foregroundColor:
                          MaterialStateProperty.all<Color>(Colors.white),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => NewPage()),
                      );
                    },
                    child: Text(
                      'Your Planner',
                      style: state.themeData.textTheme.headline5
                          ?.copyWith(fontSize: 24),
                    ),
                  ),
                ]),
              )),
              Spacer(),
              ListTile(
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      'Theme',
                      style: state.themeData.textTheme.bodyText1,
                    ),
                  ],
                ),
                subtitle: SizedBox(
                  height: 100,
                  child: Center(
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      shrinkWrap: true,
                      itemCount: 3,
                      itemBuilder: (BuildContext context, int index) {
                        return Stack(
                          children: <Widget>[
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                    width: 50,
                                    height: 50,
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                            width: 2, color: borders[index]),
                                        color: colors[index]),
                                  ),
                                ),
                                Text(themes[index],
                                    style: state.themeData.textTheme.bodyText1)
                              ],
                            ),
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: InkWell(
                                    onTap: () {
                                      setState(() {
                                        switch (index) {
                                          case 0:
                                            state.saveOptionValue(
                                                ThemeStateEnum.light);
                                            break;
                                          case 1:
                                            state.saveOptionValue(
                                                ThemeStateEnum.dark);
                                            break;
                                          case 2:
                                            state.saveOptionValue(
                                                ThemeStateEnum.amoled);

                                            break;
                                        }
                                      });
                                    },
                                    child: Container(
                                      width: 50,
                                      height: 50,
                                      child: Container(),
                                    ),
                                  ),
                                ),
                                Text(themes[index],
                                    style: state.themeData.textTheme.bodyText1)
                              ],
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
