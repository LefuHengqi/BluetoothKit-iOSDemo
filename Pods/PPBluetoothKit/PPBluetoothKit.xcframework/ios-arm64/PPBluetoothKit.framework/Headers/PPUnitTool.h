//
//  PPUnitTool.h
//  PPScaleSDKDebug
//
//  Created by 彭思远 on 2022/6/27.
//

#import <Foundation/Foundation.h>
#import "PPBluetoothKit.h"
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

#define kUnitToolWeightKey @"weight"
#define kUnitToolUnitNameKey @"unitStr"
#define kUnitToolUnitKey @"unit"

#define kUnitToolWeightlboz_lbKey @"lboz_lb"
#define kUnitToolWeightlboz_ozKey @"lboz_oz"

#define kUnit_G @"g"
#define kUnit_LB_OZ @"lb:oz"
#define kUnit_ML_Water @"ml"
#define kUnit_FL_OZ @"fl:oz"
#define kUnit_ML_Milk @"ml"
#define kUnit_OZ @"oz"
#define kUnit_LB @"lb"

@interface UnitLB_OZ : NSObject
@property (nonatomic, assign) NSInteger lb;
@property (nonatomic, assign) CGFloat oz;
@end

@interface PPUnitTool : NSObject

#pragma  mark - 重量单位

+ (NSString *)getUnitStr:(NSDictionary *)dic;

+ (PPDeviceUnit)getUnit:(NSDictionary *)dic;

+ (NSString *)getWeightStr:(NSDictionary *)dic;

+ (NSString *)getWeightAndUnitStr:(NSDictionary *)dic;

+ (NSDictionary *)weightStrWithGFloat:(CGFloat)g accuracyType:(PPDeviceAccuracyType)accuracyType andUnit:(PPDeviceUnit)unitType deviceName:(NSString *)deviceName;

// 计算新方法（0.1g精度的需放大10倍传进来）
+ (NSDictionary *)weightStrNewWithGFloat:(CGFloat)g accuracyType:(PPDeviceAccuracyType)accuracyType andUnit:(PPDeviceUnit)unitType deviceName:(NSString *)deviceName;


+ (CGFloat)lb_oz2gWihtlb:(NSInteger)lb andOz:(CGFloat)oz;

+ (CGFloat)ml_water2g:(CGFloat)ml_water;

+ (CGFloat)fl_oz2g:(CGFloat)fl_oz;

+ (CGFloat)ml_milk2g:(CGFloat)ml_milk;

+ (CGFloat)oz2g:(CGFloat)oz;

+ (CGFloat)g2lb:(CGFloat)g;

+ (CGFloat)lb2g:(CGFloat)lb;
@end

NS_ASSUME_NONNULL_END
