import 'package:flutter/material.dart';
import 'package:cache_image/cache_image.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wallpapers_app/wallheaven.dart';
import 'package:wallpapers_app/display.dart';

class Wallpapers extends StatefulWidget {
  int width;
  int height;
  Wallpapers(this.width, this.height);
  @override
  _WallpapersState createState() => _WallpapersState();
}

class _WallpapersState extends State<Wallpapers> {
  final Color loadingTextColor = Color(0xFF000000);
  final Color bgColor = Color(0xFFAAAAAA);
  String query = "";
  int adder = 0;
  bool fetchedData = false;
  List wallpapersLinks = [];
  List wallpapersThumbs = [];
  List wallpapersColors = [];
  List wallpapersColors2 = [];
  List wallpapersViews = [];
  List wallpapersResolution = [];
  List wallpapersUrl = [];
  List wallpapersCreatedAt = [];
  List wallpapersFav = [];
  WallData wallheaven = WallData();
  List<String> items = List.generate(
      20, (number) => "https://via.placeholder.com/300x400.jpg/FFFFFF/FFFFFF");

  void getwalls(String query, int width, int height) async {
    setState(() {
      fetchedData = false;
    });
    adder = 0;
    items = List.generate(20,
        (number) => "https://via.placeholder.com/300x400.jpg/FFFFFF/FFFFFF");
    Map data = await wallheaven.getData(query, width, height);
    wallpapersLinks = data["links"];
    wallpapersThumbs = data["thumbs"];
    wallpapersColors = data["colors"];
    wallpapersColors2 = data["colors2"];
    wallpapersViews = data["views"];
    wallpapersResolution = data["resolution"];
    wallpapersUrl = data["url"];
    wallpapersCreatedAt = data["created_at"];
    wallpapersFav = data["favourites"];
    // print(wallpapersColors.toString());
    items =
        List.generate(20, (number) => wallpapersLinks[int.parse('$number')]);
    setState(() {
      fetchedData = true;
    });
  }

  Future<Null> refreshList() async {
    refreshKey.currentState?.show(atTop: true);
    await Future.delayed(Duration(seconds: 2));
    getwalls(query, widget.width, widget.height);

    // setState(() {
    //   items = List.generate(
    //       20, (number) => "https://picsum.photos/id/${number + 5}/600/800");
    // }
    // );

    return null;
  }

  // Future<Null> refreshLoad() async {
  //   refreshKey.currentState?.show(atTop: true);
  //   await Future.delayed(Duration(seconds: 5));
  //   return null;
  // }

  ScrollController controller;
  var refreshKey = GlobalKey<RefreshIndicatorState>();

  @override
  void initState() {
    super.initState();
    getwalls(query, widget.width, widget.height);
    controller = new ScrollController()..addListener(_scrollListener);
  }

  @override
  void dispose() {
    controller.removeListener(_scrollListener);
    super.dispose();
  }

  void _scrollListener() {
    // print(controller.position.extentAfter);
    if (controller.position.extentAfter < 500) {
      if (adder < 120) {
        setState(() {
          adder = adder + 20;
          items.addAll(new List.generate(
              20, (number) => wallpapersLinks[int.parse('${number + adder}')]));
        });
      }
    }
    // print(adder.toString());
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, width: 720, height: 1440, allowFontScaling: true);
    return fetchedData
        ? RefreshIndicator(
            key: refreshKey,
            onRefresh: refreshList,
            child: new Container(
                color: bgColor,
                child: Scrollbar(
                  child: GridView.builder(
                      shrinkWrap: true,
                      controller: controller,
                      padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                      itemCount: items.length,
                      gridDelegate:
                          new SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2, childAspectRatio: 0.75),
                      itemBuilder: (BuildContext context, int index) {
                        return new GestureDetector(
                          child: new Card(
                            shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(24))),
                            elevation: 0.0,
                            semanticContainer: true,
                            margin: EdgeInsets.fromLTRB(7, 7, 7, 7),
                            clipBehavior: Clip.antiAliasWithSaveLayer,
                            child: new Container(
                                child: new Hero(
                                    tag: wallpapersUrl[index],
                                    child: FadeInImage(
                                      fadeInDuration:
                                          Duration(milliseconds: 200),
                                      placeholder: CacheImage(
                                          "https://via.placeholder.com/300x400.jpg/${wallpapersColors[index]}/${wallpapersColors[index]}"),
                                      image: CacheImage(
                                        wallpapersThumbs[index],
                                      ),
                                      fit: BoxFit.cover,
                                    ))),
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) {
                                    return Display(
                                        wallpapersLinks[index],
                                        wallpapersThumbs[index],
                                        wallpapersColors[index],
                                        wallpapersColors2[index],
                                        wallpapersViews[index],
                                        wallpapersResolution[index],
                                        wallpapersUrl[index],
                                        wallpapersCreatedAt[index],
                                        wallpapersFav[index]);
                                  },
                                  fullscreenDialog: true),
                            );
                            // showDialog(
                            //   barrierDismissible: false,
                            //   context: context,
                            //   child: new AlertDialog(
                            //     shape: RoundedRectangleBorder(
                            //         borderRadius:
                            //             BorderRadius.all(Radius.circular(24))),
                            //     title: new Column(
                            //       children: <Widget>[
                            //         new Text("Image $index"),
                            //       ],
                            //     ),
                            //     content: new FadeInImage(
                            //       image: CacheImage(fetchedData
                            //           ? wallpapersLinks[index]
                            //           : items[index]),
                            //       placeholder: CacheImage(fetchedData
                            //           ? wallpapersThumbs[index]
                            //           : "https://via.placeholder.com/300x400.jpg/FFFFFF/FFFFFF"),
                            //     ),
                            //     actions: <Widget>[
                            //       new FlatButton(
                            //           onPressed: () {
                            //             Navigator.of(context).pop();
                            //           },
                            //           child: new Text("OK"))
                            //     ],
                            //   ),
                            // );
                          },
                        );
                      }),
                )),
          )
        : Container(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Image(
                    image: AssetImage("assets/images/loading.png"),
                    height: 600.h,
                    width: 600.w,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Text(
                      "Loading",
                      style: GoogleFonts.raleway(
                          fontSize: 30, color: loadingTextColor),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Text(
                    "Sit Back and wait a few seconds\nas your favourite wallpapers are\nloading.",
                    style: GoogleFonts.raleway(
                        fontSize: 16, color: loadingTextColor),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          );
  }
}