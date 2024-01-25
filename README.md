# salle-du-temps
----------
- [What?](https://github.com/Vegapunk-1710/salle-du-temps/blob/main/README.md#what)
- [Why?](https://github.com/Vegapunk-1710/salle-du-temps/blob/main/README.md#why)
- [How?](https://github.com/Vegapunk-1710/salle-du-temps/blob/main/README.md#how)
- [Demo](https://github.com/Vegapunk-1710/salle-du-temps/blob/main/README.md#demo)

## What?
----------
A full-stack fitness mobile application designed to combine workout organization and social media interactivity. This app allows users to not only plan and track their workouts and exercises but also provides a unique social aspect where they can access and utilize routines created by others. Additionally, the application offers features to monitor and record progress in terms of body weight and the advancement in workout or exercise performance, fostering a comprehensive fitness tracking experience.

## Why?
----------
A group of fitness enthusiasts, consisting of gym professionals and avid gym-goers who also happen to be my best friends, expressed the need for a specialized application to track their workouts, moving beyond the use of standard note-taking apps. They required a platform with social media elements to easily share and exchange their workout routines with one another. This need highlighted the demand for a dedicated, non-commercial app tailored to the specific needs of regular gym users for tracking and sharing their fitness journeys.

## How? 
----------
Technologies Used :
- Flutter (Frontend)
- Node.JS (Backend) using Typescript
- Apollo GraphQL (Server/GraphQL)
- Prisma (ORM)
- PostgreSQL (Database)
- Railway (Deployment)

### Step 1
Open up a terminal and go to the backend folder :
```
cd backend/
```
### Step 2
Initialize [Node](https://nodejs.org/en/download/current) and Prisma :
```
npm install
npx prisma init
```
### Step 3
Create a .env file if Prisma hasn't created it already, open it and paste the following variables:
```
DATABASE_URL="YOUR_DATABASE_URL"
PORT=4000
```
⚠️ Assuming you already have a PostgreSQL database up and running, replace YOUR_DATABASE_URL with your actual database URL. ⚠️
### Step 4
Initialize Prisma Client and Start the server:
```
npx prisma migrate dev --name init
npm install @prisma/client
npm start
```
### Step 5
Open up **another** terminal and go to the frontend folder :
```
cd frontend/
```
### Step 6
While having a phone simulator opened and [Flutter](https://docs.flutter.dev/get-started/install) installed, run the application:
```
flutter run
```
⚠️ The app was built/tested on an iPhone 15 Pro Max and an iPhone SE. Android phones/simulations aren't guaranteed to work ⚠️

## Demo
----------
