//
//  NSString+PPAstonExtension.h
//  PPAstonExtensionExample
//
//  Created by PPAston Lee on 15/6/7.
//  Copyright (c) 2015年 小码哥. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PPAstonExtensionConst.h"

@interface NSString (PPAstonExtension)
/**
 *  驼峰转下划线（loveYou -> love_you）
 */
- (NSString *)PPAston_underlineFromCamel;
/**
 *  下划线转驼峰（love_you -> loveYou）
 */
- (NSString *)PPAston_camelFromUnderline;
/**
 * 首字母变大写
 */
- (NSString *)PPAston_firstCharUpper;
/**
 * 首字母变小写
 */
- (NSString *)PPAston_firstCharLower;

- (BOOL)PPAston_isPureInt;

- (NSURL *)PPAston_url;
@end
