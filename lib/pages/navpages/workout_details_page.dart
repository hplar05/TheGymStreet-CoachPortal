import 'package:flutter/material.dart';

class WorkoutDetailsPage extends StatelessWidget {
  final String? title;
  final String? description;
  final String? imageUrl;
  final String? reps;
  final String? sets;
  final String? youtubeUrl;

  WorkoutDetailsPage({
    this.title,
    this.description,
    this.imageUrl,
    this.reps,
    this.sets,
    this.youtubeUrl,
    required String muscleGroups,
    required workoutId,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: const Color(0xFF004aad),
        title: Center(
          child: Text(
            title ?? '',
            textAlign: TextAlign.center,
          ),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                imageUrl ?? '',
                fit: BoxFit.cover,
                width: double.infinity,
                height: 300,
                loadingBuilder: (BuildContext context, Widget child,
                    ImageChunkEvent? progress) {
                  if (progress == null) return child;
                  return CircularProgressIndicator(
                    value: progress.expectedTotalBytes != null
                        ? progress.cumulativeBytesLoaded /
                            progress.expectedTotalBytes!
                        : null,
                  );
                },
                errorBuilder: (BuildContext context, Object error,
                    StackTrace? stackTrace) {
                  return Icon(Icons.error);
                },
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 0),
                Center(
                  child: Text(
                    title ?? '',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(height: 8),
                Center(
                  child: Text(
                    description ?? '',
                    style: TextStyle(fontSize: 18),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(height: 30),
                Divider(),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Column(
                        children: [
                          Text(
                            "Reps",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 8),
                          Text(
                            reps ?? '',
                            style: TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          Text(
                            "Sets",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 8),
                          Text(
                            sets ?? '',
                            style: TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Divider(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
