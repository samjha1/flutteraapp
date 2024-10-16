<?php
header("Access-Control-Allow-Origin: *"); // Allow all origins
header("Access-Control-Allow-Methods: POST, OPTIONS"); // Allow POST and OPTIONS methods
header("Access-Control-Allow-Headers: Content-Type"); // Allow Content-Type header

error_reporting(E_ALL);
ini_set('display_errors', 1);

// Database connection credentials
$servername = "localhost";
$username = "root";
$password = "";
$dbname = "flutterdb";

// Create connection
$conn = new mysqli($servername, $username, $password, $dbname);

// Check connection
if ($conn->connect_error) {
    die(json_encode(["error" => "Connection failed: " . $conn->connect_error]));
}

// Handle preflight request
if ($_SERVER['REQUEST_METHOD'] === 'OPTIONS') {
    exit(0);
}

// Check if the request method is POST
if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    // Retrieve POST data
    $full_name = isset($_POST['full_name']) ? trim($_POST['full_name']) : '';
    $number = isset($_POST['number']) ? trim($_POST['number']) : '';
    $purpose = isset($_POST['purpose']) ? trim($_POST['purpose']) : '';
    $meeting_person = isset($_POST['meeting_person']) ? trim($_POST['meeting_person']) : '';

    // Check if all fields are filled
    if (!empty($full_name) && !empty($number) && !empty($purpose) && !empty($meeting_person)) {
        // Prepare the SQL query to insert data into the `site_bookings` table
        $stmt = $conn->prepare("INSERT INTO visitors (full_name, number, purpose, meeting_person) VALUES (?, ?, ?, ?)");
        
        // Check if preparation was successful
        if ($stmt === false) {
            die(json_encode(["error" => "Error preparing SQL query: " . $conn->error]));
        }

        $stmt->bind_param("ssss", $full_name, $number, $purpose, $meeting_person);

        // Execute the query and check for success
        if ($stmt->execute()) {
            echo json_encode(["status" => "success", "message" => "Record inserted successfully"]);
        } else {
            echo json_encode(["error" => "Error: " . $stmt->error]);
        }

        $stmt->close();
    } else {
        echo json_encode(["error" => "All fields are required!"]);
    }
} else {
    echo json_encode(["error" => "Invalid request method!"]);
}

// Close the connection
$conn->close();
?>
