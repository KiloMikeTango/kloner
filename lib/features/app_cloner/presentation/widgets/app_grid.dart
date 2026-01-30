// lib/features/app_cloner/widgets/app_grid.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kloner/features/app_cloner/domain/entities/app_entity.dart';
import 'package:kloner/features/app_cloner/presentation/bloc/app_cloner_bloc.dart';

class AppGrid extends StatelessWidget {
  const AppGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppClonerBloc, AppClonerState>(
      builder: (context, state) {
        if (state is! AppClonerLoaded) {
          return Container();
        }

        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 0.85,
          ),
          itemCount: state.apps.length,
          itemBuilder: (context, index) {
            final app = state.apps[index]; // ✅ Your AppEntity!

            // ✅ SAFE: Both are AppEntity - same structure
            final isCloned = state.clonedApps.any(
              (pkgname) => pkgname == app.packageName,
            );

            return AppCard(
              app: app,
              isCloned: isCloned,
              isCloning: state.isCloning,
              onClone: () => context.read<AppClonerBloc>().add(
                CloneAppEvent(app.packageName),
              ),
              onLaunch: () => _launchApp(context, app.packageName),
            );
          },
        );
      },
    );
  }

  void _launchApp(BuildContext context, String packageName) {
    debugPrint('🚀 Launching: $packageName');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('📱 Launching $packageName'),
        duration: const Duration(seconds: 2),
      ),
    );
  }
}



class AppCard extends StatelessWidget {
  final AppEntity app;
  final bool isCloned;
  final bool isCloning;
  final VoidCallback onClone;
  final VoidCallback onLaunch;

  const AppCard({
    super.key,
    required this.app,
    required this.isCloned,
    required this.isCloning,
    required this.onClone,
    required this.onLaunch,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isCloning ? null : onLaunch,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            // ✅ REAL App Icon from AppEntity
            Container(
              height: 50.h,
              width: 50.w,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: app.icon != null
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(12.r),
                      child: Image.memory(
                        app.icon!,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Icon(
                          Icons.android,
                          size: 24.sp,
                          color: Colors.grey,
                        ),
                      ),
                    )
                  : Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Colors.blue.shade400, Colors.blue.shade600],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: Icon(
                        _getAppIcon(app.packageName),
                        color: Colors.white,
                        size: 24.sp,
                      ),
                    ),
            ),
            SizedBox(height: 8.h),

            // ✅ REAL App Name from AppEntity
            Expanded(
              child: Text(
                app.appName.length > 12
                    ? '${app.appName.substring(0, 12)}...'
                    : app.appName,
                style: TextStyle(fontSize: 10.sp, fontWeight: FontWeight.w500),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),

            // ✅ Clone Button / Status
            if (!isCloned)
              Padding(
                padding: EdgeInsets.all(4.w),
                child: ElevatedButton(
                  onPressed: isCloning ? null : onClone,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(
                      horizontal: 8.w,
                      vertical: 4.h,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    textStyle: TextStyle(fontSize: 10.sp),
                  ),
                  child: isCloning
                      ? SizedBox(
                          width: 12.w,
                          height: 12.h,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: const AlwaysStoppedAnimation(
                              Colors.white,
                            ),
                          ),
                        )
                      : const Text('Clone'),
                ),
              )
            else
              Container(
                padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: Colors.green.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: const Icon(
                  Icons.check_circle,
                  size: 14,
                  color: Colors.green,
                ),
              ),
          ],
        ),
      ),
    );
  }

  IconData _getAppIcon(String packageName) {
    final lower = packageName.toLowerCase();
    if (lower.contains('whatsapp')) return Icons.message;
    if (lower.contains('telegram')) return Icons.chat;
    if (lower.contains('facebook')) return Icons.facebook;
    if (lower.contains('instagram')) return Icons.camera_alt;
    if (lower.contains('chrome')) return Icons.language;
    return Icons.apps;
  }
}
