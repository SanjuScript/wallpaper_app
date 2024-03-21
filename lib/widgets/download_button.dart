import 'package:flutter/material.dart';

class DonwloadButton extends StatelessWidget {
  final void Function() onTap;
  final bool is1st;
  final String text;
  const DonwloadButton({super.key, required this.onTap, required this.is1st, required this.text});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return InkWell(
      onTap: onTap,
      child: Container(
        height: size.height / 18,
        width: is1st ? size.height * .25 : size.width * .70,
        decoration: BoxDecoration(
          color: const Color.fromARGB(128, 148, 138, 138),
          borderRadius: BorderRadius.circular(30),
          border: Border.all(width: 1, color: Colors.white),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(),
            Text(
              text,
              textAlign: TextAlign.center,
              style: const TextStyle(fontFamily: 'optica', color: Colors.white),
            ),
            const Icon(Icons.download, color: Colors.white),
          ],
        ),
      ),
    );
  }
}
