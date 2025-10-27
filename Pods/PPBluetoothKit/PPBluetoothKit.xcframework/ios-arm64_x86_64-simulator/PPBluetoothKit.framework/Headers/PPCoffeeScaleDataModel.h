//
//  PPCoffeeScaleDataModel.h
//  Pods
//
//  Created by lefu on 2025/7/1
//  


#import <Foundation/Foundation.h>
#import "PPBluetoothDefine.h"


@interface PPCoffeeScaleDataModel : NSObject

/// dataStr since1970的时间戳（秒）
@property (nonatomic, assign) double dateTimeInterval;


/// 测量重量状态
@property (nonatomic, assign) PPWeightStatus weightStatus;

/// 计时器状态
@property (nonatomic, assign) PPTimerStatus timerStatus;

/// 当前模式
@property (nonatomic, assign) PPCoffeeCurrentMode currentMode;

/// 咖啡阶段，注：coffeeStage != PPCoffeeStageShowRatio才有值
@property (nonatomic, assign) PPCoffeeStage coffeeStage;

/// 咖啡阶段-子模式
@property (nonatomic, assign) PPCoffeeStageSubMode coffeeStageSubMode;

/// 咖啡粉重量，单位:0.1g，放大十倍上传，注：coffeeStage != PPCoffeeStageShowRatio才有值
@property (nonatomic, assign) NSInteger coffeeWeight;

/// 用户设置的咖啡粉重量，单位:0.1g，放大十倍上传
@property (nonatomic, assign) NSInteger userCoffeeWeight;

/// 咖啡粉重量，是否为正数
@property (nonatomic, assign) BOOL isCoffeeWeightPlus;

/// 重量，单位:0.1g，放大十倍上传，注：coffeeStage != PPCoffeeStageShowRatio才有值
@property (nonatomic, assign) NSInteger weight;

/// 粉液比，注：coffeeStage 为 PPCoffeeStageShowRatio 才有值
@property (nonatomic, assign) NSInteger coffeeWaterRatio;

/// 总注水量，注：coffeeStage 为 PPCoffeeStageShowRatio 才有值
@property (nonatomic, assign) NSInteger totalWaterWeight;

/// 液重，注：coffeeStage 为 PPCoffeeStageShowRatio 才有值
@property (nonatomic, assign) NSInteger coffeeLiquidWeight;

/// 液重，是否为正数
@property (nonatomic, assign) BOOL isCoffeeLiquidWeightPlus;

/// 流速 单位:0.1g，放大十倍上传
@property (nonatomic, assign) NSInteger flowRate;

/// 计时器时间，单位:秒
@property (nonatomic, assign) NSInteger timerDuration;

///设备单位
@property (nonatomic, assign) PPDeviceUnit unit;

/// 重量是否为正数
@property (nonatomic, assign) BOOL isWeightPlus;

/// 水粉比（实时），单位:0.1
@property (nonatomic, assign) NSInteger brewRatio;

/// 用户设置的 水粉笔（手冲2有），单位:0.1
@property (nonatomic, assign) NSInteger userBrewRatio;

/// 移走重量，单位:0.1g，放大十倍上传
@property (nonatomic, assign) NSInteger removedWeight;

/// 移走重量，是否为正数
@property (nonatomic, assign) BOOL isRemovedWeightPlus;

/// 杯重，单位:0.1g，放大十倍上传
@property (nonatomic, assign) NSInteger cupWeight;



@end


