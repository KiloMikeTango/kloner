// lib/features/app_cloner/presentation/pages/home_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
      )..add(LoadApps()), // ✅ Auto-load apps
      child: BlocListener<AppClonerBloc, AppClonerState>(
        listener: (context, state) {
          if (state is AppClonerError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
                duration: const Duration(seconds: 3),
              ),
            );
          } else if (state is AppClonerLoaded && state.isCloning == false) {
            if (state.clonedApps.isNotEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Cloned ${state.clonedApps.length} apps!'),
                  backgroundColor: Colors.green,
                  duration: const Duration(seconds: 2),
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
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              return RefreshIndicator(
                onRefresh: () async => context.read<AppClonerBloc>().add(LoadApps()),
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: EdgeInsets.all(16.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
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
                      const AppGrid(), // ✅ AppGrid can now safely use context.read<AppClonerBloc>()
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
}
