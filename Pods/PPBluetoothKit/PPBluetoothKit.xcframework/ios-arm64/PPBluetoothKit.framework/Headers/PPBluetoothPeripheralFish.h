//
//  PPBluetoothPeripheralFish.h
//  Alamofire
//
//  Created by En Ze on 2023/7/17.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import "PPBluetoothAdvDeviceModel.h"
#import "PPBluetooth180ADeviceModel.h"
#import "PPBluetoothInterface.h"
//#import "PPBluetoothDeviceSettingModel.h"
#import <PPBaseKit/PPBaseKit.h>

NS_ASSUME_NONNULL_BEGIN


// 服务UUID
static NSString *const kBK3432ServiceUUID = @"F000FFC0-0451-4000-B000-000000000000";
// 特征UUID
static NSString *const kCharacteristicFFC1 = @"F000FFC1-0451-4000-B000-000000000000";
static NSString *const kCharacteristicFFC2 = @"F000FFC2-0451-4000-B000-000000000000";

@interface PPBluetoothPeripheralFish : NSObject


@property (nonatomic, weak) id<PPBluetoothServiceDelegate> serviceDelegate;

@property (nonatomic, weak) id<PPBluetoothCMDDataDelegate> cmdDelegate;

@property (nonatomic, weak) id<PPBluetoothFoodScaleDataDelegate> scaleDataDelegate;

@property (nonatomic, strong) CBPeripheral *peripheral;

- (instancetype)initWithPeripheral:(CBPeripheral *)peripheral  andDevice:(PPBluetoothAdvDeviceModel *)device;

- (void)discoverDeviceInfoService:(void(^)(PPBluetooth180ADeviceModel *deviceModel))deviceInfoResponseHandler;

- (void)discoverFFF0Service;

/// 切换单位
/// @param currentUnit 当前单位
- (void)changeUnit:(PPDeviceUnit)currentUnit;

/// 去皮/清零
- (void)toZero;

/// 修改蜂鸣器开关
/// @param open open description
- (void)changeBuzzerGate:(BOOL)open;


/// 同步厨房秤时间
/// @param date 时间对象
- (void)syncTime:(NSDate *)date;



/// DFU升级，部分设备支持
- (void)startDfu:(NSString *)packagePath handler:(void(^)(CGFloat progress, PPDFUState state))handler;
/// 进入内码模式，部分设备支持
- (void)enterInternalCodeModeWithComplete:(void(^)(void))completion;
/// 退出内码模式，部分设备支持
- (void)exitInternalCodeModeWithComplete:(void(^)(void))completion;


@end

NS_ASSUME_NONNULL_END
