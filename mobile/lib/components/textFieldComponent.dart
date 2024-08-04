import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Widget buildBorderTextField(TextEditingController controller, String label,String hintText, bool obscureText) {
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
Widget buildUnderlineTextField(TextEditingController controller, String label,String hintText, bool obscureText) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.black),
        floatingLabelBehavior: FloatingLabelBehavior.always,
        contentPadding: EdgeInsets.only(top:5),
        focusedBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: Colors.black),
      ),
  hintText: hintText,
  hintStyle: TextStyle(color: Colors.grey),
      ),
    );
  }

Widget buildDateField(TextEditingController controller, BuildContext context) {
    return TextField(
      readOnly: true,
      controller: controller,
      decoration:const InputDecoration(
        // filled: true,
        labelText: 'วัน/เดือน/ปี เกิด',
        labelStyle: TextStyle(color: Colors.black),
        floatingLabelBehavior: FloatingLabelBehavior.always,
        contentPadding: EdgeInsets.only(top:5),
        focusedBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: Colors.black),
      ),
      hintText: "DD/MM/YYYY",
      hintStyle: TextStyle(color: Colors.grey),
      suffixIcon: Icon(Icons.calendar_today),
      ),
      onTap: () async{
       DateTime? pickedDate = await showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime(1900),
              lastDate: DateTime(2100),
            ).then((date) {
          if (date != null) {
            controller.text = "${date.day}/${date.month}/${date.year}";
          }
        });
      },
    );
  }
