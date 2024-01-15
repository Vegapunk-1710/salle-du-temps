export const typeDefs = `#graphql
  
  type User {
    id : String
    username : String 
    password : String 
    name : String
    dob : String
    createdAt : String
    updatedAt : String 
    startingWeight : Float
    height : Int
    workouts : [Workout]
  }

  type Workout {
    id : String 
    imageURL : String 
    createdBy : String 
    createdAt : String
    title : String 
    difficulty : String
    time : Int 
    description : String
    exercises : [Exercise]
    users : [User]
  }

  type Exercise {
    id : String
    imageURL : String
    createdBy : String 
    createdAt : String 
    title : String 
    difficulty : String
    time : Int 
    type : String
    tutorial : String
    setsreps : String
    workouts : [Workout]
  }

  type WorkoutProgrssion{
    id : String
    createdBy : String
    workoutId : String
    date: String
    time : String
  } 

  type ExerciseProgression{
    id: String
    createdBy: String
    exerciseId: String
    date: String
    weight : Int
    sets: Int
    reps: Int
  }

  type Days{
    id: String
    createdBy: String
    workoutId: String
    days: [String]
  }

  type Query {
    exercises: [Exercise]!
    workouts: [Workout]!
    searchWorkouts(query:String) : [Workout]!
    user(username:String): User!
  }

  type Mutation {
    createWorkout(workout: CreateWorkoutInput!) : Workout!
  }

  input CreateWorkoutInput{
    imageURL : String!, 
    createdBy : String!,
    createdAt : String!,
    title : String!, 
    difficulty : String!,
    time : Int!, 
    description : String!,
  }
`;