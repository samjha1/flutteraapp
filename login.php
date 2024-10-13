<?php
// Set headers to allow CORS (Cross-Origin Resource Sharing) and specify allowed methods
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: POST");
header("Access-Control-Allow-Headers: Content-Type");

// Include your database connection file
include("dbconnection.php");
$con = dbconnection();

// Check if the request method is POST
if ($_SERVER['REQUEST_METHOD'] === 'POST') {

    // Check if username and password are provided in the POST request
    if (isset($_POST["username"]) && isset($_POST["password"])) {
        $username = $_POST["username"];
        $password = $_POST["password"];

        // Prepare the SQL query to check if the user exists
        $query = "SELECT `password` FROM `users` WHERE `username` = ?";
        $stmt = $con->prepare($query);

        if ($stmt) {
            // Bind the username parameter to the query
            $stmt->bind_param("s", $username);
            $stmt->execute();
            $stmt->store_result();

            // If a user is found with the given username
            if ($stmt->num_rows > 0) {
                $stmt->bind_result($stored_password);
                $stmt->fetch();

                // Compare the plain text password directly (since it's stored as plain text in the database)
                if ($password === $stored_password) {
                    $response = [
                        "success" => "true",
                        "message" => "Login successful."
                    ];
                } else {
                    $response = [
                        "success" => "false",
                        "message" => "Invalid username or password."
                    ];
                }
            } else {
                $response = [
                    "success" => "false",
                    "message" => "Invalid username or password."
                ];
            }

            // Close the statement
            $stmt->close();
        } else {
            // If the query fails, return a query error response
            $response = [
                "success" => "false",
                "message" => "Database query error."
            ];
        }
    } else {
        // If username or password is not provided in the request
        $response = [
            "success" => "false",
            "message" => "Username and password are required."
        ];
    }
} else {
    // If the request method is not POST, return an error
    $response = [
        "success" => "false",
        "message" => "Invalid request method."
    ];
}

// Return the response in JSON format
header('Content-Type: application/json');
echo json_encode($response);
?>
