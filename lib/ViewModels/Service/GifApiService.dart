import 'dart:io';
import 'package:dio/dio.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:gifapp/Core/Api.dart';
import 'package:gifapp/Models/GifModel.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class GifApiService {
  final Dio _dio = Dio();

  Future<List<GifModel>> fetchGifTrending(int limit) async {
    try {
      Response response = await _dio.get(ApiUrl.gifTrending, queryParameters: {
        "api_key": ApiUrl.API_KEY,
        "limit": limit,
        "offset": 0,
        "rating": "g",
        "bundle": "messaging_non_clips"
      });
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data["data"];
        return data.map((e) => GifModel.fromJson(e)).toList();
      } else {
        throw Exception("Lỗi: API trả về mã lỗi: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Lỗi: $e");
    }
  }

  Future<List<GifModel>> searchGif(int limit, String content)async{
    try{
      Response response= await _dio.get(ApiUrl.gifSearch, queryParameters: {
        "api_key":ApiUrl.API_KEY,
        "q":content,
        "offset":0,
        "rating":"pg-13",
        "lang":"en",
        "bundle":"clips_grid_picker"
      });

      if(response.statusCode==200){
        final List<dynamic> ds=response.data["data"];
        return ds.map((e) => GifModel.fromJson(e)).toList();
      }
      else{
        throw Exception("StatusCode: ${response.statusCode}");
      }
    }catch(e){
      throw Exception("Lỗi: $e");
    }
  }

  Future<List<GifModel>> getGifById(String id) async{
    try{
      var status=await Permission.storage.request();
      if(status.isDenied||status.isPermanentlyDenied){
        print("Quyền truy cập bị từ chối");
        return [];
      }

      Response response=await _dio.get(
        ApiUrl.getGifById+id,
        queryParameters: {
          "api_key":ApiUrl.API_KEY,
          "rating":"pg-13"
        }
      );
      if(response.statusCode==200){
        final List<dynamic> gifs=response.data["data"];
        return gifs.map((e) => GifModel.fromJson(e)).toList();
      }
      else{
        throw Exception("Lỗi: ${response.statusCode}");
      }
    }catch(e){
      throw Exception(e);
    }
  }
  //
  // Future<void> downloadAndSave(String url, String fileName)async{
  //   try{
  //       Directory directory=await getApplicationCacheDirectory();
  //       String filePath='${directory.path}/$fileName';
  //
  //       await _dio.download(url, filePath);
  //
  //       print("Da luu");
  //   }catch(e){
  //     throw Exception("Khong the luu: $e");
  //   }
  // }
  //
  //

  Future<void> saveImage(String imageUrl) async {
    // Kiểm tra quyền trước khi lưu
    var status = await Permission.photos.request();

    if (status.isGranted) {
      bool? success = await GallerySaver.saveImage(imageUrl);
      if (success == true) {
        print("Ảnh đã được lưu vào thư viện!");
      } else {
        print("Lưu ảnh thất bại!");
      }
    } else {
      print("Bạn cần cấp quyền truy cập thư viện ảnh!");
    }
  }

}
