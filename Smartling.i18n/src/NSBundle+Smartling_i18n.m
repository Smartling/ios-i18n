//
//  NSBundle+Smartling_i18n.m
//  Smartling.i18n
//
//  Created by Pavel Ivashkov on 2013-03-06.
//  Copyright (c) 2013 Smartling. All rights reserved.
//

#import "SLLocalization.h"

// This is hard-coded in this version of the lib, but in the future we could handle multiple plural parameters.
#define SL_PLURAL_PARAMETER 1


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
	NSString *keyVariant = [NSString stringWithFormat:@"%@##{%d:%s}", key, SL_PLURAL_PARAMETER, form];
	
	NSString *so = [self localizedStringForKey:keyVariant value:defaultValue table:tableName];
	return so;
}

@end
