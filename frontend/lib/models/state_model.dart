import 'package:flutter/foundation.dart';
import 'package:frontend/models/user_model.dart';
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

  void getUser(Function(bool isFinished) loading_callback) async {
    try {
      QueryResult result = await _client.query(
        QueryOptions(
          document: gql("""
             query User(\$username: String) {
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
                }
              }
            """),
          variables: {"username": _username},
          fetchPolicy: FetchPolicy.noCache,
        ),
      );
      if (result.hasException) {
        throw (Exception(result.exception));
      }
      if (kDebugMode) {
        print(result.data!);
      }
      user = User.fromJson(result.data!['user']);
      if (kDebugMode) {
        print(user);
      }
      loading_callback(false);
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }
}
