//
//  PPBodyFatModel+Calculate.h
//  Pods
//
//  Created by lefu on 2024/4/26
//  


#import <Foundation/Foundation.h>
#import "PPCalculateKit.h"
#import <PPBaseKit/PPBaseKit.h>
#import "PPCalculateInputModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface PPBodyFatModel (Calculate)

#pragma mark - 普通构造方法，用于秤端计算

- (instancetype)initWithUserModel:(PPBluetoothDeviceSettingModel *)userModel
                        andWeight:(CGFloat)weight;

/// 4电极 & 8电极 算法入口
- (instancetype)initWithInputModel:(PPCalculateInputModel *)inputModel;



/// 8电极-平滑算法（CF597专用）
- (instancetype)initSmoothWithLastInputModel:(PPCalculateInputModel *)lastModel
                           currentInputModel:(PPCalculateInputModel *)currentModel;


@end


NS_ASSUME_NONNULL_END

