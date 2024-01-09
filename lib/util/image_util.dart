import 'package:http/http.dart' as http;
import 'package:flutter_image_compress/flutter_image_compress.dart';

class ImageUtil {
  static Future<http.MultipartFile> compressImageToMultipartFile(String fieldName, String imagePath) async {
    const int maxSizeInBytes = 1 * 1000000; // 1MB
    double compressionQuality = 1.0;

    // 이미지 압축 함수
    Future<List<int>> compressImage(double quality) async {
      return (await FlutterImageCompress.compressWithFile(
        imagePath,
        quality: (quality * 100).toInt(),
      )) as List<int>;
    }

    List<int> imageData = await compressImage(1.0);

    // 이미지 용량이 초과될 경우, 반복해서 압축
    while (imageData.length > maxSizeInBytes && compressionQuality > 0) {
      imageData = await compressImage(compressionQuality);
      compressionQuality -= 0.1;
    }

    // 압축된 이미지 파일 반환
    return http.MultipartFile.fromBytes(
      fieldName,
      imageData,
      filename: 'compressed_image.jpg',
    );
  }
}
