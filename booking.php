<?php
header("Content-Type: application/json");
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: POST, GET, OPTIONS");
header("Access-Control-Allow-Headers: Content-Type, Authorization");

// Database credentials
$servername = "localhost";
$username = "root";
$password = "";
$dbname = "shri_durga";

// Create connection
$conn = new mysqli($servername, $username, $password, $dbname);

// Check connection
if ($conn->connect_error) {
    die(json_encode(["error" => "Database connection failed: " . $conn->connect_error]));
}

// Get the JSON input
$data = json_decode(file_get_contents("php://input"), true);

// Validate input
if (!$data) {
    echo json_encode(["error" => "Invalid input"]);
    exit;
}

// Assign data to variables with default null check
$dt = $data['dt'] ?? null;
$fname = $data['fname'] ?? null;
$mname = $data['mname'] ?? null;
$lname = $data['lname'] ?? null;
$ph = $data['ph'] ?? null;
$executive_name = $data['executive_name'] ?? null;
$manager_name = $data['manager_name'] ?? null;
$tel_name = $data['tel_name'] ?? null;
$p_mode = $data['p_mode'] ?? null;
$remark = $data['remark'] ?? null;
$nxt_dt = $data['nxt_dt'] ?? null;
$p_name = $data['p_name'] ?? null;
$sqft = $data['sqft'] ?? null;
$rate = $data['rate'] ?? null;
$book_amt = $data['book_amt'] ?? null;
$tamount = $data['tamount'] ?? null;
$balance = $data['balance'] ?? 0; // Default to 0 if not provided
$flt = $data['flt'] ?? 0;         // Default to 0 if not provided
$developer = $data['developer'] ?? null;
$mail = $data['mail'] ?? null;
$dob = $data['dob'] ?? null;
$occupation = $data['occupation'] ?? null;
$adhar = $data['adhar'] ?? null;
$nam = $data['nam'] ?? null;
$relation = $data['relation'] ?? null;
$raddress = $data['raddress'] ?? null;
$paddress = $data['paddress'] ?? null;
$layout = $data['layout'] ?? null;

// Check required fields are not empty
$required_fields = ['dt', 'fname', 'ph', 'executive_name', 'manager_name', 'tel_name', 'rate', 'book_amt', 'tamount', 'nxt_dt', 'sqft', 'p_name'];

foreach ($required_fields as $field) {
    if (empty($data[$field])) {
        echo json_encode(["error" => "Field '$field' is required"]);
        exit;
    }
}

// Prepare statements for each table
$stmt_booking = $conn->prepare("
    INSERT INTO booking_item_master 
    (dt, fname, mname, lname, ph, executive_name, manager_name, tel_name, p_mode, remark, nxt_dt, p_name, sqft, rate, book_amt, tamount) 
    VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
");
$stmt_booking->bind_param("ssssssssssssssss", $dt, $fname, $mname, $lname, $ph, $executive_name, $manager_name, $tel_name, $p_mode, $remark, $nxt_dt, $p_name, $sqft, $rate, $book_amt, $tamount);

$stmt_agent = $conn->prepare("
    INSERT INTO agent_master 
    (executive_name, manager_name, tel_name, fname, p_name, rate, book_amt, tamount, flt, dt) 
    VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
");
$stmt_agent->bind_param("ssssssssss", $executive_name, $manager_name, $tel_name, $fname, $p_name, $rate, $book_amt, $tamount, $flt, $dt);

$stmt_balance = $conn->prepare("
    INSERT INTO balance_master 
    (fname, p_name, rate, book_amt, tamount, balance, nxt_dt, ph) 
    VALUES (?, ?, ?, ?, ?, ?, ?, ?)
");
$stmt_balance->bind_param("ssssssss", $fname, $p_name, $rate, $book_amt, $tamount, $balance, $nxt_dt, $ph);

$stmt_customer = $conn->prepare("
    INSERT INTO booking_customer 
    (developer, fname, mname, lname, ph, mail, dob, occupation, adhar, nam, relation, raddress, paddress, executive_name, manager_name, tel_name, p_mode, remark, layout, nxt_dt, p_name) 
    VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
");
$stmt_customer->bind_param("sssssssssssssssssssss", $developer, $fname, $mname, $lname, $ph, $mail, $dob, $occupation, $adhar, $nam, $relation, $raddress, $paddress, $executive_name, $manager_name, $tel_name, $p_mode, $remark, $layout, $nxt_dt, $p_name);

// Transaction and execution as before
$conn->begin_transaction();
try {
    if (!$stmt_booking->execute()) throw new Exception("Error inserting into booking_item_master: " . $stmt_booking->error);
    if (!$stmt_agent->execute()) throw new Exception("Error inserting into agent_master: " . $stmt_agent->error);
    if (!$stmt_balance->execute()) throw new Exception("Error inserting into balance_master: " . $stmt_balance->error);
    if (!$stmt_customer->execute()) throw new Exception("Error inserting into booking_customer: " . $stmt_customer->error);

    $conn->commit();
    echo json_encode(["message" => "Form submitted successfully"]);
} catch (Exception $e) {
    $conn->rollback();
    echo json_encode(["error" => $e->getMessage()]);
}

// Close statements and connection
$stmt_booking->close();
$stmt_agent->close();
$stmt_balance->close();
$stmt_customer->close();
$conn->close();
?>
