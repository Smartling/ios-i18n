//
//  SLLocalization.h
//  Smartling.i18n
//
//  Created by Pavel Ivashkov on 2013-02-25.
//  Copyright (c) 2013 Smartling. All rights reserved.
//

#define SLPluralizedString(key, n, comment) \
	({ \
		__typeof__(n) _n = (n); \
		[[SLResource instance] pluralizedStringWithKey:key value:&_n valueType:@encode(__typeof__(n))]; \
	})


@interface SLResource : NSObject

@property(retain, nonatomic) NSBundle *bundle;
@property(retain, nonatomic) NSString *table;
@property(retain, nonatomic, readonly) NSString *localization;	// the first value of bundle preferredLocalizations

+ (SLResource *)instance;
- (NSString *)pluralizedStringWithKey:(NSString *)key value:(float)value;
- (NSString *)pluralizedStringWithKey:(NSString *)key value:(void *)value valueType:(const char *)valueType;


#ifndef SL_EXTERN
#if defined (__cplusplus)
#define SL_EXTERN extern "C"
#else
#define SL_EXTERN extern
#endif
#endif

// Returns one of: zero, one, two, few, many, other
SL_EXTERN const char* pluralform(const char* lang, int n);
SL_EXTERN const char* pluralformf(const char* lang, float n);


@end
