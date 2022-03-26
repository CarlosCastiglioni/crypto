import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class TextStyles {
  static final baseTitle = GoogleFonts.lexendDeca(
    fontSize: 20,
    fontWeight: FontWeight.w300,
    color: AppColors.background,
  );
  static final selectionTitle = GoogleFonts.lexendDeca(
    fontSize: 20,
    fontWeight: FontWeight.w300,
    color: AppColors.dark,
  );
  static final title = GoogleFonts.lexendDeca(
    fontSize: 35,
    letterSpacing: -1.5,
    fontWeight: FontWeight.w600,
    color: AppColors.dark,
  );
  static final bigLabel = GoogleFonts.inter(
    fontSize: 26,
    fontWeight: FontWeight.w600,
    color: AppColors.grey,
  );
  static final smallLabel = GoogleFonts.inter(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: AppColors.grey,
  );
  static final titleRegular = GoogleFonts.lexendDeca(
    fontSize: 26,
    letterSpacing: -1.5,
    fontWeight: FontWeight.w400,
    color: AppColors.primary,
  );
  static final subtitleBold = GoogleFonts.lexendDeca(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: AppColors.primary,
  );
  static final subtitle = GoogleFonts.lexendDeca(
    fontSize: 20,
    fontWeight: FontWeight.w300,
    color: AppColors.label,
  );
  static final selection = GoogleFonts.lexendDeca(
    fontSize: 20,
    fontWeight: FontWeight.w300,
    color: AppColors.dark,
  );
  static final text = GoogleFonts.inter(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: AppColors.dark,
  );
  static final buttonPrimary = GoogleFonts.inter(
    fontSize: 24,
    fontWeight: FontWeight.w500,
    color: AppColors.background,
  );
  static final buttonSecondary = GoogleFonts.inter(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: AppColors.background,
  );
}
