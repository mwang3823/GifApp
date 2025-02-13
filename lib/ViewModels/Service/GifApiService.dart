import 'package:dio/dio.dart';
import 'package:gifapp/Core/Api.dart';
import 'package:gifapp/Models/GifModel.dart';

class GifApiService{
  final Dio _dio=Dio();

  Future<List<GifModel>> fetchGifTrending(int limit) async{
    try{
      Response response= await _dio.get(
          ApiUrl.gifTrending,
        queryParameters: {
           "api_key":ApiUrl.API_KEY,
          "limit":limit,
          "offset":0,
          "rating":"g",
          "bundle":"messaging_non_clips"
        });
      if(response==200){
        final List<dynamic> data= response.data["data"];
        return data.map((e) => GifModel.fromJson(e)).toList();
      }
      else{
        throw Exception("Lỗi: API trả về mã lỗi: "+response.statusCode.toString());
      }
    }catch(e){
      throw Exception("Lỗi: $e");
    }
  }
}