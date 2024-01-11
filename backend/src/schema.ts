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
    days : [String]
    progression : [WorkoutProgrssion]
    exercises : [Exercise]
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
    progression : [ExerciseProgression]
  }

  type WorkoutProgrssion{
    id : String
    date: String
    time : String
  } 

  type ExerciseProgression{
    id: String
    date: String
    weight : Int
    sets: Int
    reps: Int
  }

  type Query {
    exercises: [Exercise]!
    exercisesByCreator(createdBy:String) : [Exercise]!
    workouts: [Workout]!
    users: [User]!
    user(username:String): User!
    userNameById(id:String) : User!
  }
`;