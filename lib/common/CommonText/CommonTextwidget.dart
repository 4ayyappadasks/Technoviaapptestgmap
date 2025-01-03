import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CommonText extends StatelessWidget {
  final String text;
  final TextStyle? textStyle;
  final Color? color;
  final double? fontSize;
  final FontWeight? fontWeight;
  final FontStyle? fontStyle;
  final TextAlign? textAlign;
  final TextDecoration? textDecoration;
  final double? letterSpacing;
  final double? wordSpacing;
  final int? maxLines;
  final TextOverflow? overflow;

  const CommonText({
    Key? key,
    required this.text,
    this.textStyle,
    this.color,
    this.fontSize,
    this.fontWeight,
    this.fontStyle,
    this.textAlign,
    this.textDecoration,
    this.letterSpacing,
    this.wordSpacing,
    this.maxLines,
    this.overflow,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
      style: GoogleFonts.lato(
        textStyle: textStyle,
        color: color,
        fontSize: fontSize,
        fontWeight: fontWeight,
        fontStyle: fontStyle,
        decoration: textDecoration,
        letterSpacing: letterSpacing,
        wordSpacing: wordSpacing,
      ),
    );
  }
}
