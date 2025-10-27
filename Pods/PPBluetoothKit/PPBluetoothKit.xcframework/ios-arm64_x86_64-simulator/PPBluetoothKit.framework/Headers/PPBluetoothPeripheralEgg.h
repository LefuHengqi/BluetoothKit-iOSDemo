//
//  PPBluetoothPeripheralEgg.h
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

@interface PPBluetoothPeripheralEgg : NSObject


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



@end

NS_ASSUME_NONNULL_END
