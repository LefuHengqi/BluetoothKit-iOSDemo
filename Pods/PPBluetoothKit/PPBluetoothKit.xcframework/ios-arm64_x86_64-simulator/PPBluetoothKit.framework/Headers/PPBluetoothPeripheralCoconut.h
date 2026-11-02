//
//  PPBluetoothPeripheralCoconut.h
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
#import "PPTorreDFUPackageModel.h"
#import "PPBluetoothDefine.h"
#import "PPSyncBodyModel.h"


NS_ASSUME_NONNULL_BEGIN

@interface PPBluetoothPeripheralCoconut : NSObject

@property (nonatomic, weak) id<PPBluetoothServiceDelegate> serviceDelegate;

@property (nonatomic, weak) id<PPBluetoothCMDDataDelegate> cmdDelegate;

@property (nonatomic, weak) id<PPBluetoothScaleDataDelegate> scaleDataDelegate;

@property (nonatomic, strong) CBPeripheral *peripheral;

@property (nonatomic, strong) PPBatteryInfoModel *batteryInfo;


- (instancetype)initWithPeripheral:(CBPeripheral *)peripheral  andDevice:(PPBluetoothAdvDeviceModel *)device;

- (void)discoverDeviceInfoService:(void(^)(PPBluetooth180ADeviceModel *deviceModel))deviceInfoResponseHandler;

- (void)discoverFFF0Service;

- (void)fetchDeviceBatteryInfo;

- (void)fetchDeviceHistoryData;

- (void)deleteDeviceHistoryData;

- (void)syncDeviceTime;

- (void)syncDeviceSetting:(PPBluetoothDeviceSettingModel *)settingModel;

/// DFU升级，部分设备支持
- (void)startDfu:(NSString *)packagePath handler:(void(^)(CGFloat progress, PPDFUState state))handler;
/// 进入内码模式，部分设备支持
- (void)enterInternalCodeModeWithComplete:(void(^)(void))completion;
/// 退出内码模式，部分设备支持
- (void)exitInternalCodeModeWithComplete:(void(^)(void))completion;

/// 同步身体数据（部分设备支持）
- (void)syncBodyData:(PPSyncBodyModel *)model;

@end

NS_ASSUME_NONNULL_END
