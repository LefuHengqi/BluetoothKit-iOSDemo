//
//  PPBluetoothConnectManager.h
//  PPBluetoothKit
//
//  Created by 彭思远 on 2023/3/30.
//

#import <Foundation/Foundation.h>
#import "PPBluetoothDefine.h"
#import "PPBluetoothInterface.h"
#import <CoreBluetooth/CoreBluetooth.h>

NS_ASSUME_NONNULL_BEGIN

@interface PPBluetoothConnectManager : NSObject

@property (nonatomic, weak) id<PPBluetoothUpdateStateDelegate> updateStateDelegate;

@property (nonatomic, weak) id<PPBluetoothSurroundDeviceDelegate> surroundDeviceDelegate;

@property (nonatomic, weak) id<PPBluetoothConnectDelegate> connectDelegate;

@property (nonatomic, weak) id<PPBluetoothScaleDataDelegate> scaleDataDelegate;

- (void)searchSurroundDevice;


- (void)connectPeripheral:(CBPeripheral *)peripheral withDevice:(PPBluetoothAdvDeviceModel *)device;

- (void)stopSearch;

- (void)disconnect:(CBPeripheral *)peripheral;

@end

NS_ASSUME_NONNULL_END
