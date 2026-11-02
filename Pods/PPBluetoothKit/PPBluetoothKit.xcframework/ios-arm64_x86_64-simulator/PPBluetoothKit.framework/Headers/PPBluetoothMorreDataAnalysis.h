//
//  PPBluetoothMorreDataAnalysis.h
//  PPBluetoothKit
//
//  Created by 彭思远 on 2023/4/10.
//

#import <Foundation/Foundation.h>
#import "PPBluetoothAdvDeviceModel.h"
#import "PPBatteryInfoModel.h"
#import "PPAnalysisResultModel.h"
#import "PPKorreFoodInfo.h"
#import "PPCoffeeScaleDataModel.h"



@interface PPBluetoothMorreDataAnalysis : NSObject

+ (PPCoffeeScaleDataModel *)analysisData:(NSData *)receiveDate device:( PPBluetoothAdvDeviceModel *)deviceAdv;

+ (PPAnalysisResultModel *)analysisWeightModeData:(NSData *)receiveDate device:( PPBluetoothAdvDeviceModel *)deviceAdv;

+ (PPBatteryInfoModel *)analysisStrengthWithData:(NSData *)receiveData;

+ (NSArray <PPCoffeeScaleDataModel *>*)historyWithData:(NSData *)data;

@end


