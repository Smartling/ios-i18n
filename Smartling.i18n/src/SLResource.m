//
//  SLResource.m
//  Smartling.i18n
//
//  Created by Pavel Ivashkov on 2013-02-25.
//  Copyright (c) 2013 Smartling. All rights reserved.
//

#import "SLLocalization.h"


@implementation SLResource

+ (SLResource *)instance
{
	static SLResource *obj = nil;
	if (!obj) {
		obj = [[SLResource alloc] init];
	}
	return obj;
}

- (id)init
{
	if (!(self = [super init]))
		return nil;
	
	self.bundle = [NSBundle mainBundle];

	return self;
}

- (void)setBundle:(NSBundle *)value
{
	if (!value) value = [NSBundle mainBundle];
	_bundle = value;
//	self.reverseTable = nil;
//	self.variationsTable = nil;
}
- (void)setTable:(NSString *)value
{
	_table = value;
//	self.reverseTable = nil;
//	self.variationsTable = nil;
}
- (NSString *)localization
{
	return [[self.bundle preferredLocalizations] objectAtIndex:0];
}

- (NSString *)pluralizedStringWithKey:(NSString *)key value:(float)value
{
	NSString *lang = [NSLocale canonicalLanguageIdentifierFromString:self.localization];
	const char* form = pluralformf([lang cStringUsingEncoding:NSASCIIStringEncoding], value);
	NSString *keyVariant = [NSString stringWithFormat:@"%@##{1:%s}", key, form];	// NOTE: hard-coded index 1
	static NSString *MARKER = @"##{}##";
	NSString *so = [self.bundle localizedStringForKey:keyVariant value:MARKER table:self.table];
	if ([so isEqualToString:MARKER]) {
		NSLog(@"Not found variant: (%@) %@", lang, keyVariant);
		so = [self.bundle localizedStringForKey:key value:@"" table:self.table];
	}
	return so;
}

- (NSString *)pluralizedStringWithKey:(NSString *)key value:(void *)value valueType:(const char *)valueType
{
	if (value == NULL || valueType == NULL) {
		return key;
	}
	
	float fval = 0;
	
	char typecode = valueType[0];
	switch (typecode) {
		case '@':
		{
			__unsafe_unretained id obj = *(__unsafe_unretained id*)value;
			if ([obj respondsToSelector:@selector(floatValue)]) {
				fval = [obj floatValue];
			}
			else {
				NSLog(@"Cannot get number value from object of type %@", NSStringFromClass([obj class]));
			}
		}
		break;
			
		case 'c': fval = *(char *)value; break;
		case 'i': fval = *(int *)value; break;
		case 's': fval = *(short *)value; break;
		case 'l': fval = *(long *)value; break;
		case 'q': fval = *(long long *)value; break;
		case 'C': fval = *(u_char *)value; break;
		case 'I': fval = *(u_int *)value; break;
		case 'S': fval = *(u_short *)value; break;
		case 'L': fval = *(u_long *)value; break;
		case 'Q': fval = *(unsigned long long *)value; break;
		case 'f': fval = *(float *)value; break;
		case 'd': fval = *(double *)value; break;
		case 'B': fval = *(_Bool *)value; break;
			
		default:
			NSLog(@"Cannot convert value of type \"%s\" to number", valueType);
			break;
	}
	
	return [self pluralizedStringWithKey:key value:fval];
}

@end
