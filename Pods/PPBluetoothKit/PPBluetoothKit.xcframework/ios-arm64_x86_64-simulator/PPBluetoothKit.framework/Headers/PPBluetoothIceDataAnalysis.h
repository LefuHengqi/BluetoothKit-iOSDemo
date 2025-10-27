//
//  PPBluetoothHamburgerDataAnalysis.h
//  Alamofire
//
//  Created by 杨青山 on 2023/9/6.
//

#import <Foundation/Foundation.h>
#import "PPBluetoothScaleBaseModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface PPBluetoothIceDataAnalysis : NSObject

+ (PPBluetoothScaleBaseModel *)analysisData:(NSData *)receiveDate;

+ (PPBluetoothScaleBaseModel *)cf597HistoryWithData:(NSData *)reciveData;

/// 获取组包中的历史数据--新协议
+ (NSArray<PPBluetoothScaleBaseModel *> *)cf597HistorysWithTotalData:(NSData *)totalData;

+ (NSString *)dateStrWithYear:(int)year mounth:(int)mounth day:(int)day hour:(int)hour minite:(int)minite second:(int)secound;

@end

NS_ASSUME_NONNULL_END
