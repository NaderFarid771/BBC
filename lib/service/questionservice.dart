// // Question Service
// import 'package:flutter/foundation.dart';
// import 'dart:convert' as convert;
// import 'package:http/http.dart' as http;
// import 'package:mindo/model/apiresult.dart';
// import 'package:mindo/model/questionmodel.dart';

// class Questionservice {
//   static const String _baseUrl = 'https://opentdb.com/api.php';

//   static Future<ApiResult<List<Questionmodel>>> getQuestion(
//       String category, int amount) async {
//     try {
//       if (category.isEmpty) {
//         return ApiResult.failure('Category is required');
//       }

//       // بناء الـ URL مع المعاملات
//       final url = '$_baseUrl?amount=$amount&category=$category';
      
//       final response = await http
//           .get(
//             Uri.parse(url), // استخدام الـ URL الصحيح
//             headers: {'Content-Type': 'application/json'},
//           )
//           .timeout(Duration(seconds: 10));

//       // إصلاح فحص الـ status code
//       if (response.statusCode == 200) {
//         final data = convert.json.decode(response.body);
        
//         // فحص وجود البيانات
//         if (data['results'] != null) {
//           // تحويل مصفوفة الأسئلة
//           final List<dynamic> questionsJson = data['results'];
//           final List<Questionmodel> questions = questionsJson
//               .map((json) => Questionmodel.fromJson(json))
//               .toList();
          
//           return ApiResult.success(questions);
//         } else {
//           return ApiResult.failure('No questions found in response');
//         }
//       } else if (response.statusCode == 404) {
//         return ApiResult.failure('Error 404: Not found');
//       } else {
//         return ApiResult.failure('HTTP Error ${response.statusCode}');
//       }
//     } catch (e) {
//       return ApiResult.failure('Network error: $e');
//     }
//   }
// }

// Question Service - خدمة الأسئلة المحسنة
import 'package:flutter/foundation.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'package:mindo/model/apiresult.dart';
import 'package:mindo/model/questionmodel.dart';

class Questionservice {
  static const String _baseUrl = 'https://opentdb.com/api.php';
  
  static const Duration _requestTimeout = Duration(seconds: 15);


  static Future<ApiResult<List<Questionmodel>>> getQuestion(
      String category, int amount) async {
    try {
      if (category.isEmpty) {
        return ApiResult.failure('Category is required');
      }
      
      if (amount < 1 || amount > 50) {
        return ApiResult.failure('Amount must be between 1 and 50');
      }
      final url = '$_baseUrl?amount=$amount&category=$category&type=multiple';
      
      if (kDebugMode) {
        print('🌐 Requesting: $url');
      }

      final response = await http
          .get(
            Uri.parse(url),
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
            },
          )
          .timeout(_requestTimeout);

      if (kDebugMode) {
        print('Response Status: ${response.statusCode}');
        print('Response Body: ${response.body.substring(0, response.body.length > 200 ? 200 : response.body.length)}...');
      }

      if (response.statusCode == 200) {
        final data = convert.json.decode(response.body);
        if (data['response_code'] != null) {
          switch (data['response_code']) {
            case 0:
              break;
            case 1:
              return ApiResult.failure('No results found. Try different parameters.');
            case 2:
              return ApiResult.failure('Invalid parameter. Check category or amount.');
            case 3:
              return ApiResult.failure('Token not found.');
            case 4:
              return ApiResult.failure('Token empty. Reset token.');
            case 5:
              return ApiResult.failure('Rate limit exceeded. Try again later.');
            default:
              return ApiResult.failure('Unknown API error: ${data['response_code']}');
          }
        }
        
        if (data['results'] != null && data['results'] is List) {
          final List<dynamic> questionsJson = data['results'];
          
          if (questionsJson.isEmpty) {
            return ApiResult.failure('No questions available for this category');
          }
          
          try {
            final List<Questionmodel> questions = questionsJson
                .map((json) => Questionmodel.fromJson(json))
                .toList();
            
            if (kDebugMode) {
              print('Successfully loaded ${questions.length} questions');
            }
            
            return ApiResult.success(questions);
          } catch (parseError) {
            if (kDebugMode) {
              print('Parse Error: $parseError');
            }
            return ApiResult.failure('Failed to parse questions data');
          }
        } else {
          return ApiResult.failure('Invalid response format from server');
        }
      } 
      else if (response.statusCode == 404) {
        return ApiResult.failure('Service not found (404)');
      } else if (response.statusCode == 500) {
        return ApiResult.failure('Server error (500). Try again later.');
      } else if (response.statusCode == 429) {
        return ApiResult.failure('Too many requests. Please wait and try again.');
      } else {
        return ApiResult.failure('HTTP Error ${response.statusCode}: ${response.reasonPhrase}');
      }
    } 
    on http.ClientException catch (e) {
      if (kDebugMode) {
        print('Client Error: $e');
      }
      return ApiResult.failure('Network connection error');
    } on FormatException catch (e) {
      if (kDebugMode) {
        print('Format Error: $e');
      }
      return ApiResult.failure('Invalid response format');
    } on convert.JsonUnsupportedObjectError catch (e) {
      if (kDebugMode) {
        print('JSON Error: $e');
      }
      return ApiResult.failure('Failed to process server response');
    } catch (e) {
      if (kDebugMode) {
        print('Unknown Error: $e');
      }
      return ApiResult.failure('Unexpected error: ${e.toString()}');
    }
  }
  static Future<ApiResult<List<Questionmodel>>> getQuestionsFromMultipleCategories(
      List<String> categories, int amountPerCategory) async {
    
    if (categories.isEmpty) {
      return ApiResult.failure('At least one category is required');
    }

    try {
      List<Questionmodel> allQuestions = [];
      
      for (String category in categories) {
        final result = await getQuestion(category, amountPerCategory);
        
        if (result.isSuccess) {
          allQuestions.addAll(result.data!);
        } else {
          if (kDebugMode) {
            print('Failed to load category $category: ${result.error}');
          }
        }
      }
      
      if (allQuestions.isEmpty) {
        return ApiResult.failure('No questions loaded from any category');
      }
      
      allQuestions.shuffle();
      
      return ApiResult.success(allQuestions);
    } catch (e) {
      return ApiResult.failure('Error loading multiple categories: $e');
    }
  }
  static Map<String, String> get availableCategories => {
    '9': 'General Knowledge',
    '10': 'Books',
    '11': 'Film',
    '12': 'Music',
    '13': 'Musicals & Theatres',
    '14': 'Television',
    '15': 'Video Games',
    '16': 'Board Games',
    '17': 'Science & Nature',
    '18': 'Computers',
    '19': 'Mathematics',
    '20': 'Mythology',
    '21': 'Sports',
    '22': 'Geography',
    '23': 'History',
    '24': 'Politics',
    '25': 'Art',
    '26': 'Celebrities',
    '27': 'Animals',
    '28': 'Vehicles',
    '29': 'Comics',
    '30': 'Gadgets',
    '31': 'Japanese Anime & Manga',
    '32': 'Cartoon & Animations',
  };

  static String getCategoryName(String categoryId) {
    return availableCategories[categoryId] ?? 'Unknown Category';
  }
}