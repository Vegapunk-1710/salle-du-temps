import { dateScalar } from "./schema.js";
import prisma from "./lib/prisma.js";

export const resolvers = {
    Date: dateScalar,
    Query: {
      exercises: async () => await prisma.exercise.findMany(),
    },
  };
