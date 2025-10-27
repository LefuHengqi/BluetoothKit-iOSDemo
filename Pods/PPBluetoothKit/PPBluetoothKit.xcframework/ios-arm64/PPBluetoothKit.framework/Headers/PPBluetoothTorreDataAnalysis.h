//
//  PPBluetoothTorreDataAnalysis.h
//  PPBluetoothKit
//
//  Created by 彭思远 on 2023/4/10.
//

#import <Foundation/Foundation.h>
#import "PPBluetoothAdvDeviceModel.h"
#import "PPBluetoothScaleBaseModel.h"
#import "PPBatteryInfoModel.h"
#import "PPAnalysisResultModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface PPBluetoothTorreDataAnalysis : NSObject

+ (PPAnalysisResultModel *)analysisData:(NSData *)receiveDate device:( PPBluetoothAdvDeviceModel *)deviceAdv;

+ (NSArray <PPBluetoothScaleBaseModel *>*)torreHistoryWithData:(NSData *)reciveData device:( PPBluetoothAdvDeviceModel *)deviceAdv;

+ (PPBatteryInfoModel *)analysisStrengthWithData:(NSData *)receiveData;
@end

NS_ASSUME_NONNULL_END
