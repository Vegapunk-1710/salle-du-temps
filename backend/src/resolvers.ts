import prisma from "./lib/prisma.js";
import bcrypt from "bcrypt";

const saltRounds = 10;
const salt = bcrypt.genSaltSync(saltRounds);

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
      login: async (_,args) => {
        const user = await prisma.user.findUnique({
          where:{
            username: args.username,
          },
          include: {
            workouts: {
              include: {
                workout: true,
              },
            },
          },
        });
        if(bcrypt.compareSync(args.password, user.password)){
          const workouts = user.workouts.map(relation => relation.workout);
          return {
            ...user,
            workouts: getEntitiesWithCreatedByName(workouts),
          };
        }
        else{
          throw "Wrong Password !"
        }
      },
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
      todayWorkout : async (_,args) => {
        const userDays = await prisma.days.findMany({
          where: {
            createdBy: args.userId,
          },
        });
        const todaysWorkouts = userDays.filter(dayEntry => dayEntry.days.includes(args.day));
        if (todaysWorkouts.length > 0){
          return await prisma.workout.findFirstOrThrow({
            where:{
              id: todaysWorkouts[0].workoutId
            }
          })
        }
        else {
          return {"id":""};
        }
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
      },
      workoutProgression : async(_,args) => {
        try {
          return await prisma.workoutProgrssion.findMany({
            where : {
              createdBy: args.userId,
              workoutId: args.workoutId
            },
            orderBy : {
              date: 'desc'
            }
          });
        }catch(e){
          return [];
        }
      },
      exerciseProgression : async (_,args) => {
        try{
          return await prisma.exerciseProgression.findMany({
            where:{
              createdBy: args.userId,
              exerciseId: args.exerciseId,
            },
            orderBy : {
              date : 'desc'
            }
          });
        } catch(e){
          return [];
        }
      }
    },
    Mutation : {
      signUp : async (_,args) => {
        const sameUsername = await prisma.user.count({
          where:{
            username: args.user.username
          }
        });
        const sameName = await prisma.user.count({
          where:{
            name: args.user.name
          }
        });
        if(sameUsername > 0){
          throw "Username already exists. Pick another one!";
        }
        else if(sameName > 0){
          throw "Name already exists. Pick another one!";
        }
        else{
          return await prisma.user.create({
            data : {
              username : args.user.username,
              password : bcrypt.hashSync(args.user.password, salt),
              name : args.user.name,
              dob : args.user.dob,
              createdAt : args.user.createdAt,
              updatedAt : args.user.updatedAt,
              startingWeight : args.user.weight,
              height : args.user.height
            }
          });
        }
      },
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
          await prisma.exerciseProgression.deleteMany({
            where : {
              exerciseId: args.exerciseId
            }
          });
          await prisma.exercise.delete({
            where : {
              id: args.exerciseId
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
      },
      addWorkoutProgression: async (_,args) => {
        try {
          await prisma.workoutProgrssion.create({
            data: {
              createdBy: args.userId,
              workoutId: args.workoutId,
              date: args.date,
              time: args.time
            }
          });
          return true;
        } catch(e){
          return false;
        } 
      },
      deleteWorkoutProgression : async (_,args) => {
        try {
          await prisma.workoutProgrssion.deleteMany({
            where : {
              createdBy: args.userId,
              workoutId: args.workoutId,
              date : args.date,
              time : args.time
            }
          });
          return true;
        } catch(e){
          return false;
        }
      },
      addExerciseProgression : async (_,args) => {
        try {
          await prisma.exerciseProgression.create({
            data : {
              createdBy: args.userId,
              exerciseId : args.exerciseId,
              date: args.date,
              weight : args.weight,
              sets : args.sets,
              reps : args.reps
            }
          });
          return true;
        } catch(e){
          return false;
        }
      },
      deleteExerciseProgression : async (_,args) => {
        try{
          await prisma.exerciseProgression.deleteMany({
            where : {
              createdBy: args.userId,
              exerciseId : args.exerciseId,
              date: args.date,
            }
          });
          return true;
        } catch(e){
          return false;
        }
      }
    }
  };
