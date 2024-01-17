import { Console } from "console";
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
      searchWorkouts : async (_,args) => {
        const workouts = await prisma.workout.findMany({
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
        });
        return getWorkoutsWithCreatedByName(workouts);
      },
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
      days : async (_,args) => {
        return await prisma.days.findFirstOrThrow({
          where : {
            createdBy: args.userId,
            workoutId: args.workoutId
          }
        });
      }
    },
    Mutation : {
      createWorkout : async (_,args) => {
        const user = await prisma.user.findUniqueOrThrow({
          where:{
            id: args.workout.createdBy
          },
          select: {
            name: true,
          },
        });
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
        return {
          ...workout,
          createdBy : user.name
        };
      },
      addWorkout : async (_,args) => {
        await prisma.workoutsRelations.create({
          data:{
            userId: args.userId,
            workoutId: args.workoutId,
          }
        });
        return true;
      },
      deleteWorkout : async (_,args) => {
        await prisma.workoutsRelations.delete({
          where:{
            userId_workoutId :{ 
              userId: args.userId,
              workoutId: args.workoutId,
            }
          }
        });
        return true;
      }, 
      deleteWorkoutForAll : async (_,args) => {
        const workout = await prisma.workout.findUnique({where:{id:args.workoutId}});
        if(args.userId === workout.createdBy){
          await prisma.workoutsRelations.deleteMany({
            where:{
              workoutId: args.workoutId
            }
          });
          await prisma.workout.delete({
            where: {
              id : args.workoutId
            }
          });
          return true;
        }
        else{
          await prisma.workoutsRelations.delete({
            where:{
              userId_workoutId :{ 
                userId: args.userId,
                workoutId: args.workoutId,
              }
            }
          });
          return false;
        }
      }, 
      updateDays : async (_,args) => {
        let id;
        try{
          const d = await prisma.days.findFirstOrThrow({
            where : {
              createdBy: args.userId,
              workoutId: args.workoutId
            }
          });
          id = d.id;
        } catch(e){
          id = '';
        }
        return await prisma.days.upsert({
          where :{
            id :id,
          },
          create:{
            createdBy: args.userId,
            workoutId: args.workoutId,
            days: args.days,
          },
          update:{
            days: args.days
          }
        });
      },
      deleteDays : async (_,args) => {
        try{
          await prisma.days.deleteMany({
            where : {
              createdBy: args.userId,
              workoutId: args.workoutId
            }
          });
          return true; 
        } catch(e){
          return false;
        }
      }    
    }
  };
