<?php
ob_start(); // Start output buffering

// Enable error reporting
error_reporting(E_ALL);
ini_set('display_errors', 1);

// Handle all errors as JSON
set_exception_handler(function ($e) {
    ob_end_clean();
    echo json_encode(["error" => $e->getMessage()]);
    exit();
});
set_error_handler(function ($errno, $errstr) {
    ob_end_clean();
    echo json_encode(["error" => $errstr]);
    exit();
});

// Allow CORS for API
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: POST, GET, OPTIONS");
header("Access-Control-Allow-Headers: Content-Type, Authorization");
header("Content-Type: application/json");

// Database configuration
$servername = 'fdb1029.awardspace.net';
$username = '4569413_wellnesspath';
$password = 'yazayneeeb2023%@D';
$dbname = '4569413_wellnesspath';

// Create a connection to the database
$conn = new mysqli($servername, $username, $password, $dbname);

// Check for connection errors
if ($conn->connect_error) {
    ob_end_clean();
    echo json_encode(["error" => "Connection failed: " . $conn->connect_error]);
    exit();
}

// Handle API requests
if (isset($_GET['action'])) {
    $action = $_GET['action'];

    switch ($action) {
        // Register a user
        case 'register':
            $name = $_POST['name'] ?? null;
            $email = $_POST['email'] ?? null;
            $password = $_POST['password'] ?? null;
            $height = $_POST['height'] ?? null;
            $weight = $_POST['weight'] ?? null;

            if ($name && $email && $password) {
                $hashed_password = password_hash($password, PASSWORD_BCRYPT);
                $stmt = $conn->prepare("INSERT INTO users (name, email, password, height, weight) VALUES (?, ?, ?, ?, ?)");
                $stmt->bind_param("sssdd", $name, $email, $hashed_password, $height, $weight);

                if ($stmt->execute()) {
                    echo json_encode(["success" => true, "message" => "User registered successfully"]);
                } else {
                    echo json_encode(["error" => "Failed to register user. Email might already be taken."]);
                }
                $stmt->close();
            } else {
                echo json_encode(["error" => "Name, email, and password are required"]);
            }
            break;

        // User login
        case 'login':
            $name = $_POST['username'] ?? null;
            $password = $_POST['password'] ?? null;

            if ($name && $password) {
                $stmt = $conn->prepare("SELECT id, password FROM users WHERE name = ?");
                $stmt->bind_param("s", $name);
                $stmt->execute();
                $result = $stmt->get_result();

                if ($result->num_rows > 0) {
                    $user = $result->fetch_assoc();
                    if (password_verify($password, $user['password'])) {
                        echo json_encode(["success" => true, "user_id" => $user['id']]);
                    } else {
                        echo json_encode(["error" => "Invalid credentials"]);
                    }
                } else {
                    echo json_encode(["error" => "User not found"]);
                }
                $stmt->close();
            } else {
                echo json_encode(["error" => "Username and password are required"]);
            }
            break;

          case 'logMeal':
            $user_id = $_POST['user_id'] ?? null;
            $food_item = $_POST['food_item'] ?? null;
            $calories = $_POST['calories'] ?? null;
            $item_count = $_POST['item_count'] ?? null;
            $meal_type = $_POST['meal_type'] ?? null;
            $date = $_POST['date'] ?? date('Y-m-d');

            if ($user_id && $food_item && $calories && $item_count && $meal_type && $date) {
                // Precompute total calories
                $total_calories = $calories * $item_count;

                // Start transaction
                $conn->begin_transaction();

                try {
                    // Insert meal data
                    $stmt = $conn->prepare("
                        INSERT INTO meals (user_id, food_item, calories, item_count, meal_type, date) 
                        VALUES (?, ?, ?, ?, ?, ?)
                    ");
                    $stmt->bind_param("ississ", $user_id, $food_item, $total_calories, $item_count, $meal_type, $date);

                    if (!$stmt->execute()) {
                        throw new Exception("Failed to log meal");
                    }
                    $stmt->close();

                    // Update daily calories consumed
                    $stmt_update = $conn->prepare("
                        INSERT INTO daily_progress (user_id, date, calories_consumed)
                        VALUES (?, ?, ?)
                        ON DUPLICATE KEY UPDATE
                        calories_consumed = calories_consumed + VALUES(calories_consumed)
                    ");
                    $stmt_update->bind_param("isi", $user_id, $date, $total_calories);

                    if (!$stmt_update->execute()) {
                        throw new Exception("Failed to update daily progress");
                    }
                    $stmt_update->close();

                    // Commit transaction
                    $conn->commit();

                    echo json_encode(["success" => true, "message" => "Meal logged successfully"]);
                } catch (Exception $e) {
                    // Rollback transaction on failure
                    $conn->rollback();
                    echo json_encode(["error" => $e->getMessage()]);
                }
            } else {
                echo json_encode(["error" => "All fields are required"]);
            }
            break;


        // Log a workout
        case 'logWorkout':
            $user_id = $_POST['user_id'] ?? null;
            $workout_type = $_POST['workout_type'] ?? null;
            $duration = $_POST['duration'] ?? null;
            $calories_burned = $_POST['calories_burned'] ?? null;
            $date = $_POST['date'] ?? date('Y-m-d');

            if ($user_id && $workout_type && $duration && $calories_burned && $date) {
                $stmt = $conn->prepare("
                    INSERT INTO workouts (user_id, workout_type, duration, calories_burned, date)
                    VALUES (?, ?, ?, ?, ?)
                ");
                $stmt->bind_param("isids", $user_id, $workout_type, $duration, $calories_burned, $date);

                if ($stmt->execute()) {
                    // Update daily workouts count and calories burned
                    $stmt_update = $conn->prepare("
                        INSERT INTO daily_progress (user_id, date, workouts_count, calories_burned)
                        VALUES (?, ?, 1, ?)
                        ON DUPLICATE KEY UPDATE
                        workouts_count = workouts_count + 1,
                        calories_burned = calories_burned + VALUES(calories_burned)
                    ");
                    $stmt_update->bind_param("isi", $user_id, $date, $calories_burned);
                    $stmt_update->execute();
                    $stmt_update->close();

                    echo json_encode(["success" => true, "message" => "Workout logged successfully"]);
                } else {
                    echo json_encode(["error" => "Failed to log workout"]);
                }
                $stmt->close();
            } else {
                echo json_encode(["error" => "All fields are required"]);
            }
            break;

        case 'logWaterIntake':
            $user_id = $_POST['user_id'] ?? null;
            $amount = $_POST['amount'] ?? null;
            $date = $_POST['date'] ?? date('Y-m-d');

            if ($user_id && $amount) {
                // Check if water intake amount is numeric
                if (!is_numeric($amount)) {
                    echo json_encode(["error" => "Invalid water intake amount."]);
                    return;
                }

                // Insert or update daily water intake in daily_progress table
                $stmt = $conn->prepare("
                    INSERT INTO daily_progress (user_id, date, water_intake)
                    VALUES (?, ?, ?)
                    ON DUPLICATE KEY UPDATE 
                    water_intake = water_intake + VALUES(water_intake)
                ");
                $stmt->bind_param("isi", $user_id, $date, $amount);

                if ($stmt->execute()) {
                    echo json_encode(["success" => true, "message" => "Water intake logged successfully."]);
                } else {
                    echo json_encode(["error" => "Failed to log water intake."]);
                }
                $stmt->close();
            } else {
                echo json_encode(["error" => "User ID and amount are required."]);
            }
            break;

        case 'getDailyWaterIntake':
            $user_id = $_GET['user_id'] ?? null;
            $date = $_GET['date'] ?? date('Y-m-d');

            if ($user_id) {
                // Retrieve total water intake for the day
                $stmt = $conn->prepare("
                    SELECT COALESCE(water_intake, 0) AS total_water
                    FROM daily_progress
                    WHERE user_id = ? AND date = ?
                ");
                $stmt->bind_param("is", $user_id, $date);
                $stmt->execute();
                $result = $stmt->get_result()->fetch_assoc();

                if ($result) {
                    echo json_encode(["total_water" => $result['total_water']]);
                } else {
                    echo json_encode(["total_water" => 0]);
                }
                $stmt->close();
            } else {
                echo json_encode(["error" => "User ID is required."]);
            }
            break;


         case 'logProgress':
    $user_id = $_POST['user_id'] ?? null;
    $weight = $_POST['weight'] ?? null;
    $date = $_POST['date'] ?? date('Y-m-d');

    if ($user_id && $weight) {
        // Check if user height is available
        $query_height = $conn->prepare("SELECT height FROM users WHERE id = ?");
        $query_height->bind_param("i", $user_id);
        $query_height->execute();
        $result_height = $query_height->get_result()->fetch_assoc();
        $query_height->close();

        $height = $result_height['height'] ?? 0;

        if ($height > 0) {
            // Calculate BMI, body fat, muscle mass, and daily calorie needs
            $height_m = $height / 100;
            $bmi = $weight / ($height_m * $height_m);
            $body_fat = 1.2 * $bmi + 0.23 * 25 - 16.2; // Example formula for body fat
            $muscle_mass = $weight * 0.4; // Approximation
            $daily_calories_needed = 10 * $weight + 6.25 * $height - 5 * 25 + 5; // BMR calculation

            // Insert or update detailed progress
            $stmt = $conn->prepare("
                INSERT INTO detailed_progress (user_id, weight, height, bmi, body_fat, muscle_mass, daily_calories_needed, date)
                VALUES (?, ?, ?, ?, ?, ?, ?, ?)
                ON DUPLICATE KEY UPDATE
                weight = VALUES(weight),
                bmi = VALUES(bmi),
                body_fat = VALUES(body_fat),
                muscle_mass = VALUES(muscle_mass),
                daily_calories_needed = VALUES(daily_calories_needed)
            ");
            $stmt->bind_param("idddddss", $user_id, $weight, $height, $bmi, $body_fat, $muscle_mass, $daily_calories_needed, $date);
            $stmt->execute();
            $stmt->close();

            echo json_encode(["success" => true, "message" => "Weight logged successfully"]);
        } else {
            echo json_encode(["error" => "Height is not set for the user"]);
        }
    } else {
        echo json_encode(["error" => "User ID and weight are required"]);
    }
    break;
           
        // Fetch progress data
         case 'getProgress':
            $user_id = $_GET['user_id'] ?? null;

            if ($user_id) {
                $date = date('Y-m-d');

                // Fetch daily progress
                $stmt_daily = $conn->prepare("
                    SELECT calories_consumed, calories_burned, workouts_count, water_intake
                    FROM daily_progress
                    WHERE user_id = ? AND date = ?
                ");
                $stmt_daily->bind_param("is", $user_id, $date);
                $stmt_daily->execute();
                $daily_data = $stmt_daily->get_result()->fetch_assoc();
                $stmt_daily->close();

                // Fetch detailed progress
                $stmt_detailed = $conn->prepare("
                    SELECT weight, height, bmi, body_fat, muscle_mass, daily_calories_needed
                    FROM detailed_progress
                    WHERE user_id = ?
                ");
                $stmt_detailed->bind_param("i", $user_id);
                $stmt_detailed->execute();
                $detailed_data = $stmt_detailed->get_result()->fetch_assoc();
                $stmt_detailed->close();

                echo json_encode([
                    "daily" => $daily_data ?? [
                        "calories_consumed" => 0,
                        "calories_burned" => 0,
                        "workouts_count" => 0,
                        "water_intake" => 0
                    ],
                    "detailed" => $detailed_data ?? [
                        "weight" => null,
                        "height" => null,
                        "bmi" => null,
                        "body_fat" => null,
                        "muscle_mass" => null,
                        "daily_calories_needed" => null
                    ]
                ]);
            } else {
                echo json_encode(["error" => "User ID is required"]);
            }
            break;


        default:
            echo json_encode(["error" => "Invalid action"]);
    }
} else {
    echo json_encode(["error" => "No action specified"]);
}

// Close the database connection
$conn->close();
?>
