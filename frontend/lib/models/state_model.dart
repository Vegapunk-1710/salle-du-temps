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

  void getUser(Function(bool isFinished) loadingCallback) async {
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
      loadingCallback(false);
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
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
    // if (kDebugMode) {
    //   print(result.data!);
    // }
    return result.data!;
  }
}
