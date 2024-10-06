import 'package:flutter/material.dart';

class SiteBookingPage extends StatefulWidget {
  final String date;
  final String fullName;
  final String relation;
  final String dob;
  final String occupation;
  final String presentAddress;
  final String permanentAddress;
  final String relationship;
  final String mobileNo;
  final String nomineeName;
  final String chequeNo;
  final String drawnOn;
  final String layoutTitle;
  final String plotNo;
  final String plotSize;
  final String plotRate;
  final String paymentMode;
  final String paymentAmount;

  const SiteBookingPage({
    super.key,
    required this.date,
    required this.fullName,
    required this.relation,
    required this.dob,
    required this.occupation,
    required this.presentAddress,
    required this.permanentAddress,
    required this.relationship,
    required this.mobileNo,
    required this.nomineeName,
    required this.chequeNo,
    required this.drawnOn,
    required this.layoutTitle,
    required this.plotNo,
    required this.plotSize,
    required this.plotRate,
    required this.paymentMode,
    required this.paymentAmount,
  });

  @override
  _SiteBookingPageState createState() => _SiteBookingPageState();
}

class _SiteBookingPageState extends State<SiteBookingPage> {
  static int _applicationNo = 1000; // Starting application number

  @override
  void initState() {
    super.initState();
    _incrementApplicationNumber(); // Increment application number locally
  }

  void _incrementApplicationNumber() {
    setState(() {
      _applicationNo += 1;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Application for Booking'),
        backgroundColor: Colors.blue.shade900,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                decoration: BoxDecoration(
                  color: Colors.blue.shade100,
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Text(
                  'APPLICATION FOR BOOKING',
                  style: TextStyle(
                    color: Color(0xFFDD581B),
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Application No and Date
              Container(
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildFormGroup(
                        'Application No.:',
                        _applicationNo
                            .toString()), // Display auto-incremented application no.
                    _buildFormGroup('DATE:', widget.date),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Personal Information
              _buildInfoSection('PERSONAL INFORMATION', [
                _buildFormGroup('Smt/Shri:', widget.fullName),
                _buildFormGroup('S/o D/o W/o:', widget.relation),
                _buildFormGroup('DOB:', widget.dob),
                _buildFormGroup('Occupation:', widget.occupation),
                _buildFormGroup('Present Address:', widget.presentAddress),
                _buildFormGroup('Permanent Address:', widget.permanentAddress),
                _buildFormGroup('Relationship:', widget.relationship),
                _buildFormGroup('Mobile No:', widget.mobileNo),
              ]),

              const SizedBox(height: 20),

              // Company Information
              _buildInfoSection('COMPANY INFORMATION', [
                _buildFormGroup('Name of the Nominee:', widget.nomineeName),
                _buildFormGroup('Draft/Cheque No:', widget.chequeNo),
                _buildFormGroup('Drawn on:', widget.drawnOn),
                _buildFormGroup(
                    'Title of the layout/apartment:', widget.layoutTitle),
              ]),

              const SizedBox(height: 20),

              // Plot Information
              _buildInfoSection('PLOT INFORMATION', [
                _buildFormGroup('Flat/Plot No:', widget.plotNo),
                _buildFormGroup('Size (Flat/Plot):', widget.plotSize),
                _buildFormGroup('Rate (Flat/Plot per Sq.ft):', widget.plotRate),
              ]),

              const SizedBox(height: 20),

              // Payment Details
              _buildInfoSection('PAYMENT DETAILS', [
                _buildPaymentDetails(widget.paymentMode, widget.paymentAmount),
              ]),

              const SizedBox(height: 20),
              const Divider(color: Color(0xFFDD581B), thickness: 1.0),
              const Text(
                'Declaration: I/We read and understood the rules & regulations & abide by the same. The information furnished above is true & correct to the best of my knowledge.',
                style: TextStyle(fontSize: 16.0),
              ),

              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: _buildSignatures(),
              ),

              const SizedBox(height: 20),
              const Divider(color: Color(0xFFDD581B), thickness: 1.0),
              _buildFooter(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoSection(String title, List<Widget> fields) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader(title),
          const SizedBox(height: 10),
          ...fields,
        ],
      ),
    );
  }

  Widget _buildFormGroup(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 16.0),
          ),
          const SizedBox(height: 5),
          TextFormField(
            initialValue: value,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              contentPadding:
                  EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            ),
            readOnly: true,
            style: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentDetails(String mode, String amount) {
    return Table(
      border: TableBorder.all(color: Colors.grey),
      columnWidths: const {
        0: FlexColumnWidth(1),
        1: FlexColumnWidth(3),
        2: FlexColumnWidth(2),
      },
      children: [
        TableRow(children: [
          _buildTableCell('SL. NO', isHeader: true),
          _buildTableCell('MODE OF PAYMENT', isHeader: true),
          _buildTableCell('AMOUNT IN RS.', isHeader: true),
        ]),
        TableRow(children: [
          _buildTableCell('1'),
          _buildTableCell(mode),
          _buildTableCell(amount),
        ]),
        TableRow(children: [
          _buildTableCell('2'),
          _buildTableCell(''),
          _buildTableCell(''),
        ]),
      ],
    );
  }

  Widget _buildTableCell(String text, {bool isHeader = false}) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontWeight: isHeader ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    );
  }

  Widget _buildSignatures() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildSignature('Signature of the Applicant'),
        _buildSignature('Signature of the Marketing Manager'),
      ],
    );
  }

  Widget _buildSignature(String label) {
    return Column(
      children: [
        Container(
          width: 150.0,
          height: 50.0,
          decoration: const BoxDecoration(
            border: Border(
              top: BorderSide(color: Colors.black, width: 1.0),
            ),
          ),
        ),
        const SizedBox(height: 5),
        Text(label, textAlign: TextAlign.center),
      ],
    );
  }

  Widget _buildFooter() {
    return const Text(
      'Tel: 0836-3552773 | Email: info@shridurgadevelopers.com\nWebsite: www.shridurgadevelopers.in\nOffice: #2A, Upper Ground Floor, Gurudev Landmark, Hubballi-580021',
      textAlign: TextAlign.center,
      style: TextStyle(fontSize: 14.0, color: Colors.grey),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 18.0,
        ),
      ),
    );
  }
}
