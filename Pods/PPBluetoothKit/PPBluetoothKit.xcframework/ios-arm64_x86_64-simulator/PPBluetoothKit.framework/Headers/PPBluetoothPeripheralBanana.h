//
//  PPBluetoothPeripheralBanana.h
//  PPBluetoothKit
//
//  Created by 彭思远 on 2023/4/3.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import "PPBluetoothAdvDeviceModel.h"
#import "PPBluetoothDefine.h"
#import "PPBluetoothInterface.h"

NS_ASSUME_NONNULL_BEGIN

@interface PPBluetoothPeripheralBanana : NSObject

@property (nonatomic, weak) id<PPBluetoothUpdateStateDelegate> updateStateDelegate;

@property (nonatomic, weak) id<PPBluetoothScaleDataDelegate> scaleDataDelegate;

- (void)receivedDeviceData;

- (void)stopSearch;

- (instancetype)initWithDevice:(PPBluetoothAdvDeviceModel *)device;

@end

NS_ASSUME_NONNULL_END
