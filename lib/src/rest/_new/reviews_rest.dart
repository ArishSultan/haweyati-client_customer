import 'package:haweyati/src/const.dart';
import 'package:haweyati/src/rest/_new/_config.dart';
import 'package:haweyati_client_data_models/models/others/reviews_model.dart';
import 'package:retrofit/http.dart';
part 'reviews_rest.g.dart';

@RestApi(baseUrl: apiUrl)
abstract class ReviewsRest {
  factory ReviewsRest() => _ReviewsRest(defaultDio);

  @GET('/reviews')
  Future<List<Review>> get({
    @Query('type') String type,
    @Query('id') String id,
  });
}
