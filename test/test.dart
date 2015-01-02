import 'package:unittest/html_enhanced_config.dart';

import 'md_test.dart' as md;
import 'tls_test.dart' as tls;

void main() {
  useHtmlEnhancedConfiguration();
  md.runTests();
  tls.runTests();
}
