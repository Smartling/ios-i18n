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
	NSString *lang = nil;
	NSArray *locs = self.preferredLocalizations;
	if (locs.count) {
		lang = locs[0];
	}
	else {
		lang = self.developmentLocalization;
	}
	
	const char* form = pluralformf([lang cStringUsingEncoding:NSASCIIStringEncoding], pluralValue);
	NSString *keyVariant = [NSString stringWithFormat:@"%@##{%s}", key, form];
	
	NSString *so = [self localizedStringForKey:keyVariant value:defaultValue table:tableName];
	return so;
}

@end

// Technical Q&A QA1490
// Building Objective-C static libraries with categories
// http://developer.apple.com/library/mac/#qa/qa1490/_index.html
#define LINK_CATEGORIES(UNIQUE_NAME) @interface FORCELOAD_##UNIQUE_NAME : NSObject @end @implementation FORCELOAD_##UNIQUE_NAME @end
LINK_CATEGORIES(NSBundle_Smartling_i18n)
