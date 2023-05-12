import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:login_page/pages/navpages/workout_details_page.dart';
import 'package:provider/provider.dart';
import 'package:login_page/providers/coaches_data.dart';

class CoachWorkoutlib extends StatefulWidget {
  const CoachWorkoutlib({Key? key}) : super(key: key);

  @override
  State<CoachWorkoutlib> createState() => _CoachWorkoutlibState();
}

class _CoachWorkoutlibState extends State<CoachWorkoutlib> {
  TextEditingController searchController = TextEditingController();
  List<dynamic>? jsonList;
  int currentPage = 1;
  int lastPage = 78;
  bool isLoading = false;
  bool isSearchBarVisible = false;
  double appBarHeight = kToolbarHeight;

  @override
  void initState() {
    super.initState();
    getData();
  }

  void getData() async {
    if (isLoading) return;
    setState(() {
      isLoading = true;
    });
    try {
      var dio = Dio();
      String token = Provider.of<Coach>(context, listen: false).token;
      dio.options.headers["Authorization"] = 'Bearer $token';
      var response = await dio.get(
          'https://sbit3j-service.onrender.com/v1/global/workout-library/?page=$currentPage');
      if (response.statusCode == 200) {
        setState(() {
          if (jsonList == null) {
            jsonList = response.data['data'] as List<dynamic>;
          } else {
            jsonList!.addAll(response.data['data']);
          }
          currentPage++; // Increment the current page for pagination
        });
      } else {
        print(response.statusCode);
      }
    } catch (e) {
      print(e);
    } finally {
      setState(() {
        isLoading = false;
      });
    }
    // ignore: unused_element
    void loadMoreData() async {
      if (currentPage < lastPage) {
        currentPage++;
        getData();
      }
    }
  }

  void searchWorkouts() async {
    String searchText =
        searchController.text; // Get the text from the search field
    setState(() {
      isLoading = true; // Show loading indicator
    });
    try {
      var dio = Dio();
      String token = Provider.of<Coach>(context, listen: false).token;
      dio.options.headers["Authorization"] = 'Bearer $token';
      var response = await dio.get(
          'https://sbit3j-service.onrender.com/v1/global/workout-library/?keyword=$searchText'); // Pass the search text as a query parameter
      if (response.statusCode == 200) {
        setState(() {
          jsonList = response.data['data'] as List<dynamic>;
        });
      } else {
        print(response.statusCode);
      }
    } catch (e) {
      print(e);
    } finally {
      setState(() {
        isLoading = false; // Hide loading indicator
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Row(
            children: [
              isSearchBarVisible
                  ? Expanded(
                      child: TextField(
                        controller: searchController,
                        style: const TextStyle(
                          color: Colors.black,
                        ),
                        decoration: InputDecoration(
                          hintText: 'Search workouts',
                          hintStyle: const TextStyle(
                            color: Colors.grey,
                          ),
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(100),
                            borderSide: BorderSide.none,
                          ),
                          suffixIcon: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            width:
                                24, // Update the width of the search button to be smaller
                            height:
                                24, // Update the height of the search button to be smaller
                            child: IconButton(
                              icon:
                                  const Icon(Icons.clear, color: Colors.black),
                              onPressed: () {
                                searchController.clear();
                                searchWorkouts();
                              },
                            ),
                          ),
                        ),
                        onSubmitted: (value) {
                          searchWorkouts();
                        },
                      ),
                    )
                  : Text('Workout Library'),
            ],
          ),
          backgroundColor: const Color(0xFF004aad),
          centerTitle: false,
          actions: [
            IconButton(
              icon: const Icon(Icons.search,
                  color: Color.fromARGB(255, 255, 255,
                      255)), // Set the search icon color to black
              onPressed: () {
                setState(() {
                  isSearchBarVisible =
                      !isSearchBarVisible; // Toggle the visibility of the search text field
                });
              },
            ),
          ],
        ),
        backgroundColor: Color.fromARGB(255, 202, 22, 22),
        body: Container(
          color: Colors.white, // Add a background color to the container
          child: Column(
            children: [
              Expanded(
                child: jsonList == null
                    ? const Center(
                        child: CircularProgressIndicator(),
                      )
                    : ListView.builder(
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        physics: const BouncingScrollPhysics(),
                        itemExtent: 97,
                        itemBuilder: (BuildContext context, int index) {
                          return Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 5,
                                vertical: 3,
                              ),
                              child: Card(
                                elevation: 2.5,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                  side: BorderSide(color: Colors.grey.shade300),
                                ),
                                child: ListTile(
                                  leading: ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    // ignore: sized_box_for_whitespace
                                    child: Container(
                                      child: Image.network(
                                        jsonList?[index]['imageUrl'] ?? '',
                                        width: 120,
                                        height:
                                            120,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  title: Text(
                                    jsonList?[index]['title'] ?? '',
                                    style: const TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'Montserrat',
                                    ),
                                  ),
                                  subtitle: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const SizedBox(height: 4),
                                      Text(
                                        (jsonList?[index]['description'] ?? ''),
                                        maxLines: 3,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey,
                                          fontFamily:
                                              'Montserrat', // Use a custom font
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                    ],
                                  ),
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            WorkoutDetailsPage(
                                          title:
                                              jsonList?[index]['title'] ?? '',
                                          workoutId:
                                              jsonList?[index]['id'] ?? '',
                                          imageUrl: jsonList?[index]
                                                  ['imageUrl'] ??
                                              '',
                                          description: jsonList?[index]
                                                  ['description'] ??
                                              '',
                                          youtubeUrl: jsonList?[index]
                                                  ['youtubeUrl'] ??
                                              '',
                                          muscleGroups: '',
                                          reps: jsonList?[index]['reps']
                                                  ?.toString() ??
                                              '0', // Convert int to String
                                          sets: jsonList?[index]['set']
                                                  ?.toString() ??
                                              '0', // Convert int to String
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ));
                        },
                        itemCount: jsonList?.length ?? 0,
                      ),
              ),
              isLoading // Show "Load More" button when data is not loading
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: getData,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF004aad),
                      ),
                      child: const Text('Load More'),
                    ),
            ],
          ),
        ));
  }
}




  //'Bearer ${context.watch<Coach>().token}';
  //    var response = await dio
  //        .get('https://sbit3j-service.onrender.com/v1/coach/coachings/');



