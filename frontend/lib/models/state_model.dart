import 'package:flutter/foundation.dart';
import 'package:frontend/models/user_model.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class AppState {
  static final HttpLink httpLink = HttpLink(
    'http://192.168.2.159:4000/',
  );
  static GraphQLClient clientToQuery() =>
      GraphQLClient(link: httpLink, cache: GraphQLCache());
  static final GraphQLClient client = clientToQuery();

  static late User user;

  static void getUser({required String username}) async {
    try {
      QueryResult result = await client.query(
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
                    days
                    progression {
                      id
                      date
                      time
                    }
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
                      progression {
                        id
                        date
                        weight
                        sets
                        reps
                      }
                    }
                  }
                }
              }
            """),
          variables: {"username": username},
          fetchPolicy: FetchPolicy.noCache,
        ),
      );
      if (result.hasException) {
        throw (Exception(result.exception));
      }
      if (kDebugMode) {
        print(result.data!['user']);
      }
      var user = User.fromJson(result.data!['user']);
      if (kDebugMode) {
        print(user);
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }
}
