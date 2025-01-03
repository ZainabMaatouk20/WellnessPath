# WellnessPath

Welcome to WellnessPath, a Flutter application that helps users track their wellness journey. The app includes features for logging meals, workouts, water intake, and progress, as well as viewing detailed and daily progress.

---

## Table of Contents

1. [Overview](#overview)
2. [File Descriptions](#file-descriptions)
    - [lib/main.dart](#libmaindart)
    - [lib/pages](#libpages)
        - [home_page.dart](#libpageshome_pagedart)
        - [login_page.dart](#libpageslogin_pagedart)
        - [register_page.dart](#libpagesregister_pagedart)
        - [meal_log_page.dart](#libpagesmeal_log_pagedart)
        - [workout_log_page.dart](#libpagesworkout_log_pagedart)
        - [progress_page.dart](#libpagesprogress_pagedart)
        - [water_intake_page.dart](#libpageswater_intake_pagedart)
    - [lib/services](#libservices)
        - [api_service.dart](#libservicesapi_servicedart)
3. [Credits](#credits)

---

## Overview

WellnessPath provides the following functionalities:
- User registration and login.
- Tracking daily meals, workouts, and water intake.
- Viewing daily and detailed progress.
- A personalized homepage with motivational quotes and wellness stats.

---

## File Descriptions

### lib/main.dart
The entry point of the application. It initializes the app, sets up routing for navigation, and handles user login status to redirect to the appropriate page (login or home).

---

### lib/pages

#### home_page.dart
- **Purpose:** Displays a summary of the user's wellness journey with motivational quotes, quick stats (BMI, workouts, calories, water), and navigation buttons to other features.
- **Features:**
  - Displays user's username after login.
  - Buttons to navigate to meal log, workout log, water intake, and progress pages.
  - Includes a logout button.

#### login_page.dart
- **Purpose:** Allows users to log in to their accounts.
- **Features:**
  - Username and password input fields.
  - Login button with a loading spinner.
  - Navigation to the registration page if the user doesn't have an account.

#### register_page.dart
- **Purpose:** Allows users to register for the application.
- **Features:**
  - Input fields for name, email, password, height, and weight.
  - Registers the user on the backend via an API call.

#### meal_log_page.dart
- **Purpose:** Allows users to log meals with calorie data.
- **Features:**
  - Input fields for meal name, calories, and meal type.
  - Sends data to the backend to update the meal log and daily progress.

#### workout_log_page.dart
- **Purpose:** Allows users to log workouts with duration and calories burned.
- **Features:**
  - Input fields for workout type, duration, and calories burned.
  - Sends data to the backend to update the workout log and daily progress.

#### progress_page.dart
- **Purpose:** Displays the user's daily and detailed progress.
- **Features:**
  - Daily progress: Calories consumed, calories burned, workouts, and water intake.
  - Detailed progress: Weight, height, BMI, body fat, muscle mass, and daily calorie needs.

#### water_intake_page.dart
- **Purpose:** Allows users to log their daily water intake.
- **Features:**
  - Input field for water amount.
  - Displays the total water intake for the day.
  - Sends data to the backend and fetches updated water intake data.

---

### lib/services

#### api_service.dart
- **Purpose:** Handles API requests to the backend for all features.
- **Features:**
  - `post` and `get` methods to interact with the backend server.
  - Used by all pages to send or fetch data.

---

## Credits

- **Development Team:** Zainab Maatouk and contributors.
- **Backend Development:** [Your Name or Team Name Here]
- **Motivational Quotes:** Various public sources.

---
