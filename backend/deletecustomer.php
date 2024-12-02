<?php

header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: POST, OPTIONS");
header("Access-Control-Allow-Headers: Content-Type");
header('Content-Type: application/json');

include('db_connect.php');

// Check for a valid database connection
if (!$conn) {
    echo json_encode(["error" => "Database connection failed: " . $conn->connect_error]);
    exit;
}

// Check for POST method
if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    // Ensure 'id' is set in the POST data and is a valid integer
    if (isset($_POST['id']) && filter_var($_POST['id'], FILTER_VALIDATE_INT)) {
        $id = (int)$_POST['id']; // Explicitly cast to integer for extra safety

        // Check if the customer exists before deletion
        $checkStmt = $conn->prepare("SELECT * FROM customers WHERE id = ?");
        if ($checkStmt === false) {
            echo json_encode(["error" => "Failed to prepare SELECT statement: " . $conn->error]);
            exit;
        }

        $checkStmt->bind_param("i", $id);
        $checkStmt->execute();
        $result = $checkStmt->get_result();

        if ($result->num_rows > 0) {
            // Proceed with deletion if customer exists
            $stmt = $conn->prepare("DELETE FROM customers WHERE id = ?");
            if ($stmt === false) {
                echo json_encode(["error" => "Failed to prepare DELETE statement: " . $conn->error]);
                exit;
            }

            $stmt->bind_param("i", $id);

            if ($stmt->execute()) {
                echo json_encode(["success" => true, "message" => "Customer deleted successfully"]);
            } else {
                echo json_encode(["error" => "Failed to delete customer", "sqlError" => $stmt->error]);
            }

            $stmt->close();
        } else {
            echo json_encode(["error" => "Customer with the given ID does not exist"]);
        }

        $checkStmt->close();
    } else {
        echo json_encode(["error" => "Invalid or missing customer ID"]);
    }
} else {
    echo json_encode(["error" => "Invalid request method"]);
}

$conn->close();
?>
