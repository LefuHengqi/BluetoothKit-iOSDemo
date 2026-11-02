//
//  PPBluetoothGrapesDataAnalysis.h
//  PPBluetoothKit
//
//  Created by En Ze on 2023/7/18.
//

#import <Foundation/Foundation.h>
#import "PPBluetoothScaleBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface PPBluetoothGrapesDataAnalysis : NSObject

+ (PPBluetoothScaleBaseModel *)analysis11LengthData:(NSData *)receiveData;

@end

NS_ASSUME_NONNULL_END
