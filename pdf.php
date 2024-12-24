<?php
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: GET, OPTIONS");
header("Access-Control-Allow-Headers: Content-Type");

require_once('./dompdf/autoload.inc.php');
use Dompdf\Dompdf;
use Dompdf\Options;

// Database configuration
$host = 'localhost';
$username = 'root';
$password = '';
$database = 'u673831287_shridurgadb_qa';

// Use mysqli prepared statements to prevent SQL injection
$conn = new mysqli($host, $username, $password, $database);
if ($conn->connect_error) {
    die("Database connection failed: " . $conn->connect_error);
}

$imageData = base64_encode(file_get_contents('img/durga4.png'));
$imageDatas = base64_encode(file_get_contents('img/durga4.png'));

// Get bill number from the request
$bill_no = $_REQUEST['bill_no'];

// Fetch data from `booking_master`
$result_master = mysqli_query($conn, "SELECT * FROM booking_customer WHERE bill_no='$bill_no'");
$row_master = mysqli_fetch_array($result_master);

// Fetch data from `booking_item_master`
$result_item = mysqli_query($conn, "SELECT * FROM booking_item_master WHERE bill_no='$bill_no'");
$row_item = mysqli_fetch_array($result_item);




// Fetch terms and conditions from the `terms_conditions` table
$qry = $conn->query("SELECT * FROM terms_conditions")->fetch_array();
$terms = isset($qry['terms']) ? $qry['terms'] : '';

// Split terms into an array of lines
$terms_lines = array_filter(array_map('trim', explode("\n", $terms)));

// Calculate age from the date of birth
$birth_date = $row_master['dob'];
$current_date = date('Y-m-d');
$birth_date_obj = new DateTime($birth_date);
$current_date_obj = new DateTime($current_date);
$diff = $current_date_obj->diff($birth_date_obj);
$age_years = $diff->y;

// Format the date of birth
$date = date_create($row_master['dob']);
$formatted_dob = date_format($date, "d/m/Y");

// HTML content with dynamic PHP data
$html = '
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    
    <title>Application for Booking</title>
    <style>
        .booking-form-container {
            font-family: Arial, sans-serif;
            background-color: white;
            padding: 20px;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
            border: 1px solid #ccc;
        }
        h1 {
            color: #2777c7;
            font-size: 30px;
            font-weight: bold;
        }
        label {
            width: 180px;
            display: inline-block;
        }
        input[type="text"] {
            border: 1px solid #010a14;
            padding: 5px;
            font-size: 14px;
            font-weight: bold;
        }
        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
        }
        table, th, td {
            border: 1px solid #ccc;
            padding: 10px;
        }
        .signature {
            float:left;
            border-top: 1px solid #010a14;
            text-align: center;
            padding-top: 10px;
        }
        .signature1 {
            float:right;
            border-top: 1px solid #010a14;
            text-align: center;
            padding-top: 10px;
        }
        footer {
            margin-top: 20px;
            text-align: center;
            font-size: 14px;
        }
       .header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 20px;
        }
        .header h1 {
            margin: 0;
            color: #dd581b;
            font-size: 30px;
            font-weight: bold;
            margin-top: 20px;
        }
        .header img {
            height: 170px;
        }

    </style>
</head>
<body>
    <div class="booking-form-container">
     
        

     <header class="header" style="display: flex; justify-content: space-between; margin-bottom: 20px;">
    <div>
        <h1 style="margin: 0; color: #1e3f66; font-size: 30px; font-weight: bold; margin-top: 20px;">APPLICATION FOR BOOKING</h1>
    </div>
    <div>
        <img src="data:image/png;base64,' . $imageData . '" height="200px" style="float: right; margin-top:-100px;">
        
    </div>
</header>

        <div class="application-number">
            <span><b>Application No:</b></span> <span>' . $row_master['bill_no'] . '</span>
        </div>

                <div class="application-number" style="float:right; margin-top:-20px;">
             <span><b>Date:</b></span> <span>' . $row_master['dt'] . '</span>
        </div>
        <br><br>

        <div class="form-group">
        
            <label>Smt/Shri:</label>
            <input type="text" value="' . htmlspecialchars($row_master['fname'] . ' ' . $row_master['mname'] . ' ' . $row_master['lname']) . '" style="width:290px;" readonly>
        </div>

        <div class="form-group">
            <label>S/o D/o W/o:</label>
            <input type="text" value="' . htmlspecialchars($row_master['mname'] . ' ' . $row_master['lname']) . '" style="width:290px;" readonly>
        </div>

        <div class="form-group">
            <label>Date of Birth:</label>
            <input type="text" value="' . $formatted_dob . '" style="width:290px;" readonly>
        </div>

        <div class="form-group">
            <label>Age:</label>
            <input type="text" value="' . $age_years . '" style="width:290px;" readonly>
        </div>

        <div class="form-group">
            <label>Occupation:</label>
            <input type="text" value="' . $row_master['occupation'] . '" style="width:290px;" readonly>
        </div>

        <div class="form-group">
            <label>Present Address:</label>
            <input type="text" value="' . $row_master['raddress'] . '" style="width:290px;" readonly>
        </div>

        <div class="form-group">
            <label>Permanent Address:</label>
            <input type="text" value="' . $row_master['paddress'] . '" style="width:290px;" readonly>
        </div>

        <div class="form-group">
            <label>Nominee:</label>
            <input type="text" value="' . $row_master['nam'] . '" style="width:290px;" readonly>
        </div>

        <div class="form-group">
            <label>Relationship:</label>
            <input type="text" value="' . $row_master['relation'] . '" style="width:290px;" readonly>
        </div>

        <div class="form-group">
            <label>Draft/Cheque No:</label>
            <input type="text" value="' . $row_master['p_mode'] . '" style="width:290px;" readonly>
        </div>

        <div class="form-group">
            <label>Drawn on:</label>
            <input type="text" value="' . $row_master['remark'] . '" style="width:290px;" readonly>
        </div>

        <div class="form-group">
            <label>Flat/Plot No:</label>
            <input type="text" value="' . $row_item['flt'] . '" style="width:290px;" readonly>
        </div>

        <div class="form-group">
            <label>Size (Flat/Plot):</label>
            <input type="text" value="' . $row_item['sqft'] . '" style="width:290px;" readonly>
        </div>

        <div class="form-group">
            <label>Rate (Flat/Plot/Sq.ft):</label>
            <input type="text" value="' . $row_item['rate'] . '" style="width:290px;" readonly>
        </div>

        <div class="form-group">
            <label>Mobile No:</label>
            <input type="text" value="' . $row_item['ph'] . '" style="width:290px;" readonly>
        </div>

        <div class="payment-details">
            <table>
                <tr>
                    <th style="background-color:#4682B4;color:white">SL. NO</th>
                    <th style="background-color:#4682B4; color:white">MODE OF PAYMENT</th>
                    <th style="background-color:#4682B4; color:white">AMOUNT IN RS.</th>
                </tr>
                <tr>
                    <td>1</td>
                    <td>' . $row_item['remark'] . '</td>
                    <td>' . $row_item['book_amt'] . '.00</td>
                </tr>
            </table>
        </div>

        <p><b>Declaration:</b> I/We have read and understood the rules & regulations and abide by the same.</p>
        <br><br>

        <div class="signatures">
            <div class="signature">Signature of the Applicant</div>
             <div>
        <img src="data:image/png;base64,' . $imageDatas . '" height="50px" style="float: right; margin-top:-55px; margin-right:55px; ">
        
    </div>
           
            <div class="signature1">Signature of the Manager</div>
        </div>
      

        <footer>
        <br>
          <hr>
            <p><b>#No 2A Upper Ground Floor Gurudev Landmark Near More Bazar Vidyanagar Hubballi Karnataka 580-021</b></p>
        </footer>
    </div>
   
<ul>


</body>
</html>


 <div class="booking-form-container">
      

 
        <h1 STYLE="align-content: left; margin-left: 3%; color: #1e3f66;s">TERMS AND CONDITIONS:</h1>
      
        <ul>
            <div>
               <ul class="terms-list">';

foreach ($terms_lines as $line) {
    $html .= '<li>' . htmlspecialchars($line) . '</li>';
}

$html .= '
        </ul>
            </div>
            <br>
                
<table width="100%" style="border-collapse: collapse; border: none; margin: 0; padding: 0; table-layout: fixed;">
    <tr>
    
       
        <td style="border: none; padding: 10px; vertical-align: top; text-align: center; color: #333; ">
        <br><br><br>
        <hr>
            <div>Applicant Name and Signature</div>
        </td>

   
        <td style="border: none; padding: 10px; vertical-align: top; text-align: center; color: #333;">
        <br><br><br>
         <hr>
            <div>General Manager of Marketing Name & Signature</div>
        </td>


       
        <td style="border: none; padding: 10px; vertical-align: top; text-align: center; color: #333;">
                                                        <div>
                                               <img src="data:image/png;base64,' . $imageDatas . '" height="50px" style="float: right; margin-top:10px; margin-right:65px; ">
                                            
                                        </div>
        <br><br><br>
         <hr>
            <div>Authorised Signatory Name & Signature</div>
        </td>
    </tr>
</table>




';
// DOMPDF setup with error handling
try {
    $options = new Options();
    $options->set('defaultFont', 'Courier');
    $options->set('isHtml5ParserEnabled', true);
    $options->set('isPhpEnabled', true);
    
    $dompdf = new Dompdf($options);
    $dompdf->loadHtml($html);
    $dompdf->setPaper('A4', 'portrait');
    $dompdf->render();

    // Stream the PDF
    $dompdf->stream("booking_$bill_no.pdf", array('Attachment' => 0));

    // Save the generated PDF
    $pdf_output = $dompdf->output();
    file_put_contents("$upload_dir/booking_$bill_no.pdf", $pdf_output);
} catch (Exception $e) {
    error_log("PDF Generation Error: " . $e->getMessage());
    die("Error generating PDF. Please try again later.");
}

// Close database connections
$stmt_master->close();
$stmt_item->close();
$conn->close();
?>
