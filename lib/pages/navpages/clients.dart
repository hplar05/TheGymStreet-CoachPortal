import 'dart:math';

import 'package:flutter/material.dart';
import 'package:login_page/providers/coaches_data.dart';
import 'package:login_page/providers/session_data.dart';
import 'package:provider/provider.dart';
import 'package:dio/dio.dart';
import '../../providers/clients_data.dart';
import 'package:login_page/pages/navpages/workout_details_page.dart';

class CoachClients extends StatefulWidget {
  const CoachClients({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _CoachClientsState createState() => _CoachClientsState();
}

class _CoachClientsState extends State<CoachClients> {
  final Dio dio = Dio(); // Create an instance of Dio
  List<Map<String, dynamic>>? clientsData;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    setState(() {
      isLoading = true;
    });
    try {
      String token = Provider.of<Coach>(context, listen: false).token;
      dio.options.headers["Authorization"] = 'Bearer $token';
      var response = await dio
          .get('https://sbit3j-service.onrender.com/v1/coach/clients/');
      if (response.statusCode == 200) {
        setState(() {
          clientsData = List<Map<String, dynamic>>.from(response.data['data'])
              .map((client) => {
                    'clientName':
                        "${client['firstName'] ?? ""} ${client['lastName'] ?? ""}",
                    'age': client['age'] ?? "",
                    'workoutPreference': client['workoutPreference'] ?? "",
                    'workoutLevel': client['workoutLevel'] ?? "",
                    'goal': client['goal'] ?? "",
                    'availability': client['availability'] ?? "",
                    'id': client['id'],
                    'weight': client['weight'] ?? "",
                    'height': client['height'] ?? "",
                    'notes': client['notes'] ?? "",
                    'gender': client['gender'] ?? "",
                  })
              .toList();
          isLoading = false;
        });
      } else {
        print(response.statusCode);
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      print(e);
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: const Color(0xFF004aad),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.people, color: Colors.white),
            const SizedBox(width: 10),
            Text('Coach ${context.watch<Coach>().fname} Clients',
                style: const TextStyle(color: Colors.white)),
          ],
        ),
        elevation: 0, // remove the shadow
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(0),
          ),
        ),
      ),
      backgroundColor: const Color.fromARGB(255, 248, 248, 248),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: fetchData,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: ListView.builder(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  physics: const BouncingScrollPhysics(),
                  itemCount: clientsData?.length ?? 0,
                  itemBuilder: (BuildContext context, int index) {
                    return _buildList(clientsData?[index], context);
                  },
                ),
              ),
            ),
    );
  }

  Widget _buildList(Map<String, dynamic>? data, BuildContext context) {
    if (data == null) {
      return const SizedBox.shrink();
    }
    String clientName = data['clientName'] ?? '';
    String workoutPreference = data['workoutPreference'] ?? '';
    String workoutLevel = data['workoutLevel'] ?? '';
    String goal = data['goal'] ?? '';
    String availability = data['availability'] ?? '';
    int age = data['age'] ?? '';
    String notes = data['notes'] ?? '';
    String gender = data['gender'] ?? '';
    int weight = data['weight'] ?? '';
    int height = data['height'] ?? '';
    double bmi = (weight / pow(height / 100, 2));
    String bmiResult = bmi.toStringAsFixed(1);
    String strValue = "3.14";
double doubleValue = double.parse(strValue);
String _getWeightStatus(double bmi) {
  if (bmi < 18.5) {
    return 'Underweight';
  } else if (bmi >= 18.5 && bmi < 25.0) {
    return 'Healthy Weight';
  } else if (bmi >= 25.0 && bmi < 30.0) {
    return 'Overweight';
  } else {
    return 'Obesity';
  }
}

    String initials = (clientName.isNotEmpty)
        ? clientName
            .trim()
            .split(' ')
            .map((name) => name[0])
            .take(2)
            .join()
            .toUpperCase()
        : '';

    return Card(
      elevation: 2.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 30.0,
              backgroundColor: const Color.fromARGB(255, 16, 63, 215),
              child: Text(
                initials,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 20.0,
                ),
              ),
            ),
            const SizedBox(width: 15.0),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    clientName,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16.0,
                    ),
                  ),
                  const SizedBox(height: 10.0),
                  RichText(
                    text: TextSpan(
                      style: const TextStyle(
                        fontSize: 13.0,
                        color: Colors.black87,
                      ),
                      children: [
                        const TextSpan(
                          text: 'Age: ',
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        TextSpan(
                          text: '$age',
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 5.0),
                  RichText(
                    text: TextSpan(
                      style: const TextStyle(
                        fontSize: 13.0,
                        color: Colors.black87,
                      ),
                      children: [
                        const TextSpan(
                          text: 'Weight: ',
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        TextSpan(
                          text: '$weight kg',
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 5.0),
                  RichText(
                    text: TextSpan(
                      style: const TextStyle(
                        fontSize: 13.0,
                        color: Colors.black87,
                      ),
                      children: [
                        const TextSpan(
                          text: 'Height: ',
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        TextSpan(
                          text: '$height cm',
                        ),
                      ],
                    ),
                  ),
              const SizedBox(height: 5.0),
RichText(
  text: TextSpan(
    style: const TextStyle(
      fontSize: 13.0,
      color: Colors.black87,
    ),
    children: [
      const TextSpan(
        text: 'Bmi: ',
        style: TextStyle(
          fontWeight: FontWeight.w500,
        ),
      ),
      TextSpan(
        text: '$bmiResult ',
      ),
    ],
  ),
),
const SizedBox(height: 5.0),
RichText(
  text: TextSpan(
    style: const TextStyle(
      fontSize: 13.0,
      color: Colors.black87,
    ),
    children: [
      const TextSpan(
        text: 'Weight Status: ',
        style: TextStyle(
          fontWeight: FontWeight.w500,
        ),
      ),
    TextSpan(
        text: '${_getWeightStatus(double.parse(bmiResult))}',
      ),
    ],
  ),
),              const SizedBox(height: 5.0),
                  RichText(
                    text: TextSpan(
                      style: const TextStyle(
                        fontSize: 13.0,
                        color: Colors.black87,
                      ),
                      children: [
                        const TextSpan(
                          text: 'Gender: ',
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        TextSpan(
                          text: '$gender',
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 5.0),
                  RichText(
                    text: TextSpan(
                      style: const TextStyle(
                        fontSize: 13.0,
                        color: Colors.black87,
                      ),
                      children: [
                        const TextSpan(
                          text: 'Workout Level: ',
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        TextSpan(
                          text: '$workoutLevel',
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 5.0),
                  RichText(
                    text: TextSpan(
                      style: const TextStyle(
                        fontSize: 13.0,
                        color: Colors.black87,
                      ),
                      children: [
                        const TextSpan(
                          text: 'Workout Preference: ',
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        TextSpan(
                          text: '$workoutPreference',
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 5.0),
                  RichText(
                    text: TextSpan(
                      style: const TextStyle(
                        fontSize: 13.0,
                        color: Colors.black87,
                      ),
                      children: [
                        const TextSpan(
                          text: 'Goal: ',
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        TextSpan(
                          text: '$goal',
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 5.0),
                  RichText(
                    text: TextSpan(
                      style: const TextStyle(
                        fontSize: 13.0,
                        color: Colors.black87,
                      ),
                      children: [
                        const TextSpan(
                          text: 'Workout Days: ',
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        TextSpan(
                          text: '$availability',
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 5.0),
                  RichText(
                    text: TextSpan(
                      style: const TextStyle(
                        fontSize: 13.0,
                        color: Colors.black87,
                      ),
                      children: [
                        const TextSpan(
                          text: 'Notes: ',
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        TextSpan(
                          text: '$notes',
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(
                        child: SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => SessionPage(
                                    id: data['id'],
                                  ),
                                ),
                              );
                            },
                            icon: const Icon(Icons.arrow_forward),
                            label: const Text(
                              'View Sessions',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xff004AAD),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              elevation: 0,
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SessionPage extends StatefulWidget {
  const SessionPage({super.key, required this.id});
  final int id;

  @override
  // ignore: library_private_types_in_public_api
  _SessionPageState createState() => _SessionPageState();
}

class _SessionPageState extends State<SessionPage> {
  List<Map<String, dynamic>>? sessionData;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    Provider.of<Client>(context, listen: false).setId(widget.id);
  }

  get data => null;

  Future<void> fetchSessionData() async {
    setState(() {
      _isLoading = true;
    });
    try {
      String token = Provider.of<Coach>(context, listen: false).token;
      print(widget.id);
      final response = await Dio().get(
        'https://sbit3j-service.onrender.com/v1/coach/sessions?clientId=${widget.id}',
        options: Options(headers: {
          'Authorization': 'Bearer $token',
        }),
      );
      if (response.statusCode == 200) {
        final sessions = List<Map<String, dynamic>>.from(response.data['data']);

        // ignore: use_build_context_synchronously
        setState(() {
          // assign the response data to sessionData
          sessionData = sessions;
          _isLoading = false;
        });
      } else {
        throw Exception('Failed to fetch data from API endpoint');
      }
    } catch (e) {
      throw Exception('Failed to fetch data from API endpoint: $e');
    }
  }

  Future<void> deleteSession(int sessionId) async {
    try {
      String token = Provider.of<Coach>(context, listen: false).token;
      final response = await Dio().delete(
        'https://sbit3j-service.onrender.com/v1/coach/sessions/$sessionId',
        options: Options(headers: {
          'Authorization': 'Bearer $token',
        }),
      );
      if (response.statusCode == 200) {
        // remove the session from the sessionData list
        setState(() {
          sessionData!.removeWhere((session) => session['id'] == sessionId);
        });
      } else {
        throw Exception('Failed to delete session');
      }
    } catch (e) {
      throw Exception('Failed to delete session: $e');
    }
  }

  @override
  void didChangeDependencies() {
    fetchSessionData();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: const Color(0xFF004aad),
        title: const Text(
          'Sessions',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: RefreshIndicator(
          onRefresh: fetchSessionData,
          child: _isLoading
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : ListView.builder(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  physics: const BouncingScrollPhysics(),
                  itemCount: sessionData!.length,
                  itemBuilder: (BuildContext context, int index) {
                    final session = sessionData![index];
                    return Card(
                      color: Colors.white,
                      margin: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 30),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                        side: BorderSide(color: Colors.grey.shade300),
                      ),
                      elevation: 2,
                      child: Padding(
                        padding: const EdgeInsets.all(25.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Session Title',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              session['title'],
                              style: TextStyle(
                                fontSize: 17,
                                color: Colors.grey[700],
                              ),
                            ),
                            const SizedBox(height: 24),
                            const Text(
                              'Session Description',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 14),
                            Text(
                              session['description'],
                              style: TextStyle(
                                fontSize: 17,
                                color: Colors.grey[700],
                              ),
                            ),
                            const SizedBox(height: 40),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Calories',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black87,
                                      ),
                                    ),
                                    const SizedBox(height: 5),
                                    Text(
                                      session['calories'].toString(),
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey[700],
                                      ),
                                    ),
                                  ],
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Proteins',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black87,
                                      ),
                                    ),
                                    const SizedBox(height: 5),
                                    Text(
                                      session['proteins'].toString(),
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey[700],
                                      ),
                                    ),
                                  ],
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Fats',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black87,
                                      ),
                                    ),
                                    const SizedBox(height: 5),
                                    Text(
                                      session['fats'].toString(),
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey[700],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(height: 24),
                            Row(
                              children: [
                                Expanded(
                                  child: SizedBox(
                                    width: double.infinity,
                                    child: ElevatedButton.icon(
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                CoachseeWorkoutlib(
                                                    id: session['id']),
                                          ),
                                        );
                                      },
                                      icon: const Icon(Icons.arrow_forward),
                                      label: const Text(
                                        'View Workouts',
                                        style: TextStyle(
                                          fontSize: 11,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor:
                                            const Color(0xff004AAD),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        elevation: 0,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 1),
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 8),
                                  child: ElevatedButton.icon(
                                    onPressed: () {
                                      showModalBottomSheet(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return ClientUpdateSession(
                                              id: session['id'],
                                              title: session['title'],
                                              description:
                                                  session['description'],
                                              calories: session['calories'],
                                              proteins: session['proteins'],
                                              fats: session['fats']);
                                        },
                                      );
                                    },
                                    icon: const Icon(Icons.edit),
                                    label: const Text(
                                      'Edit',
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all<Color>(
                                        const Color(0xFF004aad),
                                      ),
                                      shape: MaterialStateProperty.all<
                                          RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                      ),
                                      minimumSize:
                                          MaterialStateProperty.all<Size>(
                                        const Size(
                                          80,
                                          35,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 1),
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 0),
                                  child: ElevatedButton(
                                    onPressed: () {
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title: const Text('Delete Session'),
                                            content: const Text(
                                                'Are you sure you want to delete this session?'),
                                            actions: [
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.of(context).pop(
                                                      false); // user clicked No
                                                },
                                                child: const Text('No'),
                                              ),
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.of(context).pop(
                                                      true); // user clicked Yes
                                                },
                                                child: const Text('Yes'),
                                              ),
                                            ],
                                          );
                                        },
                                      ).then((confirmed) {
                                        if (confirmed == true) {
                                          deleteSession(session['id']);
                                          print(session['id']);
                                        }
                                      });
                                    },
                                    style: ElevatedButton.styleFrom(
                                      foregroundColor: Colors.white,
                                      backgroundColor:
                                          const Color.fromARGB(255, 197, 13, 0),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                    child: const Row(
                                      children: [
                                        Icon(Icons.delete),
                                        Text(
                                          "Delete",
                                          style: TextStyle(
                                            fontSize: 10,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        ),
                                        SizedBox(width: 2),
                                      ],
                                    ),
                                  ),
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                    );
                  },
                )),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddSessionPage()),
          );
        },
        backgroundColor: const Color(0xff004AAD),
        child: const Icon(Icons.add),
      ),
    );
  }
}

class ClientUpdateSession extends StatefulWidget {
  final int calories;
  final int proteins;
  final int fats;
  final int id;
  final String title;
  final String description;
  const ClientUpdateSession(
      {super.key,
      required this.id,
      required this.description,
      required this.calories,
      required this.proteins,
      required this.fats,
      required this.title});

  @override
  // ignore: library_private_types_in_public_api
  _ClientUpdateSessionState createState() => _ClientUpdateSessionState();
}

class _ClientUpdateSessionState extends State<ClientUpdateSession> {
  final _formKey = GlobalKey<FormState>();
  late String _calories;
  late String _proteins;
  late String _fats;
  late String _title;
  late String _description;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF004aad),
        title: Text(widget.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(13.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Session ID: ${widget.id}'),
              const SizedBox(height: 7.0),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Title',
                  prefixIcon: const Icon(Icons.title),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  labelStyle: TextStyle(fontSize: 13.0),
                ),
                initialValue: widget.title.toString(),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the proteins';
                  }
                  return null;
                },
                onChanged: (value) {
                  _title = value;
                },
              ),
              const SizedBox(height: 7.0),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Description',
                  prefixIcon: const Icon(Icons.description),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  labelStyle: TextStyle(fontSize: 13.0),
                ),
                initialValue: widget.description.toString(),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the proteins';
                  }
                  return null;
                },
                onChanged: (value) {
                  _description = value;
                },
              ),
              const SizedBox(height: 7.0),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Calories',
                  prefixIcon: const Icon(Icons.local_fire_department),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  labelStyle: TextStyle(fontSize: 13.0),
                ),
                initialValue: widget.proteins.toString(),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the calories';
                  }
                  return null;
                },
                onChanged: (value) {
                  _calories = value;
                },
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 7.0),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Proteins',
                  prefixIcon: const Icon(Icons.food_bank),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  labelStyle: TextStyle(fontSize: 13.0),
                ),
                initialValue: widget.calories.toString(),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the proteins';
                  }
                  return null;
                },
                onChanged: (value) {
                  _proteins = value;
                },
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 7.0),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Fats',
                  prefixIcon: const Icon(Icons.fastfood_outlined),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  labelStyle: TextStyle(fontSize: 13.0),
                ),
                initialValue: widget.fats.toString(),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the fats';
                  }
                  return null;
                },
                onChanged: (value) {
                  _fats = value;
                },
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 7.0),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    updateSession();
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF004aad),
                ),
                child: const Text(
                  'Save Changes',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void updateSession() async {
    try {
      String token = Provider.of<Coach>(context, listen: false).token;
      final dio = Dio();
      dio.options.headers['Authorization'] = 'Bearer $token';
      final response = await dio.put(
        'https://sbit3j-service.onrender.com/v1/coach/sessions/${widget.id}',
        data: {
          'calories': _calories,
          'proteins': _proteins,
          'fats': _fats,
          'description': _description,
          'title': _title,
        },
      );
      if (response.statusCode == 200) {
        Navigator.pop(context);
      } else {
        print('Failed to update workout. Status code: ${response.statusCode}');
      }
    } catch (error) {
      print('Failed to update workout. Error message: $error');
    }
  }
}

// Create Session
class AddSessionPage extends StatefulWidget {
  const AddSessionPage({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _AddSessionPageState createState() => _AddSessionPageState();
}

class _AddSessionPageState extends State<AddSessionPage> {
  final dio = Dio();
  bool isSessionCreated = false;

  TextEditingController coachIdController = TextEditingController();
  TextEditingController clientIdController = TextEditingController();
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController caloriesController = TextEditingController();
  TextEditingController proteinsController = TextEditingController();
  TextEditingController fatsController = TextEditingController();

  void sessioncreate(int coachId, int clientId, String title,
      String description, int calories, int proteins, int fats) async {
    setState(() {});
  }

  void _submitForm() async {
    // Check if any of the fields is empty
    if (coachIdController.text.isEmpty ||
        clientIdController.text.isEmpty ||
        titleController.text.isEmpty ||
        descriptionController.text.isEmpty ||
        caloriesController.text.isEmpty ||
        proteinsController.text.isEmpty ||
        fatsController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Please fill up all fields'),
          duration: const Duration(seconds: 1),
          action: SnackBarAction(
            label: 'OK',
            onPressed: () {},
          ),
        ),
      );
      return;
    }

    try {
      final formData = FormData.fromMap({
        'coachId': coachIdController.text,
        'clientId': clientIdController.text,
        'title': titleController.text,
        'description': descriptionController.text,
        'calories': caloriesController.text,
        'proteins': proteinsController.text,
        'fats': fatsController.text,
      });
      print(formData.fields);
      String token = Provider.of<Coach>(context, listen: false).token;
      final response = await dio.post(
        'https://sbit3j-service.onrender.com/v1/coach/sessions',
        data: formData,
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      if (response.statusCode == 201) {
        var data = response.data;

        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text("Session Created")));
        setState(() {
          isSessionCreated = true;
        });
      } else {}
    } catch (e) {
      // ignore: avoid_print
      print(e.toString());
    } finally {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Add Session'),
          backgroundColor: const Color(0xFF004aad),
          centerTitle: true,
          automaticallyImplyLeading: false,
        ),
        body: isSessionCreated
            ? const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.check_circle,
                      size: 100,
                      color: Colors.green,
                    ),
                    SizedBox(height: 20),
                    Text(
                      'Session Created',
                      style: TextStyle(
                        fontSize: 24.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              )
            : SingleChildScrollView(
                child: GestureDetector(
                  onTap: () {
                    setState(() {});
                  },
                  child: Container(
                    padding: const EdgeInsets.all(15.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const SizedBox(height: 0),
                        Image.asset(
                          'lib/images/logo.png',
                          height: 150.0,
                          width: 400.0,
                        ),
                        const SizedBox(height: 30),
                        Row(
                          children: [
                            Flexible(
                              child: TextField(
                                controller: coachIdController
                                  ..text = context.watch<Coach>().id.toString(),
                                enabled: false,
                                decoration: const InputDecoration(
                                  labelText: 'Coach ID',
                                  prefixIcon: Icon(Icons.person,
                                      color: Color(0xFF004aad)),
                                  labelStyle: TextStyle(fontSize: 23),
                                  border:
                                      InputBorder.none, // remove the underline
                                ),
                                style: const TextStyle(
                                  fontSize: 20,
                                  color: Colors.black,
                                ),
                                onChanged: (value) {},
                              ),
                            ),
                            const SizedBox(
                                width:
                                    50), // add some spacing between the text fields
                            Flexible(
                              child: TextField(
                                controller: clientIdController
                                  ..text =
                                      context.watch<Client>().id.toString(),
                                decoration: const InputDecoration(
                                  labelText: 'Client ID',
                                  enabled: false,
                                  prefixIcon: Icon(Icons.person,
                                      color: Color(0xFF004aad)),
                                  labelStyle: TextStyle(fontSize: 23),
                                  border:
                                      InputBorder.none, // remove the underline
                                ),
                                style: const TextStyle(
                                  fontSize: 20,
                                  color: Colors.black,
                                ),
                                keyboardType: TextInputType.number,
                                onChanged: (value) {},
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        TextField(
                          controller: titleController,
                          decoration: InputDecoration(
                            labelText: 'Session Title',
                            prefixIcon: const Icon(Icons.title,
                                color: Color(0xFF004aad)),
                            labelStyle: const TextStyle(fontSize: 18),
                            filled: true,
                            fillColor: Colors.grey[200],
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide: BorderSide.none,
                            ),
                          ),
                          style: const TextStyle(
                              fontSize: 20, color: Colors.black),
                          onChanged: (value) {},
                        ),
                        const SizedBox(height: 20),
                        TextField(
                          controller: descriptionController,
                          decoration: InputDecoration(
                            labelText: 'Session Description',
                            prefixIcon: const Icon(Icons.description,
                                color: Color(0xFF004aad)),
                            labelStyle: const TextStyle(fontSize: 18),
                            filled: true,
                            fillColor: Colors.grey[200],
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide: BorderSide.none,
                            ),
                          ),
                          style: const TextStyle(
                              fontSize: 20, color: Colors.black),
                          onChanged: (value) {},
                        ),
                        const SizedBox(height: 20),
                        TextField(
                          controller: caloriesController,
                          decoration: InputDecoration(
                            labelText: 'Calories',
                            prefixIcon: const Icon(Icons.local_fire_department,
                                color: Color(0xFF004aad)),
                            labelStyle: const TextStyle(fontSize: 18),
                            filled: true,
                            fillColor: Colors.grey[200],
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide: BorderSide.none,
                            ),
                          ),
                          style: const TextStyle(
                              fontSize: 20, color: Colors.black),
                          keyboardType: TextInputType.number,
                          onChanged: (value) {},
                        ),
                        const SizedBox(height: 20),
                        TextField(
                          controller: proteinsController,
                          decoration: InputDecoration(
                            labelText: 'Protein',
                            prefixIcon: const Icon(Icons.food_bank,
                                color: Color(0xFF004aad)),
                            labelStyle: const TextStyle(fontSize: 18),
                            filled: true,
                            fillColor: Colors.grey[200],
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide: BorderSide.none,
                            ),
                          ),
                          style: const TextStyle(
                              fontSize: 20, color: Colors.black),
                          keyboardType: TextInputType.number,
                          onChanged: (value) {},
                        ),
                        const SizedBox(height: 20),
                        TextField(
                          controller: fatsController,
                          decoration: InputDecoration(
                            labelText: 'Fats',
                            prefixIcon: const Icon(Icons.fastfood,
                                color: Color(0xFF004aad)),
                            labelStyle: const TextStyle(fontSize: 18),
                            filled: true,
                            fillColor: Colors.grey[200],
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide: BorderSide.none,
                            ),
                          ),
                          style: const TextStyle(
                              fontSize: 20, color: Colors.black),
                          keyboardType: TextInputType.number,
                          onChanged: (value) {},
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: () {
                            _submitForm();
                            isSessionCreated = true;
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xff004AAD),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 32, vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            textStyle: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          child: const Text('Create Session'),
                        ),
                      ],
                    ),
                  ),
                ),
              ));
  }
}

class CoachseeWorkoutlib extends StatefulWidget {
  const CoachseeWorkoutlib({Key? key, required this.id}) : super(key: key);
  final int id;

  @override
  State<CoachseeWorkoutlib> createState() => _CoachseeWorkoutlibState();
}

class _CoachseeWorkoutlibState extends State<CoachseeWorkoutlib> {
  List<Map<String, dynamic>>? workoutsData;

  @override
  void initState() {
    super.initState();
    Provider.of<Session>(context, listen: false).setId(widget.id);
    fetchWorkoutsData(); // fetch data when the widget is first initialized
  }

  Future<void> fetchWorkoutsData() async {
    try {
      String token = Provider.of<Coach>(context, listen: false).token;
      final response = await Dio().get(
        'https://sbit3j-service.onrender.com/v1/coach/sessions/${widget.id}',
        options: Options(headers: {
          'Authorization': 'Bearer $token',
        }),
      );
      if (response.statusCode == 200) {
        final sessions =
            List<Map<String, dynamic>>.from(response.data['data']['workouts']);
        setState(() {
          workoutsData = sessions;
        });
      } else {
        throw Exception('Failed to fetch data from API endpoint');
      }
    } catch (e) {
      throw Exception('Failed to fetch data from API endpoint: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: const Color(0xFF004aad),
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Workouts',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: fetchWorkoutsData,
        child: workoutsData == null
            ? const Center(child: CircularProgressIndicator())
            : ListView.builder(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                physics: const BouncingScrollPhysics(),
                itemCount: workoutsData!.length,
                itemBuilder: (context, index) {
                  final workout = workoutsData![index];
                  final workoutId = workout['id'];
                  final workoutname = workout['title'];
                  final reps = workout['reps'];
                  final sets = workout['sets'];
                  final time = workout['time'];
                  final isDone = workout['isDone'];
                  return Card(
                    color: Colors.white,
                    margin:
                        const EdgeInsets.symmetric(vertical: 5, horizontal: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(color: Colors.grey.shade300),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (isDone == true)
                            const Icon(Icons.check, color: Colors.green)
                          else
                            const SizedBox.shrink(),
                          Image.network(
                            workout['imageUrl'] ?? '',
                            height: 100,
                            width: 65,
                          ),
                          const SizedBox(width: 5),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  workout['title'] ?? '',
                                  style: const TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  workout['description'] ?? '',
                                  style: const TextStyle(
                                    fontSize: 15,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Row(
                                  children: [
                                    const SizedBox(width: 0),
                                    Expanded(
                                      child: Text(
                                        'Reps: ${workout['reps'] ?? ''}',
                                        style: const TextStyle(
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 0),
                                    Expanded(
                                      child: Text(
                                        'Sets: ${workout['set'] ?? ''}',
                                        style: const TextStyle(
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 0),
                                    Expanded(
                                      child: Text(
                                        'Rest: ${workout['time'] ?? ''}s',
                                        style: const TextStyle(
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),
                                    ElevatedButton(
                                      onPressed: () {
                                        showModalBottomSheet(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return ClientUpdateWorkout(
                                              workoutId: workoutId,
                                              workoutname: workoutname,
                                            );
                                          },
                                        );
                                      },
                                      style: ButtonStyle(
                                        backgroundColor:
                                            MaterialStateProperty.all<Color>(
                                                const Color(0xFF004aad)),
                                        shape: MaterialStateProperty.all<
                                            RoundedRectangleBorder>(
                                          RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                          ),
                                        ),
                                        minimumSize:
                                            MaterialStateProperty.all<Size>(
                                          const Size(15,
                                              30), // Set the desired width and height values here
                                        ),
                                      ),
                                      child: const Text(
                                        'Edit',
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    )
                                  ],
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const CoachClientWorkout()),
          );
        },
        backgroundColor: const Color(0xff004AAD),
        child: const Icon(Icons.add),
      ),
    );
  }
}

class ClientUpdateWorkout extends StatefulWidget {
  final int workoutId;
  final String workoutname;

  const ClientUpdateWorkout(
      {super.key, required this.workoutId, required this.workoutname});

  @override
  // ignore: library_private_types_in_public_api
  _ClientUpdateWorkoutState createState() => _ClientUpdateWorkoutState();
}

class _ClientUpdateWorkoutState extends State<ClientUpdateWorkout> {
  final _formKey = GlobalKey<FormState>();
  late String _reps;
  late String _sets;
  late String _time;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF004aad),
        title: Text('${widget.workoutname}'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Workout ID: ${widget.workoutId}'),
              const SizedBox(height: 16.0),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Reps',
                  prefixIcon: const Icon(Icons.repeat),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the reps';
                  }
                  return null;
                },
                onChanged: (value) {
                  _reps = value;
                },
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Sets',
                  prefixIcon: const Icon(Icons.fitness_center_outlined),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                maxLines: null,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the sets';
                  }
                  return null;
                },
                onChanged: (value) {
                  _sets = value;
                },
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Time',
                  prefixIcon: const Icon(Icons.timer),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                maxLines: null,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the time';
                  }
                  return null;
                },
                onChanged: (value) {
                  _time = value;
                },
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    updateWorkout();
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF004aad),
                ),
                child: const Text(
                  'Save Changes',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void updateWorkout() async {
    try {
      String token = Provider.of<Coach>(context, listen: false).token;
      final dio = Dio();
      dio.options.headers['Authorization'] = 'Bearer $token';
      final response = await dio.put(
        'https://sbit3j-service.onrender.com/v1/coach/session-workouts/${widget.workoutId}',
        data: {
          'reps': _reps,
          'sets': _sets,
          'time': _time,
        },
      );
      if (response.statusCode == 200) {
        Navigator.pop(context);
      } else {
        print('Failed to update workout. Status code: ${response.statusCode}');
      }
    } catch (error) {
      print('Failed to update workout. Error message: $error');
    }
  }
}

//ADD WORKOUT

class CoachClientWorkout extends StatefulWidget {
  const CoachClientWorkout({Key? key}) : super(key: key);

  @override
  State<CoachClientWorkout> createState() => _CoachClientWorkoutState();
}

class _CoachClientWorkoutState extends State<CoachClientWorkout> {
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
          currentPage++;
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
                            width: 24,
                            height: 24,
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
                  : const Text('Workouts Library'),
            ],
          ),
          backgroundColor: const Color(0xFF004aad),
          actions: [
            IconButton(
              icon: const Icon(Icons.search,
                  color: Color.fromARGB(255, 255, 255, 255)),
              onPressed: () {
                setState(() {
                  isSearchBarVisible = !isSearchBarVisible;
                });
              },
            ),
          ],
        ),
        backgroundColor: const Color(0xFFE5E5E5),
        body: Container(
          color: Colors.white,
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
                          // ignore: unused_local_variable
                          final workoutId =
                              jsonList?[index]['id'].toString() ?? '';
                          // ignore: unused_local_variable
                          final workoutName = jsonList?[index]['title'] ?? '';
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
                                  child: Container(
                                    child: Image.network(
                                      jsonList?[index]['imageUrl'] ?? '',
                                      width: 120,
                                      height: 120,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                title: Text(
                                  jsonList?[index]['title'] ?? '',
                                  style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Montserrat',
                                  ),
                                ),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(height: 4),
                                    Text(
                                      (jsonList?[index]['description'] ?? ''),
                                      maxLines: 12,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey,
                                        fontFamily:
                                            'Montserrat', // Use a custom font
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                  ],
                                ),
                                trailing: GestureDetector(
                                  child: const Icon(
                                    Icons.add,
                                    color: Color(0xff004AAD),
                                  ),
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => AddWorkout(
                                          //  workoutId: workoutId,
                                          title:
                                              jsonList?[index]['title'] ?? '',
                                          imageUrl: jsonList?[index]
                                                  ['imageUrl'] ??
                                              '',
                                          description: jsonList?[index]
                                                  ['description'] ??
                                              '',
                                          youtubeUrl: jsonList?[index]
                                                  ['youtubeUrl'] ??
                                              '',
                                        ),
                                      ),
                                    );
                                  },
                                ),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => WorkoutDetailsPage(
                                        title: jsonList?[index]['title'] ?? '',
                                        workoutId: jsonList?[index]['id'] ?? '',
                                        imageUrl:
                                            jsonList?[index]['imageUrl'] ?? '',
                                        description: jsonList?[index]
                                                ['description'] ??
                                            '',
                                        youtubeUrl: jsonList?[index]
                                                ['youtubeUrl'] ??
                                            '',
                                        muscleGroups: '',
                                        reps: jsonList?[index]['reps']
                                                ?.toString() ??
                                            '0',
                                        sets: jsonList?[index]['set']
                                                ?.toString() ??
                                            '0',
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          );
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

class AddWorkout extends StatefulWidget {
//  final String workoutId;
  final String title;
  final String imageUrl;
  final String description;
  final String youtubeUrl;

  const AddWorkout({
    Key? key,
    //  required this.workoutId,
    required this.title,
    required this.imageUrl,
    required this.description,
    required this.youtubeUrl,
  }) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _AddWorkoutState createState() => _AddWorkoutState();
}

class _AddWorkoutState extends State<AddWorkout> {
  final dio = Dio();
  bool isWorkoutCreated = false;

  TextEditingController sessionIdController = TextEditingController();
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController repsController = TextEditingController();
  TextEditingController setsController = TextEditingController();
  TextEditingController timeController = TextEditingController();
  TextEditingController imageUrlController = TextEditingController();
  TextEditingController youtubeUrlController = TextEditingController();

  void workoutcreate(int sessionId, String title, String description, int reps,
      int sets, int time, String imageUrl, String youtubeUrl) async {
    setState(() {});
  }

  void _submitForm() async {
    // Check if any of the fields is empty
    if (sessionIdController.text.isEmpty ||
        titleController.text.isEmpty ||
        descriptionController.text.isEmpty ||
        repsController.text.isEmpty ||
        setsController.text.isEmpty ||
        timeController.text.isEmpty ||
        imageUrlController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Please fill up all fields'),
          duration: const Duration(seconds: 1),
          action: SnackBarAction(
            label: 'OK',
            onPressed: () {},
          ),
        ),
      );
      return;
    }

    try {
      final formData = FormData.fromMap({
        'sessionId': sessionIdController.text,
        'title': titleController.text,
        'description': descriptionController.text,
        'reps': repsController.text,
        'sets': setsController.text,
        'time': timeController.text,
        'imageUrl': imageUrlController.text,
        'youtubeUrl': youtubeUrlController.text,
      });
      print(formData.fields);
      String token = Provider.of<Coach>(context, listen: false).token;
      final response = await dio.post(
        'https://sbit3j-service.onrender.com/v1/coach/session-workouts',
        data: formData,
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      if (response.statusCode == 201) {
        var data = response.data;

        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Workout Created Successfully")));
        setState(() {
          isWorkoutCreated = true;
        });
      } else {}
    } catch (e) {
      // ignore: avoid_print
      print(e.toString());
    } finally {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Create Workout'),
          centerTitle: true,
          backgroundColor: const Color(0xFF004aad),
          automaticallyImplyLeading: false,
        ),
        body: isWorkoutCreated
            ? const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.check_circle,
                      size: 100,
                      color: Colors.green,
                    ),
                    SizedBox(height: 20),
                    Text(
                      'Workout Created',
                      style: TextStyle(
                        fontSize: 24.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              )
            : SizedBox(
                height: MediaQuery.of(context).size.height,
                child: Column(children: [
                  Expanded(
                      child: SingleChildScrollView(
                          child: GestureDetector(
                    onTap: () {
                      setState(() {});
                    },
                    child: Container(
                      padding: const EdgeInsets.all(13.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const SizedBox(height: 20),

                          // logo
                          Image.network(
                            widget.imageUrl,
                            height: 200.0,
                            width: 1000.0,
                          ),

                          const SizedBox(height: 30),
                          Center(
                            child: SizedBox(
                              width: 400,
                              child: TextField(
                                controller: titleController
                                  ..text = widget.title,
                                decoration: const InputDecoration(
                                  enabled: false,
                                  border: InputBorder.none,
                                  labelText: 'Workout Title',
                                  prefixIcon: Icon(Icons.title,
                                      color: Color(0xFF004aad)),
                                  labelStyle: TextStyle(fontSize: 18),
                                ),
                                style: const TextStyle(
                                    fontSize: 18, color: Colors.black),
                                onChanged: (value) {},
                              ),
                            ),
                          ),
                          const SizedBox(height: 0),
                          TextField(
                            controller: descriptionController
                              ..text = widget.description,
                            decoration: const InputDecoration(
                              enabled: false,
                              border: InputBorder.none,
                              labelText: 'Workout Description',
                              prefixIcon: Icon(
                                Icons.description,
                                color: Color(0xFF004aad),
                              ),
                              labelStyle: TextStyle(
                                fontSize: 18,
                              ),
                            ),
                            style: const TextStyle(
                              fontSize: 15,
                              color: Colors.black,
                            ),
                            onChanged: (value) {},
                          ),
                          const SizedBox(height: 0),
                          TextField(
                            controller: imageUrlController
                              ..text = widget.imageUrl,
                            decoration: const InputDecoration(
                              enabled: false,
                              border: InputBorder.none,
                              labelText: 'Image Url',
                              prefixIcon: Icon(
                                Icons.image_outlined,
                                color: Color(0xFF004aad),
                              ),
                              labelStyle: TextStyle(
                                fontSize: 18,
                              ),
                            ),
                            style: const TextStyle(
                              fontSize: 15,
                              color: Colors.black,
                            ),
                            onChanged: (value) {},
                          ),
                          const SizedBox(height: 0),
                          TextField(
                            controller: youtubeUrlController
                              ..text = widget.youtubeUrl,
                            decoration: const InputDecoration(
                              enabled: false,
                              border: InputBorder.none,
                              labelText: 'Youtube Url',
                              prefixIcon: Icon(
                                Icons.personal_video,
                                color: Color(0xFF004aad),
                              ),
                              labelStyle: TextStyle(
                                fontSize: 15,
                              ),
                            ),
                            style: const TextStyle(
                              fontSize: 15,
                              color: Colors.black,
                            ),
                            onChanged: (value) {},
                          ),
                          const SizedBox(height: 0),
                          TextField(
                            controller: sessionIdController
                              ..text = context.watch<Session>().id.toString(),
                            decoration: const InputDecoration(
                              enabled: false,
                              border: InputBorder.none,
                              labelText: 'Session ID',
                              prefixIcon: Icon(Icons.calendar_today,
                                  color: Color(0xFF004aad)),
                              labelStyle: TextStyle(fontSize: 18),
                            ),
                            style: const TextStyle(
                                fontSize: 15, color: Colors.black),
                            onChanged: (value) {},
                          ),
                          const SizedBox(height: 30),
                          Row(
                            children: [
                              const SizedBox(height: 0),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0),
                                  child: TextField(
                                    controller: repsController,
                                    decoration: InputDecoration(
                                      labelText: 'Reps',
                                      prefixIcon: const Icon(Icons.repeat,
                                          color: Color(0xFF004aad)),
                                      labelStyle: const TextStyle(fontSize: 13),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: const BorderSide(
                                            color: Color(0xFF004aad)),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: const BorderSide(
                                            color: Color(0xFF004aad), width: 2),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                    style: const TextStyle(
                                        fontSize: 20, color: Colors.black),
                                    keyboardType: TextInputType.number,
                                    onChanged: (value) {},
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0),
                                  child: TextField(
                                    controller: setsController,
                                    decoration: InputDecoration(
                                      labelText: 'Sets',
                                      prefixIcon: const Icon(
                                          Icons.fitness_center,
                                          color: Color(0xFF004aad)),
                                      labelStyle: const TextStyle(fontSize: 13),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: const BorderSide(
                                            color: Color(0xFF004aad)),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: const BorderSide(
                                            color: Color(0xFF004aad), width: 2),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                    style: const TextStyle(
                                        fontSize: 20, color: Colors.black),
                                    keyboardType: TextInputType.number,
                                    onChanged: (value) {},
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0),
                                  child: TextField(
                                    controller: timeController,
                                    decoration: InputDecoration(
                                      labelText: 'Time',
                                      prefixIcon: const Icon(Icons.lock_clock,
                                          color: Color(0xFF004aad)),
                                      labelStyle: const TextStyle(fontSize: 13),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: const BorderSide(
                                            color: Color(0xFF004aad)),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: const BorderSide(
                                            color: Color(0xFF004aad), width: 2),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                    style: const TextStyle(
                                        fontSize: 20, color: Colors.black),
                                    keyboardType: TextInputType.number,
                                    onChanged: (value) {},
                                  ),
                                ),
                              ),
                              const SizedBox(height: 20),
                            ],
                          ),

                          const SizedBox(height: 20),
                          ElevatedButton(
                            onPressed: () {
                              _submitForm();
                              isWorkoutCreated = true;
                            },
                            style: ElevatedButton.styleFrom(
                              primary: const Color(0xff004AAD),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 32, vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              elevation: 2.0,
                            ),
                            child: const Text(
                              'Add Selected Workout',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )))
                ]),
              ));
  }
}
