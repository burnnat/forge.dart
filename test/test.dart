import 'package:unittest/html_enhanced_config.dart';

import 'tls_test.dart' as tls;

void main() {
  useHtmlEnhancedConfiguration();
  tls.runTests();
}
