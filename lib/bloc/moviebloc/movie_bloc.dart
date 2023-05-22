import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:proyecto/bloc/moviebloc/movie_bloc_event.dart';
import 'package:proyecto/bloc/moviebloc/movie_bloc_state.dart';
import 'package:proyecto/services/api_services.dart';
import 'package:proyecto/models/movie.dart';

class MovieBloc extends Bloc<MovieEvent, MovieState> {
  MovieBloc() : super(MovieState.loading());

  @override
  Stream<MovieState> mapEventToState(MovieEvent event) async* {
    yield* event.when(
      started: (int movieId, String query) async* {
        final service = ApiService();
        yield MovieState.loading();
        try {
          List<Movie> movieList = [];
          if (movieId == 0) {
            movieList = await service.getNowPlayingMovie();
          }
          yield MovieState.loaded(movieList: movieList);
        } catch (_) {
          yield MovieState.error();
        }
      },
    );
  }
}
