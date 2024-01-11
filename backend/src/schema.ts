import { GraphQLScalarType, Kind } from 'graphql';

export const typeDefs = `#graphql
  
  scalar Date

  type User {
    id : String
    username : String 
    password : String 
    name : String
    dob : String
    createdAt : Date
    updatedAt : Date 
    startingWeight : Float
    height : Int
    workouts : [Workout]
  }

  type Workout {
    id : String 
    imageURL : String 
    createdBy : String 
    createdAt : Date
    title : String 
    difficulty : String
    time : Int 
    description : String
    days : [String]
    progression : [String]
    exercises : [Exercise]
  }

  type Exercise {
    id : String
    imageURL : String
    createdBy : String 
    createdAt : Date 
    title : String 
    difficulty : String
    time : Int 
    type : String
    tutorial : String
    setsreps : String
    progression : [String]
  }

  type Query {
    exercises: [Exercise]!
  }
`;

export const dateScalar = new GraphQLScalarType({
    name: 'Date',
    description: 'Date custom scalar type',
    serialize(value) {
      if (value instanceof Date) {
        return value.getTime(); 
      }
      throw Error('GraphQL Date Scalar serializer expected a `Date` object');
    },
    parseValue(value) {
      if (typeof value === 'number') {
        return new Date(value); 
      }
      throw new Error('GraphQL Date Scalar parser expected a `number`');
    },
    parseLiteral(ast) {
      if (ast.kind === Kind.INT) {
        return new Date(parseInt(ast.value, 10));
      }
      return null;
    },
  });