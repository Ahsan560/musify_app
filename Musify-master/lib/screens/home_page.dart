import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:musify/API/musify.dart';
import 'package:musify/screens/playlists_page.dart';
import 'package:musify/style/app_themes.dart';
import 'package:musify/widgets/marque.dart';
import 'package:musify/widgets/playlist_cube.dart';
import 'package:musify/widgets/song_bar.dart';
import 'package:musify/widgets/spinner.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Musify.',
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            FutureBuilder(
              future: getPlaylists(5),
              builder: (context, AsyncSnapshot<List<dynamic>> data) {
                return data.hasData
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                              top: 16,
                              bottom: 10,
                              left: 20,
                              right: 20,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width / 1.4,
                                  child: MarqueeWidget(
                                    direction: Axis.horizontal,
                                    child: Text(
                                      AppLocalizations.of(context)!
                                          .suggestedPlaylists,
                                      style: TextStyle(
                                        color: colorScheme.primary,
                                        fontSize: 20,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                                ),
                                IconButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => PlaylistsPage(),
                                      ),
                                    );
                                  },
                                  icon: Icon(
                                    FluentIcons.more_horizontal_24_regular,
                                    color: colorScheme.primary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 230,
                            child: ListView.separated(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 15),
                              scrollDirection: Axis.horizontal,
                              separatorBuilder: (_, __) =>
                                  const SizedBox(width: 15),
                              itemCount: data.data!.length,
                              itemBuilder: (context, index) {
                                final playlist = data.data![index];
                                return SizedBox(
                                  width: 230,
                                  height: 230,
                                  child: PlaylistCube(
                                    id: playlist['ytid'],
                                    image: playlist['image'].toString(),
                                    title: playlist['title'].toString(),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      )
                    : const Center(
                        child: Padding(
                          padding: EdgeInsets.all(35),
                          child: Spinner(),
                        ),
                      );
              },
            ),
            FutureBuilder(
              future: get10Music('PLgzTt0k8mXzEk586ze4BjvDXR7c-TUSnx'),
              builder: (context, AsyncSnapshot<dynamic> snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.waiting:
                    return const Center(
                      child: Padding(
                        padding: EdgeInsets.all(35),
                        child: Spinner(),
                      ),
                    );
                  case ConnectionState.done:
                    if (snapshot.hasError) {
                      return Center(
                        child: Text(
                          'Error!',
                          style: TextStyle(
                            color: colorScheme.primary,
                            fontSize: 18,
                          ),
                        ),
                      );
                    }
                    if (!snapshot.hasData) {
                      return Center(
                        child: Text(
                          'Nothing Found!',
                          style: TextStyle(
                            color: colorScheme.primary,
                            fontSize: 18,
                          ),
                        ),
                      );
                    }
                    return Wrap(
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(
                            top: MediaQuery.of(context).size.height / 55,
                            bottom: 10,
                            left: 20,
                            right: 20,
                          ),
                          child: Text(
                            AppLocalizations.of(context)!.recommendedForYou,
                            style: TextStyle(
                              color: colorScheme.primary,
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        ListView.builder(
                          shrinkWrap: true,
                          addAutomaticKeepAlives: false,
                          addRepaintBoundaries: false,
                          physics: const BouncingScrollPhysics(),
                          itemCount: snapshot.data.length as int,
                          itemBuilder: (context, index) {
                            return SongBar(snapshot.data[index], true);
                          },
                        )
                      ],
                    );
                  default:
                    return const SizedBox.shrink();
                }
              },
            )
          ],
        ),
      ),
    );
  }
}
