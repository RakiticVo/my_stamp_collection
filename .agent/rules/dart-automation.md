# Rule: Dart-First Automation

This rule mandates prioritizing **Dart scripts** for all technical automation, batch file processing, and code manipulation tasks within this Flutter project.

## 1. The Core Mandate
- **MANDATORY**: For any task involving batch file editing, data migration, or code standardization (e.g., Header Audits), you MUST use a **Dart script** as the primary automation engine.
- **FORBIDDEN**: Relying on OS-specific shell scripts (PowerShell, Bash) for tasks that modify source files containing non-ASCII characters (Vietnamese) is strictly prohibited.

## 2. UTF-8 & Encoding Safety
- **UTF-8 Requirement**: All Dart scripts MUST explicitly use `utf8` encoding from the `dart:convert` library for both reading and writing files.
- **Vietnamese Character Preservation**: Automation tools MUST be tested to ensure they do not corrupt Vietnamese accents or special characters.
- **Icon Rendering**: Scripts MUST correctly handle and preserve Emoji icons used in project headers.

## 3. Implementation Standards
- **Standard Library Only**: Prefer using only the Dart standard library (`dart:io`, `dart:convert`) to ensure scripts can be run immediately without `pub get`.
- **Regex-Based Logic**: Use robust Regular Expressions for finding insertion points (e.g., after imports) to avoid breaking code structure.
- **No BOM**: Ensure files are written without a Byte Order Mark (BOM) to maintain consistency with Git and IDE standards.

## 4. Script Template (Base)
Use this structure for new automation tasks:
```dart
import 'dart:io';
import 'dart:convert';

void main() {
  final List<String> targetFiles = [/* ... */];
  
  for (var path in targetFiles) {
    final file = File(path);
    if (!file.existsSync()) continue;

    // Read with explicit UTF-8
    final content = file.readAsStringSync(encoding: utf8);
    
    // Modification Logic
    String newContent = process(content);

    // Save with explicit UTF-8 (No BOM)
    file.writeAsStringSync(newContent, encoding: utf8);
  }
}
```

## 5. Compliance
- This rule is binding for all AI Agents and developers.
- Failure to use Dart-based automation for multi-file source code changes is considered a violation of project documentation standards.
