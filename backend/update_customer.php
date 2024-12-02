<?php

header("Access-Control-Allow-Origin: *"); // Allow all origins
header("Access-Control-Allow-Methods: POST, OPTIONS"); // Allow POST and OPTIONS methods
header("Access-Control-Allow-Headers: Content-Type"); // Allow Content-Type header
header('Content-Type: application/json'); // Set content type to JSON

// Include the database connection
include('db_connect.php');

// Check if the request method is POST
if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    // Get the posted data from the form
    $id = $_POST['id'];
    $first_name = $_POST['first_name'];
    $middle_name = $_POST['middle_name'];
    $last_name = $_POST['last_name'];
    $phone_no = $_POST['phone_no'];
    $email = $_POST['mail_id'];
    $dob = $_POST['DOB'];
    $occupation = $_POST['occupation'];
    $nominee = $_POST['nominee'];
    $relationship = $_POST['relationship'];
    $present_address = $_POST['present_address'];
    $permanent_address = $_POST['permanent_address'];
    $aadhar_no = $_POST['aadhar_no'];
    $apartment_type = $_POST['apartment_type'];

    // Validate input data to avoid SQL injection
    $first_name = $conn->real_escape_string($first_name);
    $middle_name = $conn->real_escape_string($middle_name);
    $last_name = $conn->real_escape_string($last_name);
    $phone_no = $conn->real_escape_string($phone_no);
    $email = $conn->real_escape_string($email);
    $dob = $conn->real_escape_string($dob);
    $occupation = $conn->real_escape_string($occupation);
    $nominee = $conn->real_escape_string($nominee);
    $relationship = $conn->real_escape_string($relationship);
    $present_address = $conn->real_escape_string($present_address);
    $permanent_address = $conn->real_escape_string($permanent_address);
    $aadhar_no = $conn->real_escape_string($aadhar_no);
    $apartment_type = $conn->real_escape_string($apartment_type);

    // SQL query to update the customer record
    $sql = "UPDATE customers SET 
            first_name = '$first_name', 
            middle_name = '$middle_name', 
            last_name = '$last_name', 
            phone_no = '$phone_no', 
            mail_id = '$email', 
            DOB = '$dob', 
            occupation = '$occupation', 
            nominee = '$nominee', 
            relationship = '$relationship', 
            present_address = '$present_address', 
            permanent_address = '$permanent_address', 
            aadhar_no = '$aadhar_no', 
            apartment_type = '$apartment_type' 
            WHERE id = '$id'";

    // Execute the query
    if ($conn->query($sql) === TRUE) {
        // Successfully updated customer details
        echo json_encode(["success" => true, "message" => "Customer updated successfully"]);
    } else {
        // Failed to update customer details
        echo json_encode(["error" => "Failed to update customer: " . $conn->error]);
    }

    // Close the connection
    $conn->close();
} else {
    // If not a POST request
    echo json_encode(["error" => "Invalid request method"]);
}
?>
