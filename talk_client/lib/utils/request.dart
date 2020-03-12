import 'package:dio/dio.dart';

class HttpUtil {
  static HttpUtil instance;
  Dio dio;
  BaseOptions options;
  CancelToken cancelToken = CancelToken();

  static HttpUtil getInstance() {
    if (instance == null) instance = HttpUtil();
    return instance;
  }

  HttpUtil() {
    options = BaseOptions(
      baseUrl: 'http://192.168.0.107:7001/api/',
      connectTimeout: 10000,
      receiveTimeout: 5000,
      headers: {},
      responseType: ResponseType.json,
    );

    dio = Dio(options);

    dio.interceptors.add(InterceptorsWrapper(
      onRequest: (RequestOptions options) {
        return options;
      },
      onResponse: (Response response) {
        return response;
      },
      onError: (DioError e) {
        return e;
      },
    ));
  }

  get(url, {data, options}) async {
    Response response;
    try {
      response = await dio.get(url, queryParameters: data, options: options);
    } on DioError catch (e) {
      formatError(e);
    }
    return response.data;
  }

  post(url, {data, options}) async {
    Response response;
    try {
      response = await dio.post(url, data: data, options: options);
    } on DioError catch (e) {
      formatError(e);
    }
    return response.data;
  }

  void formatError(DioError e) {
    print('请求失败======$e');
    if (e.type == DioErrorType.CONNECT_TIMEOUT) {
      print("连接超时");
    } else if (e.type == DioErrorType.SEND_TIMEOUT) {
      print("请求超时");
    } else if (e.type == DioErrorType.RECEIVE_TIMEOUT) {
      print("响应超时");
    } else if (e.type == DioErrorType.RESPONSE) {
      print("出现异常");
    } else if (e.type == DioErrorType.CANCEL) {
      print("请求取消");
    } else {
      print("未知错误");
    }
  }
}
