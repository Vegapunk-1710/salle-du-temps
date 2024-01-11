import {PrismaClient} from "@prisma/client"
import { exercises } from "./data/exercises";

const prisma = new PrismaClient();

async function main(){
   await prisma.user.create({
    data: {
        id:'ADMIN',
        createdAt:'2023-10-17',
        updatedAt:'2023-10-17',
        username:'vegapunk',
        password:'rony123',
        name:'Rony',
        dob:'2000-10-17',
        startingWeight:180,
        height:183
    },
   });
   await prisma.user.create({
    data: {
        createdAt:'2022-11-24',
        updatedAt:'2022-11-24',
        id:'USER',
        username:'tarzan',
        password:'baher123',
        name:'Baher',
        dob:'2000-11-24',
        startingWeight:200,
        height:191
    },
   });

   await prisma.exercise.createMany({
        data:exercises,
   });
}

main().catch(e => {
    console.error(e);
    process.exit(1);
})
.finally(async () => {
    await prisma.$disconnect();
});