//
//  PPHeartRateDataModel.h
//  PPBluetoothKit
//
//  Created by lefu on 2026/10/12
//  


#import <Foundation/Foundation.h>

@interface PPHeartRateDataModel : NSObject
/// 心率
@property (nonatomic, assign) NSInteger heartRate;
/// 佩戴状态， 0：未佩戴，1：已佩戴
@property (nonatomic, assign) NSInteger wearStatus;
/// 心率原始数据
@property (nonatomic, strong) NSArray<NSNumber *> *originDatas;
@end


