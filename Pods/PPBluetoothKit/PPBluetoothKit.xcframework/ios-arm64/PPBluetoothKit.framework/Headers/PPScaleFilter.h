//
//  PPScaleFilter.h
//  powercloudneutral
//
//  Created by 彭思远 on 2020/8/5.
//  Copyright © 2020 Peng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import "PPBluetoothDefine.h"
#import "PPBluetoothAdvDeviceModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface PPScaleFilter : NSObject

+ (BOOL)checkData:(NSData *)receiveData;




+ (NSArray<CBUUID *> *)filterServicesByUUID;

//+ (NSString *)macAddressByCBAdvDataManufacturerData:(NSData *)advData andDeivceName:(NSString *)name;


+ (NSString *)signByAdvData:(NSData *)advData;


+ (NSInteger)devicePowerByCBAdvDataManufacturerData:(NSData *)advData protocol:(PPDeviceProtocolType)protocolType;




+ (NSString *)macAddressByCBAdvDataManufacturerData:(NSData *)advData andMacAddressStart:(NSInteger )macAddressStart;


+ (NSString *)signByAdvData:(NSData *)advData andMacAddressStart:(NSInteger )macAddressStart;


/// torre 广播标记位
+ (NSString *)torreEquipmentLabelingByAdvData:(NSData *)advData;

/// ice 广播标记位
+ (NSString *)iceEquipmentLabelingByAdvData:(NSData *)advData;

+ (NSString *)forreMacAddressByCBAdvData:(NSData *)advData andMacAddressStart:(NSInteger )macAddressStart;

+ (void)analystAuthTorre:(NSData *)advData device:(PPBluetoothAdvDeviceModel *)advModel;

+ (void)analystAuthIce:(NSData *)advData device:(PPBluetoothAdvDeviceModel *)advModel;

@end

NS_ASSUME_NONNULL_END
