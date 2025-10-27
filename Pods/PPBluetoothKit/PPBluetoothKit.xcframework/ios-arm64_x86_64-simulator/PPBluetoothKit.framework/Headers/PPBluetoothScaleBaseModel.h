//
//  PPBluetoothScaleBaseModel.h
//  PPBlueToothDemo
//
//  Created by 彭思远 on 2020/7/31.
//  Copyright © 2020 彭思远. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PPBluetoothDefine.h"
#import "PPKorreFoodInfo.h"




@interface PPBluetoothScaleBaseModel : NSObject

@property (nonatomic, assign) NSInteger weight; // 重量放大了100倍
@property (nonatomic, assign) NSInteger impedance; //4电极算法阻抗
@property (nonatomic, assign) BOOL isEnd; // 本次测量是否结束
@property (nonatomic, assign) BOOL isPowerOff; // 设备是否关机

@property (nonatomic, assign) PPDeviceUnit unit; //设备单位
@property (nonatomic, assign) NSInteger heartRate; // 心律
@property (nonatomic, assign) BOOL isHeartRating; // 心律是否测量中
@property (nonatomic, assign) BOOL isFatting; // 体脂是否测量中
@property (nonatomic, assign) BOOL isOverload; // 是否超载
@property (nonatomic, assign) BOOL isPlus; // 是否是正数

@property (nonatomic, assign) NSInteger lightStrength; // 特殊秤光照强度
@property (nonatomic, assign) BOOL hasLightStrength; // 是否包含光照强度

 
@property (nonatomic, assign) NSInteger impedance100EnCode; // 100kHz密文阻抗(4电极双频)

@property (nonatomic, copy) NSString *dateStr; // formate yyyy-MM-dd HH:mm:ss

@property (nonatomic, assign, readonly) double dateTimeInterval; // dataStr since1970的时间戳

@property (nonatomic, copy) NSString *memberId; //数据归属 torre协议用
@property (nonatomic, assign) NSInteger footLen; // 脚长，CM放大100倍
@property (nonatomic, strong) PPKorreFoodInfo *foodInfo; // 食物信息，营养秤才支持



@property (nonatomic, assign) NSInteger  z100KhzLeftArmEnCode;//100KHz左手阻抗加密值(下位机上传值)
@property (nonatomic, assign) NSInteger  z100KhzLeftLegEnCode;//100KHz左腳阻抗加密值(下位机上传值)
@property (nonatomic, assign) NSInteger  z100KhzRightArmEnCode;//100KHz右手阻抗加密值(下位机上传值)
@property (nonatomic, assign) NSInteger  z100KhzRightLegEnCode;//100KHz右腳阻抗加密值(下位机上传值)
@property (nonatomic, assign) NSInteger  z100KhzTrunkEnCode;//100KHz軀幹阻抗加密值(下位机上传值)
@property (nonatomic, assign) NSInteger  z20KhzLeftArmEnCode;//20KHz左手阻抗加密值(下位机上传值)
@property (nonatomic, assign) NSInteger  z20KhzLeftLegEnCode;//20KHz左腳阻抗加密值(下位机上传值)
@property (nonatomic, assign) NSInteger  z20KhzRightArmEnCode;//20KHz右手阻抗加密值(下位机上传值)
@property (nonatomic, assign) NSInteger  z20KhzRightLegEnCode;//20KHz右腳阻抗加密值(下位机上传值)
@property (nonatomic, assign) NSInteger  z20KhzTrunkEnCode;//20KHz軀幹阻抗加密值(下位机上传值)

@end


