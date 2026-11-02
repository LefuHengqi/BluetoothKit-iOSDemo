//
//  PPBluetoothCMDEgg.h
//  PPBluetoothKit
//
//  Created by En Ze on 2023/7/17.
//

#import <Foundation/Foundation.h>
#import "PPBluetoothDefine.h"
NS_ASSUME_NONNULL_BEGIN

@interface PPBluetoothCMDEgg : NSObject

+ (NSData *)changeUnit:(PPDeviceUnit)unit;

+ (NSData *)toZero;

@end

NS_ASSUME_NONNULL_END
