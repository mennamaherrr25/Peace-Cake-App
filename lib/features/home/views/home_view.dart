import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'package:peace_cake_app/features/home/data/ids.dart';
import 'package:peace_cake_app/features/home/views/video_player_page.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final TextEditingController searchController = TextEditingController();

  late List<Map<String, dynamic>> filteredList;

  @override
  void initState() {
    super.initState();
    filteredList = idsList;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        titleSpacing: 0,
        title: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: 420),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Row(
                children: [
                  Icon(Icons.play_circle_fill, color: Colors.red, size: 26),
                  const SizedBox(width: 6),

                  const Text(
                    'Peace Cake',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),

                  const SizedBox(width: 12),

                  // 🔍 Search field
                  Expanded(
                    child: TextField(
                      controller: searchController,
                      onChanged: searchVideos,
                      decoration: InputDecoration(
                        hintText: 'Search',
                        filled: true,
                        fillColor: Colors.grey.shade200,
                        contentPadding: const EdgeInsets.symmetric(vertical: 8),
                        prefixIcon: const Icon(Icons.search),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 420),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: ListView.builder(
              physics: BouncingScrollPhysics(),
              itemCount: filteredList.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => VideoPlayerPage(
                          videoId: filteredList[index]['id'],
                          title: filteredList[index]['title'],
                        ),
                      ),
                    );
                  },
                  child: Card(
                    elevation: 2,
                    child: Container(
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        // boxShadow: [
                        //   BoxShadow(blurRadius: 10, color: Colors.black26),
                        // ],
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,

                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: CachedNetworkImage(
                              imageUrl:
                                  'https://img.youtube.com/vi/${filteredList[index]['id']}/0.jpg',
                              placeholder: (context, url) =>
                                  Center(child: CircularProgressIndicator()),
                              errorWidget: (context, url, error) =>
                                  Icon(Icons.error),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: Text(
                              filteredList[index]['title'],
                              style: TextStyle(fontSize: 18),
                              textDirection: TextDirection.rtl,
                              textAlign: TextAlign.start,
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
        ),
      ),
    );
  }

  void searchVideos(String query) {
    final results = idsList.where((video) {
      final title = video['title'].toString().toLowerCase();
      return title.contains(query.toLowerCase());
    }).toList();

    setState(() {
      filteredList = results;
    });
  }
}
