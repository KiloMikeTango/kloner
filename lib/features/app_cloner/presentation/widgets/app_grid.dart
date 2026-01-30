// lib/features/app_cloner/presentation/widgets/app_grid.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../bloc/app_cloner_bloc.dart';
import 'app_tile.dart';

class AppGrid extends StatelessWidget {
  const AppGrid({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppClonerBloc, AppClonerState>(
      builder: (context, state) {
        if (state is AppClonerLoaded) {
          return LayoutBuilder(
            builder: (context, constraints) {
              // Dynamically calculate columns: 2 for phones, 3-4 for tablets
              int crossAxisCount = constraints.maxWidth > 600 ? 3 : 2;
              if (constraints.maxWidth > 900) crossAxisCount = 4;

              return GridView.builder(
                // Removed shrinkWrap for performance; using Sliver in Home instead
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: crossAxisCount,
                  childAspectRatio: 0.85, // Adjusted for vertical tile layout
                  crossAxisSpacing: 12.w,
                  mainAxisSpacing: 12.h,
                ),
                itemCount: state.apps.length,
                itemBuilder: (context, index) {
                  final app = state.apps[index];
                  return AppTile(
                    app: app,
                    isCloned: state.clonedApps.contains(app.packageName),
                    isCloning: state.isCloning,
                  );
                },
              );
            },
          );
        }
        return const SizedBox();
      },
    );
  }
}