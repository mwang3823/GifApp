import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gifapp/ViewModels/Rivrepod/GifNotifier.dart';

class SearchGif extends ConsumerStatefulWidget {
  const SearchGif({super.key});

  @override
  _SearchGifState createState() => _SearchGifState();
}

class _SearchGifState extends ConsumerState<SearchGif> {
  ScrollController controller = ScrollController();
  int limit = 10;
  String content = "";

  @override
  void initState() {
    super.initState();
    controller.addListener(
      () {
        if (controller.position.pixels >=
            controller.position.maxScrollExtent - 200) {
          setState(() {
            limit + 10;
          });
          ref.read(searchGifProvider.notifier).searchGif(limit, content);
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    final gifs = ref.watch(searchGifProvider);
    return Scaffold(
      appBar: AppBar(title: Text("GIF APP")),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            SearchBar(
              hintText: "Tìm kiếm...",
              leading: Icon(Icons.search),
              onSubmitted: (value) {
                setState(() {
                  content = value;
                });
                ref.read(searchGifProvider.notifier).searchGif(limit, content);
              },
            ),
            Expanded(
                child: gifs.isEmpty
                    ? Center(
                        child: CircularProgressIndicator(),
                      )
                    : GridView.builder(
                        itemCount: gifs.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2),
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            child: Image.network(
                                gifs[index].images['original']!.webp),
                            onLongPress: () async {},
                          );
                        },
                      ))
          ],
        ),
      ),
    );
  }
}
