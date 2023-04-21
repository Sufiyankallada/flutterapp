import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:oru_app/screens/homepage.dart';

TextField reusableTextField(String text, IconData icon, bool isPassword,
    TextEditingController controller) {
  return TextField(
    controller: controller,
    obscureText: isPassword,
    enableSuggestions: !isPassword,
    autocorrect: !isPassword,
    cursorColor: Colors.black,
    style: TextStyle(color: Colors.black.withOpacity(0.9)),
    decoration: InputDecoration(
      prefixIcon: Icon(
        icon,
        color: Colors.black87,
      ),
      hintText: text,
      labelText: text,
      labelStyle: TextStyle(
        color: Colors.black.withOpacity(0.9),
      ),
      filled: true,
      floatingLabelBehavior: FloatingLabelBehavior.never,
      fillColor: Colors.white.withOpacity(0.3),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30),
        borderSide: const BorderSide(width: 1, style: BorderStyle.none),
      ),
    ),
    keyboardType:
        isPassword ? TextInputType.visiblePassword : TextInputType.emailAddress,
  );
}

Container signInSignUpButton(
    String text, BuildContext context, Function onTap) {
  return Container(
    width: MediaQuery.of(context).size.width,
    height: 50,
    margin: const EdgeInsets.fromLTRB(0, 10, 0, 20),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(90),
    ),
    child: ElevatedButton(
      onPressed: () {
        onTap();
      },
      style: ButtonStyle(
          backgroundColor: MaterialStateProperty.resolveWith((states) {
            if (states.contains(MaterialState.pressed)) {
              return Colors.black26;
            }
            return Color.fromARGB(255, 63, 93, 118);
          }),
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
          )),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
      ),
    ),
  );
}

Container buttons(BuildContext context, String text, Function onTap) {
  return Container(
    width: MediaQuery.of(context).size.width,
    height: 50,
    margin: const EdgeInsets.fromLTRB(0, 10, 0, 20),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(90),
    ),
    child: ElevatedButton(
      onPressed: () {
        onTap();
      },
      style: ButtonStyle(
          backgroundColor: MaterialStateProperty.resolveWith((states) {
            if (states.contains(MaterialState.pressed)) {
              return Colors.white;
            }
            return Color.fromARGB(255, 63, 93, 118);
          }),
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
          )),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
      ),
    ),
  );
}

Card GB(String text, IconData iconss, Function() onTap) {
  return Card(
    elevation: 3,
    child: GridButton(
        color: Colors.blue[50]!,
        icon: iconss,
        label: text,
        onPressed: () {
          onTap();
        }),
  );
}

TextField reusableTextField2(
    String text, IconData icon, TextEditingController controller) {
  return TextField(
    controller: controller,
    cursorColor: Colors.black,
    style: TextStyle(color: Colors.black.withOpacity(0.9)),
    decoration: InputDecoration(
      prefixIcon: Icon(
        icon,
        color: Colors.black87,
      ),
      hintText: text,
      labelStyle: TextStyle(
        color: Colors.black.withOpacity(0.9),
      ),
      filled: true,
      floatingLabelBehavior: FloatingLabelBehavior.never,
      fillColor: Colors.white.withOpacity(0.3),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30),
        borderSide: const BorderSide(width: 1, style: BorderStyle.none),
      ),
    ),
  );
}

TextField numberTextFeild(
    String text, bool isPurity, TextEditingController controller) {
  return TextField(
    controller: controller,
    cursorColor: Colors.black,
    style: TextStyle(
      color: Colors.black.withOpacity(0.9),
    ),
    decoration: InputDecoration(
      hintText: text,
      labelStyle: TextStyle(
        color: Colors.black.withOpacity(0.9),
      ),
      filled: true,
      floatingLabelBehavior: FloatingLabelBehavior.never,
      fillColor: Colors.white.withOpacity(0.3),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30),
        borderSide: const BorderSide(width: 1, style: BorderStyle.none),
      ),
    ),
    keyboardType: const TextInputType.numberWithOptions(decimal: true),
    inputFormatters: [
      FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
      // Restrict input to 0 to 100
      isPurity
          ? TextInputFormatter.withFunction((oldValue, newValue) {
              final double? parsedValue = double.tryParse(newValue.text);
              if (parsedValue != null) {
                if (parsedValue < 0) {
                  return oldValue.copyWith(text: '0');
                } else if (parsedValue > 100) {
                  return oldValue.copyWith(text: '100');
                }
              }
              return newValue;
            })
          : TextInputFormatter.withFunction((oldValue, newValue) {
              final double? parsedValue = double.tryParse(newValue.text);

              return newValue;
            }),
    ],
  );
}

TextField numberTextFeildWithIcon(String text, bool isPurity,
    TextEditingController controller, IconData icon) {
  return TextField(
    controller: controller,
    cursorColor: Colors.black,
    style: TextStyle(
      color: Colors.black.withOpacity(0.9),
    ),
    decoration: InputDecoration(
      prefixIcon: Icon(
        icon,
        color: Colors.black87,
      ),
      hintText: text,
      labelStyle: TextStyle(
        color: Colors.black.withOpacity(0.9),
      ),
      filled: true,
      floatingLabelBehavior: FloatingLabelBehavior.never,
      fillColor: Colors.white.withOpacity(0.3),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30),
        borderSide: const BorderSide(
          width: 1,
          style: BorderStyle.none,
        ),
      ),
    ),
    keyboardType: const TextInputType.numberWithOptions(decimal: true),
    inputFormatters: [
      FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
      // Restrict input to 0 to 100
      isPurity
          ? TextInputFormatter.withFunction((oldValue, newValue) {
              final double? parsedValue = double.tryParse(newValue.text);
              if (parsedValue != null) {
                if (parsedValue < 0) {
                  return oldValue.copyWith(text: '0');
                } else if (parsedValue > 100) {
                  return oldValue.copyWith(text: '100');
                }
              }
              return newValue;
            })
          : TextInputFormatter.withFunction((oldValue, newValue) {
              final double? parsedValue = double.tryParse(newValue.text);

              return newValue;
            }),
    ],
  );
}
