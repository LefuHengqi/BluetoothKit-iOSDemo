//
//  PPBluetoothKorreDataAnalysis.h
//  PPBluetoothKit
//
//  Created by 彭思远 on 2023/4/10.
//

#import <Foundation/Foundation.h>
#import "PPBluetoothAdvDeviceModel.h"
#import "PPBluetoothScaleBaseModel.h"
#import "PPBatteryInfoModel.h"
#import "PPAnalysisResultModel.h"
#import "PPKorreFoodInfo.h"

NS_ASSUME_NONNULL_BEGIN

@interface PPBluetoothKorreDataAnalysis : NSObject

+ (PPAnalysisResultModel *)analysisData:(NSData *)receiveDate device:( PPBluetoothAdvDeviceModel *)deviceAdv;

+ (PPBatteryInfoModel *)analysisStrengthWithData:(NSData *)receiveData;

+ (NSArray <PPBluetoothScaleBaseModel *>*)foodHistoryWithData:(NSData *)data device:( PPBluetoothAdvDeviceModel *)deviceAdv;

+ (void)korreDealWithMemberIdAndUserId:(NSString *)reciveStr settingModelArray:(NSMutableArray *)array;

+ (NSArray <PPBluetoothScaleBaseModel *>*)savedFoodListWithData:(NSData *)data device:( PPBluetoothAdvDeviceModel *)deviceAdv;

@end

NS_ASSUME_NONNULL_END
