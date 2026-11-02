//
//  PPUserRecentBodyData.h
//  PPBluetoothKit
//
//  Created by lefu on 2024/4/30
//  


#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN



@interface PPUserRecentBodyData : NSObject

@property (nonatomic, assign) NSInteger value; // 重量：放大100倍,如：60.5kg 传 6550； 其他指标放大10倍，如：29.0% 传290
@property (nonatomic, assign) double timeStamp; // 时间戳



@property (nonatomic, assign) CGFloat bmi; // bmi：放大100倍

@property (nonatomic, assign) CGFloat bodyfat; // bodyfat：放大100倍

@property (nonatomic, assign) CGFloat heartRate; // heartRate：放大10倍,960 = 96

@property (nonatomic, assign) CGFloat muscleRate; // muscleRate：放大100倍

@property (nonatomic, assign) CGFloat muscle; // muscle：放大100倍

@property (nonatomic, assign) CGFloat bone; // muscle：放大100倍

@property (nonatomic, assign) CGFloat boneRate; // 骨骼肌率：放大100倍

@property (nonatomic, assign) CGFloat waterRate; // 水分率：放大100倍

@property (nonatomic, assign) CGFloat visceralFat; // 内脏脂肪，放大10倍

@property (nonatomic, assign) NSInteger weight; // 重量，放大100倍

@end

NS_ASSUME_NONNULL_END
