//
//  PPScaleState.h
//  Pods
//
//  Created by lefu on 2024/8/30
//  


#import <Foundation/Foundation.h>
#import "PPBluetoothDefine.h"


typedef NS_ENUM(NSUInteger, PPScaleFootState) {
    PPScaleFootStateNotMeasured, // 脚长未测量
    PPScaleFootStatePrepare, // 脚长准备中
    PPScaleFootStateMeasuring, // 脚长测量中
    PPScaleFootStateMeasurementSuccessful, // 脚长测量成功
    PPScaleFootStateMeasurementFailed, // 脚长测量失败
};

@interface PPScaleState : NSObject

/// 抓零状态
@property (nonatomic, assign) PPScaleCaptureZeroType captureZeroType;

/// 心率测量状态
@property (nonatomic, assign) PPScaleHeartRateType heartRateType;

/// 阻抗测量状态
@property (nonatomic, assign) PPScaleImpedanceType impedanceType;

/// 测量模式
@property (nonatomic, assign) PPScaleMeasureModeType measureModeType;

/// 测量结果
@property (nonatomic, assign) PPScaleMeasureResultType measureResultType;

/// 电源状态
@property (nonatomic, assign) PPScalePowerType powerType;

/// 重量状态
@property (nonatomic, assign) PPScaleWeightType weightType;

/// 脚长测量状态
@property (nonatomic, assign) PPScaleFootState footState;

///  营养秤当前模式
@property (nonatomic, assign) PPNutritionalScaleMode nutritionalScaleMode;


@end


