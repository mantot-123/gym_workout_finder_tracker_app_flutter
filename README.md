# Fitdex
## A mobile gym workout finder app

This is a version of [an existing project](https://github.com/mantot-123/gym_workout_finder_tracker_app_flutter) that I made, this time it comes with a mobile GUI written in Flutter.

### How to run
To run this app, type the command below and replace `<YOUR_API_KEY_HERE>` with the ExerciseDB API key you got from this page here: https://rapidapi.com/justin-WFnsXH_t6/api/exercisedb
```
flutter run --dart-define=API_KEY=<YOUR_API_KEY_HERE>
```
For building, run this command instead:
```
flutter build <platform> --dart-define=API_KEY=<YOUR_API_KEY_HERE>
```

### Features (current)
* Search using the API
* Workout viewer - it explains the exercise + adds GIF images fetched from the ExerciseDB API showing how to do it
* Save and manage saved workouts


### Features (planned)

* Personalised workout plan generator 
    - Automatically suggests a set of exercises based on: 
        - Workout frequency
        - Current build 
        - Goal
        - Age
        - Height
        - Experience
        - Target muscle groups
        - Number of total exercises to do
        - Previous health conditions<br>
        etc.
* Set up and manage workout routines
    - Set a time for the routine to start
    - Which days to do the routine
    - Add workouts to the routine and mark each one of them as completed 
    - Sends push notifications/alarms when the user should start doing the routine
* Login and signup system + cloud saving exercises and routines
* Real time notifications
* Leveling system for completed routines
    - Has multiple tiers: Beginner, Intermediate, Advanced, Elite, Master, Legend
    - Experience points (XP) gained when a user completes the routine for all the selected days
* AI features to suggest routines - might use a chatbot API to do this