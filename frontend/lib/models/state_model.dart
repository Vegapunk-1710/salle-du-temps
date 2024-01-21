import 'package:flutter/foundation.dart';
import 'package:frontend/models/exercise_model.dart';
import 'package:frontend/models/user_model.dart';
import 'package:frontend/models/workout_model.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class AppState {
  final HttpLink _endpoint = HttpLink(
    'https://salle-du-temps.up.railway.app/',
  );
  late final GraphQLClient _client;
  String _username = "";
  String _password = "";

  late User user;
  String todayWorkoutId = "";

  List<String> daysOfWeek = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday'
  ];
  late DateTime now;
  late String dayName;

  AppState(String username, String password) {
    now = DateTime.now();
    dayName = daysOfWeek[now.weekday - 1];
    _username = username;
    _password = password;
    _client = GraphQLClient(link: _endpoint, cache: GraphQLCache());
  }

  Future<bool> getUser() async {
    try {
      Map<String, dynamic> result = await query("""
        query Query(\$username: String) {
            user(username: \$username) {
              id
              username
              password
              name
              dob
              createdAt
              updatedAt
              startingWeight
              height
              workouts {
                id
                imageURL
                createdBy
                createdAt
                title
                difficulty
                time
                description
              }
            }
          }
        """, {"username": _username});
      user = User.fromJson(result['user']);
      Map<String, dynamic> result2 = await query("""
        query Query(\$userId: String, \$day: String) {
          todayWorkout(userId: \$userId, day: \$day) {
            id
          }
        }
        """, {"userId": user.id, "day": dayName});
      todayWorkoutId = await result2['todayWorkout']['id'];
      return false;
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return true;
    }
  }

  Future<Workout?> createWorkout(Map<String, dynamic> data) async {
    try {
      data['createdBy'] = user.id;
      Map<String, dynamic> result = await query("""
        mutation Mutation(\$workout: CreateWorkoutInput!) {
          createWorkout(workout: \$workout) {
            id
            imageURL
            createdBy
            createdAt
            title
            difficulty
            time
            description
          }
        }
        """, {"workout": data});
      Workout workout = Workout.fromJson(result['createWorkout']);
      return workout;
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
    return null;
  }

  Future<List<Workout>> getWorkouts() async {
    try {
      Map<String, dynamic> result = await query("""
        query Query {
          workouts {
            id
            imageURL
            createdBy
            createdAt
            title
            difficulty
            time
            description
          }
        }
        """, {});
      List<Workout> workouts = await result['workouts']
          .map<Workout>((w) => Workout.fromJson(w))
          .toList();
      return workouts;
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return [];
    }
  }

  Future<List<Workout>> searchWorkouts(String searchQuery) async {
    try {
      Map<String, dynamic> result = await query("""
        query Query(\$query: String) {
          searchWorkouts(query: \$query) {
            id
            imageURL
            createdBy
            createdAt
            title
            difficulty
            time
            description
          }
        }
        """, {"query": searchQuery});
      List<Workout> workouts = await result['searchWorkouts']
          .map<Workout>((w) => Workout.fromJson(w))
          .toList();
      return workouts;
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return [];
    }
  }

  void addWorkout(String workoutId) async {
    try {
      Map<String, dynamic> result = await query("""
        mutation AddWorkout(\$userId: String, \$workoutId: String) {
          addWorkout(userId: \$userId, workoutId: \$workoutId) 
        }
        """, {"userId": user.id, "workoutId": workoutId});
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  Future<void> deleteWorkout(String workoutId) async {
    try {
      Map<String, dynamic> result = await query("""
        mutation DeleteWorkout(\$userId: String, \$workoutId: String) {
          deleteWorkout(userId: \$userId, workoutId: \$workoutId)
        }
        """, {"userId": user.id, "workoutId": workoutId});
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  void deleteWorkoutForAll(String workoutId) async {
    try {
      Map<String, dynamic> result = await query("""
        mutation DeleteWorkout(\$userId: String, \$workoutId: String) {
          deleteWorkoutForAll(userId: \$userId, workoutId: \$workoutId)
        }
        """, {"userId": user.id, "workoutId": workoutId});
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  void addDays(String workoutId, List<String> days) async {
    try {
      Map<String, dynamic> result = await query("""
        mutation Mutation(\$userId: String, \$workoutId: String, \$days: [String]) {
          updateDays(userId: \$userId, workoutId: \$workoutId, days: \$days) {
            days
          }
        }
        """, {"userId": user.id, "workoutId": workoutId, "days": days});
      if (days.contains(dayName)) {
        todayWorkoutId = workoutId;
      }
      if (workoutId == todayWorkoutId) {
        if (!days.contains(dayName)) {
          todayWorkoutId = "";
          user.workouts.forEach((workout) {
            if (workout.days.contains(Workout.translateStringToDay(dayName))) {
              todayWorkoutId = workout.id;
            }
          });
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  Future<List<String>> getDays(String workoutId) async {
    try {
      Map<String, dynamic> result = await query("""
        query Query(\$userId: String, \$workoutId: String) {
          days(userId: \$userId, workoutId: \$workoutId) {
            days
          }
        }
        """, {"userId": user.id, "workoutId": workoutId});
      List<String> returnedDays = await result['days']['days']
          .map<String>((day) => day.toString())
          .toList();
      if (todayWorkoutId == "") {
        if (returnedDays.contains(dayName)) {
          todayWorkoutId = workoutId;
        }
      }
      return returnedDays;
    } catch (e) {
      return [];
    }
  }

  Future<void> deleteDays(String workoutId) async {
    try {
      Map<String, dynamic> result = await query("""
        mutation Mutation(\$userId: String, \$workoutId: String) {
          deleteDays(userId: \$userId, workoutId: \$workoutId)
        }
        """, {"userId": user.id, "workoutId": workoutId});
      if (todayWorkoutId == workoutId) {
        todayWorkoutId = "";
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  Future<List<Exercise>> getExercises() async {
    try {
      Map<String, dynamic> result = await query("""
        query Query {
          exercises {
            id
            imageURL
            createdBy
            createdAt
            title
            difficulty
            time
            type
            tutorial
            setsreps
          }
        }
        """, {});
      List<Exercise> exercises = await result['exercises']
          .map<Exercise>((e) => Exercise.fromJson(e))
          .toList();
      return exercises;
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return [];
    }
  }

  Future<List<Exercise>> searchExercises(String searchQuery) async {
    try {
      Map<String, dynamic> result = await query("""
        query SearchExercises(\$query: String) {
          searchExercises(query: \$query) {
            id
            imageURL
            createdBy
            createdAt
            title
            difficulty
            time
            type
            tutorial
            setsreps
          }
        }
        """, {"query": searchQuery});
      List<Exercise> exercises = await result['searchExercises']
          .map<Exercise>((e) => Exercise.fromJson(e))
          .toList();
      return exercises;
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return [];
    }
  }

  Future<List<Exercise>> getWorkoutExercises(String workoutId) async {
    try {
      Map<String, dynamic> result = await query("""
       query Query(\$workoutId: String) {
        workoutExercises(workoutId: \$workoutId) {
          id
          imageURL
          createdBy
          createdAt
          title
          difficulty
          time
          type
          tutorial
          setsreps
        }
      }
        """, {"workoutId": workoutId});
      List<Exercise> exercises = await result['workoutExercises']
          .map<Exercise>((e) => Exercise.fromJson(e))
          .toList();
      return exercises;
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return [];
    }
  }

  Future<void> addExercise(String exerciseId, String workoutId) async {
    try {
      Map<String, dynamic> result = await query("""
       mutation Mutation(\$workoutId: String, \$exerciseId: String) {
          addExercise(workoutId: \$workoutId, exerciseId: \$exerciseId)
        }
        """, {"workoutId": workoutId, "exerciseId": exerciseId});
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  Future<void> updateOrder(
      String exerciseId, String workoutId, int order) async {
    try {
      Map<String, dynamic> result = await query("""
       mutation Mutation(\$workoutId: String, \$exerciseId: String, \$order: Int) {
        updateOrder(workoutId: \$workoutId, exerciseId: \$exerciseId, order: \$order)
      }
        """,
          {"workoutId": workoutId, "exerciseId": exerciseId, "order": order});
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  Future<Exercise?> createExercise(Map<String, dynamic> data) async {
    try {
      data['createdBy'] = user.id;
      Map<String, dynamic> result = await query("""
        mutation Mutation(\$exercise: CreateExerciseInput!) {
        createExercise(exercise: \$exercise) {
          id
          imageURL
          createdBy
          createdAt
          title
          difficulty
          time
          type
          tutorial
          setsreps
        }
      }
        """, {"exercise": data});
      Exercise exercise = Exercise.fromJson(result['createExercise']);
      return exercise;
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return null;
    }
  }

  Future<void> deleteExercise(String workoutId, String exerciseId) async {
    try {
      Map<String, dynamic> result = await query("""
        mutation Mutation(\$workoutId: String, \$exerciseId: String) {
          deleteExercise(workoutId: \$workoutId, exerciseId: \$exerciseId)
        }
        """, {"workoutId": workoutId, "exerciseId": exerciseId});
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  void deleteExerciseForAll(String workoutId, String exerciseId) async {
    try {
      Map<String, dynamic> result = await query("""
        mutation Mutation(\$userId: String, \$workoutId: String, \$exerciseId: String) {
          deleteExerciseForAll(userId: \$userId, workoutId: \$workoutId, exerciseId: \$exerciseId)
        }
        """, {
        "userId": user.id,
        "workoutId": workoutId,
        "exerciseId": exerciseId
      });
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  Future<List<(DateTime, String)>> getWorkoutProgression(
      String workoutId) async {
    try {
      Map<String, dynamic> result = await query("""
        query WorkoutProgression(\$userId: String, \$workoutId: String) {
          workoutProgression(userId: \$userId, workoutId: \$workoutId) {
            date
            time
          }
        }
        """, {
        "userId": user.id,
        "workoutId": workoutId,
      });
      List<(DateTime, String)> progression = await result['workoutProgression'].map<(DateTime, String)>((e) => (DateTime.parse(e["date"]),e["time"].toString()))
          .toList();
      return progression;
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return [];
    }
  }

  addWorkoutProgression(String workoutId, String date, String time) async {
    try{
        Map<String, dynamic> result = await query("""
            mutation Mutation(\$userId: String, \$workoutId: String, \$date: String, \$time: String) {
              addWorkoutProgression(userId: \$userId, workoutId: \$workoutId, date: \$date, time: \$time)
            }
            """, {
      "userId": user.id,
      "workoutId": workoutId,
      "date": date,
      "time": time,
    });
    } catch(e){
       if (kDebugMode) {
        print(e);
      }
    }
  }

  deleteWorkoutProgression(String workoutId, String date, String time) async {
    try{
       Map<String, dynamic> result = await query("""
       mutation Mutation(\$userId: String, \$workoutId: String, \$time: String, \$date: String) {
          deleteWorkoutProgresssion(userId: \$userId, workoutId: \$workoutId, time: \$time, date: \$date)
        }
        """, {
      "userId": user.id,
      "workoutId": workoutId,
      "date": date,
      "time": time,
    });
    } catch(e){
       if (kDebugMode) {
        print(e);
      }
    }
  }

  Future<Map<String, dynamic>> query(
      String query, Map<String, dynamic> variables) async {
    QueryResult result = await _client.query(
      QueryOptions(
        document: gql(query),
        variables: variables,
        fetchPolicy: FetchPolicy.noCache,
      ),
    );
    if (result.hasException) {
      throw (Exception(result.exception));
    }
    return result.data!;
  }

  Workout? getTodaysWorkout() {
    if (user.workouts.isNotEmpty) {
      for (int i = 0; i < user.workouts.length; i++) {
        if (user.workouts[i].id == todayWorkoutId) {
          return user.workouts[i];
        }
      }
    } else {
      return null;
    }
    return null;
  }

}
