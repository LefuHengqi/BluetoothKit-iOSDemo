//
//  PPBMPConverter.h
//  xxxx
//
//  Created by 彭思远 on 2025/6/6.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface PPBMPConverter : NSObject

/// 主转换方法
+ (UIImage *)convertText:(NSString *)text
            fixedHeight:(NSUInteger)fixedHeight maxWidth:(NSUInteger)maxWidth;
@end
NS_ASSUME_NONNULL_END
