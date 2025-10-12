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
* Workout viewer - it explains the exercise + adds GIF images fetched from the ExerciseDB API
* Save and manage saved exercises
* Set up and manage workout routines
* Login and signup system for cloud-saving exercises and routines

### Features (planned)

* AI personalised workout routine plan generator 
    - Automatically suggests a set of exercises based on user-defined variables such as:
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
* Real time notifications
* Leveling system for completed routines
    - Has multiple tiers: Beginner, Intermediate, Advanced, Elite, Master, Legend
    - Experience points (XP) gained when a user completes routines for all their selected days