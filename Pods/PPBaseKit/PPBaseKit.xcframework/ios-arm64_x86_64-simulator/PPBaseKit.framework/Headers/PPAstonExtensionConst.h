
#ifndef __PPAstonExtensionConst__H__
#define __PPAstonExtensionConst__H__

#import <Foundation/Foundation.h>

#ifndef PPAston_LOCK
#define PPAston_LOCK(lock) dispatch_semaphore_wait(lock, DISPATCH_TIME_FOREVER);
#endif

#ifndef PPAston_UNLOCK
#define PPAston_UNLOCK(lock) dispatch_semaphore_signal(lock);
#endif

// 信号量
#define PPAstonExtensionSemaphoreCreate \
extern dispatch_semaphore_t PPAstone_signalSemaphore; \
extern dispatch_once_t PPAstone_onceTokenSemaphore; \
dispatch_once(&PPAstone_onceTokenSemaphore, ^{ \
    PPAstone_signalSemaphore = dispatch_semaphore_create(1); \
});

// 过期
#define PPAstonExtensionDeprecated(instead) NS_DEPRECATED(2_0, 2_0, 2_0, 2_0, instead)

// 构建错误
#define PPAstonExtensionBuildError(clazz, msg) \
NSError *error = [NSError errorWithDomain:msg code:250 userInfo:nil]; \
[clazz setPPAston_error:error];

// 日志输出
#ifdef DEBUG
#define PPAstonExtensionLog(...) NSLog(__VA_ARGS__)
#else
#define PPAstonExtensionLog(...)
#endif

/**
 * 断言
 * @param condition   条件
 * @param returnValue 返回值
 */
#define PPAstonExtensionAssertError(condition, returnValue, clazz, msg) \
[clazz setPPAston_error:nil]; \
if ((condition) == NO) { \
    PPAstonExtensionBuildError(clazz, msg); \
    return returnValue;\
}

#define PPAstonExtensionAssert2(condition, returnValue) \
if ((condition) == NO) return returnValue;

/**
 * 断言
 * @param condition   条件
 */
#define PPAstonExtensionAssert(condition) PPAstonExtensionAssert2(condition, )

/**
 * 断言
 * @param param         参数
 * @param returnValue   返回值
 */
#define PPAstonExtensionAssertParamNotNil2(param, returnValue) \
PPAstonExtensionAssert2((param) != nil, returnValue)

/**
 * 断言
 * @param param   参数
 */
#define PPAstonExtensionAssertParamNotNil(param) PPAstonExtensionAssertParamNotNil2(param, )

/**
 * 打印所有的属性
 */
#define PPAstonLogAllIvars \
- (NSString *)description \
{ \
    return [self PPAston_keyValues].description; \
}
#define PPAstonExtensionLogAllProperties PPAstonLogAllIvars

/** 仅在 Debugger 展示所有的属性 */
#define PPAstonImplementDebugDescription \
- (NSString *)debugDescription \
{ \
return [self PPAston_keyValues].debugDescription; \
}

/**
 *  类型（属性类型）
 */
FOUNDATION_EXPORT NSString *const PPAstonPropertyTypeInt;
FOUNDATION_EXPORT NSString *const PPAstonPropertyTypeShort;
FOUNDATION_EXPORT NSString *const PPAstonPropertyTypeFloat;
FOUNDATION_EXPORT NSString *const PPAstonPropertyTypeDouble;
FOUNDATION_EXPORT NSString *const PPAstonPropertyTypeLong;
FOUNDATION_EXPORT NSString *const PPAstonPropertyTypeLongLong;
FOUNDATION_EXPORT NSString *const PPAstonPropertyTypeChar;
FOUNDATION_EXPORT NSString *const PPAstonPropertyTypeBOOL1;
FOUNDATION_EXPORT NSString *const PPAstonPropertyTypeBOOL2;
FOUNDATION_EXPORT NSString *const PPAstonPropertyTypePointer;

FOUNDATION_EXPORT NSString *const PPAstonPropertyTypeIvar;
FOUNDATION_EXPORT NSString *const PPAstonPropertyTypeMethod;
FOUNDATION_EXPORT NSString *const PPAstonPropertyTypeBlock;
FOUNDATION_EXPORT NSString *const PPAstonPropertyTypeClass;
FOUNDATION_EXPORT NSString *const PPAstonPropertyTypeSEL;
FOUNDATION_EXPORT NSString *const PPAstonPropertyTypeId;

#endif
