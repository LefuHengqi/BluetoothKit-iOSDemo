//
//  PPBluetoothPeripheralJambulDataAnalysis.h
//  Alamofire
//
//  Created by 杨青山 on 2023/9/15.
//

#import <Foundation/Foundation.h>
#import "PPBluetoothAdvDeviceModel.h"
#import "PPBluetoothScaleBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface PPBluetoothPeripheralJambulDataAnalysis : NSObject

+ (PPBluetoothScaleBaseModel *)analysis11LengthDataV3:(NSData *)receiveDate deviceModel:(PPBluetoothAdvDeviceModel *)device;

@end

NS_ASSUME_NONNULL_END
