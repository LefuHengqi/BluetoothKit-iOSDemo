//
//  PPBluetoothCMDFish.h
//  PPBluetoothKit
//
//  Created by En Ze on 2023/7/18.
//

#import <Foundation/Foundation.h>
#import "PPBluetoothDefine.h"

NS_ASSUME_NONNULL_BEGIN

@interface PPBluetoothCMDFish : NSObject

+ (NSData *)changeUnit:(PPDeviceUnit)unit;

+ (NSData *)toZero;

+ (NSData *)buzzerGate:(BOOL)open;

+ (NSData *)syncTime:(NSDate *)date;

@end

NS_ASSUME_NONNULL_END
