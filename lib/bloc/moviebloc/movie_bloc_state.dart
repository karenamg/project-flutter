import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:proyecto/models/movie.dart';

part 'movie_bloc_state.freezed.dart';

@freezed
class MovieState with _$MovieState {
  const factory MovieState.loading() = _Loading;
  const factory MovieState.loaded({required List<Movie> movieList}) = _Loaded;
  const factory MovieState.error() = _Error;
}
