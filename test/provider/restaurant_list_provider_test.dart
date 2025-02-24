import 'package:mocktail/mocktail.dart';
import 'package:restaurant_app/data/api/api_services.dart';
import 'package:restaurant_app/data/model/restaurant.dart';
import 'package:restaurant_app/data/model/restaurant_list_response.dart';
import 'package:restaurant_app/provider/home/restaurant_list_provider.dart';
import 'package:restaurant_app/static/restaurant_list_result_state.dart';
import 'package:test/test.dart';

class MockApiServices extends Mock implements ApiServices {}

void main() {
  late MockApiServices mockApiServices;
  late RestaurantListProvider provider;

  setUp(() {
    mockApiServices = MockApiServices();
    provider = RestaurantListProvider(mockApiServices);
  });

  group('restaurant list provider', () {
    test('initial state should be restaurant list none state', () {
      expect(provider.resultState, isA<RestaurantListNoneState>());
    });

    test('should return list of restaurants when API call is success',
        () async {
      final mockRestaurantListResponse = RestaurantListResponse(
        error: false,
        message: "success",
        count: 20,
        restaurants: [
          Restaurant(
            id: "rqdv5juczeskfw1e867",
            name: "Melting Pot",
            description: "Lorem ipsum dolor sit amet, consectetuer...",
            pictureId: "14",
            city: "Medan",
            rating: 4.2,
          ),
          Restaurant(
            id: "s1knt6za9kkfw1e867",
            name: "Kafe Kita",
            description: "Quisque rutrum. Aenean imperdiet. Etiam...",
            pictureId: "25",
            city: "Gorontalo",
            rating: 4,
          ),
        ],
      );

      when(() => mockApiServices.getRestaurantList()).thenAnswer(
        (_) async => mockRestaurantListResponse,
      );

      await provider.fetchRestaurantList();

      expect(provider.resultState, isA<RestaurantListLoadedState>());

      final loadedState = provider.resultState as RestaurantListLoadedState;

      expect(loadedState.data.length, 2);
      expect(loadedState.data.first.name, "Melting Pot");
    });

    test('should return error state when API call fail', () async {
      when(() => mockApiServices.getRestaurantList())
        .thenThrow(Exception("Error fetching data"));
      
      await provider.fetchRestaurantList();

      expect(provider.resultState, isA<RestaurantListErrorState>());
      
      final errorState = provider.resultState as RestaurantListErrorState;

      expect(errorState.error, contains("Something went wrong. Please try again after some time."));
    });
  });
}
