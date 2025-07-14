import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:chefstation_multivendor/util/state_manager.dart';
import 'unit_test_helpers.mocks.dart';

// Generate mocks for common dependencies
@GenerateMocks([
  SharedPreferences,
  // Add other dependencies here
])
void main() {}

/// Test utilities and helpers
class TestUtils {
  /// Create a test app with GetX support
  static Widget createTestApp({
    required Widget child,
    List<GetPage> routes = const [],
    Bindings? initialBinding,
  }) {
    return GetMaterialApp(
      home: child,
      getPages: routes,
      initialBinding: initialBinding,
    );
  }

  /// Pump widget with GetX support
  static Future<void> pumpWidget(
    WidgetTester tester,
    Widget widget, {
    Duration? duration,
  }) async {
    await tester.pumpWidget(createTestApp(child: widget));
    if (duration != null) {
      await tester.pump(duration);
    }
  }

  /// Wait for async operations to complete
  static Future<void> waitForAsync(WidgetTester tester) async {
    await tester.pumpAndSettle();
  }

  /// Mock SharedPreferences for testing
  static Future<MockSharedPreferences> createMockSharedPreferences() async {
    final mock = MockSharedPreferences();
    
    // Setup common mock responses
    when(mock.getString(any)).thenReturn(null);
    when(mock.setString(any, any)).thenAnswer((_) async => true);
    when(mock.remove(any)).thenAnswer((_) async => true);
    when(mock.clear()).thenAnswer((_) async => true);
    
    return mock;
  }

  /// Create test data
  static Map<String, dynamic> createTestUser() {
    return {
      'id': 1,
      'name': 'Test User',
      'email': 'test@example.com',
      'phone': '+1234567890',
    };
  }

  static Map<String, dynamic> createTestProduct() {
    return {
      'id': 1,
      'name': 'Test Product',
      'price': 10.99,
      'description': 'Test description',
      'image': 'test_image.png',
    };
  }

  static List<Map<String, dynamic>> createTestProducts([int count = 5]) {
    return List.generate(count, (index) => {
      'id': index + 1,
      'name': 'Product ${index + 1}',
      'price': (index + 1) * 10.99,
      'description': 'Description for product ${index + 1}',
      'image': 'product_${index + 1}.png',
    });
  }

  /// Assert widget is visible
  static void expectWidgetVisible(WidgetTester tester, String text) {
    expect(find.text(text), findsOneWidget);
  }

  /// Assert widget is not visible
  static void expectWidgetNotVisible(WidgetTester tester, String text) {
    expect(find.text(text), findsNothing);
  }

  /// Tap on widget by text
  static Future<void> tapByText(WidgetTester tester, String text) async {
    await tester.tap(find.text(text));
    await tester.pump();
  }

  /// Tap on widget by key
  static Future<void> tapByKey(WidgetTester tester, Key key) async {
    await tester.tap(find.byKey(key));
    await tester.pump();
  }

  /// Enter text in text field
  static Future<void> enterText(
    WidgetTester tester,
    String text,
    String value,
  ) async {
    await tester.enterText(find.byType(TextField), value);
    await tester.pump();
  }

  /// Scroll to widget
  static Future<void> scrollToWidget(
    WidgetTester tester,
    String text,
  ) async {
    await tester.scrollUntilVisible(
      find.text(text),
      500.0,
      scrollable: find.byType(SingleChildScrollView),
    );
  }
}

/// Base test class for common setup
abstract class BaseTest {
  late MockSharedPreferences mockSharedPreferences;

  Future<void> setUp() async {
    // Initialize mocks
    mockSharedPreferences = await TestUtils.createMockSharedPreferences();
    
    // Setup GetX test environment
    Get.testMode = true;
    
    // Disable logging during tests
    // AppLogger.debug = (String message) {}; // Disable debug logs
  }

  Future<void> tearDown() async {
    // Clean up
    Get.reset();
  }
}

/// Test matchers for common assertions
class CustomMatchers {
  /// Matcher for StateData
  static Matcher isStateData<T>({
    StateStatus? status,
    T? data,
    String? message,
  }) {
    return _StateDataMatcher<T>(
      status: status,
      data: data,
      message: message,
    );
  }

  /// Matcher for API response
  static Matcher isApiResponse({
    bool? success,
    String? message,
    dynamic data,
  }) {
    return _ApiResponseMatcher(
      success: success,
      message: message,
      data: data,
    );
  }
}

class _StateDataMatcher<T> extends Matcher {
  final StateStatus? status;
  final T? data;
  final String? message;

  _StateDataMatcher({
    this.status,
    this.data,
    this.message,
  });

  @override
  bool matches(dynamic item, Map matchState) {
    if (item is! StateData<T>) return false;
    
    if (status != null && item.status != status) return false;
    if (data != null && item.data != data) return false;
    if (message != null && item.message != message) return false;
    
    return true;
  }

  @override
  Description describe(Description description) {
    return description.add('StateData with ');
    // Add more description details
  }
}

class _ApiResponseMatcher extends Matcher {
  final bool? success;
  final String? message;
  final dynamic data;

  _ApiResponseMatcher({
    this.success,
    this.message,
    this.data,
  });

  @override
  bool matches(dynamic item, Map matchState) {
    if (item is! Map) return false;
    
    if (success != null && item['success'] != success) return false;
    if (message != null && item['message'] != message) return false;
    if (data != null && item['data'] != data) return false;
    
    return true;
  }

  @override
  Description describe(Description description) {
    return description.add('API response with ');
    // Add more description details
  }
}

/// Test data builders
class TestDataBuilder {
  static Map<String, dynamic> user({
    int? id,
    String? name,
    String? email,
    String? phone,
  }) {
    return {
      'id': id ?? 1,
      'name': name ?? 'Test User',
      'email': email ?? 'test@example.com',
      'phone': phone ?? '+1234567890',
    };
  }

  static Map<String, dynamic> product({
    int? id,
    String? name,
    double? price,
    String? description,
    String? image,
  }) {
    return {
      'id': id ?? 1,
      'name': name ?? 'Test Product',
      'price': price ?? 10.99,
      'description': description ?? 'Test description',
      'image': image ?? 'test_image.png',
    };
  }

  static Map<String, dynamic> order({
    int? id,
    String? status,
    double? total,
    List<Map<String, dynamic>>? items,
  }) {
    return {
      'id': id ?? 1,
      'status': status ?? 'pending',
      'total': total ?? 25.99,
      'items': items ?? [product()],
    };
  }
}

/// Performance test utilities
class PerformanceTestUtils {
  static Future<void> measurePerformance(
    String operationName,
    Future<void> Function() operation,
  ) async {
    final stopwatch = Stopwatch()..start();
    await operation();
    stopwatch.stop();
    
    // print('Performance: $operationName took ${stopwatch.elapsedMilliseconds}ms');
  }

  static Future<void> measureWidgetBuild(
    WidgetTester tester,
    Widget widget,
  ) async {
    await measurePerformance('Widget Build', () async {
      await TestUtils.pumpWidget(tester, widget);
    });
  }
}

/// Integration test utilities
class IntegrationTestUtils {
  static Future<void> waitForAppToLoad(WidgetTester tester) async {
    // Wait for initial loading to complete
    await tester.pumpAndSettle(const Duration(seconds: 5));
  }

  static Future<void> navigateToScreen(
    WidgetTester tester,
    String routeName,
  ) async {
    Get.toNamed(routeName);
    await tester.pumpAndSettle();
  }

  static Future<void> goBack(WidgetTester tester) async {
    Get.back();
    await tester.pumpAndSettle();
  }
} 