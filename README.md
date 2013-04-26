# Smartling.i18n.framework
iOS Plurals Localization Library

iOS localization does not support plural functionality out of the box. The ios-i18n library was designed to bridge that gap and provide a means for developers to seamlessly integrate plurals into their localized apps across any number of locales.


## Installation
1. Download [Smartling.i18n.framework.tar.gz] [fw]
2. Unpack and drag `Smartling.i18n.framework` to your project's `Frameworks` group.
3. In the `Build Settings` of your target add **-ObjC** to **Other Linker Flags**.
4. `#import <Smartling.i18n/SLLocalization.h>`

## Usage

### Plurals

    int number = 42;
    NSString *key = SLPluralizedString(@"%d apples", number, @"Comment");
    NSString *text = [NSString stringWithFormat:key, number];

#### SLPluralizedString...
There are four functions to retrieve pluralized string, similar to [NSLocalizedString]:

    NSString * SLPluralizedString(NSString *key, number, NSString *comment)
    NSString * SLPluralizedStringFromTable(NSString *key,
        NSString *tableName,
        number,
        NSString *comment)
    NSString * SLPluralizedStringFromTableInBundle(NSString *key,
        NSString *tableName,
        NSBundle *bundle,
        number,
        NSString *comment)
    NSString * SLPluralizedStringWithDefaultValue(NSString *key,
        NSString *tableName,
        NSBundle *bundle,
        number,
        NSString *defaultValue,
        NSString *comment)

`number` can be any primitive type (int, long, float, double), or NSNumber.

#### Fallback

At runtime, SLPluralizedString tries to retrieve localized string according to selected plural form, given number value. If not found, it mimicks NSLocalizedString – and falls back to developer specified language.
For more details on this mechanism, see [Support for Internationalization] [applei18n]

### Extended .strings format

[Standard .strings file format][stringsff] is extended with pluralized variants. 

The extended syntax for key is: `KEY##{rule}`.
Where `KEY` is the original key string, and `rule` is one of plural rules: `zero`, `one`, `two`, `few`, `many`, `other`.

The `rule` portion of the full key conforms to the [CLDR spec][CLDR] on plural forms. The iOS-18n library will load a particular translation following the same rules as defined under CLDR.

Sample resource files for key string `%d songs found`:

##### en.lproj/Localizable.strings

    /* Number of songs from search results */
    "%d songs found##{one}" = "One song found";
    "%d songs found##{other}" = "%d songs found";

##### ru.lproj/Localizable.strings

    /* Number of songs from search results */
    "%d songs found##{one}" = "Найдена одна песня";
    "%d songs found##{few}" = "Найдено %d песни";
    "%d songs found##{many}" = "Найдено %d песен";
    "%d songs found##{other}" = "Найдено %d песен";

## Copyright and license

Copyright 2013 Smartling, Inc.

Licensed under the Apache License, Version 2.0 (the "License"); you may not use this work except in compliance with the License. You may obtain a copy of the License in the LICENSE file, or at:

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License.

  [fw]: ../../raw/master/Frameworks/Smartling.i18n.framework.tar.gz
  [NSLocalizedString]: https://developer.apple.com/library/ios/#documentation/cocoa/reference/foundation/miscellaneous/foundation_functions/reference/reference.html
  [applei18n]: https://developer.apple.com/library/mac/#documentation/MacOSX/Conceptual/BPInternational/Articles/InternatSupport.html
  [stringsff]: https://developer.apple.com/library/ios/#documentation/Cocoa/Conceptual/LoadingResources/Strings/Strings.html
  [CLDR]: http://unicode.org/repos/cldr-tmp/trunk/diff/supplemental/language_plural_rules.html
  
