/*
  Warnings:

  - You are about to drop the column `progression` on the `Exercise` table. All the data in the column will be lost.
  - You are about to drop the column `progression` on the `Workout` table. All the data in the column will be lost.

*/
-- AlterTable
ALTER TABLE "Exercise" DROP COLUMN "progression",
ALTER COLUMN "createdAt" DROP DEFAULT,
ALTER COLUMN "createdAt" SET DATA TYPE TEXT;

-- AlterTable
ALTER TABLE "User" ALTER COLUMN "createdAt" DROP DEFAULT,
ALTER COLUMN "createdAt" SET DATA TYPE TEXT,
ALTER COLUMN "updatedAt" SET DATA TYPE TEXT;

-- AlterTable
ALTER TABLE "Workout" DROP COLUMN "progression",
ALTER COLUMN "createdAt" DROP DEFAULT,
ALTER COLUMN "createdAt" SET DATA TYPE TEXT;

-- CreateTable
CREATE TABLE "WorkoutProgrssion" (
    "id" TEXT NOT NULL,
    "date" TEXT NOT NULL,
    "time" TEXT NOT NULL,

    CONSTRAINT "WorkoutProgrssion_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "ExerciseProgression" (
    "id" TEXT NOT NULL,
    "date" TEXT NOT NULL,
    "weight" INTEGER NOT NULL,
    "sets" INTEGER NOT NULL,
    "reps" INTEGER NOT NULL,

    CONSTRAINT "ExerciseProgression_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "_WorkoutToWorkoutProgrssion" (
    "A" TEXT NOT NULL,
    "B" TEXT NOT NULL
);

-- CreateTable
CREATE TABLE "_ExerciseToExerciseProgression" (
    "A" TEXT NOT NULL,
    "B" TEXT NOT NULL
);

-- CreateIndex
CREATE UNIQUE INDEX "_WorkoutToWorkoutProgrssion_AB_unique" ON "_WorkoutToWorkoutProgrssion"("A", "B");

-- CreateIndex
CREATE INDEX "_WorkoutToWorkoutProgrssion_B_index" ON "_WorkoutToWorkoutProgrssion"("B");

-- CreateIndex
CREATE UNIQUE INDEX "_ExerciseToExerciseProgression_AB_unique" ON "_ExerciseToExerciseProgression"("A", "B");

-- CreateIndex
CREATE INDEX "_ExerciseToExerciseProgression_B_index" ON "_ExerciseToExerciseProgression"("B");

-- AddForeignKey
ALTER TABLE "_WorkoutToWorkoutProgrssion" ADD CONSTRAINT "_WorkoutToWorkoutProgrssion_A_fkey" FOREIGN KEY ("A") REFERENCES "Workout"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "_WorkoutToWorkoutProgrssion" ADD CONSTRAINT "_WorkoutToWorkoutProgrssion_B_fkey" FOREIGN KEY ("B") REFERENCES "WorkoutProgrssion"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "_ExerciseToExerciseProgression" ADD CONSTRAINT "_ExerciseToExerciseProgression_A_fkey" FOREIGN KEY ("A") REFERENCES "Exercise"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "_ExerciseToExerciseProgression" ADD CONSTRAINT "_ExerciseToExerciseProgression_B_fkey" FOREIGN KEY ("B") REFERENCES "ExerciseProgression"("id") ON DELETE CASCADE ON UPDATE CASCADE;
