<?php
header("Content-Type: application/json");
header("Access-Control-Allow-Origin: *"); // Allows requests from any origin
header("Access-Control-Allow-Methods: POST, GET, OPTIONS"); // Allowed methods
header("Access-Control-Allow-Headers: Content-Type, Authorization");

// Database credentials
$servername = "localhost";
$username = "root"; // Replace with your database username
$password = ""; // Replace with your database password
$dbname = "flutterdb"; // Replace with your database name

// Create connection
$conn = new mysqli($servername, $username, $password, $dbname);

// Check connection
if ($conn->connect_error) {
    die(json_encode(["error" => "Database connection failed: " . $conn->connect_error]));
}

// Get the JSON input
$data = json_decode(file_get_contents("php://input"), true);

if (!$data) {
    echo json_encode(["error" => "Invalid input"]);
    exit;
}

// Prepare the SQL statement
$stmt = $conn->prepare("
    INSERT INTO site_bookings 
    (developer, dt, fname, mname, lname, ph, mail, dob, occupation, adhar, nam, relation, address, 
    paddress, executive_name, manager_name, tel_name, p_mode, remark, layout, nxt_dt, p_name, 
    sqft_k, rate_k, book_amt_k, tamount_k) 
    VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
");

if (!$stmt) {
    echo json_encode(["error" => "Failed to prepare statement: " . $conn->error]);
    exit;
}

// Bind parameters
$stmt->bind_param(
    "ssssssssssssssssssssssssss",
    $data['developer'], $data['dt'], $data['fname'], $data['mname'], $data['lname'], $data['ph'], 
    $data['mail'], $data['dob'], $data['occupation'], $data['adhar'], $data['nam'], $data['relation'], 
    $data['address'], $data['paddress'], $data['executive_name'], $data['manager_name'], 
    $data['tel_name'], $data['p_mode'], $data['remark'], $data['layout'], $data['nxt_dt'], 
    $data['p_name'], $data['sqft_k'], $data['rate_k'], $data['book_amt_k'], $data['tamount_k']
);

// Execute the query
if ($stmt->execute()) {
    echo json_encode(["message" => "Form submitted successfully"]);
} else {
    echo json_encode(["error" => "Failed to insert data: " . $stmt->error]);
}

// Close the statement and connection
$stmt->close();
$conn->close();
?>
