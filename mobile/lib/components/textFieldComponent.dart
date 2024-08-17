import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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
    String hintText, bool obscureText, bool readOnly) {
  return TextField(
    readOnly: readOnly,
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
          value: value ?? '',
          child: Text(value),
        );
      }).toList(),
      onChanged: onChanged,
    );
  }
}

class buildImageUploadButton extends StatelessWidget {
  final String label;
  final Function() onPressed;

  buildImageUploadButton({
    required this.label,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      child: Text(label),
    );
  }
}

class CustomImageUploadButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final Widget? leadingIcon;
  final Widget? trailingIcon;

  const CustomImageUploadButton({
    Key? key,
    required this.label,
    required this.onPressed,
    this.leadingIcon,
    this.trailingIcon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(8),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                SizedBox(width: 12),
                leadingIcon ??
                    Icon(Icons.camera_alt, color: Colors.grey, size: 24),
                SizedBox(width: 40),
                Expanded(
                  child: Text(
                    label,
                    style: TextStyle(fontSize: 14, color: Colors.black87),
                  ),
                ),
                trailingIcon ??
                    Icon(Icons.chevron_right, color: Colors.grey, size: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
