import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

Widget _buildImageUploadButton(String label) {
  return OutlinedButton(
    onPressed: () {},
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Icon(Icons.camera_alt, color: Colors.grey),
            SizedBox(width: 8),
            Text(label, style: TextStyle(color: Colors.black)),
          ],
        ),
        Icon(Icons.chevron_right, color: Colors.grey),
      ],
    ),
    style: OutlinedButton.styleFrom(
      padding: EdgeInsets.symmetric(vertical: 16, horizontal: 12),
      side: BorderSide(color: Colors.grey.shade300),
    ),
  );
}

Widget buildBorderTextField(TextEditingController controller, String label,
    String hintText, bool obscureText) {
  return TextField(
    controller: controller,
    obscureText: obscureText,
    decoration: InputDecoration(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.0),
        borderSide: BorderSide(color: Color(0xFFE5E5E5)),
      ),
      labelText: label,
      labelStyle: TextStyle(color: Colors.black),
      floatingLabelBehavior: FloatingLabelBehavior.always,
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      contentPadding: EdgeInsets.all(10),
    ),
  );
}

Widget buildUnderlineTextField(TextEditingController controller, String label,
    String hintText, bool obscureText) {
  return TextField(
    controller: controller,
    obscureText: obscureText,
    decoration: InputDecoration(
      labelText: label,
      labelStyle: TextStyle(color: Colors.black, fontSize: 18),
      floatingLabelBehavior: FloatingLabelBehavior.always,
      contentPadding: EdgeInsets.only(top: 5),
      focusedBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: Colors.black),
      ),
      hintText: hintText,
      hintStyle: TextStyle(color: Colors.grey, fontSize: 12),
    ),
  );
}

Widget buildDateField(TextEditingController controller, BuildContext context) {
  return TextField(
    readOnly: true,
    controller: controller,
    decoration: const InputDecoration(
      // filled: true,
      labelText: 'วัน/เดือน/ปี เกิด',
      labelStyle: TextStyle(color: Colors.black),
      floatingLabelBehavior: FloatingLabelBehavior.always,
      contentPadding: EdgeInsets.only(top: 5),
      focusedBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: Colors.black),
      ),
      hintText: "DD/MM/YYYY",
      hintStyle: TextStyle(color: Colors.grey),
      suffixIcon: Icon(Icons.calendar_today),
    ),
    onTap: () async {
      DateTime? pickedDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(1900),
        lastDate: DateTime(2100),
      );
      if (pickedDate != null) {
        controller.text =
            "${pickedDate.day}/${pickedDate.month}/${pickedDate.year}";
      }
    },
  );
}

// class SelectOption extends StatefulWidget {
//   final List<String> options;
//   final String selectedProvince;
//   final String label;

//   SelectOption({
//     required this.options,
//     required this.selectedProvince,
//     required this.label,
//   });

//   @override
//   _SelectOptionState createState() => _SelectOptionState();
// }

// class _SelectOptionState extends State<SelectOption> {
//   late String _selectedProvince;

//   @override
//   void initState() {
//     super.initState();
//     _selectedProvince = widget.selectedProvince;

//     // Debugging statements
//     print('Selected Province: $_selectedProvince');
//     print('Options: ${widget.options}');
//   }

//   @override
//   Widget build(BuildContext context) {
//     // Check if the selectedProvince is in the options list
//     if (!widget.options.contains(_selectedProvince)) {
//       _selectedProvince = widget.options.isNotEmpty ? widget.options.first : '';
//     }

//     return DropdownButtonFormField<String>(
//       style: TextStyle(
//           color: const Color.fromARGB(255, 59, 59, 59),
//           fontSize: 12,
//           fontFamily: GoogleFonts.mitr().fontFamily),
//       decoration: InputDecoration(
//         labelStyle: TextStyle(color: Colors.black, fontSize: 18),
//         contentPadding: EdgeInsets.only(top: 5),
//         labelText: widget.label,
//         border: UnderlineInputBorder(),
//         focusedBorder: UnderlineInputBorder(
//           borderSide: BorderSide(color: Colors.black),
//         ),
//       ),
//       value: _selectedProvince,
//       items: widget.options.map((String province) {
//         return DropdownMenuItem<String>(
//           value: province,
//           child: Text(province),
//         );
//       }).toList(),
//       onChanged: (String? newValue) {
//         setState(() {
//           _selectedProvince = newValue!;
//         });
//       },
//     );
//   }
// }
class SelectOption extends StatelessWidget {
  final String label;
  final List<String> options;
  final String selectedValue;
  final ValueChanged<String?> onChanged;

  SelectOption({
    required this.label,
    required this.options,
    required this.selectedValue,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      style: TextStyle(
          color: const Color.fromARGB(255, 59, 59, 59),
          fontSize: 12,
          fontFamily: GoogleFonts.mitr().fontFamily),
      decoration: InputDecoration(
        contentPadding: EdgeInsets.only(top: 2),
        labelText: label,
        labelStyle: TextStyle(color: Colors.black, fontSize: 18),
        border: UnderlineInputBorder(),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.black),
        ),
      ),
      value: selectedValue,
      items: options.map((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
      onChanged: onChanged,
    );
  }
}
