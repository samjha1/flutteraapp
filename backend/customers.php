<?php

header("Access-Control-Allow-Origin: *"); // Allow all origins
header("Access-Control-Allow-Methods: POST, OPTIONS"); // Allow POST and OPTIONS methods
header("Access-Control-Allow-Headers: Content-Type"); // Allow Content-Type header
header('Content-Type: application/json'); // Set content type to JSON

// Handle the OPTIONS request
if ($_SERVER['REQUEST_METHOD'] === 'OPTIONS') {
    http_response_code(200);
    exit();
}

// Database connection (adjust as necessary for your environment)
$host = 'localhost';
$dbname = 'flutterdb';
$username = 'root'; // Your database username
$password = ''; // Your database password

try {
    $pdo = new PDO("mysql:host=$host;dbname=$dbname", $username, $password);
    $pdo->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
} catch (PDOException $e) {
    echo json_encode(['error' => 'Database connection failed: ' . $e->getMessage()]);
    exit();
}

// Process the form data (POST method expected)
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    // Collect data
    $data = $_POST;

    // Validate the data (basic example)
    $required_fields = ['first_name', 'last_name', 'phone_no', 'mail_id', 'DOB', 'occupation', 'nominee', 'relationship', 'present_address', 'permanent_address', 'aadhar_no'];

    foreach ($required_fields as $field) {
        if (empty($data[$field])) {
            echo json_encode(['error' => "$field is required"]);
            exit();
        }
    }

    // Sanitize the inputs to prevent SQL injection
    $first_name = htmlspecialchars(trim($data['first_name']));
    $middle_name = htmlspecialchars(trim($data['middle_name']));
    $last_name = htmlspecialchars(trim($data['last_name']));
    $phone_no = htmlspecialchars(trim($data['phone_no']));
    $mail_id = htmlspecialchars(trim($data['mail_id']));
    $DOB = htmlspecialchars(trim($data['DOB']));
    $occupation = htmlspecialchars(trim($data['occupation']));
    $nominee = htmlspecialchars(trim($data['nominee']));
    $relationship = htmlspecialchars(trim($data['relationship']));
    $present_address = htmlspecialchars(trim($data['present_address']));
    $permanent_address = htmlspecialchars(trim($data['permanent_address']));
    $aadhar_no = htmlspecialchars(trim($data['aadhar_no']));
    $apartment_type = htmlspecialchars(trim($data['apartment_type'])); // Handle apartment type

    // Insert data into the database
    try {
        $sql = "INSERT INTO customers (first_name, middle_name, last_name, phone_no, mail_id, DOB, occupation, nominee, relationship, present_address, permanent_address, aadhar_no, apartment_type) 
                VALUES (:first_name, :middle_name, :last_name, :phone_no, :mail_id, :DOB, :occupation, :nominee, :relationship, :present_address, :permanent_address, :aadhar_no, :apartment_type)";

        $stmt = $pdo->prepare($sql);
        $stmt->execute([
            ':first_name' => $first_name,
            ':middle_name' => $middle_name,
            ':last_name' => $last_name,
            ':phone_no' => $phone_no,
            ':mail_id' => $mail_id,
            ':DOB' => $DOB,
            ':occupation' => $occupation,
            ':nominee' => $nominee,
            ':relationship' => $relationship,
            ':present_address' => $present_address,
            ':permanent_address' => $permanent_address,
            ':aadhar_no' => $aadhar_no,
            ':apartment_type' => $apartment_type
        ]);

        echo json_encode(['message' => 'Data submitted successfully']);
    } catch (PDOException $e) {
        echo json_encode(['error' => 'Database error: ' . $e->getMessage()]);
    }
} else {
    echo json_encode(['error' => 'Invalid request method']);
}
?>
