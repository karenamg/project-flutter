import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:proyecto/bloc/moviebloc/movie_bloc.dart';
import 'package:proyecto/bloc/moviebloc/movie_bloc_state.dart';
import 'package:proyecto/models/movie.dart';

import '../bloc/moviebloc/movie_bloc_event.dart';

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
            create: (_) => MovieBloc()
              ..add(const MovieEvent.started(movieId: 0, query: '')))
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
        body: _buildBody(context),
      ),
    );
  }
}

Widget _buildBody(BuildContext context) {
  return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
    return SingleChildScrollView(
      child: ConstrainedBox(
        constraints: BoxConstraints(minHeight: constraints.maxHeight),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            BlocBuilder<MovieBloc, MovieState>(builder: (context, state) {
              return state.when(
                loading: () {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                },
                loaded: (movies) {
                  print(movies.length);
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CarouselSlider.builder(
                        itemCount: movies.length,
                        itemBuilder:
                            (BuildContext context, int index, int realIndex) {
                          Movie movie = movies[index];
                          return Stack(
                            children: <Widget>[
                              ClipRRect(
                                child: CachedNetworkImage(
                                  imageUrl:
                                      'https://image.tmd.org/t/p/original/${movie.backdropPath}',
                                  height:
                                      MediaQuery.of(context).size.height / 3,
                                  width: MediaQuery.of(context).size.width,
                                  fit: BoxFit.cover,
                                  placeholder: (context, url) =>
                                      CircularProgressIndicator(),
                                  errorWidget: (context, url, error) =>
                                      Container(
                                    decoration: BoxDecoration(
                                        image: DecorationImage(
                                      image: AssetImage(
                                          'assets/image/img_not_found.jpg'),
                                    )),
                                  ),
                                ),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                              )
                            ],
                          );
                        },
                        options: CarouselOptions(
                          enableInfiniteScroll: true,
                          autoPlay: true,
                          autoPlayInterval: Duration(seconds: 3),
                          autoPlayAnimationDuration:
                              Duration(microseconds: 500),
                          pauseAutoPlayOnTouch: true,
                          viewportFraction: 0.8,
                          enlargeCenterPage: true,
                        ),
                      )
                    ],
                  );
                },
                error: () {
                  return const Text('Failed to load movies');
                },
              );
            })
          ],
        ),
      ),
    );
  });
}
