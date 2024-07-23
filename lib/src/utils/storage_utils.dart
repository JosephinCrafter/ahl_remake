import 'dart:convert';
import 'dart:developer';
import 'dart:typed_data';

import 'package:firebase_article/firebase_article.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:http/http.dart' as http;
import 'package:session_storage/session_storage.dart';

import '../firebase_constants.dart';

final class ArticleStorageUtils {
  // Image of the cover image
  Uint8List? coverImage;

  // content response
  http.Response? contentResponse;

  // Cover image url
  String? coverImageUrl;

  ArticleStorageUtils({
    required Article article,
    required this.collection,
    Reference? storageRef,
  })  : _article = article,
        coverImageUrlKey = '${article.id}_coverImageUrl',
        coverImageDataKey = '${article.id}_coverImageData',
        contentDataKey = '${article.id}_contentData',
        _storage = storageRef ?? storage;

  /// The article on which this utils perform
  final Article _article;

  /// Collection name where to look for items.
  final String collection;

  /// Key to trigger cover image data
  final String coverImageDataKey;

  // key to trigger cover image url from cache.
  final String coverImageUrlKey;

  // key to trigger cover image url from cache.
  final String contentDataKey;

  // Firebase storage instance
  final Reference _storage;

  final SessionStorage cache = SessionStorage();

  /// Ask storage Reference the coverImage url.
  Future<String?> getCoverImageUrl() async {
    // Cache check

    String? coverImageUrl = cache[coverImageUrlKey];
    if (coverImageUrl != null) {
      return coverImageUrl;
    }

    // perform true operation on database
    final heroHeaderImageRef = _storage.child(
      "$collection/${_article.id}/${_article.relations?[0][RepoSetUp.coverImageKey]}",
      // "articles/qui_est_laure_sabes/hero_header_image.jpg",
    );
    try {
      final String url = await heroHeaderImageRef.getDownloadURL();

      // storing to cache
      coverImageUrl = url;
      cache[coverImageUrlKey] = coverImageUrl;
    } catch (e) {
      log('[storage] Error getting coverImage: e');
      coverImageUrl = null;
    }

    return coverImageUrl;
  }

  Future<Uint8List?> getCoverImage() async {
    Uint8List? data;
    String? dataString = cache[coverImageDataKey];
    //cache check
    try {
      data =
          (dataString != null) ? decodeUint8ListFromString(dataString) : null;
      if (data != null) {
        coverImage = data;
        return data;
      }
    } catch (e) {
      log('[cache] Error getting data: $e');
    }

    // perform truth reading
    try {
      final heroHeaderImageRef = _storage.child(
        "$collection/${_article.id}/${_article.relations?[0][RepoSetUp.coverImageKey]}",
        // "articles/qui_est_laure_sabes/hero_header_image.jpg",
      );
      data = await heroHeaderImageRef.getData();
      log('Image got: ${heroHeaderImageRef.name} ');

      // write data to cache
      cache[coverImageDataKey] = encodeUint8ListToString(data!);

      // update coverImage
    } catch (e) {
      log('Error loading image: $e');
      data = Uint8List(0);
    }

    coverImage = data;
    return data;
  }

  /// Get the content of the article.
  Future<http.Response?> getContent() async {
    // cache
    String? contentString = cache[contentDataKey];
    http.Response? response =
        (contentString != null) ? decodeStringToResponse(contentString) : null;
    if (response != null) {
      return response;
    }

    //perform true operation
    final contentRef = storage.child(
      "$collection/${_article.id}/${_article.contentPath}",
      // "articles/qui_est_laure_sabes/hero_header_image.jpg",
    );
    final String url = await contentRef.getDownloadURL();

    response = await http.get(Uri.parse(url));
    cache[contentDataKey] = encodeResponseToString(response);

    return response;
  }
}

// Function to encode Response to string
String encodeResponseToString(http.Response response) {
  // Read the response body as a stream of bytes
  final bytes = response.bodyBytes;
  // Encode the bytes to a base64 string
  final encodedBody = base64Encode(bytes);

  // Extract other important fields from the response
  final headers = response.headers;
  final statusCode = response.statusCode;
  final reasonPhrase = response.reasonPhrase;

  // Combine all data into a JSON object
  final data = {
    'headers': headers.toString(),
    'statusCode': statusCode,
    'reasonPhrase': reasonPhrase,
    'url': response.request?.url.toString(),
    'body': encodedBody,
    'baseRequest': {
      'method': response.request?.method,
      'contentLength': response.request?.contentLength,
      'url': response.request?.url.toString(),
      'finalized': response.request?.finalized,
      'headers': response.request?.headers,
      'followRedirects': response.request?.followRedirects,
      'hashCode': response.request?.hashCode,
      'maxRedirects': response.request?.maxRedirects,
      'persistentConnection': response.request?.persistentConnection,
      'runtimeType': response.request?.runtimeType,
    }
  };

  // Convert the data map to a JSON string
  return jsonEncode(data);
}

http.Response decodeStringToResponse(String encodedString) {
  // Decode the JSON string into a map
  final decodedData = jsonDecode(encodedString) as Map<String, dynamic>;

  // Extract data from the map
  final headers = Map<String, String>.from(decodedData['headers']);
  final statusCode = decodedData['statusCode'] as int;
  final reasonPhrase = decodedData['reasonPhrase'] as String;
  final url = Uri.parse(decodedData['url'] as String);
  final bodyBytes = base64Decode(decodedData['body'] as String);

  // Extract request data (if available)
  http.Request? request;
  if (decodedData.containsKey('baseRequest')) {
    final requestData = decodedData['baseRequest'] as Map<String, dynamic>;
    request = http.Request(
      requestData['method'] as String,
      url,
      // headers: Map<String, String>.from(requestData['headers']),
      // bodyBytes: requestData['contentLength'] != null ? Uint8List.fromList(requestData['body'] as List) : null,
    );
  }

  // Rebuild the Response object with the decoded data
  return http.Response.bytes(
    bodyBytes,
    statusCode,
    reasonPhrase: reasonPhrase,
    headers: headers,
    request: request,
  );
}

String encodeUint8ListToString(Uint8List data) {
  // Use the built-in converter to transform the list into a base64 encoded string
  return base64Encode(data);
}

Uint8List decodeUint8ListFromString(String encodedString) {
  // Use the built-in converter to decode the base64 string back into a Uint8List
  return base64Decode(encodedString);
}
