import 'package:flutter_screenutil/flutter_screenutil.dart';

class Responsive {
  static bool get isMobile => ScreenUtil().screenWidth < 600;
  static bool get isTablet => ScreenUtil().screenWidth >= 600;
  
  static double get padding => isMobile ? 16.w : 24.w;
  static double get spacing => isMobile ? 12.w : 20.w;
  static double get elevation => isMobile ? 4.0 : 8.0;
}
