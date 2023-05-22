import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:proyecto/bloc/moviebloc/movie_bloc.dart';
import 'package:proyecto/bloc/moviebloc/movie_bloc_event.dart';

class MoviesScreen extends StatefulWidget {
  @override
  _MoviesScreenState createState() => _MoviesScreenState();
}

class _MoviesScreenState extends State<MoviesScreen> {
  final TextEditingController messageController = TextEditingController();
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  void _logout() async {
    await auth.signOut();
    Navigator.pushNamed(context, '/');
  }

  void _sendMessage() async {
    String message = messageController.text;
    String? uid = auth.currentUser?.uid;

    if (message.isEmpty || uid == null) {
      // TODO: Show an error message
      return;
    }

    try {
      await firestore.collection('Mensajes').doc().set({
        'message': message,
        'uid': uid,
      });

      messageController.clear();
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<MovieBloc>(
          create: (_) => MovieBloc()..add(MovieEventStarted(0, '')),
        )
      ],
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: const Icon(
            Icons.menu,
            color: Colors.black45,
          ),
          title: Text(
            'Konie'.toUpperCase(),
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Colors.black45,
                fontSize: 20,
                fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
