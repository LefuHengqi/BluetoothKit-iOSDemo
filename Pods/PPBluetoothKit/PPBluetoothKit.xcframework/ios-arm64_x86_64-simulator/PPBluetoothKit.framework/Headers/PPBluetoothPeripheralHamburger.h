//
//  PPBluetoothPeripheralHamburger.h
//  Alamofire
//
//  Created by 杨青山 on 2023/9/15.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import "PPBluetoothAdvDeviceModel.h"
#import "PPBluetoothDefine.h"
#import "PPBluetoothInterface.h"
NS_ASSUME_NONNULL_BEGIN

@interface PPBluetoothPeripheralHamburger : NSObject

@property (nonatomic, weak) id<PPBluetoothUpdateStateDelegate> updateStateDelegate;

@property (nonatomic, weak) id<PPBluetoothFoodScaleDataDelegate> scaleDataDelegate;

- (void)receivedDeviceData;

- (void)stopSearch;

- (instancetype)initWithDevice:(PPBluetoothAdvDeviceModel *)device;

@end

NS_ASSUME_NONNULL_END
