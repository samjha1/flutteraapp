<?php
header("Access-Control-Allow-Origin: *"); // Allow all origins
header("Access-Control-Allow-Methods: GET, OPTIONS"); // Allow GET and OPTIONS methods
header("Access-Control-Allow-Headers: Content-Type"); // Allow Content-Type header

error_reporting(E_ALL);
ini_set('display_errors', 1);

// Database connection credentials (consider using environment variables in production)
$servername = "localhost";
$username = "root";
$password = "";
$dbname = "flutterdb"; // Use your actual database name

// Create connection
$conn = new mysqli($servername, $username, $password, $dbname);

// Check connection
if ($conn->connect_error) {
    // Avoid showing sensitive error details
    echo json_encode(["error" => "Connection failed"]);
    exit;
}

// Handle preflight request (CORS)
if ($_SERVER['REQUEST_METHOD'] === 'OPTIONS') {
    exit(0); // Exit to handle preflight requests
}

// SQL Query to fetch all data from the `diary` table, sorted by `next_date`
$sql = "SELECT * FROM customers ORDER BY created_at DESC"; // Change ASC to DESC if you want the most recent first
$result = $conn->query($sql);

$diaryData = [];

// Check if there are any results
if ($result->num_rows > 0) {
    // Fetch all rows and push them into the $diaryData array
    while ($row = $result->fetch_assoc()) {
        $diaryData[] = $row;
    }

    // Return the data as a JSON response
    echo json_encode($diaryData);
} else {
    // If no data is found
    echo json_encode(["error" => "No records found"]);
}

// Close the connection
$conn->close();
?>
