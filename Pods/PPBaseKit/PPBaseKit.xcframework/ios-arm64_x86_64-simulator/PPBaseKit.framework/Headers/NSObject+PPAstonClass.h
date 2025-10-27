//
//  NSObject+PPAstonClass.h
//  PPAstonExtensionExample
//
//  Created by PPAston Lee on 15/8/11.
//  Copyright (c) 2015年 小码哥. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  遍历所有类的block（父类）
 */
typedef void (^PPAstonClassesEnumeration)(Class c, BOOL *stop);

/** 这个数组中的属性名才会进行字典和模型的转换 */
typedef NSArray * (^PPAstonAllowedPropertyNames)(void);
/** 这个数组中的属性名才会进行归档 */
typedef NSArray * (^PPAstonAllowedCodingPropertyNames)(void);

/** 这个数组中的属性名将会被忽略：不进行字典和模型的转换 */
typedef NSArray * (^PPAstonIgnoredPropertyNames)(void);
/** 这个数组中的属性名将会被忽略：不进行归档 */
typedef NSArray * (^PPAstonIgnoredCodingPropertyNames)(void);

/**
 * 类相关的扩展
 */
@interface NSObject (PPAstonClass)
/**
 *  遍历所有的类
 */
+ (void)PPAston_enumerateClasses:(PPAstonClassesEnumeration)enumeration;
+ (void)PPAston_enumerateAllClasses:(PPAstonClassesEnumeration)enumeration;

#pragma mark - 属性白名单配置
/**
 *  这个数组中的属性名才会进行字典和模型的转换
 *
 *  @param allowedPropertyNames          这个数组中的属性名才会进行字典和模型的转换
 */
+ (void)PPAston_setupAllowedPropertyNames:(PPAstonAllowedPropertyNames)allowedPropertyNames;

/**
 *  这个数组中的属性名才会进行字典和模型的转换
 */
+ (NSMutableArray *)PPAston_totalAllowedPropertyNames;

#pragma mark - 属性黑名单配置
/**
 *  这个数组中的属性名将会被忽略：不进行字典和模型的转换
 *
 *  @param ignoredPropertyNames          这个数组中的属性名将会被忽略：不进行字典和模型的转换
 */
+ (void)PPAston_setupIgnoredPropertyNames:(PPAstonIgnoredPropertyNames)ignoredPropertyNames;

/**
 *  这个数组中的属性名将会被忽略：不进行字典和模型的转换
 */
+ (NSMutableArray *)PPAston_totalIgnoredPropertyNames;

#pragma mark - 归档属性白名单配置
/**
 *  这个数组中的属性名才会进行归档
 *
 *  @param allowedCodingPropertyNames          这个数组中的属性名才会进行归档
 */
+ (void)PPAston_setupAllowedCodingPropertyNames:(PPAstonAllowedCodingPropertyNames)allowedCodingPropertyNames;

/**
 *  这个数组中的属性名才会进行字典和模型的转换
 */
+ (NSMutableArray *)PPAston_totalAllowedCodingPropertyNames;

#pragma mark - 归档属性黑名单配置
/**
 *  这个数组中的属性名将会被忽略：不进行归档
 *
 *  @param ignoredCodingPropertyNames          这个数组中的属性名将会被忽略：不进行归档
 */
+ (void)PPAston_setupIgnoredCodingPropertyNames:(PPAstonIgnoredCodingPropertyNames)ignoredCodingPropertyNames;

/**
 *  这个数组中的属性名将会被忽略：不进行归档
 */
+ (NSMutableArray *)PPAston_totalIgnoredCodingPropertyNames;

#pragma mark - 内部使用
+ (void)PPAston_setupBlockReturnValue:(id (^)(void))block key:(const char *)key;
@end
