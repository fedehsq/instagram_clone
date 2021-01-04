import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:photo_manager/photo_manager.dart';
import 'AlbumImages.dart';

// camera images
final cameraImages = [];

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      darkTheme: ThemeData(
        appBarTheme: AppBarTheme(color: Colors.black),
        scaffoldBackgroundColor: Colors.black ,
        brightness: Brightness.dark),
      theme: ThemeData(
        // This is the theme of your application.

        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
        // This makes the visual density adapt to the platform that you run
        // the app on. For desktop platforms, the controls will be smaller and
        // closer together (more dense) than on mobile platforms.
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      themeMode: ThemeMode.dark,
      home: MyHomePage(title: 'fedehsq'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with SingleTickerProviderStateMixin {
  // picked profile image
  File _image;
  final _picker = ImagePicker();
  // flag tells evidence stories are to shown
  bool _showStory = false;
  // swipe between routes
  TabController _tabController;

  // for controller
  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(_handleTabSelection);
    super.initState();
  }

  _handleTabSelection() {
    if (_tabController.indexIsChanging) {
      setState(() {});
    }
  }

  // concat two string: normal and bold
  Widget _buildDoubleText(String one, String two) {
    return Column(
      children: [
        Text(one,
          style: (TextStyle(
              fontSize: 16, fontWeight: FontWeight.bold
          )
          ),
        ),
        Text(
            two
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: Icon(
                  Icons.lock_outline, size: 18
              ),
            ),
            Text(
                widget.title,
                style: TextStyle(
                    fontSize: 24, fontWeight: FontWeight.bold)
            ),
            Icon(
              Icons.keyboard_arrow_down, size: 20,
            ),
            Icon(
              Icons.verified, size: 20, color: Colors.blue,
            ),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Icon(
                Icons.add, size: 32
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Icon(
                Icons.menu, size: 32
            ),
          )
        ],
      ),
      body: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              SliverList(
                delegate: SliverChildListDelegate([
                  // row with image, post, follower
                  _setImagePostFollower(),
                  // description
                  _setDescription(),
                  // modify profile
                  _setModifyButton(),
                  // set story info
                  _setStoryInfo(),
                  // display stories in evidence
                  if (_showStory)
                    _showStories()
                ]),
              )
            ];
          },
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // photo grid
              buildTabBar(),
              _tabController.index == 0 ? loadCamera() : loadAlbum()
            ]
            ,)
      ),
    );
  }



  // two routes: camera photo and all photos
  TabBar buildTabBar() {
    return TabBar(
          controller: _tabController,
          tabs: [
            Tab(icon: Icon(Icons.grid_on_sharp,)),
            Tab(icon: Icon(Icons.portrait_outlined)),
          ],
        );
  }

  // display story if needed
  Widget _showStories() {
    return Padding(
        padding: const EdgeInsets.only(left: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Conserva le tue storie preferite sul tuo profilo"),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _addEvidenceStories(Icons.add),
                Icon(Icons.circle, size: 58, color: Colors.grey,),
                Icon(Icons.circle, size: 58, color: Colors.grey,),
                Icon(Icons.circle, size: 58, color: Colors.grey,),
                Icon(Icons.circle, size: 58, color: Colors.grey,),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(left: 18.0),
              child: Text("Nuova", style: TextStyle(fontSize: 11),),
            )
          ],
        ),
      );
  }

  // button to add story
  ButtonTheme _addEvidenceStories(IconData add) {
    return ButtonTheme(
      height: 48,
      minWidth: 48,
      child: OutlineButton(
          padding: EdgeInsets.zero,
          borderSide: BorderSide(color: Colors.white),
          shape: CircleBorder(),
          onPressed: () {},
          child: Icon(Icons.add)
      ),
    );
  }

  // pick image from internal storage to put in profile image
  Future getImage() async {
    final pickedFile = await _picker.getImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  // build first line of profile
  Widget _setImagePostFollower() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
      IconButton(
        padding: EdgeInsets.zero,
        iconSize: 85,
        icon: _image == null ?
        Icon(
            Icons.circle
        )
            :
        CircleAvatar(
          backgroundImage: new FileImage(_image), radius: 80,
        ),
        onPressed: getImage,
      ),
      _buildDoubleText("69", "Post"),
      _buildDoubleText("128 mln", "Follower"),
      _buildDoubleText("512", "Seguiti"),
    ],
    );
  }

  // second line of profile: info
  _setDescription() {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0, left: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top:4.0),
            child: Text("Federico Bernacca",
              style: TextStyle(fontWeight: FontWeight.bold),),
          ),
          Padding(
            padding: const EdgeInsets.only(top:4.0),
            child: Text("📍 Carrara"),
          ),
          _setRichText("🎓 Informatica ", "@unipisa"),
          _setRichText("📚 Cybersecurity ", "@unipisa"),
          Padding(
            padding: const EdgeInsets.only(top:4.0),
            child: Text("💻 { }"),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 4.0),
            child: Text(
              "github.com/fedehsq",
              style: TextStyle(
                  color: Colors.blue
              ),
            ),
          ),
        ],
      ),
    );
  }

  // concat two text of different style
  _setRichText(String s, String t) {
    return Padding(
      padding: const EdgeInsets.only(top: 4.0),
      child: RichText(
        text: TextSpan(
          text: s,
          children: <TextSpan>[
            TextSpan(
                text: t,
                style: TextStyle(
                    color: Colors.blue
                )
            ),
          ],
        ),
      ),
    );
  }

  // modify button
  _setModifyButton() {
    return Padding(
        padding: const EdgeInsets.only(top: 8.0, bottom: 8.0, left: 16.0, right: 16.0),
        child:
        ButtonTheme(
          height: 32,
          minWidth: MediaQuery.of(context).size.width,
          child: OutlineButton(
              borderSide: BorderSide(color: Colors.white),
              onPressed: () {},
              child: Text("Modifica il profilo")
          ),
        )
    );
  }

  // display row with info about stories
  _setStoryInfo() {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0, right: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text("Storie in evidenza",
              style: TextStyle(
                  fontWeight: FontWeight.bold)
          ),
          IconButton(
            // remove visual effects
              padding: EdgeInsets.zero,
              constraints: BoxConstraints(),
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              icon: !_showStory ? Icon(Icons.keyboard_arrow_down) :
              Icon(Icons.keyboard_arrow_up),
              onPressed: () {
                setState(() {
                  _showStory = !_showStory;
                });
              })
        ],
      ),
    );
  }


// task loading camera photos in first tab
  FutureBuilder<Widget> loadCamera() {
    return FutureBuilder<Widget>(
        future: _showMyCamera(),
        builder: (context, AsyncSnapshot<Widget> snapshot) {
          if (snapshot.hasData) {
            return snapshot.data;
          } else {
            return Padding(
              padding: const EdgeInsets.only(top: 64.0),
              child: Center(child: CircularProgressIndicator()),
            );
          }
        }
    );
  }

// load and display camera photo
  Future<Widget> _showMyCamera() async {
    var result = await PhotoManager.requestPermission();
    if (result) {
      // get albums
      List<AssetPathEntity> list = await PhotoManager.getAssetPathList();
      // 1st album in the list, typically the "Recent" or "All" album
      List<AssetEntity> imageList;
      AssetPathEntity data;
      for (var album in list) {
        if (album.name == "Camera") {
          data = album;
          imageList = await data.assetList;
          return Expanded(
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisSpacing: 2, mainAxisSpacing: 2, crossAxisCount: 3
              ),
              itemCount: imageList.length,
              itemBuilder: (BuildContext context, int index) {
                // display progress bar until photo isn't loaded
                return FutureBuilder<Widget>(
                    future: _getImageFromInternalStorage(imageList, index),
                    builder: (context, AsyncSnapshot<Widget> snapshot) {
                      if (snapshot.hasData) {
                        cameraImages.add(snapshot.data);
                        return snapshot.data;
                      } else {
                        return Padding(
                          padding: const EdgeInsets.only(top: 64.0),
                          child: Center(child: CircularProgressIndicator()),
                        );
                      }
                    }
                );
              },
            ),
          );
        }
      }
    } else {
      PhotoManager.openSetting();
    }
    return Text("Error");
  }

  // get image from camera
  Future<Widget> _getImageFromInternalStorage(List<AssetEntity> imageList, int index) async {
    /*
    var width = entity.width;
    var height = entity.height;
    var aspectRatio = height / width;
    int newHeight = (aspectRatio * 256).round();
    int newWidth = (256 / aspectRatio).round();
    // width > height ? 256 : newWidth, height: height > width ? 256 : newHeight,
    */
    File file = await imageList[index].file;
    if (file.path.endsWith("jpg") || file.path.endsWith("jpeg") ||
        file.path.endsWith("png")) {
      return InkWell(
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) =>
                  Image(
                      image: FileImage(
                          file
                      )
                  )
          ));
        },
        child: Image(fit: BoxFit.fitWidth,
            image: ResizeImage(
                FileImage(
                    file
                ),
                width: 250, allowUpscaling: false
            )
        ),
      );
    } else {
      return Container(
          color: Colors.red,
          child: Center(
              child: Text(
                  "Not an Image!"
              )
          )
      );
    }
  }

  // task loading album in second tab
  FutureBuilder<Widget> loadAlbum() {
    return FutureBuilder<Widget>(
        future: _showMyAlbums(),
        builder: (context, AsyncSnapshot<Widget> snapshot) {
          if (snapshot.hasData) {
            return snapshot.data;
          } else {
            return Padding(
              padding: const EdgeInsets.only(top: 64.0),
              child: Center(child: CircularProgressIndicator()),
            );
          }
        }
    );
  }

// show album name as card in first tab
  Future<Widget> _showMyAlbums() async {
    var result = await PhotoManager.requestPermission();
    if (result) {
      // get albums
      List<AssetPathEntity> album = await PhotoManager.getAssetPathList();
      List<Card> mAlbum = [];
      for (var album in album) {
        mAlbum.add(
            Card(
              color: Colors.blue,
              child: InkWell(
                onTap: ()  {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) {
                        return FutureBuilder<Widget>(
                            future: _startRoute(album),
                            builder: (context, AsyncSnapshot<Widget> snapshot) {
                              if (snapshot.hasData) {
                                return snapshot.data;
                              } else {
                                return Center(
                                    child: CircularProgressIndicator());
                              }
                            }
                        );
                      })
                  );
                },
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.folder),
                      Text(
                        album.name,
                      ),
                    ],
                  ),
                ),
              ),
            )
        );
      }
      return Expanded(
        child: GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisSpacing: 2,
                mainAxisSpacing: 2,
                crossAxisCount: 3),
            itemCount: mAlbum.length,
            itemBuilder: (BuildContext context, int index) {
              return mAlbum[index];
            }
        ),
      );
    } else {
      PhotoManager.openSetting();
    }
    return Text("Error");
  }

// open album tapped in new route AlbumImages.dart
  Future<Widget> _startRoute(AssetPathEntity album) async {
    var imageList = await album.assetList;
    return AlbumImages(
        images: imageList, album: album.name, size: album.assetCount);
  }



}

