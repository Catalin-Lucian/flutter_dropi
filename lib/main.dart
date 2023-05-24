import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dropi/bloc/error/error_cubit.dart';
import 'package:flutter_dropi/bloc/main/main_bloc.dart';
import 'package:flutter_dropi/bloc/main/main_event.dart';
import 'package:flutter_dropi/repo/files_repo.dart';
import 'package:flutter_dropi/views/main_view.dart';

void main() {
  runApp(const MyApp());
}

// app that has a list view of folders and files
// on top
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MiniDrop',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
      ),
      home: RepositoryProvider(
        create: (_) => FilesRepo(),
        child: SafeArea(
          child: MultiBlocProvider(
            providers: [
              BlocProvider(
                create: (context) => ErrorCubit(),
              ),
              BlocProvider(
                create: (context) => MainBloc(
                    filesRepo: context.read<FilesRepo>(),
                    errorCubit: context.read<ErrorCubit>())
                  ..add(GetRoot())
                  ..add(GetRootContent()),
              ),
            ],
            child: BlocListener<ErrorCubit, String>(
              listener: (context, state) {
                // show error snackbar
                if (state.isNotEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(state),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
              child: MainView(),
            ),
          ),
        ),
      ),
    );
  }
}
