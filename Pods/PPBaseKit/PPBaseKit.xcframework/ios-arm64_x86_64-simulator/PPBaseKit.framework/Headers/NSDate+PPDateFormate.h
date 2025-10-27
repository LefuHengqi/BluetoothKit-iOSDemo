//
//  NSDate+PPDateFormate.h
//  PPScaleSDKDebug
//
//  Created by 彭思远 on 2022/6/27.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSDate (PPDateFormate)

- (NSString *)stringWithFormat:(NSString *)format timeZone:(NSTimeZone *)timeZone locale:(NSLocale *)locale;
@end

NS_ASSUME_NONNULL_END
