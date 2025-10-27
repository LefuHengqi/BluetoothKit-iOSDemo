//
//  PPScaleFormatTool.h
//  PPBlueToothDemo
//
//  Created by 彭思远 on 2020/8/3.
//  Copyright © 2020 彭思远. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN

static NSInteger ABNORMAL_HISTORY_INTERVAL_TIME = 1577808000; //2020/1/1

static NSInteger TORRE_ABNORMAL_HISTORY_INTERVAL_TIME = 1675353600; //2023-2-3，



@interface PPScaleFormatTool : NSObject
+ (NSString *)addZero:(NSString *)str withLength:(int)length;

+ (NSString *)addZeroBehind:(NSString *)str withLength:(int)length;

+ (NSInteger)numberHexString:(NSString *)aHexString;

+ (NSString *)data2String:(NSData *)data;

+ (Byte)convertDecimalTo0x:(NSInteger) decimal;

+ (NSString *)getHexByDecimal:(NSInteger)decimal;

+ (NSData *)convertHexStrToData:(NSString *)str;

+ (NSString *)getBinaryStrByHexStr:(NSString *)hex;

//普通字符串转换为十六进制的。
+ (NSString *)hexStringFromString:(NSString *)string;

+ (UIImage *)text2Image:(NSString *)text;

+ (UIImage *)text2Image_lorre:(NSString *)text;

+ (UIImage*)covertToGrayImageFromImage:(UIImage*)sourceImage;

+ (NSData *)image2Bitmap:(UIImage *)image;

+ (NSString *)reversStrWith2Step:(NSString *)str;

+ (NSString *)addF:(NSString *)str withLength:(int)length;

+ (NSString *)add0x30:(NSString *)str withLength:(int)length;

+ (NSString *)getHexByBinary:(NSString *)binary;

+ (NSData *)trimData:(NSData *)data;

+ (NSData *)checkDataConvert:(NSData *)receiveData;

+ (NSString *)createUUIDByDataHex:(NSString *)hex;

+ (NSString *)getBinaryByHex:(NSString *)hex;

+ (NSInteger)getFinalWeight100:(CGFloat)weightKG;

+ (NSString *)formatHexStringWithPrefix:(NSString *)hexString;

+ (NSInteger)calculateFoodWithValue:(CGFloat)value total:(CGFloat)total;

+ (BOOL)hasChinese:(NSString *)str;

+ (BOOL) hasJapanese:(NSString *)str;

@end

NS_ASSUME_NONNULL_END
