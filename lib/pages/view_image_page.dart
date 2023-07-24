import 'package:flutter/material.dart';

class ViewImagesPage extends StatefulWidget {
  final List<String> imageUrls;

  const ViewImagesPage({Key? key, required this.imageUrls}) : super(key: key);

  @override
  _ViewImagesPageState createState() => _ViewImagesPageState();
}

class _ViewImagesPageState extends State<ViewImagesPage> {
  void deleteImage(int index) {
    setState(() {
      widget.imageUrls.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Saved Images'),
      ),
      body: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 10.0,
          crossAxisSpacing: 10.0,
        ),
        itemCount: widget.imageUrls.length,
        itemBuilder: (context, index) {
          final imageUrl = widget.imageUrls[index];
          return GestureDetector(
            onTap: () {
              // Open the full-size image in a dialog or navigate to a new screen
              showDialog(
                context: context,
                builder: (context) => Dialog(
                  child: Column(
                    children: [
                      Image.network(imageUrl),
                      ElevatedButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) => AlertDialog(
                              title: const Text('Delete Image'),
                              content: const Text('Are you sure you want to delete this image?'),
                              actions: <Widget>[
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop(); // Close the dialog
                                  },
                                  child: const Text('Cancel'),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop(); // Close the confirmation dialog
                                    deleteImage(index); // Delete the image
                                  },
                                  child: const Text('Delete'),
                                ),
                              ],
                            ),
                          );
                        },
                        child: const Text('Delete'),
                      ),
                    ],
                  ),
                ),
              );
            },
            child: Image.network(imageUrl, fit: BoxFit.cover),
          );
        },
      ),
    );
  }
}
