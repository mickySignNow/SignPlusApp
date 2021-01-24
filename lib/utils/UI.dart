import 'package:flutter/material.dart';
import 'package:sign_plus/resources/color.dart';

class UIDesign {
  static TextFormField CreateScreenTextField(
      TextEditingController textControllerDate,
      Future<dynamic> Function() func,
      BuildContext context,
      bool isEditing,
      String hintText,
      String errText) {
    return TextFormField(
      textAlign: TextAlign.center,
      cursorColor: CustomColor.sea_blue,
      controller: textControllerDate,
      textCapitalization: TextCapitalization.characters,
      onTap: () => func(),
      readOnly: true,
      style: TextStyle(
        color: Colors.black87,
        fontWeight: FontWeight.bold,
        letterSpacing: 0.5,
      ),
      decoration: new InputDecoration(
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
          borderSide: BorderSide(color: CustomColor.sea_blue, width: 1),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
          borderSide: BorderSide(color: CustomColor.sea_blue, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
          borderSide: BorderSide(color: CustomColor.dark_blue, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
          borderSide: BorderSide(color: Colors.redAccent, width: 2),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
        ),
        contentPadding: EdgeInsets.only(
          left: 16,
          bottom: 16,
          top: 16,
          right: 16,
        ),
        hintText: hintText,
        hintStyle: TextStyle(
          color: Colors.grey.withOpacity(0.6),
          fontWeight: FontWeight.bold,
          letterSpacing: 0.5,
        ),
        errorText: isEditing && textControllerDate.text != null
            ? textControllerDate.text.isNotEmpty
                ? null
                : errText
            : null,
        errorStyle: TextStyle(
          fontSize: 12,
          color: Colors.redAccent,
        ),
      ),
    );
  }
}
