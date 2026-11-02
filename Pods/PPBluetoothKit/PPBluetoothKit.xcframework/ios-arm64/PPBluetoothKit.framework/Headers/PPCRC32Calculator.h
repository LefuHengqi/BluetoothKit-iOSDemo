//
//  PPPPCRC32Calculator.h
//  Pods
//
//  Created by lefu on 2026/4/22
//  


#import <Foundation/Foundation.h>

// CRC32 变体类型
typedef NS_ENUM(NSUInteger, CRC32Variant) {
    CRC32VariantStandard,     // 标准 CRC32 (IEEE 802.3)
    CRC32VariantCastagnoli,   // CRC-32C (Castagnoli)
    CRC32VariantKoopman,      // CRC-32K (Koopman)
    CRC32VariantJamCRC        // CRC-32/JAMCRC
};

// 字符串编码类型
typedef NS_ENUM(NSUInteger, StringEncoding) {
    StringEncodingUTF8,
    StringEncodingUTF16,
    StringEncodingUTF32,
    StringEncodingGBK,
    StringEncodingGB18030
};

NS_ASSUME_NONNULL_BEGIN

@interface PPCRC32Calculator : NSObject

#pragma mark - 基础方法

/// 计算字符串的 CRC32 校验和
/// @param string 输入字符串（支持多国语言）
/// @return 4字节十六进制字符串（8个字符，如 "a1b2c3d4"）
+ (NSString *)crc32ForString:(NSString *)string;

/// 计算字符串的 CRC32 校验和（自定义参数）
/// @param string 输入字符串
/// @param variant CRC32 变体类型
/// @param encoding 字符串编码
/// @return 4字节十六进制字符串
+ (NSString *)crc32ForString:(NSString *)string
                     variant:(CRC32Variant)variant
                    encoding:(StringEncoding)encoding;

#pragma mark - 流式计算

/// 开始流式计算
+ (instancetype)streamCalculatorWithVariant:(CRC32Variant)variant;

/// 更新流式计算的数据
- (void)updateWithData:(NSData *)data;

/// 获取当前 CRC32 值
- (NSString *)finalCRC32Hex;

#pragma mark - 文件计算

/// 计算文件的 CRC32
/// @param filePath 文件路径
/// @param variant CRC32 变体类型
/// @return CRC32 十六进制字符串，失败返回 nil
+ (NSString *)crc32ForFileAtPath:(NSString *)filePath
                         variant:(CRC32Variant)variant;

/// 验证文件的 CRC32
/// @param filePath 文件路径
/// @param expectedCRC 预期的 CRC32 十六进制字符串
/// @param variant CRC32 变体类型
/// @return 验证结果
+ (BOOL)verifyFileAtPath:(NSString *)filePath
         expectedCRC:(NSString *)expectedCRC
             variant:(CRC32Variant)variant;

#pragma mark - 工具方法

/// 将 4 字节数据转换为十六进制字符串
+ (NSString *)dataToHexString:(NSData *)data;

/// 将十六进制字符串转换为 4 字节数据
+ (NSData *)hexStringToData:(NSString *)hexString;

/// 获取 CRC32 计算结果的数据（4字节）
+ (NSData *)crc32DataForString:(NSString *)string;

@end

// NSString 扩展
@interface NSString (CRC32)

/// 获取字符串的 CRC32 校验和（十六进制）
- (NSString *)crc32Hex;

/// 获取字符串的 CRC32 数据（4字节）
- (NSData *)crc32Data;

/// 获取指定变体的 CRC32
- (NSString *)crc32HexWithVariant:(CRC32Variant)variant;

@end

// NSData 扩展
@interface NSData (CRC32)

/// 获取数据的 CRC32 校验和（十六进制）
- (NSString *)crc32Hex;

/// 获取数据的 CRC32 值（uint32_t）
- (uint32_t)crc32Value;

@end

NS_ASSUME_NONNULL_END


