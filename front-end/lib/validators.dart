import 'package:expshare/providers/experts.dart';
import 'package:provider/provider.dart';

String? numberValidator(value, context) {
  var language = Provider.of<Experts>(context, listen: false).language;
  if (value!.isEmpty) {
    return language == Language.english
        ? 'This field is required'
        : 'هذا الحقل مطلوب';
  }
  if (!RegExp(r'^[\+]?[(]?[0-9]{2,3}[)]?[-\s\.]?[0-9]{2,3}[-\s\.]?[0-9]{6,}$')
      .hasMatch(value)) {
    return language == Language.english
        ? 'Enter Valid phone number'
        : 'يرجى أدخال رقم صحيح';
  }
  return null;
}

String? priceValidator(value, context) {
  var language = Provider.of<Experts>(context, listen: false).language;
  if (value!.isEmpty) {
    return language == Language.english
        ? 'This field is required'
        : 'هذا الحقل مطلوب';
  }
  try {
    int.parse(value.trim());
  } catch (_) {
    return language == Language.english
        ? 'Enter a valid number'
        : 'الرقم المدخل يحتوي على احرف أو رموز غير مقبولة';
  }
  return null;
}

String? normalValidator(value, context) {
  var language = Provider.of<Experts>(context, listen: false).language;
  if (value!.isEmpty) {
    return language == Language.english
        ? 'This field is required'
        : 'هذا الحقل مطلوب';
  }

  return null;
}

String? emailValidator(value, context) {
  var language = Provider.of<Experts>(context, listen: false).language;
  if (value!.isEmpty) {
    return language == Language.english
        ? 'This field is required'
        : 'هذا الحقل مطلوب';
  } else if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
    return language == Language.english
        ? 'Valid Email Address'
        : 'صيغة البريد غير صحيحة';
  }
  return null;
}

String? passwordValidator(value, context) {
  var language = Provider.of<Experts>(context, listen: false).language;
  if (value!.isEmpty) {
    return language == Language.english
        ? 'This field is required'
        : 'هذا الحقل مطلوب';
  }
  if (value.trim().length < 8) {
    return language == Language.english
        ? 'password must be 8 charecters at least'
        : 'كلمة السر يجب ان تكون مكونة من 8 حروف على الأقل';
  }
  // if (value.isNotEmpty &&
  //     !RegExp(r'(?=.*[+=;:\",<>./?(){}|\\`~!@#$%^&*_-])(?=.*\d).*$')
  //         .hasMatch(value)) {
  //   return r'Password must contain at least one number and one symbol: () [] {} | \\ `~! @ # $% ^ & * _- + =;:\", <> ./? ';
  // }
  return null;
}
