//
//  PPCalculateInputModel.h
//  Pods
//
//  Created by lefu on 2025/8/18
//  


#import <Foundation/Foundation.h>
#import "PPBaseKit/PPBaseKit.h"
#import "PPCalculateDefine.h"

@interface PPCalculateInputModel : NSObject

/// 密钥，必传
@property (nonatomic, copy) NSString *secret;
/// 算法类型，必传
@property (nonatomic, assign) PPDeviceCalcuteType deviceCalcuteType;
///体重-单位kg，必传
@property (nonatomic, assign) CGFloat weight;
/// 是否孕妇，必传
@property (nonatomic, assign) BOOL isPregnantMode;
/// 是否运动员，必传
@property (nonatomic, assign) BOOL isAthleteMode;
/// 年龄，必传
@property (nonatomic, assign) NSInteger age;
/// 性别，必传
@property (nonatomic, assign) PPDeviceGenderType gender;
/// 身高-单位cm，必传
@property (nonatomic, assign) NSInteger height;


/// 设备Mac，没有可不传
@property (nonatomic, copy) NSString *deviceMac;
/// 心率，没有可不传
@property (nonatomic, assign) NSInteger heartRate;
/// 脚长，没有可不传
@property (nonatomic, assign) NSInteger footLen;
/// 时间戳-单位秒，没有可不传
@property (nonatomic, assign) NSTimeInterval timeInterval;
/// 设备单位，没有可不传
@property (nonatomic, assign) PPDeviceUnit unit;

/// 4电极- 阻抗
@property (nonatomic, assign) NSInteger impedance;
/// 4电极- 双频加密阻抗-100频率字段
@property (nonatomic, assign) NSInteger impedance100EnCode;
/// 身体年龄计算方式
@property (nonatomic, assign) PPBodyAgeMethod bodyAgeMethod;


/// 8电极- 20KHz左手阻抗加密值(下位机上传值)
@property (nonatomic, assign) NSInteger z20KhzLeftArmEnCode;
/// 8电极- 20KHz右手阻抗加密值(下位机上传值)
@property (nonatomic, assign) NSInteger z20KhzRightArmEnCode;
/// 8电极- 20KHz左腳阻抗加密值(下位机上传值)
@property (nonatomic, assign) NSInteger z20KhzLeftLegEnCode;
/// 8电极- 20KHz右腳阻抗加密值(下位机上传值)
@property (nonatomic, assign) NSInteger z20KhzRightLegEnCode;
/// 8电极- 20KHz軀幹阻抗加密值(下位机上传值)
@property (nonatomic, assign) NSInteger z20KhzTrunkEnCode;
/// 8电极- 100KHz左手阻抗加密值(下位机上传值)
@property (nonatomic, assign) NSInteger z100KhzLeftArmEnCode;
/// 8电极- 100KHz右手阻抗加密值(下位机上传值)
@property (nonatomic, assign) NSInteger z100KhzRightArmEnCode;
/// 8电极- 100KHz左腳阻抗加密值(下位机上传值)
@property (nonatomic, assign) NSInteger z100KhzLeftLegEnCode;
/// 8电极- 100KHz右腳阻抗加密值(下位机上传值)
@property (nonatomic, assign) NSInteger z100KhzRightLegEnCode;
/// 8电极- 100KHz軀幹阻抗加密值(下位机上传值)
@property (nonatomic, assign) NSInteger z100KhzTrunkEnCode;


@end


