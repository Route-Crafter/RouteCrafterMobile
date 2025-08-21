import 'package:dio/dio.dart';
import 'package:routes_mobile/domain/exceptions.dart';

abstract class RemoteDataSource {
  final Dio dio;
  RemoteDataSource({required this.dio});

  Future<Response> executeDioService(
    Future<Response> Function() service
  )async{
    try{
      final response = await service();
      final statusCode = response.statusCode;
      if(statusCode == 200 || statusCode == 201 || statusCode == 202 || statusCode == 203 || statusCode == 205 || statusCode == 206 || statusCode == 208) {
        return response;
      } else if(statusCode == 401) {
        throw const GeneralException(meessage: 'Sin autorización');
      } else {
        print(response.data);
        throw GeneralException(meessage: response.data['error']['message'] ?? 'Ha ocurrido un error inesperado' );
      }
    }on GeneralException catch(_){
      rethrow;
    }catch(exception, stackTrace){
      print(stackTrace);
      throw const GeneralException(meessage: 'Ha ocurrido un error inesperado');
    }
  }

  Map<String, String> getJsonContentHeaders() => {
    'Content-Type': 'application/json'
  };
}