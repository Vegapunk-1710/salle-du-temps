import { dateScalar } from "./schema.js";
import prisma from "./lib/prisma.js";

export const resolvers = {
    Date: dateScalar,
    Query: {
      exercises: async () => await prisma.exercise.findMany(),
      exercisesByCreator : async (_,args) => await prisma.exercise.findMany({
        where:{
          createdBy: args.createdBy
        }
      }),


      workouts: async () => await prisma.workout.findMany(),


      users: async () => await prisma.user.findMany(), 
      user:  async (_,args) => await prisma.user.findUniqueOrThrow({
        where:{
          username: args.username
        },
      }),
      userNameById : async (_,args) => await prisma.user.findUniqueOrThrow({
        where:{
          id: args.id
        },
        select: {
          name: true,
        },
      })
    },
  };
