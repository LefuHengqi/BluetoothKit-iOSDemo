//
//  PPBloodOxygenDataModel.h
//  PPBluetoothKit
//
//  Created by lefu on 2026/10/12
//  


#import <Foundation/Foundation.h>

@interface PPBloodSlotModel : NSObject
/// 血氧-slot0
@property (nonatomic, assign) NSInteger slot0;
/// 血氧-slot1
@property (nonatomic, assign) NSInteger slot1;
/// 血氧-slot2
@property (nonatomic, assign) NSInteger slot2;

@end


@interface PPBloodOxygenDataModel : NSObject
/// 血氧
@property (nonatomic, assign) NSInteger bloodOxygen;
/// 佩戴状态， 0：未佩戴，1：已佩戴
@property (nonatomic, assign) NSInteger wearStatus;
/// 血氧原始数据
@property (nonatomic, strong) NSArray<PPBloodSlotModel *> *originDatas;


@end



