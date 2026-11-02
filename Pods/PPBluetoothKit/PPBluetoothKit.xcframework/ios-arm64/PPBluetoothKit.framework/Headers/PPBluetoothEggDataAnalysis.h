//
//  PPBluetoothEggDataAnalysis.h
//  PPBluetoothKit
//
//  Created by En Ze on 2023/7/17.
//

#import <Foundation/Foundation.h>
#import "PPBluetoothScaleBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface PPBluetoothEggDataAnalysis : NSObject

+ (PPBluetoothScaleBaseModel *)analysis11LengthData:(NSData *)receiveData;

+ (PPBluetoothScaleBaseModel *)analysis16LengthData:(NSData *)receiveData;

@end

NS_ASSUME_NONNULL_END
