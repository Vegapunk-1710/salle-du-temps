import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:frontend/models/user_model.dart';
import 'package:frontend/models/workout_model.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class AppState {
  final HttpLink _endpoint = HttpLink(
    'http://192.168.2.159:4000/',
  );
  late final GraphQLClient _client;
  String _username = "";
  String _password = "";
  late User user;

  AppState(String username, String password) {
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
    } catch (e) {
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
}
