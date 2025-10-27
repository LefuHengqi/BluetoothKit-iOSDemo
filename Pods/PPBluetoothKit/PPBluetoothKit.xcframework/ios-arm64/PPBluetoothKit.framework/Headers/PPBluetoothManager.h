//
//  PPBluetoothManager.h
//  PPBluetoothKit
//
//  Created by 彭思远 on 2023/4/7.
//

#import <Foundation/Foundation.h>
#import "PPBluetoothDefine.h"

NS_ASSUME_NONNULL_BEGIN

@interface PPBluetoothManager : NSObject

+ (BOOL)hasScaleFunc:(PPDeviceFuncType)funcType;

+ (BOOL)hasHistoryFunc:(PPDeviceFuncType)funcType;

+ (BOOL)hasSafeFunc:(PPDeviceFuncType)funcType;

+ (BOOL)hasBMDJFunc:(PPDeviceFuncType)funcType;

+ (BOOL)hasBabyFunc:(PPDeviceFuncType)funcType;

// 判断是否支持wifi功能, 2.4G 和 5G
+ (BOOL)hasWifiFunc:(PPDeviceFuncType)funcType;

// 判断是否支持 2.4G wifi
+ (BOOL)has24GWifiFunc:(PPDeviceFuncType)funcType;

// 判断是否支持 5G wifi
+ (BOOL)has5GWifiFunc:(PPDeviceFuncType)funcType;

+ (BOOL)hasHeartRateFunc:(PPDeviceFuncType)funcType;

+ (BOOL)hasBidirectionalFunc:(PPDeviceFuncType)funcType;

+ (BOOL)hasTimeFormatFunc:(PPDeviceFuncType)funcType;

+ (BOOL)hasLightFunc:(PPDeviceFuncType)funcType;

+ (BOOL)hasLanguageSwitchFunc:(PPDeviceFuncType)funcType;

+ (BOOL)hasVoiceBroadcast4ElectrodesFunc:(PPDeviceFuncType)funcType;

+ (BOOL)hasVoiceBroadcast8ElectrodesFunc:(PPDeviceFuncType)funcType;

+ (BOOL)hasVoiceBroadcastCF610Func:(PPDeviceFuncType)funcType;

+ (BOOL)hasWeightInformationFunc:(PPDeviceFuncType)funcType API_DEPRECATED("已过期，不再使用(Expired and no longer in use)", ios(1.0, API_TO_BE_DEPRECATED), visionos(1.0, API_TO_BE_DEPRECATED));

+ (BOOL)hasFootLengthTestFunc:(PPDeviceFuncType)funcType;

+ (BOOL)has7DataFunc:(PPDeviceFuncType)funcType API_DEPRECATED("已过期，不再使用(Expired and no longer in use)", ios(1.0, API_TO_BE_DEPRECATED), visionos(1.0, API_TO_BE_DEPRECATED));

+ (BOOL)hasTargetDatasFunc:(PPDeviceFuncType)funcType API_DEPRECATED("已过期，不再使用(Expired and no longer in use)", ios(1.0, API_TO_BE_DEPRECATED), visionos(1.0, API_TO_BE_DEPRECATED));

+ (void)loadDeviceWithJsonData:(NSArray *)jsonDicDataArray;

+ (void)loadDeviceWithJsonFile:(NSString *)filePath;

+ (void)loadDeviceWithAppKey:(NSString *)appKey appSecrect:(NSString *)appSecret filePath:(NSString *)path;

+ (void)loadDeviceWithAppKey:(NSString *)appKey appSecrect:(NSString *)appSecret configContent:(NSString *)configContent;

+ (NSInteger)getSDKCode;

@end

NS_ASSUME_NONNULL_END
