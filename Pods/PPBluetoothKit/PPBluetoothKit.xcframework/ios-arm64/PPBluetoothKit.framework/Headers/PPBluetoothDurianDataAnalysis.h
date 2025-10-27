//
//  PPBluetoothDurianDataAnalysis.h
//  PPBluetoothKit
//
//  Created by 彭思远 on 2023/4/3.
//

#import <Foundation/Foundation.h>
//#import "PPBodyFatModel.h"
#import "PPBluetoothScaleBaseModel.h"
#import "PPBluetoothKit.h"

NS_ASSUME_NONNULL_BEGIN

@interface PPBluetoothDurianDataAnalysis : NSObject

+ (PPBodyFatModel *)analysis16LengthData:(NSData *)receiveDate;

+ (void)analysis17LengthData:(NSData *)receiveDate withHandler:(void(^)( PPBluetoothScaleBaseModel *baseModel, PPBodyFatModel *fatModel))handler;

+ (PPBodyFatModel *)analysis20LengthData:(NSData *)receiveDate;

@end

NS_ASSUME_NONNULL_END
