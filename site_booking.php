<?php
// Allow from any origin
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: POST, GET, OPTIONS");
header("Access-Control-Allow-Headers: Content-Type");

// Your existing PHP code below...
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
    die("Connection failed: " . $conn->connect_error);
}

// Check if the request method is POST
if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    // Your existing code...
    $application_id = isset($_POST['application_id']) ? trim($_POST['application_id']) : '';
    $full_name = isset($_POST['full_name']) ? trim($_POST['full_name']) : '';
    $relation = isset($_POST['relation']) ? trim($_POST['relation']) : '';
    $dob = isset($_POST['dob']) ? trim($_POST['dob']) : '';
    $occupation = isset($_POST['occupation']) ? trim($_POST['occupation']) : '';

    // Prepare the SQL query to insert data into the `site_bookings` table
    $stmt = $conn->prepare("INSERT INTO site_bookings (application_id, full_name, relation, dob, occupation) VALUES (?, ?, ?, ?, ?)");
    $stmt->bind_param("sssss", $application_id, $full_name, $relation, $dob, $occupation);

    // Execute the query and check for success
    if ($stmt->execute()) {
        echo "Record inserted successfully";
    } else {
        echo "Error: " . $stmt->error;
    }

    $stmt->close();
} else {
    echo "Invalid request method!";
}

// Close the connection
$conn->close();
?>
