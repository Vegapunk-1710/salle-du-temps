/*
  Warnings:

  - You are about to drop the column `days` on the `Workout` table. All the data in the column will be lost.
  - You are about to drop the `_ExerciseToExerciseProgression` table. If the table is not empty, all the data it contains will be lost.
  - You are about to drop the `_ExerciseToWorkout` table. If the table is not empty, all the data it contains will be lost.
  - You are about to drop the `_UserToWorkout` table. If the table is not empty, all the data it contains will be lost.
  - You are about to drop the `_WorkoutToWorkoutProgrssion` table. If the table is not empty, all the data it contains will be lost.
  - Added the required column `createdBy` to the `ExerciseProgression` table without a default value. This is not possible if the table is not empty.
  - Added the required column `exerciseId` to the `ExerciseProgression` table without a default value. This is not possible if the table is not empty.
  - Added the required column `createdBy` to the `WorkoutProgrssion` table without a default value. This is not possible if the table is not empty.
  - Added the required column `workoutId` to the `WorkoutProgrssion` table without a default value. This is not possible if the table is not empty.

*/
-- DropForeignKey
ALTER TABLE "_ExerciseToExerciseProgression" DROP CONSTRAINT "_ExerciseToExerciseProgression_A_fkey";

-- DropForeignKey
ALTER TABLE "_ExerciseToExerciseProgression" DROP CONSTRAINT "_ExerciseToExerciseProgression_B_fkey";

-- DropForeignKey
ALTER TABLE "_ExerciseToWorkout" DROP CONSTRAINT "_ExerciseToWorkout_A_fkey";

-- DropForeignKey
ALTER TABLE "_ExerciseToWorkout" DROP CONSTRAINT "_ExerciseToWorkout_B_fkey";

-- DropForeignKey
ALTER TABLE "_UserToWorkout" DROP CONSTRAINT "_UserToWorkout_A_fkey";

-- DropForeignKey
ALTER TABLE "_UserToWorkout" DROP CONSTRAINT "_UserToWorkout_B_fkey";

-- DropForeignKey
ALTER TABLE "_WorkoutToWorkoutProgrssion" DROP CONSTRAINT "_WorkoutToWorkoutProgrssion_A_fkey";

-- DropForeignKey
ALTER TABLE "_WorkoutToWorkoutProgrssion" DROP CONSTRAINT "_WorkoutToWorkoutProgrssion_B_fkey";

-- AlterTable
ALTER TABLE "ExerciseProgression" ADD COLUMN     "createdBy" TEXT NOT NULL,
ADD COLUMN     "exerciseId" TEXT NOT NULL;

-- AlterTable
ALTER TABLE "Workout" DROP COLUMN "days";

-- AlterTable
ALTER TABLE "WorkoutProgrssion" ADD COLUMN     "createdBy" TEXT NOT NULL,
ADD COLUMN     "workoutId" TEXT NOT NULL;

-- DropTable
DROP TABLE "_ExerciseToExerciseProgression";

-- DropTable
DROP TABLE "_ExerciseToWorkout";

-- DropTable
DROP TABLE "_UserToWorkout";

-- DropTable
DROP TABLE "_WorkoutToWorkoutProgrssion";

-- CreateTable
CREATE TABLE "WorkoutsRelations" (
    "userId" TEXT NOT NULL,
    "workoutId" TEXT NOT NULL,

    CONSTRAINT "WorkoutsRelations_pkey" PRIMARY KEY ("userId","workoutId")
);

-- CreateTable
CREATE TABLE "ExercisesRelations" (
    "workoutId" TEXT NOT NULL,
    "exerciseId" TEXT NOT NULL,

    CONSTRAINT "ExercisesRelations_pkey" PRIMARY KEY ("workoutId","exerciseId")
);

-- CreateTable
CREATE TABLE "Days" (
    "id" TEXT NOT NULL,
    "createdBy" TEXT NOT NULL,
    "workoutId" TEXT NOT NULL,
    "days" TEXT[],

    CONSTRAINT "Days_pkey" PRIMARY KEY ("id")
);

-- AddForeignKey
ALTER TABLE "WorkoutsRelations" ADD CONSTRAINT "WorkoutsRelations_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "WorkoutsRelations" ADD CONSTRAINT "WorkoutsRelations_workoutId_fkey" FOREIGN KEY ("workoutId") REFERENCES "Workout"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "ExercisesRelations" ADD CONSTRAINT "ExercisesRelations_workoutId_fkey" FOREIGN KEY ("workoutId") REFERENCES "Workout"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "ExercisesRelations" ADD CONSTRAINT "ExercisesRelations_exerciseId_fkey" FOREIGN KEY ("exerciseId") REFERENCES "Exercise"("id") ON DELETE RESTRICT ON UPDATE CASCADE;
