import 'package:chefstation_multivendor/common/models/product_model.dart';
import 'package:chefstation_multivendor/common/models/restaurant_model.dart';
import 'package:chefstation_multivendor/features/search/domain/repositories/search_repository_interface.dart';
import 'package:chefstation_multivendor/features/search/domain/models/search_suggestion_model.dart';
import 'package:chefstation_multivendor/features/search/domain/services/search_service_interface.dart';
import 'package:chefstation_multivendor/helper/date_converter.dart';
import 'package:get/get_connect/http/src/response/response.dart';

class SearchService implements SearchServiceInterface {
  final SearchRepositoryInterface searchRepositoryInterface;
  SearchService({required this.searchRepositoryInterface});

  @override
  Future<List<Product>?> getSuggestedFoods() async {
    return await searchRepositoryInterface.getSuggestedFoods();
  }

  @override
  Future<SearchSuggestionModel?> getSearchSuggestions(String searchText) async {
    return await searchRepositoryInterface.getSearchSuggestions(searchText);
  }

  @override
  Future<Response> getSearchData({required String query, required bool isRestaurant, required int offset,
    String? type, int? isNew = 0, int? isPopular = 0, double? minPrice, double? maxPrice,
    int? isOneRatting = 0, int? isTwoRatting = 0, int? isThreeRatting = 0, int? isFourRatting = 0, int? isFiveRatting = 0,
    String? sortBy, int? discounted = 0, required List<int> selectedCuisines, int? isOpenRestaurant}) async {

    return await searchRepositoryInterface.getSearchData(query: query, isRestaurant: isRestaurant, offset: offset,
    type: type, isNew: isNew, isPopular: isPopular, isOneRatting: isOneRatting, isTwoRatting: isTwoRatting, isThreeRatting: isThreeRatting,
        isFourRatting: isFourRatting, isFiveRatting: isFiveRatting, sortBy: sortBy, discounted: discounted,
        minPrice: minPrice, maxPrice: maxPrice, selectedCuisines: selectedCuisines, isOpenRestaurant: isOpenRestaurant);
  }

  @override
  int findRatings(int rating) {
    if(rating == 1) {
      return 1;
    } else if(rating == 2) {
      return 2;
    } else if(rating == 3) {
      return 3;
    } else if(rating == 4) {
      return 4;
    } else if(rating == 5) {
      return 5;
    } else {
      return 0;
    }
  }

  @override
  String getSortBy(bool isRestaurant, int restaurantSortIndex, int sortIndex) {
    if(isRestaurant) {
      if(restaurantSortIndex == 0) {
        return 'asc';
      } else if(restaurantSortIndex == 1) {
        return 'desc';
      } else {
        return '';
      }
    } else {
      if(sortIndex == 0) {
        return 'asc';
      } else if(sortIndex == 1) {
        return 'desc';
      } else if(sortIndex == 2) {
        return 'low';
      } else if(sortIndex == 3) {
        return 'high';
      } else {
        return '';
      }
    }
  }

  @override
  String processType(bool isRestaurant, bool restVeg, bool restNonVeg, bool veg, bool nonVeg) {
    if(isRestaurant) {
      if(restVeg) {
        return 'veg';
      } else if (restNonVeg) {
        return 'non_veg';
      } else {
        return '';
      }
    } else {
      if(veg) {
        return 'veg';
      } else if(nonVeg) {
        return 'non_veg';
      } else {
        return '';
      }
    }
  }

  @override
  Future<bool> saveSearchHistory(List<String> searchHistories) async {
    return await searchRepositoryInterface.saveSearchHistory(searchHistories);
  }

  @override
  List<String> getSearchHistory() {
    return searchRepositoryInterface.getSearchHistory();
  }

  @override
  Future<bool> clearSearchHistory() async {
    return searchRepositoryInterface.clearSearchHistory();
  }

  @override
  List<Product>? sortFoodSearchList( List<Product>? allProductList, double upperValue, double lowerValue, int rating, bool veg, bool nonVeg, bool isAvailableFoods, bool isDiscountedFoods, int sortIndex, int priceSortIndex) {
    List<Product>? searchProductList = [];
    searchProductList.addAll(allProductList!);

    if(upperValue > 0) {
      searchProductList.removeWhere((product) => product.price! <= lowerValue || product.price! > upperValue);
    }
    if(rating != -1) {
      searchProductList.removeWhere((product) => product.avgRating! < rating);
    }
    if(!veg && nonVeg) {
      searchProductList.removeWhere((product) => product.veg == 1);
    }
    if(!nonVeg && veg) {
      searchProductList.removeWhere((product) => product.veg == 0);
    }
    if(isAvailableFoods || isDiscountedFoods) {
      if(isAvailableFoods) {
        searchProductList.removeWhere((product) => !DateConverter.isAvailable(product.availableTimeStarts, product.availableTimeEnds));
      }
      if(isDiscountedFoods) {
        searchProductList.removeWhere((product) => product.discount == 0);
      }
    }
    if(sortIndex != -1) {
      if(sortIndex == 0) {
        // searchProductList!.sort((a, b) => b.price!.compareTo(a.price!));
        searchProductList.sort((a, b) => a.name!.toLowerCase().compareTo(b.name!.toLowerCase()));
      }else {
        searchProductList.sort((a, b) => a.name!.toLowerCase().compareTo(b.name!.toLowerCase()));
        Iterable iterable = searchProductList.reversed;
        searchProductList = iterable.toList() as List<Product>?;
      }
    }

    if(priceSortIndex != -1) {
      if(priceSortIndex == 0) {
        searchProductList!.sort((a, b) => a.price!.compareTo(b.price!));
      } else {
        searchProductList!.sort((a, b) => b.price!.compareTo(a.price!));
      }
    }
    return searchProductList;
  }

    @override
  List<Restaurant>? sortRestaurantSearchList(List<Restaurant>? allRestaurantList, int rating, bool veg, bool nonVeg, bool isAvailableRestaurants, bool isDiscountedRestaurants, int sortIndex, int restaurantPriceSortIndex) {
    List<Restaurant>? searchRestaurantList = [];
    searchRestaurantList.addAll(allRestaurantList!);
    if(rating != -1) {
      searchRestaurantList.removeWhere((restaurant) => restaurant.avgRating! < rating);
    }
    if(!veg && nonVeg) {
      searchRestaurantList.removeWhere((product) => product.nonVeg == 0);
    }
    if(!nonVeg && veg) {
      searchRestaurantList.removeWhere((product) => product.veg == 0);
    }
    if(isAvailableRestaurants || isDiscountedRestaurants) {
      if(isAvailableRestaurants) {
        searchRestaurantList.removeWhere((restaurant) => (restaurant.open == 0 || !restaurant.active!));
      }
      if(isDiscountedRestaurants) {
        searchRestaurantList.removeWhere((restaurant) => restaurant.discount == null);
      }
    }
    if(sortIndex != -1) {
      if(sortIndex == 0) {
        searchRestaurantList.sort((a, b) => a.name!.toLowerCase().compareTo(b.name!.toLowerCase()));
      }else {
        searchRestaurantList.sort((a, b) => a.name!.toLowerCase().compareTo(b.name!.toLowerCase()));
        Iterable iterable = searchRestaurantList.reversed;
        searchRestaurantList = iterable.toList() as List<Restaurant>?;
      }
    }

    if(restaurantPriceSortIndex != -1) {
      if(restaurantPriceSortIndex == 0) {
        searchRestaurantList!.sort((a, b) => a.minimumOrder!.compareTo(b.minimumOrder!));
      } else {
        searchRestaurantList!.sort((a, b) => b.minimumOrder!.compareTo(a.minimumOrder!));
      }
    }
    return searchRestaurantList;
  }


}
