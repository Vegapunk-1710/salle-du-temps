/*
  Warnings:

  - Added the required column `order` to the `ExercisesRelations` table without a default value. This is not possible if the table is not empty.

*/
-- AlterTable
ALTER TABLE "ExercisesRelations" ADD COLUMN     "order" INTEGER NOT NULL;
