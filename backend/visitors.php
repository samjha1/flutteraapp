<?php
header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json");
header("Access-Control-Allow-Methods: POST");
header("Access-Control-Allow-Headers: Content-Type, Access-Control-Allow-Headers, Authorization, X-Requested-With");

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $host = 'localhost';
    $dbname = 'flutterdb';
    $username = 'root';
    $password = '';

    try {
        // Initialize PDO connection
        $pdo = new PDO("mysql:host=$host;dbname=$dbname", $username, $password);
        $pdo->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);

        // Fetch POST data
        $data = $_POST;

        // Define required fields
        $required = ['full_name', 'mobile_no', 'location', 'appointment', 'email', 'company', 'visiting_for', 'message'];
        foreach ($required as $field) {
            if (empty($data[$field])) {
                echo json_encode(['error' => "$field is required"]);
                http_response_code(400);
                exit();
            }
        }

        // Prepare SQL query
        $sql = "INSERT INTO visitors (full_name, mobile_no, location, appointment, email, company, visiting_for, message) 
                VALUES (:full_name, :mobile_no, :location, :appointment, :email, :company, :visiting_for, :message)";
        $stmt = $pdo->prepare($sql);

        // Bind parameters
        $stmt->bindParam(':full_name', $data['full_name']);
        $stmt->bindParam(':mobile_no', $data['mobile_no']);
        $stmt->bindParam(':location', $data['location']);
        $stmt->bindParam(':appointment', $data['appointment']);
        $stmt->bindParam(':email', $data['email']);
        $stmt->bindParam(':company', $data['company']);
        $stmt->bindParam(':visiting_for', $data['visiting_for']);
        $stmt->bindParam(':message', $data['message']);

        // Execute query
        $stmt->execute();

        // Success response
        http_response_code(201);
        echo json_encode(['message' => 'Data submitted successfully']);
    } catch (PDOException $e) {
        // Internal server error
        http_response_code(500);
        echo json_encode(['error' => $e->getMessage()]);
    }
} else {
    // Method not allowed
    http_response_code(405);
    echo json_encode(['error' => 'Method not allowed']);
}
?>
