//
//  NSBundle+Smartling_i18n.m
//  Smartling.i18n
//
//  Created by Pavel Ivashkov on 2013-03-06.
//  Copyright (c) 2013 Smartling. All rights reserved.
//

#import "SLLocalization.h"


@implementation NSBundle(Smartling_i18n)

- (NSString *)pluralizedStringWithKey:(NSString *)key defaultValue:(NSString *)defaultValue table:(NSString *)tableName pluralValue:(float)pluralValue
{
	NSMutableArray *locales = [NSMutableArray arrayWithArray:self.preferredLocalizations];
	if (self.developmentLocalization && ![[locales lastObject] isEqualToString:self.developmentLocalization]) {
		[locales addObject:self.developmentLocalization];
	}
	
	for (NSString *lang in locales) {
		const char* form = pluralformf([lang cStringUsingEncoding:NSASCIIStringEncoding], pluralValue);
		NSString *keyVariant = [NSString stringWithFormat:@"%@##{%s}", key, form];
		
		if (!tableName) {
			tableName = [self pathForResource:@"Localizable" ofType:@"strings" inDirectory:nil forLocalization:lang];
		}
		if (!tableName) {
			NSArray *paths = [self pathsForResourcesOfType:@"strings" inDirectory:nil forLocalization:lang];
			if (paths.count) tableName = paths[0];
		}
		
		NSDictionary *dict = nil;
		if (tableName) {
			dict = [NSDictionary dictionaryWithContentsOfFile:tableName];
		}
		
		NSString *ls = dict[keyVariant];
		if (ls.length) {
			return ls;
		}

		BOOL report = [[NSUserDefaults standardUserDefaults] boolForKey:@"NSShowNonLocalizedStrings"];
		if (report) {
			NSLog(@"Missing %@ localization for \"%@\"", lang.uppercaseString, keyVariant);
			return [keyVariant uppercaseString];
		}
	}
		
	if (defaultValue.length) {
		return defaultValue;
	}
	
	return key;
}

@end

// Technical Q&A QA1490
// Building Objective-C static libraries with categories
// http://developer.apple.com/library/mac/#qa/qa1490/_index.html
#define LINK_CATEGORIES(UNIQUE_NAME) @interface FORCELOAD_##UNIQUE_NAME : NSObject @end @implementation FORCELOAD_##UNIQUE_NAME @end
LINK_CATEGORIES(NSBundle_Smartling_i18n)
