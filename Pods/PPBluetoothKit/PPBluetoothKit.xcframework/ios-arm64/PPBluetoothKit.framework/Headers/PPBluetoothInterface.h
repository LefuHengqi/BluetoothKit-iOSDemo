//
//  PPBluetoothInterface.h
//  PPBluetoothKIt
//
//  Created by 彭思远 on 2023/3/27.
//

#ifndef PPBluetoothInterface_h
#define PPBluetoothInterface_h

#import "PPScaleState.h"
#import "PPBluetoothDefine.h"


@class PPBluetoothAdvDeviceModel;
@class CBPeripheral;
@class PPBluetoothScaleBaseModel;
@class PPBluetooth180ADeviceModel;
@class PPBodyFatModel;
@class PPBatteryInfoModel;
@class PPCoffeeScaleDataModel;


@protocol PPBluetoothUpdateStateDelegate <NSObject>

- (void)centralManagerDidUpdateState:(PPBluetoothState)state;

@end

@protocol PPBluetoothSurroundDeviceDelegate <NSObject>

- (void)centralManagerDidFoundSurroundDevice:(PPBluetoothAdvDeviceModel *)device andPeripheral:(CBPeripheral *)peripheral;
@end


@protocol PPBluetoothConnectDelegate <NSObject>

@optional

- (void)centralManagerDidConnect;

- (void)centralManagerDidFailToConnect:(NSError *)error;

- (void)centralManagerDidDisconnect;

@end


@protocol PPBluetoothServiceDelegate <NSObject>

- (void)discoverFFF0ServiceSuccess;

@optional
- (void)authState:(PPAuthState) authState;

@end

@protocol PPBluetoothCMDDataDelegate <NSObject>

@optional

- (void)syncDeviceHistorySuccess;

- (void)syncDeviceTimeSuccess;

- (void)deleteDeviceHistoryDataSuccess;

- (void)deviceWillDisconnect;

@end


@protocol PPBluetoothScaleDataDelegate <NSObject>


- (void)monitorProcessData:(PPBluetoothScaleBaseModel *)model advModel:(PPBluetoothAdvDeviceModel*)advModel;

- (void)monitorLockData:(PPBluetoothScaleBaseModel*)model advModel:(PPBluetoothAdvDeviceModel*)advModel;


@optional

- (void)monitorHistoryData:(PPBluetoothScaleBaseModel *)model advModel:(PPBluetoothAdvDeviceModel*)advModel;

- (void)monitorBatteryInfoChange:(PPBatteryInfoModel *)model advModel:(PPBluetoothAdvDeviceModel*)advModel;

/// Torre、Borre、Dorre 获取当前设备的实时状态，请勿缓存
- (void)monitorScaleState:(PPScaleState *)scaleState;


@end


@protocol PPBluetoothCalculateInScaleDataDelegate <NSObject>

- (void)monitorLockData:(PPBodyFatModel *)model advModel:(PPBluetoothAdvDeviceModel*)advModel;

@optional

- (void)monitorProcessData:(PPBluetoothScaleBaseModel *)model advModel:(PPBluetoothAdvDeviceModel*)advModel;

- (void)monitorBatteryInfoChange:(PPBatteryInfoModel *)model advModel:(PPBluetoothAdvDeviceModel*)advModel;

@end

@protocol PPBluetoothFoodScaleDataDelegate <NSObject>

- (void)monitorData:(PPBluetoothScaleBaseModel *)model advModel:(PPBluetoothAdvDeviceModel*)advModel;

@optional

- (void)monitorScaleState:(PPScaleState *)scaleState;

@end


@protocol PPBluetoothCoffeeScaleDataDelegate <NSObject>

- (void)monitorCoffeeData:(PPCoffeeScaleDataModel *)model advModel:(PPBluetoothAdvDeviceModel*)advModel;

@optional

- (void)monitorWeightModeData:(PPBluetoothScaleBaseModel *)model advModel:(PPBluetoothAdvDeviceModel*)advModel;

- (void)monitorWeightModeScaleState:(PPScaleState *)scaleState;

@end



#endif /* PPBluetoothInterface_h */
