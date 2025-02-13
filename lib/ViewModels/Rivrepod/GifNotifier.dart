import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gifapp/Models/GifModel.dart';
import 'package:gifapp/ViewModels/Service/GifApiService.dart';

class GifNotifier extends StateNotifier<List<GifModel>>{
  final GifApiService apiService;

  GifNotifier(this.apiService):super([]){
    fetchGifTrending(10);
  }

  Future<void> fetchGifTrending(int limit) async{
    try{
      List<GifModel> ds= await apiService.fetchGifTrending(limit);
      state=[...state, ...ds];
    }catch(e){
      throw Exception("Lỗi riverpod: $e");
    }
  }
}

final gifProvider=StateNotifierProvider<GifNotifier,List<GifModel>>((ref) {
  return GifNotifier(GifApiService());
});