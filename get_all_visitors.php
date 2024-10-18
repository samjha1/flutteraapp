<?php

header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: POST, GET, OPTIONS");
header("Access-Control-Allow-Headers: Content-Type");

// Connect to the database
$host = "localhost"; // Update with your actual DB host
$username = "root";  // DB username
$password = "";      // DB password
$dbname = "flutterdb"; // Your database name

$conn = new mysqli($host, $username, $password, $dbname);

if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}

// Query to get all visitors
$sql = "SELECT full_name, number, purpose, meeting_person FROM visitors";
$result = $conn->query($sql);

$visitors = [];

if ($result->num_rows > 0) {
    while($row = $result->fetch_assoc()) {
        $visitors[] = $row;
    }
}

// Return data as JSON
header('Content-Type: application/json');
echo json_encode($visitors);

$conn->close();
?>
