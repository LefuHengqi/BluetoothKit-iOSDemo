//
//  PPBluetoothPeripheralDurian.h
//  PPBluetoothKit
//
//  Created by 彭思远 on 2023/4/3.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import "PPBluetoothAdvDeviceModel.h"
#import "PPBluetooth180ADeviceModel.h"
#import "PPBluetoothInterface.h"
//#import "PPBluetoothDeviceSettingModel.h"
#import <PPBaseKit/PPBaseKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PPBluetoothPeripheralDurian : NSObject

@property (nonatomic, weak) id<PPBluetoothServiceDelegate> serviceDelegate;

@property (nonatomic, weak) id<PPBluetoothCMDDataDelegate> cmdDelegate;

@property (nonatomic, weak) id<PPBluetoothCalculateInScaleDataDelegate> scaleDataDelegate;

@property (nonatomic, strong) CBPeripheral *peripheral;

@property (nonatomic, strong) PPBatteryInfoModel *batteryInfo;

- (instancetype)initWithPeripheral:(CBPeripheral *)peripheral  andDevice:(PPBluetoothAdvDeviceModel *)device;

- (void)discoverDeviceInfoService:(void(^)(PPBluetooth180ADeviceModel *deviceModel))deviceInfoResponseHandler;

- (void)discoverFFF0Service;

- (void)syncDeviceSetting:(PPBluetoothDeviceSettingModel *)settingModel;

@end

NS_ASSUME_NONNULL_END
