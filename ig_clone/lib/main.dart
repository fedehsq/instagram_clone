import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:photo_manager/photo_manager.dart';


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
        //

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
  File _image;
  final _picker = ImagePicker();
  bool _showStory = false;
  final _images = [];

  TabController _tabController;

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
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
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
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
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
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
            _showStories(),
          // photo grid
          buildTabBar(),
          if (_tabController.index == 0)
            _loadImages(),
        ]
        ,),

    );
  }

  TabBar buildTabBar() {
    return TabBar(
          controller: _tabController,
          tabs: [
            Tab(icon: Icon(Icons.grid_on_sharp,)),
            Tab(icon: Icon(Icons.portrait_outlined)),
          ],
        );
  }


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

  // read image from internal storage! i love android
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

  // build first line of prifile
  Widget _setImagePostFollower() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
      IconButton(
        padding: EdgeInsets.zero,
        iconSize: 80,
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
          Text("Federico Bernacca",
            style: TextStyle(fontWeight: FontWeight.bold),),
          Text("📍 Carrara"),
          _setRichText("🎓 Informatica ", "@unipisa"),
          _setRichText("📚 Cybersecurity ", "@unipisa"),
          Text("💻 { }"),
          Text(
            "github.com/fedehsq",
            style: TextStyle(
                color: Colors.blue
            ),
          ),
        ],
      ),
    );
  }

  _setRichText(String s, String t) {
    return RichText(
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
    );
  }

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

  FutureBuilder<Widget> _loadImages() {
    return FutureBuilder<Widget>(
        future: _showMyPhotos(),
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

  Future<Widget> _showMyPhotos() async {
    var result = await PhotoManager.requestPermission();
    if (result) {
      // get albums
      List<AssetPathEntity> list = await PhotoManager.getAssetPathList();
      // 1st album in the list, typically the "Recent" or "All" album
      List<AssetEntity> imageList;
      for (var album in list) {
        if (album.name == "Camera") {
          AssetPathEntity data = album;
          imageList = await data.assetList;
          for (int i = 0; i < 100; i++) {
            AssetEntity entity = imageList[i];
            var width = entity.width;
            var height = entity.height;
            var aspectRatio = height / width;
            int newHeight = (aspectRatio * 256).round();
            File file = await imageList[i].file;
            _images.add(Image(fit: BoxFit.cover,
                image: ResizeImage(
                    FileImage(
                        file), width: 256, height: newHeight, allowUpscaling: false
                )
            ));
          }
          return Expanded(
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisSpacing: 2,
                  mainAxisSpacing: 2,
                  crossAxisCount: 3),
              itemCount: _images.length,
              itemBuilder: (BuildContext context, int index) {
                print(index);

                return _images[index];
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



}

