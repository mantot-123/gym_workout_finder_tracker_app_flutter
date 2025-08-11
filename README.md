# Fitdex
## A mobile gym workout finder app

This is a version of [an existing project](https://github.com/mantot-123/gym_workout_finder_tracker_app_flutter) that I made, this time it comes with a mobile GUI written in Flutter.

### How to run
To run this app, type the command below and replace `<YOUR_API_KEY_HERE>` with the ExerciseDB API key you got from this page here: https://rapidapi.com/justin-WFnsXH_t6/api/exercisedb
```
flutter run --dart-define=API_KEY=<YOUR_API_KEY_HERE>
```

### Features (current)
* Search (currently only allows you to search by name)
* Workout viewer - it explains the exercise + adds GIF images fetched from the ExerciseDB API showing how to do it


### Features (planned)

Note that some of the features from the command line version are not yet available in this app. They are shown in this list here. 
* Target muscle search
* Add and manage saved workouts
* Workout recommender - Automatically suggests a set of exercises based on the target muscle groups (for example: Push, Pull and Leg days), number of total exercises to do, difficulty and intensity

