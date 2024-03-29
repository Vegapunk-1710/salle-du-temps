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
    searchExercises(query:String) :  [Exercise]!
    todayWorkout(userId:String,day:String) : Workout
    workouts: [Workout]!
    searchWorkouts(query:String) : [Workout]!
    login(username:String, password:String): User!
    days(userId:String,workoutId:String) : Days!
    workoutExercises(workoutId:String): [Exercise]!
    workoutProgression(userId:String,workoutId:String) : [WorkoutProgrssion]!
    exerciseProgression(userId:String,exerciseId:String) : [ExerciseProgression]!
  }

  type Mutation {
    signUp(user:CreateUserInput): User!
    createWorkout(workout: CreateWorkoutInput!) : Workout!
    addWorkout(userId:String, workoutId:String) : Boolean!
    deleteWorkout(userId:String,workoutId:String) : Boolean!
    deleteWorkoutForAll(userId:String,workoutId:String) : Boolean!
    updateDays(userId:String,workoutId:String,days:[String]) : Days!
    deleteDays(userId:String,workoutId:String): Boolean!
    addExercise(workoutId:String, exerciseId:String): Int!
    updateOrder(workoutId:String, exerciseId:String, order:Int): Int!
    createExercise(exercise: CreateExerciseInput!) : Exercise!
    deleteExercise(workoutId:String,exerciseId:String) : Boolean!
    deleteExerciseForAll(userId:String,workoutId:String,exerciseId:String) : Boolean!
    addWorkoutProgression(userId:String,workoutId:String,date:String,time:String): Boolean!
    deleteWorkoutProgression(userId:String,workoutId:String,date:String,time:String): Boolean!
    addExerciseProgression(userId:String,exerciseId:String,date:String,weight:Int,sets:Int,reps:Int): Boolean!
    deleteExerciseProgression(userId:String,exerciseId:String,date:String): Boolean!
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

  input CreateExerciseInput{
    imageURL : String!, 
    createdBy : String!,
    createdAt : String!,
    title : String!, 
    difficulty : String!,
    time : Int!, 
    type : String!,
    tutorial : String!,
    setsreps : String!,
  }

  input CreateUserInput{
    username : String!, 
    password : String!,
    name : String!,
    dob : String!, 
    createdAt : String!,
    updatedAt : String!, 
    weight : Int!,
    height : Int!,
  }
`;