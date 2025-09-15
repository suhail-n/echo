# README

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

* Ruby version

* System dependencies

* Configuration

* Database creation

* Database initialization

* How to run the test suite

* Services (job queues, cache servers, search engines, etc.)

* Deployment instructions

* ...


## Project Feature Requirements

- [x] User Authentication: Implement user sign-up, login, and logout functionalities using Devise.
- [ ] User profile management: Allow users to view and edit their profiles, including changing passwords and updating personal information.
  - [ ] manage persons bodyweight. THink about future metric management such as arm size, chest size, etc.
- [ ] Workout plans
- [ ] Workout templates section
  - [ ] Templates already exist in the database
  - [ ] Templates are like workout plans that are made public by the admin which can be downloaded by the users
  - [ ] Should be able to download templates as new workouts
- [ ] Create exercises (admin only for now. Maybe later allow users to create exercises)
- [ ] Workout sessions
    - [ ] Start and end a workout session
    - [ ] Exercises with the weights and reps
    - [ ] Exercises reps, and weight per set
    - [ ] Exercises show the weight and reps during the previous session
    - [ ] An option for how good a set felt from painful to easy (1-5 scale)
    - [ ] Timer on the page
- [ ] Trackable workout sessions
    - [ ] Track the time taken for each exercise
    - [ ] Track the time taken for the entire workout session
    - [ ] Track the weight lifted for each exercise in previous sessions
- [ ] Metrics
    - [ ] Graph for exercise progressions over time
    - [ ] User should create a progression graph by selecting an exercise and viewing their performance over time
    - [ ] User can select a time range for the graph (e.g., last week, last month, last year)


## Entity Relationship Diagram (ERD)

The database schema is defined in the `ERD.dbml` file. You can visualize it using a DBML viewer or convert it to SQL for your database.
