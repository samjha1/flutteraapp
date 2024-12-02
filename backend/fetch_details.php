<?php
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: POST, GET, OPTIONS");
header("Access-Control-Allow-Headers: Content-Type");
header("Content-Type: application/json");

// Database connection
$host = "localhost";
$username = "root";
$password = "";
$database = "flutterdb";

$conn = new mysqli($host, $username, $password, $database);

// Check connection and handle error gracefully
if ($conn->connect_error) {
    echo json_encode(['error' => "Connection failed: " . $conn->connect_error]);
    exit();
}

// Check if the 'name' parameter is set
if (isset($_GET['name'])) {
    $name = $conn->real_escape_string($_GET['name']);
    
    // Query to fetch details based on name
    $sql = "SELECT id, number FROM visitors WHERE full_name = '$name' LIMIT 1";
    $result = $conn->query($sql);

    if ($result && $result->num_rows > 0) {
        // Fetch the row and convert to JSON
        $data = $result->fetch_assoc();
        echo json_encode($data);
    } else {
        echo json_encode(['error' => 'No details found']);
    }
} else {
    echo json_encode(['error' => 'Name parameter missing']);
}

// Close the database connection
$conn->close();
?>
