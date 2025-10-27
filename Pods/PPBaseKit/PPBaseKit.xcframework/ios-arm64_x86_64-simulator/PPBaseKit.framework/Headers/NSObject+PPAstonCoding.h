//
//  NSObject+PPAstonCoding.h
//  PPAstonExtension
//
//  Created by PPAston on 14-1-15.
//  Copyright (c) 2014年 小码哥. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PPAstonExtensionConst.h"

/**
 *  Codeing协议
 */
@protocol PPAstonCoding <NSObject>
@optional
/**
 *  这个数组中的属性名才会进行归档
 */
+ (NSArray *)PPAston_allowedCodingPropertyNames;
/**
 *  这个数组中的属性名将会被忽略：不进行归档
 */
+ (NSArray *)PPAston_ignoredCodingPropertyNames;
@end

@interface NSObject (PPAstonCoding) <PPAstonCoding>
/**
 *  解码（从文件中解析对象）
 */
- (void)PPAston_decode:(NSCoder *)decoder;
/**
 *  编码（将对象写入文件中）
 */
- (void)PPAston_encode:(NSCoder *)encoder;
@end

/**
 归档的实现
 */
#define PPAstonCodingImplementation \
- (id)initWithCoder:(NSCoder *)decoder \
{ \
if (self = [super init]) { \
[self PPAston_decode:decoder]; \
} \
return self; \
} \
\
- (void)encodeWithCoder:(NSCoder *)encoder \
{ \
[self PPAston_encode:encoder]; \
}\

#define PPAstonExtensionCodingImplementation PPAstonCodingImplementation

#define PPAstonSecureCodingImplementation(CLASS, FLAG) \
@interface CLASS (PPAstonSecureCoding) <NSSecureCoding> \
@end \
@implementation CLASS (PPAstonSecureCoding) \
PPAstonCodingImplementation \
+ (BOOL)supportsSecureCoding { \
return FLAG; \
} \
@end \

