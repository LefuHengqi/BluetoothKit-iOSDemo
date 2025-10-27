//
//  PPBluetoothCoconutDataAnalysis.h
//  PPBluetoothKit
//
//  Created by 彭思远 on 2023/4/3.
//

#import <Foundation/Foundation.h>
#import "PPBluetoothAdvDeviceModel.h"
#import "PPBluetoothScaleBaseModel.h"
#import "PPBatteryInfoModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface PPBluetoothCoconutDataAnalysis : NSObject

+ (PPBluetoothScaleBaseModel *)analysis11LengthDataV3:(NSData *)receiveDate deviceModel:(PPBluetoothAdvDeviceModel *)device;

+ (PPBluetoothScaleBaseModel *)analysis18LengthDataV3:(NSData *)receiveDate deviceModel:(PPBluetoothAdvDeviceModel *)device;

+ (PPBatteryInfoModel *)analysisStrengthWithData:(NSData *)receiveData;
@end

NS_ASSUME_NONNULL_END
