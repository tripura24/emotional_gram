import 'package:flutter/material.dart';

class ViewVideosPage extends StatelessWidget {
  final List<String> videoUrls;

  const ViewVideosPage({Key? key, required this.videoUrls}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("View Videos"),
      ),
      body: ListView.builder(
        itemCount: videoUrls.length,
        itemBuilder: (context, index) {
          final videoUrl = videoUrls[index];
          return ListTile(
            title: Text("Video ${index + 1}"),
            subtitle: Text(videoUrl),
            trailing: ElevatedButton(
              onPressed: () {
                // Implement the logic to play the video
              },
              child: Text("View"),
            ),
            onTap: () {
              // Implement additional logic when the ListTile is tapped
            },
          );
        },
      ),
    );
  }
}
