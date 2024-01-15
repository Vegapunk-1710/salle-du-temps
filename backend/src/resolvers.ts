import prisma from "./lib/prisma.js";

async function getWorkoutsWithCreatedByName(workouts : any) {
  for (let i = 0; i < workouts.length; i++) {
    const user = await prisma.user.findUniqueOrThrow({
      where:{
        id: workouts[i].createdBy
      },
      select: {
        name: true,
      },
    });
    workouts[i] = {
      ...workouts[i],
      createdBy : user.name
    }
  }
  return workouts;
}

export const resolvers = {
    Query: {
      exercises: async () => await prisma.exercise.findMany(),

      workouts: async () => {
        const workouts = await prisma.workout.findMany();
        return getWorkoutsWithCreatedByName(workouts);
      },
      searchWorkouts : async (_,args) => await prisma.workout.findMany({
        where:{
          OR:[
            {
              description :{
                contains : args.query,
                mode: 'insensitive',
              }
            },
            {
              difficulty :{
                contains : args.query,
                mode: 'insensitive',
              }
            },
            {
              title :{
                contains : args.query,
                mode: 'insensitive',
              }
            },
            {
              createdAt :{
                contains : args.query,
                mode: 'insensitive',
              }
            },
          ]
        }
      }),


      user: async (_,args) => {
        const user = await prisma.user.findUnique({
          where:{
            username: args.username
          },
          include: {
            workouts: {
              include: {
                workout: true,
              },
            },
          },
        });
        const workouts = user.workouts.map(relation => relation.workout);
        return {
          ...user,
          workouts: getWorkoutsWithCreatedByName(workouts),
        };
      },
    },
    Mutation : {
      createWorkout : async (_,args) => {
        const workout = await prisma.workout.create({
          data:{
            imageURL : args.workout.imageURL,
            createdBy : args.workout.createdBy,
            createdAt : args.workout.createdAt,
            title: args.workout.title,
            difficulty : args.workout.difficulty,
            time : args.workout.time,
            description : args.workout.description
          }
        });
        await prisma.workoutsRelations.create({
          data:{
            userId: args.workout.createdBy,
            workoutId: workout.id,
          }
        });
        return workout;
      },

    }
  };
