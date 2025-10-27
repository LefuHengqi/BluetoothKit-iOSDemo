//
//  PPTargetModel.h
//  PPBluetoothKit
//
//  Created by lefu on 2025/8/21
//  


#import <Foundation/Foundation.h>
#import "PPBluetoothDefine.h"

@interface PPTargetModel : NSObject
@property (nonatomic, assign) PPUserBodyDataType type; // 指标类型
@property (nonatomic, assign) CGFloat value; // 数值（重量kg、BMI、体脂率、肌肉率等）

@end


