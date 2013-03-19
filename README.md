# Smartling.i18n.framework
Extended iOS localization with plurals.

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

  [fw]: Frameworks/Smartling.i18n.framework.tar.gz
  [NSLocalizedString]: https://developer.apple.com/library/ios/#documentation/cocoa/reference/foundation/miscellaneous/foundation_functions/reference/reference.html
  [applei18n]: https://developer.apple.com/library/mac/#documentation/MacOSX/Conceptual/BPInternational/Articles/InternatSupport.html
  [stringsff]: https://developer.apple.com/library/ios/#documentation/Cocoa/Conceptual/LoadingResources/Strings/Strings.html
  