import 'package:dio/dio.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';

class ImageUtil {
  static Future<MultipartFile> compressImageToMultipartFile(
      String fieldName, String imagePath) async {
    const int maxSizeInBytes = 1 * 1000000; // 1MB
    double compressionQuality = 1.0;

    // 이미지 압축 함수
    Future<List<int>> compressImage(double quality) async {
      return await FlutterImageCompress.compressWithFile(
            imagePath,
            quality: (quality * 100).toInt(),
          ) ??
          [];
    }

    List<int> imageData = await compressImage(1.0);

    // 이미지 용량이 초과될 경우, 반복해서 압축
    while (imageData.length > maxSizeInBytes && compressionQuality > 0) {
      compressionQuality -= 0.1;
      imageData = await compressImage(compressionQuality);
    }

    // // 파일 확장자를 기반으로 MIME 타입 설정
    // String mimeType = 'application/octet-stream';
    // if (imagePath.endsWith('.png')) {
    //   mimeType = 'image/png';
    // } else if (imagePath.endsWith('.jpg') || imagePath.endsWith('.jpeg')) {
    //   mimeType = 'image/jpeg';
    // }

    return MultipartFile.fromBytes(
      imageData,
      filename: 'compressed_image.${imagePath.split('.').last}',
    );
  }
}
