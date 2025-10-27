//
//  PPBluetoothPeripheralGrapes.h
//  PPBluetoothKit
//
//  Created by En Ze on 2023/7/18.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import "PPBluetoothAdvDeviceModel.h"
#import "PPBluetoothDefine.h"
#import "PPBluetoothInterface.h"

NS_ASSUME_NONNULL_BEGIN

@interface PPBluetoothPeripheralGrapes : NSObject

@property (nonatomic, weak) id<PPBluetoothUpdateStateDelegate> updateStateDelegate;

@property (nonatomic, weak) id<PPBluetoothFoodScaleDataDelegate> scaleDataDelegate;

- (void)receivedDeviceData;

- (void)stopSearch;

- (instancetype)initWithDevice:(PPBluetoothAdvDeviceModel *)device;

@end

NS_ASSUME_NONNULL_END
