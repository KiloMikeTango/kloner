// lib/features/app_cloner/presentation/pages/home_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kloner/core/services/shizuku_service.dart';
import 'package:kloner/features/app_cloner/domain/usecases/clone_app.dart';
import 'package:kloner/features/app_cloner/domain/usecases/get_installed_apps.dart';
import '../../../../core/di/injection_container.dart';
import '../bloc/app_cloner_bloc.dart';
import '../widgets/app_grid.dart';
import '../widgets/stats_card.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AppClonerBloc>(
      create: (context) => AppClonerBloc(
        getInstalledApps: sl<GetInstalledApps>(),
        cloneApp: sl<CloneApp>(),
      )..add(LoadApps()),
      child: BlocListener<AppClonerBloc, AppClonerState>(
        listener: (context, state) {
          if (state is AppClonerError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message), backgroundColor: Colors.red),
            );
          } else if (state is AppClonerLoaded && !state.isCloning) {
            if (state.clonedApps.isNotEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('✅ Cloned ${state.clonedApps.length} apps!'),
                  backgroundColor: Colors.green,
                ),
              );
            }
          }
        },
        child: Scaffold(
          backgroundColor: Colors.grey[50],
          appBar: AppBar(
            title: Text('Kloner', style: TextStyle(fontSize: 18.sp)),
            elevation: 0,
            backgroundColor: Colors.white,
            actions: [
              IconButton(
                icon: const Icon(Icons.refresh),
                onPressed: () => context.read<AppClonerBloc>().add(LoadApps()),
              ),
            ],
          ),
          body: BlocBuilder<AppClonerBloc, AppClonerState>(
            builder: (context, state) {
              if (state is AppClonerLoading) {
                return const Center(child: CircularProgressIndicator());
              }

              return RefreshIndicator(
                onRefresh: () async => context.read<AppClonerBloc>().add(LoadApps()),
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: EdgeInsets.all(16.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 🔥 SHIZUKU SETUP BANNER
                      _buildShizukuBanner(context),
                      SizedBox(height: 16.h),
                      
                      const StatsCard(),
                      SizedBox(height: 20.h),
                      
                      Text(
                        "Installed Apps",
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      SizedBox(height: 12.h),
                      const AppGrid(),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildShizukuBanner(BuildContext context) {
    return FutureBuilder<bool>(
      future: ShizukuService.isReady(),
      builder: (context, snapshot) {
        final isReady = snapshot.data ?? false;
        
        return Container(
          width: double.infinity,
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: isReady 
                  ? [Colors.green.shade400, Colors.green.shade600]
                  : [Colors.orange.shade400, Colors.red.shade400],
            ),
            borderRadius: BorderRadius.circular(20.r),
          ),
          child: Row(
            children: [
              Icon(
                isReady ? Icons.security : Icons.security_update_warning,
                color: Colors.white,
                size: 24.sp,
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      isReady ? '✅ Shizuku Ready!' : '🚀 Enable Real Cloning',
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    if (!isReady)
                      Text(
                        'Install Shizuku app for perfect clones',
                        style: TextStyle(fontSize: 12.sp, color: Colors.white),
                      ),
                  ],
                ),
              ),
              if (!isReady)
                ElevatedButton(
                  onPressed: () => _setupShizuku(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.orange.shade600,
                  ),
                  child: Text('Setup', style: TextStyle(fontSize: 12.sp)),
                ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _setupShizuku(BuildContext context) async {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '1. Install "Shizuku" from Play Store\n'
          '2. Start Shizuku (Wireless debugging)\n'
          '3. Tap "Setup" again',
        ),
        backgroundColor: Colors.orange,
        duration: Duration(seconds: 5),
        action: SnackBarAction(
          label: 'Open Shizuku',
          onPressed: () {
            // TODO: Open Shizuku app
          },
        ),
      ),
    );
  }
}
