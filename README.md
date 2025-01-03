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

## About Flutter
Flutter is an open-source UI software development kit created by Google. It is used to develop cross-platform applications for Android, iOS, Linux, macOS, Windows, and the web from a single codebase. WellnessPath leverages Flutter for its frontend to deliver a seamless and responsive user experience across all platforms.

### Key Features of Flutter:
- **Hot Reload**: Enables real-time updates during development.
- **Cross-Platform**: Build apps for multiple platforms with one codebase.
- **Rich Widgets**: Provides pre-designed widgets for a polished UI.
- **High Performance**: Utilizes Dart programming language for fast execution.

To learn more about Flutter, visit the [official documentation](https://flutter.dev/docs).

---

## API Source
The backend API for this project is written in PHP and hosted on [AwardSpace](https://www.awardspace.com/). The API enables communication between the Flutter application and the MySQL database for data storage and retrieval. Below are some key features and endpoints of the API:

- **User Authentication**
  - `login`: Authenticates users based on their credentials.
  - `register`: Registers a new user and stores their details in the database.

- **Progress Tracking**
  - `logMeal`: Logs meal data into the database.
  - `logWorkout`: Records workout details, including calories burned and duration.
  - `logWaterIntake`: Updates the daily water intake.
  - `getDailyWaterIntake`: Retrieves the daily total water intake.

- **Data Aggregation**
  - Fetches daily and detailed progress including BMI, calories, and other metrics.

You can find the PHP API code in the `api/` directory of the backend repository.

---

## How It Works
The app uses HTTP requests to communicate with the backend API. Below are the steps for each operation:
1. **API Endpoints**: Each feature (e.g., login, register, log meals) corresponds to a specific API endpoint.
2. **Data Flow**: Data entered by the user is sent to the API in JSON format via HTTP POST requests.
3. **Database Updates**: The API interacts with the MySQL database to fetch or store the data.
4. **Response Handling**: The app processes the response (e.g., success messages, errors) and updates the UI accordingly.

---

## Running the Repository

To run this project locally, follow these steps:

### Prerequisites
- Install Flutter SDK from [Flutter's official website](https://flutter.dev/docs/get-started/install).
- Install PHP and MySQL server to set up the backend.
- Clone this repository and the backend repository to your local machine.

### Steps
1. **Clone the Repository**:
   ```bash
   git clone https://github.com/YourUsername/WellnessPath.git
   cd WellnessPath
   ```
2. **Install Flutter Dependencies**:
   ```bash
   flutter pub get
   ```
3. **Run the Application**:
   ```bash
   flutter run
   ```
4. **Set Up the Backend**:
   - Configure your PHP server and MySQL database using the provided `index.php` file and SQL scripts.
   - Update the API endpoint in `api_service.dart` to point to your backend.

5. **Test the App**:
   - Launch the app on an emulator or physical device.
   - Verify functionality by logging meals, workouts, water intake, and viewing progress.

---
## Credits

- **Development Team:** Zainab Maatouk 
- **Backend Development:** LIU Dr. Marwan Cheaito
- **Email:** 4232001@students.liu.edu.lb
- **Motivational Quotes:** "Wellness is the complete integration of body, mind, and spirit—the realization that everything we do, think, feel, and believe has an impact on our state of health." – Greg Anderson

---
