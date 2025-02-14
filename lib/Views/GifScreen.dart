import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gifapp/ViewModels/Rivrepod/GifNotifier.dart';
import 'package:gifapp/ViewModels/Service/GifApiService.dart';
import 'package:gifapp/Views/SearchGif.dart';

class GifScreen extends ConsumerStatefulWidget {
  const GifScreen({super.key});

  @override
  _GifScreenState createState() => _GifScreenState();
}

class _GifScreenState extends ConsumerState<GifScreen> {
  int _limit = 10;
  final ScrollController scrollController = ScrollController();
  int _selected = 0;

  @override
  void initState() {
    super.initState();
    Future.microtask(
        () => ref.read(gifProvider.notifier).fetchGifTrending(_limit));

    scrollController.addListener(
      () {
        if (scrollController.position.pixels >=
            scrollController.position.maxScrollExtent - 200) {
          setState(() {
            _limit + 10;
          });
          ref.read(gifProvider.notifier).fetchGifTrending(_limit);
        }
      },
    );
  }

  void onSelect(int i) {
    setState(() {
      _selected = i;
    });
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    final gifs = ref.watch(gifProvider);

    return Scaffold(
      appBar: AppBar(
          title: Text(
            "GIF APP",
            style: TextStyle(color: Colors.white70),
          ),
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SearchGif(),
                      ));
                },
                icon: Icon(
                  Icons.search,
                  color: Colors.white70,
                ))
          ],
          leading: Builder(
            builder: (context) => IconButton(
                onPressed: () {
                  Scaffold.of(context).openDrawer();
                },
                icon: Icon(
                  Icons.menu,
                  color: Colors.white70,
                )),
          )),
      body: gifs.isEmpty
          ? Center(
              child: CircularProgressIndicator(),
            )
          : GridView.builder(
              controller: scrollController,
              itemCount: gifs.length,
              gridDelegate:
                  SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
              itemBuilder: (context, index) {
                return GestureDetector(
                  onLongPress: () {
                    GifApiService service=GifApiService();
                    service.saveImage(gifs[index].images['original']!.url);
                  },
                  child: Image.network(gifs[index].images['original']!.webp),
                );
              },
            ),
      drawer: Drawer(
        backgroundColor: Colors.black,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              child: Center(
                child: Text(
                  "GIF APP",
                  style: TextStyle(
                      color: Colors.white70,
                      fontSize: 30,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
            ListTile(
              title: Text(
                "Gif",
                style: TextStyle(
                    color: Colors.white70,
                    fontSize: 30,
                    fontWeight: FontWeight.bold),
              ),
              selected: _selected == 0,
              onTap: () => onSelect(0),
            ),
            ListTile(
              title: Text(
                "Emoji",
                style: TextStyle(
                    color: Colors.white70,
                    fontSize: 30,
                    fontWeight: FontWeight.bold),
              ),
              selected: _selected == 1,
              onTap: () => onSelect(1),
            )
          ],
        ),
      ),
    );
  }
}
