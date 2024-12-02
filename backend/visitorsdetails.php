<?php
header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json");
header("Access-Control-Allow-Methods: GET");
header("Access-Control-Allow-Headers: Content-Type, Access-Control-Allow-Headers, Authorization, X-Requested-With");

// Handle OPTIONS request for preflight (CORS)
if ($_SERVER['REQUEST_METHOD'] === 'OPTIONS') {
    http_response_code(200);
    exit();
}

// Database connection details
$host = 'localhost';
$dbname = 'flutterdb';
$username = 'root';
$password = '';

// Create a new connection to the MySQL database
$conn = new mysqli($host, $username, $password, $dbname);

// Check if the connection was successful
if ($conn->connect_error) {
    echo json_encode(["error" => "Connection failed: " . $conn->connect_error]);
    exit();
}

// SQL Query to fetch all data from the `visitors` table
$sql = "SELECT * FROM visitors ORDER BY created_at DESC"; // Fetch records sorted by `created_at` in descending order

// Execute the query
$result = $conn->query($sql);

// Initialize an array to hold the fetched data
$visitorsData = [];

// Check if the query returned any results
if ($result->num_rows > 0) {
    // Fetch all rows and add them to the $visitorsData array
    while ($row = $result->fetch_assoc()) {
        $visitorsData[] = $row;
    }

    // Return the fetched data as a JSON response
    echo json_encode($visitorsData);
} else {
    // If no records are found
    echo json_encode(["error" => "No records found"]);
}

// Close the database connection
$conn->close();
?>
