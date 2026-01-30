// lib/features/app_cloner/presentation/widgets/app_grid.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kloner/features/app_cloner/domain/entities/app_entity.dart';
import '../bloc/app_cloner_bloc.dart';

class AppGrid extends StatelessWidget {
  const AppGrid({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppClonerBloc, AppClonerState>(
      builder: (context, state) {
        // ✅ Show loading skeleton for non-loaded states
        if (state is AppClonerLoading || state is! AppClonerLoaded) {
          return GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.85,
              crossAxisSpacing: 12.w,
              mainAxisSpacing: 12.h,
            ),
            itemCount: 6,
            itemBuilder: (context, index) => _buildSkeletonTile(),
          );
        }

        final apps = state.apps;
        if (apps.isEmpty) return const SizedBox();

        return LayoutBuilder(
          builder: (context, constraints) {
            int crossAxisCount = constraints.maxWidth > 600 ? 3 : 2;
            if (constraints.maxWidth > 900) crossAxisCount = 4;

            return GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossAxisCount,
                childAspectRatio: 0.85,
                crossAxisSpacing: 12.w,
                mainAxisSpacing: 12.h,
              ),
              itemCount: apps.length,
              itemBuilder: (context, index) {
                final app = apps[index];
                final isCloned = state.clonedApps.contains(app.packageName);
                // ✅ FIXED: Pass full state for per-app cloning
                return _buildAppTile(context, app, isCloned, state);
              },
            );
          },
        );
      },
    );
  }

  Widget _buildSkeletonTile() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Column(
        children: [
          Container(width: 48.w, height: 48.h, color: Colors.grey[300]),
          SizedBox(height: 12.h),
          Container(width: 80.w, height: 16.h, color: Colors.grey[300]),
          SizedBox(height: 12.h),
          Container(
            width: double.infinity,
            height: 32.h,
            color: Colors.grey[300],
          ),
        ],
      ),
    );
  }

  Widget _buildAppTile(
    BuildContext context,
    AppEntity app,
    bool isCloned,
    AppClonerState state,
  ) {
    // ✅ FIXED: Get per-app cloning state
    final isCloningThisApp = state is AppClonerLoaded
        ? state.cloningApps[app.packageName] ?? false
        : false;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10.r),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16.r),
          onTap: (isCloned || isCloningThisApp)
              ? null
              : () => _onCloneTap(context, app.packageName),
          child: Padding(
            padding: EdgeInsets.all(16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ✅ App Icon
                Container(
                  width: 48.w,
                  height: 48.h,
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: app.icon != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(12.r),
                          child: Image.memory(app.icon!, fit: BoxFit.cover),
                        )
                      : Icon(Icons.apps, size: 24.sp, color: Colors.grey[400]),
                ),
                SizedBox(height: 12.h),

                // ✅ App Name
                Expanded(
                  child: Text(
                    app.appName,
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),

                SizedBox(height: 8.h),

                // ✅ PERFECT BUTTON - Individual app states
                SizedBox(
                  width: double.infinity,
                  height: 36.h,
                  child: ElevatedButton(
                    onPressed: (isCloned || isCloningThisApp)
                        ? null
                        : () => _onCloneTap(context, app.packageName),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isCloned
                          ? Colors.green.shade500
                          : isCloningThisApp
                          ? Colors.orange.shade500
                          : Colors.blue.shade500,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      elevation: isCloned ? 0 : 2,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (isCloningThisApp)
                          SizedBox(
                            width: 16.w,
                            height: 16.h,
                            child: CircularProgressIndicator(
                              strokeWidth: 2.w,
                              color: Colors.white,
                            ),
                          )
                        else if (isCloned)
                          Icon(Icons.check, size: 16.sp)
                        else
                          Icon(Icons.copy, size: 16.sp),

                        SizedBox(width: 4.w),
                        Text(
                          isCloned
                              ? 'Cloned'
                              : isCloningThisApp
                              ? 'Cloning...'
                              : 'Clone',
                          style: TextStyle(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _onCloneTap(BuildContext context, String packageName) {
    context.read<AppClonerBloc>().add(CloneAppEvent(packageName));
  }
}
