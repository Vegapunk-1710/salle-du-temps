import prisma from "./lib/prisma.js";

async function getEntitiesWithCreatedByName(entities : any) {
  for (let i = 0; i < entities.length; i++) {
    const user = await prisma.user.findUniqueOrThrow({
      where:{
        id: entities[i].createdBy
      },
      select: {
        name: true,
      },
    });

    entities[i] = {
      ...entities[i],
      createdBy : user.name,
    }
  }
  return entities;
}

export const resolvers = {
    Query: {
      exercises: async () => {
        const exercises = await prisma.exercise.findMany({
          orderBy : {
            createdAt : 'desc'
          },
          take : 10
        });
        return getEntitiesWithCreatedByName(exercises);
      },
      searchExercises : async (_,args) => {
        const exercises = await prisma.exercise.findMany({
          where:{
            OR:[
              {
                tutorial :{
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
                type :{
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
              {
               setsreps :{
                  contains : args.query,
                  mode: 'insensitive',
                }
              },
            ]
          }
        });
        return getEntitiesWithCreatedByName(exercises);
      },

      workouts: async () => {
        const workouts = await prisma.workout.findMany({
          orderBy : {
            createdAt : 'desc'
          },
          take : 10
        });
        return getEntitiesWithCreatedByName(workouts);
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
        return getEntitiesWithCreatedByName(workouts);
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
          workouts: getEntitiesWithCreatedByName(workouts),
        };
      },
      days : async (_,args) => {
        return await prisma.days.findFirstOrThrow({
          where : {
            createdBy: args.userId,
            workoutId: args.workoutId
          }
        });
      },
      workoutExercises : async (_,args) => {
        try {
          const exerciseRelations = await prisma.exercisesRelations.findMany({
            where: {
              workoutId: args.workoutId,
            },
            orderBy: {
              order: 'asc', 
            },
            include: {
              exercise: true,
            },
          });
      
          return getEntitiesWithCreatedByName(exerciseRelations.map(relation => relation.exercise));
        } catch (error) {
          return [];
        }
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
          await prisma.workoutProgrssion.deleteMany({
            where : {
              workoutId :  args.workoutId
            }
          });
          await prisma.days.deleteMany({
            where : {
              workoutId : args.workoutId
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
      },
      addExercise : async (_,args) => {
        try {
          const count = await prisma.exercisesRelations.count({
            where: {
              workoutId: args.workoutId,
            },
          });
          await prisma.exercisesRelations.create({
            data:{
              exerciseId : args.exerciseId,
              workoutId: args.workoutId,
              order: count+1
            }
          });
          return count+1;
        }
        catch(e){
          return -1;
        }
      },
      updateOrder: async (_,args) => {
        try {
          const updatedRelation = await prisma.exercisesRelations.update({
            where: {
              workoutId_exerciseId: { // This assumes a composite key of workoutId and exerciseId
                workoutId: args.workoutId,
                exerciseId: args.exerciseId,
              },
            },
            data: {
              order: args.order,
            },
          });
          return updatedRelation.order;
        } catch(e){
          return -1;
        }
      },
      createExercise: async (_,args) => {
        const user = await prisma.user.findUniqueOrThrow({
          where:{
            id: args.exercise.createdBy
          },
          select: {
            name: true,
          },
        });
        const exercise = await prisma.exercise.create({
          data:{
            imageURL : args.exercise.imageURL,
            createdBy : args.exercise.createdBy,
            createdAt : args.exercise.createdAt,
            title: args.exercise.title,
            difficulty : args.exercise.difficulty,
            time : args.exercise.time,
            type : args.exercise.type,
            tutorial : args.exercise.tutorial,
            setsreps : args.exercise.setsreps
          }
        });
        return {
          ...exercise,
          createdBy : user.name
        }
      },
      deleteExercise: async (_,args) => {
        try{
          await prisma.exercisesRelations.delete({
            where : {
              workoutId_exerciseId :{
                exerciseId : args.exerciseId,
                workoutId : args.workoutId
              }
            }
          });
          return true;
        }
        catch(e){
          return false;
        }
      },
      deleteExerciseForAll : async (_,args) => {
        try{
          const exercise = await prisma.exercise.findUnique({where:{id:args.exerciseId}});
          if(args.userId === exercise.createdBy){
          await prisma.exercisesRelations.deleteMany({
            where : {
              exerciseId: args.exerciseId
            }
          });
          await prisma.exercise.delete({
            where : {
              id: args.exerciseId
            }
          });
          await prisma.exerciseProgression.deleteMany({
            where : {
              exerciseId: args.exerciseId
            }
          });
        } 
        else{
          await prisma.exercisesRelations.delete({
            where : {
              workoutId_exerciseId :{
                exerciseId : args.exerciseId,
                workoutId : args.workoutId
              }
            }
          });
        }
          return true;
        }
        catch(e){
          return false;
        }
      }
    }
  };
