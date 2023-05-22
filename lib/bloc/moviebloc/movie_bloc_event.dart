import 'package:freezed_annotation/freezed_annotation.dart';

part 'movie_bloc_event.freezed.dart';

@freezed
class MovieEvent with _$MovieEvent {
  const factory MovieEvent.started(
      {required int movieId, required String query}) = _Started;
}
