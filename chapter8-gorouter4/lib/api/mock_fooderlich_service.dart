import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/models.dart';

// Mock recipe service that grabs sample json data to mock recipe request/response
class MockFooderlichService {
  // Batch request that gets both today recipes and friend's feed
  Future<ExploreData> getExploreData() async {
    final todayRecipes = await _getTodayRecipes();
    final friendPosts = await _getFriendFeed();

    return ExploreData(todayRecipes, friendPosts);
  }

  // Get sample explore recipes json to display in ui
  Future<List<ExploreRecipe>> _getTodayRecipes() async {
    // Simulate api request wait time
    // await Future.delayed(const Duration(milliseconds: 300));
    // Load json from file system
    final dataString = await _loadAsset(
      'assets/sample_data/sample_explore_recipes.json',
    );
    // Decode to json
    final json = jsonDecode(dataString);

    return json['recipes']?.map<ExploreRecipe>((e) => ExploreRecipe.fromJson(e))
    .toList() ?? [];
  }

  // Get the sample friend json posts to display in ui
  Future<List<Post>> _getFriendFeed() async {
    // Simulate api request wait time
    await Future.delayed(const Duration(milliseconds: 300));
    // Load json from file system
    final dataString =
        await _loadAsset('assets/sample_data/sample_friends_feed.json');
    // Decode to json
    final Map<String, dynamic> json = jsonDecode(dataString);

    // Go through each post and convert json to Post object.
    return json['feed']?.map<Post>((e) => Post.fromJson(e))
    .toList() ?? [];
  }

  // Get the sample recipe json to display in ui
  Future<List<SimpleRecipe>> getRecipes() async {
    // Simulate api request wait time
    await Future.delayed(const Duration(milliseconds: 300), () {});
    // Load json from file system
    final dataString =
        await _loadAsset('assets/sample_data/sample_recipes.json');
    // Decode to json
    final json = jsonDecode(dataString) as Map<String, dynamic>;
    
    // Go through each recipe and convert json to SimpleRecipe object.
    return json['recipes']?.map<SimpleRecipe>((e) => SimpleRecipe.fromJson(e))
    .toList() ?? [];
  }

  // Loads sample json data from file system
  Future<String> _loadAsset(String path) async {
    return rootBundle.loadString(path);
  }
}
