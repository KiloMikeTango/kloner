// lib/features/app_cloner/presentation/widgets/app_tile.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kloner/features/app_cloner/domain/entities/app_entity.dart';

class AppTile extends StatelessWidget {
  final AppEntity app;
  final bool isCloned;
  final bool isCloning;

  const AppTile({
    required this.app,
    this.isCloned = false,
    this.isCloning = false,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8.r,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // App Icon
          Expanded(
            child: Container(
              margin: EdgeInsets.only(bottom: 8.h),
              child: _buildAppIcon(),
            ),
          ),

          // App Name
          Text(
            app.appName,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold),
          ),

          SizedBox(height: 8.h),

          // Adaptive Button
          SizedBox(
            width: double.infinity,
            height: 32.h,
            child: ElevatedButton(
              onPressed: isCloning
                  ? null
                  : () {
                      // Trigger Bloc Event here
                    },
              style: ElevatedButton.styleFrom(
                backgroundColor: isCloned ? Colors.green : Colors.blue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.r),
                ),
                padding: EdgeInsets.zero,
              ),
              child: isCloning
                  ? SizedBox(
                      width: 12.w,
                      height: 12.w,
                      child: const CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : Text(
                      isCloned ? 'Cloned' : 'Clone',
                      style: TextStyle(fontSize: 11.sp, color: Colors.white),
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppIcon() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12.r),
      child: (app.icon != null && app.icon!.isNotEmpty)
          ? Image.memory(app.icon!)
          : Icon(Icons.android, size: 100.sp, color: Colors.green),
    );
  }
}
