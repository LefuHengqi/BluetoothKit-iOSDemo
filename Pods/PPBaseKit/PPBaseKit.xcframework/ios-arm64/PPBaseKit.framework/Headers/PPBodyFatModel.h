//
//  PPBodyFatModel.h
//  PPBlueToothDemo
//
//  Created by 彭思远 on 2020/7/31.
//  Copyright © 2020 彭思远. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PPBaseDefine.h"



@class PPBodyDetailStandardArray;
@class Bh2Body270;
@class BhTwoLegs140;
@class Bh4TwoArms140;
@class PPPeopleGeneral;
@class Bh1TwoLegs140;
@class Bh3TwoLegs240;
@class Bh5Body270;

///错误类型(针对输入的参数)
typedef NS_ENUM(NSInteger, PPBodyfatErrorType){

    PP_ERROR_TYPE_NONE = 0,
    PP_ERROR_TYPE_AGE ,
    PP_ERROR_TYPE_HEIGHT,
    PP_ERROR_TYPE_WEIGHT,
    PP_ERROR_TYPE_SEX,
    PP_ERROR_TYPE_PEOPLE_TYPE,
    PP_ERROR_TYPE_IMPEDANCE_TWO_LEGS,
    PP_ERROR_TYPE_IMPEDANCE_TWO_ARMS,
    PP_ERROR_TYPE_IMPEDANCE_LEFT_BODY,
    PP_ERROR_TYPE_IMPEDANCE_LEFT_ARM,
    PP_ERROR_TYPE_IMPEDANCE_RIGHT_ARM,
    PP_ERROR_TYPE_IMPEDANCE_LEFT_LEG,
    PP_ERROR_TYPE_IMPEDANCE_RIGHT_LEG,
    PP_ERROR_TYPE_IMPEDANCE_TRUNK,
    PP_ERROR_TYPE_HOME,
    PP_ERROR_TYPE_PRODUCT,

};


//肥胖等级
typedef NS_ENUM(NSInteger, PPBodyFatGrade) {
    
    PPBodyGradeFatThin,             // 偏瘦
    PPBodyGradeFatStandard,      // 标准
    PPBodyGradeFatOverwight,         // 超重
    PPBodyGradeFatOne,             // 肥胖1级
    PPBodyGradeFatTwo,            // 肥胖2级
    PPBodyGradeFatThree,           // 肥胖3级
 
};
//健康评估
typedef NS_ENUM(NSInteger, PPBodyHealthAssessment) {
    
    PPBodyAssessment1,          // 健康存在隐患
    PPBodyAssessment2,          // 亚健康
    PPBodyAssessment3,          // 一般
    PPBodyAssessment4,          // 良好
    PPBodyAssessment5,          // 非常好
};

// 身体类型
typedef NS_ENUM(NSUInteger, PPBodyDetailType) {
    
     PPBodyTypeThin,             // 偏瘦型
     PPBodyTypeThinMuscle,      // 偏瘦肌肉型
     PPBodyTypeMuscular,         // 肌肉发达型
    
     PPBodyTypeLackofexercise,   // 缺乏运动型
     PPBodyTypeStandard,         // 标准型
     PPBodyTypeStandardMuscle,   // 标准肌肉型
    
     PPBodyTypeObesFat,          // 浮肿肥胖型
     PPBodyTypeFatMuscle,       // 偏胖肌肉型
     PPBodyTypeMuscleFat,        // 肌肉型偏胖
};

// 通用身体等级
typedef NS_ENUM(NSInteger, PPCommonBodyPartsLevel) {
    PPCommonBodyPartsLevelLow = 0, //偏低
    PPCommonBodyPartsLevelNormal, //正常
    PPCommonBodyPartsLevelHigh, //偏高
};

// 通用均衡度等级
typedef NS_ENUM(NSInteger, PPCommonEquilibriumLevel) {
    PPCommonEquilibriumLevelBalance = 0, //均衡
    PPCommonEquilibriumLevelMildImbalance, //轻度不均衡
    PPCommonEquilibriumLevelSevereImbalance, //重度不均衡
};

NS_ASSUME_NONNULL_BEGIN

@interface PPBodyFatModel : NSObject

#pragma mark - 用户信息

@property (nonatomic,assign) PPBodyfatErrorType   errorType;
/// 性别
@property (nonatomic,assign) PPDeviceGenderType   ppSex;
/// 身高(cm)
@property (nonatomic,assign) NSInteger            ppHeightCm;
/// 年龄(岁)
@property (nonatomic,assign) NSInteger            ppAge;
/// 体重(kg)
@property (nonatomic,assign) CGFloat              ppWeightKg;
/// 双脚阻抗加密值(下位机上传值)
@property (nonatomic,assign) NSInteger            ppZTwoLegsEnCode;
///100KHz左手阻抗加密值(下位机上传值)
@property (nonatomic,assign) NSInteger   ppZ100KhzLeftArmEnCode;
///100KHz左腳阻抗加密值(下位机上传值)
@property (nonatomic,assign) NSInteger   ppZ100KhzLeftLegEnCode;
///100KHz右手阻抗加密值(下位机上传值)
@property (nonatomic,assign) NSInteger   ppZ100KhzRightArmEnCode;
///100KHz右腳阻抗加密值(下位机上传值)
@property (nonatomic,assign) NSInteger   ppZ100KhzRightLegEnCode;
///100KHz軀幹阻抗加密值(下位机上传值)
@property (nonatomic,assign) NSInteger   ppZ100KhzTrunkEnCode;
///20KHz左手阻抗加密值(下位机上传值)
@property (nonatomic,assign) NSInteger   ppZ20KhzLeftArmEnCode;
///20KHz左腳阻抗加密值(下位机上传值)
@property (nonatomic,assign) NSInteger   ppZ20KhzLeftLegEnCode;
///20KHz右手阻抗加密值(下位机上传值)
@property (nonatomic,assign) NSInteger   ppZ20KhzRightArmEnCode;
///20KHz右腳阻抗加密值(下位机上传值)
@property (nonatomic,assign) NSInteger   ppZ20KhzRightLegEnCode;
///20KHz軀幹阻抗加密值(下位机上传值)
@property (nonatomic,assign) NSInteger   ppZ20KhzTrunkEnCode;

///100KHz左手阻抗解密值(下位机上传值)
@property (nonatomic,assign) CGFloat   ppZ100KhzLeftArmDeCode;
///100KHz左腳阻抗解密值(下位机上传值)
@property (nonatomic,assign) CGFloat   ppZ100KhzLeftLegDeCode;
///100KHz右手阻抗解密值(下位机上传值)
@property (nonatomic,assign) CGFloat   ppZ100KhzRightArmDeCode;
///100KHz右腳阻抗解密值(下位机上传值)
@property (nonatomic,assign) CGFloat   ppZ100KhzRightLegDeCode;
///100KHz軀幹阻抗解密值(下位机上传值)
@property (nonatomic,assign) CGFloat   ppZ100KhzTrunkDeCode;
///20KHz左手阻抗解密值(下位机上传值)
@property (nonatomic,assign) CGFloat   ppZ20KhzLeftArmDeCode;
///20KHz左腳阻抗解密值(下位机上传值)
@property (nonatomic,assign) CGFloat   ppZ20KhzLeftLegDeCode;
///20KHz右手阻抗解密值(下位机上传值)
@property (nonatomic,assign) CGFloat   ppZ20KhzRightArmDeCode;
///20KHz右腳阻抗解密值(下位机上传值)
@property (nonatomic,assign) CGFloat   ppZ20KhzRightLegDeCode;
///20KHz軀幹阻抗解密值(下位机上传值)
@property (nonatomic,assign) CGFloat   ppZ20KhzTrunkDeCode;


/// 四电极设备双频-100kHz密文阻抗
@property (nonatomic,assign) NSInteger ppImpedance100EnCode;

/// 四电极设备双频-100kHz解密阻抗
@property (nonatomic, assign)CGFloat ppImpedance100DeCode;


/// 四电极算法解密阻抗
@property (nonatomic, assign)CGFloat ppZTwoLegsDeCode;




#pragma mark - 设备相关

/// 秤端单位
@property (nonatomic,assign) PPDeviceUnit          ppUnit;
/// 计算库版本号
/// 8电极     HT_8_BHLefu_2023-05-15_V1.5.5
/// 4电极     HT_4_BHLefu_2023-05-15_V5.0.1
/// 4电极直流  LF_4_ZLefu_2023-05-15_V1.0.0
@property (nonatomic,copy) NSString                *ppSDKVersion;
/// 产生设备的蓝牙MAC
@property (nonatomic,copy) NSString                *ppDeviceMac;



#pragma mark - 四电极算法

@property (nonatomic,strong) NSArray<NSNumber *>* ppWeightKgList;

/// Body Mass Index
@property (nonatomic,assign) CGFloat              ppBMI;
@property (nonatomic,strong) NSArray<NSNumber *>* ppBMIList;

/// 脂肪率(%)
@property (nonatomic,assign) CGFloat              ppFat;
@property (nonatomic,strong) NSArray<NSNumber *>* ppFatList;

/// 脂肪量(kg)
@property (nonatomic,assign) CGFloat               ppBodyfatKg;
@property (nonatomic,strong) NSArray<NSNumber *>* ppBodyfatKgList;

/// 肌肉率(%)
@property (nonatomic,assign) CGFloat               ppMusclePercentage;
@property (nonatomic,strong) NSArray<NSNumber *>* ppMusclePercentageList;

/// 肌肉量(kg)
@property (nonatomic,assign) CGFloat               ppMuscleKg;
@property (nonatomic,strong) NSArray<NSNumber *>* ppMuscleKgList;

/// 骨骼肌率(%)
@property (nonatomic,assign) CGFloat               ppBodySkeletal;
@property (nonatomic,strong) NSArray<NSNumber *>* ppBodySkeletalList;

/// 骨骼肌量(kg)
@property (nonatomic,assign) CGFloat               ppBodySkeletalKg;
@property (nonatomic,strong) NSArray<NSNumber *>* ppBodySkeletalKgList;

/// 水分率(%), 分辨率0.1,
@property (nonatomic,assign) CGFloat               ppWaterPercentage;
@property (nonatomic,strong) NSArray<NSNumber *>* ppWaterPercentageList;

///水分量(Kg)
@property (nonatomic,assign) CGFloat               ppWaterKg;
@property (nonatomic,strong) NSArray<NSNumber *>* ppWaterKgList;

/// 蛋白质率(%)
@property (nonatomic,assign) CGFloat               ppProteinPercentage;
@property (nonatomic,strong) NSArray<NSNumber *>* ppProteinPercentageList;

///蛋白质量(Kg)
@property (nonatomic,assign) CGFloat               ppProteinKg;
@property (nonatomic,strong) NSArray<NSNumber *>* ppProteinKgList;
 
/// 去脂体重(kg)
@property (nonatomic,assign) CGFloat               ppLoseFatWeightKg;
@property (nonatomic,strong) NSArray<NSNumber *>* ppLoseFatWeightKgList;

/// 皮下脂肪率(%)
@property (nonatomic,assign) CGFloat               ppBodyFatSubCutPercentage;
@property (nonatomic,strong) NSArray<NSNumber *>* ppBodyFatSubCutPercentageList;

/// 皮下脂肪量(kg)
@property (nonatomic,assign) CGFloat               ppBodyFatSubCutKg;
@property (nonatomic,strong) NSArray<NSNumber *>* ppBodyFatSubCutKgList;

/// 心律(bmp)
@property (nonatomic,assign) NSInteger             ppHeartRate;
@property (nonatomic,strong) NSArray<NSNumber *>* ppHeartRateList;

/// 脚长(cm)，放大100倍
@property (nonatomic,assign) NSInteger             ppFootLen;
@property (nonatomic,strong) NSArray<NSNumber *>* ppFootLenList;

/// 基础代谢(kcal/day)
@property (nonatomic,assign) NSInteger             ppBMR;
@property (nonatomic,strong) NSArray<NSNumber *>* ppBMRList;

/// 内脏脂肪等级
@property (nonatomic,assign) NSInteger             ppVisceralFat;
@property (nonatomic,strong) NSArray<NSNumber *>* ppVisceralFatList;

/// 骨量(kg)
@property (nonatomic,assign) CGFloat               ppBoneKg;
@property (nonatomic,strong) NSArray<NSNumber *>* ppBoneKgList;


/// 肌肉控制量(kg)
@property (nonatomic,assign) CGFloat              ppBodyMuscleControl;
/// 脂肪控制量(kg)
@property (nonatomic,assign) CGFloat              ppFatControlKg;
/// 标准体重(kg)
@property (nonatomic,assign) CGFloat              ppBodyStandardWeightKg;
/// 理想体重(kg)
@property (nonatomic,assign) CGFloat              ppIdealWeightKg;

/// 控制体重(kg)
@property (nonatomic,assign) CGFloat              ppControlWeightKg;
/// 身体类型
@property (nonatomic,assign) PPBodyDetailType     ppBodyType;

/// 肥胖等级
@property (nonatomic,assign) PPBodyFatGrade       ppFatGrade;

/// 健康评估
@property (nonatomic,assign) PPBodyHealthAssessment   ppBodyHealth;

/// 身体年龄
@property (nonatomic,assign) NSInteger            ppBodyAge;
@property (nonatomic,strong) NSArray<NSNumber *>* ppBodyAgeList;

/// 身体得分
@property (nonatomic,assign) NSInteger            ppBodyScore;
@property (nonatomic,strong) NSArray<NSNumber *>* ppBodyScoreList;



#pragma mark - 八电极算法独有


///輸出參數-全身体组成:身体细胞量(kg)
@property (nonatomic,assign) CGFloat               ppCellMassKg;
 @property (nonatomic,strong) NSArray<NSNumber *>* ppCellMassKgList;

///輸出參數-评价建议:建议卡路里摄入量 kcal/day
@property (nonatomic,assign) NSInteger             ppDCI;

///輸出參數-全身体组成:无机盐量(kg)
@property (nonatomic,assign) CGFloat               ppMineralKg;
 @property (nonatomic,strong) NSArray<NSNumber *>* ppMineralKgList;

///輸出參數-评价建议: 肥胖度(%)
@property (nonatomic,assign) CGFloat               ppObesity;
 @property (nonatomic,strong) NSArray<NSNumber *>* ppObesityList;

///輸出參數-全身体组成:细胞外水量(kg)
@property (nonatomic,assign) CGFloat               ppWaterECWKg;
 @property (nonatomic,strong) NSArray<NSNumber *>* ppWaterECWKgList;

///輸出參數-全身体组成:细胞内水量(kg)
@property (nonatomic,assign) CGFloat               ppWaterICWKg;
 @property (nonatomic,strong) NSArray<NSNumber *>* ppWaterICWKgList;

///左手脂肪量(%), 分辨率0.1
@property (nonatomic,assign) CGFloat               ppBodyFatKgLeftArm;

///左脚脂肪量(%), 分辨率0.1
@property (nonatomic,assign) CGFloat               ppBodyFatKgLeftLeg;

///右手脂肪量(%), 分辨率0.1
@property (nonatomic,assign) CGFloat               ppBodyFatKgRightArm;

///右脚脂肪量(%), 分辨率0.1
@property (nonatomic,assign) CGFloat               ppBodyFatKgRightLeg;

///躯干脂肪量(%), 分辨率0.1
@property (nonatomic,assign) CGFloat               ppBodyFatKgTrunk;

///左手脂肪率(%), 分辨率0.1
@property (nonatomic,assign) CGFloat               ppBodyFatRateLeftArm;

///左脚脂肪率(%), 分辨率0.1
@property (nonatomic,assign) CGFloat               ppBodyFatRateLeftLeg;

///右手脂肪率(%), 分辨率0.1
@property (nonatomic,assign) CGFloat               ppBodyFatRateRightArm;

///右脚脂肪率(%), 分辨率0.1
@property (nonatomic,assign) CGFloat               ppBodyFatRateRightLeg;

///躯干脂肪率(%), 分辨率0.1
@property (nonatomic,assign) CGFloat               ppBodyFatRateTrunk;

///左手肌肉量(kg), 分辨率0.1
@property (nonatomic,assign) CGFloat               ppMuscleKgLeftArm;

///左脚肌肉量(kg), 分辨率0.1
@property (nonatomic,assign) CGFloat               ppMuscleKgLeftLeg;

///右手肌肉量(kg), 分辨率0.1
@property (nonatomic,assign) CGFloat               ppMuscleKgRightArm;

///右脚肌肉量(kg), 分辨率0.1
@property (nonatomic,assign) CGFloat               ppMuscleKgRightLeg;

///躯干肌肉量(kg), 分辨率0.1
@property (nonatomic,assign) CGFloat               ppMuscleKgTrunk;

///左手肌肉率(%), 分辨率0.1
@property (nonatomic,assign) CGFloat               ppMuscleRateLeftArm;

///左脚肌肉率(%), 分辨率0.1
@property (nonatomic,assign) CGFloat               ppMuscleRateLeftLeg;

///右手肌肉率(%), 分辨率0.1
@property (nonatomic,assign) CGFloat               ppMuscleRateRightArm;

///右脚肌肉率(%), 分辨率0.1
@property (nonatomic,assign) CGFloat               ppMuscleRateRightLeg;

///躯干肌肉率(%), 分辨率0.1
@property (nonatomic,assign) CGFloat               ppMuscleRateTrunk;

///右手肌肉标准
@property (nonatomic, assign) PPCommonBodyPartsLevel ppRightArmMuscleLevel;

///左手肌肉标准
@property (nonatomic, assign) PPCommonBodyPartsLevel ppLeftArmMuscleLevel;

///躯干肌肉标准
@property (nonatomic, assign) PPCommonBodyPartsLevel ppTrunkMuscleLevel;

///右脚肌肉标准
@property (nonatomic, assign) PPCommonBodyPartsLevel ppRightLegMuscleLevel;

///左脚肌肉标准
@property (nonatomic, assign) PPCommonBodyPartsLevel ppLeftLegMuscleLevel;

///右手脂肪标准
@property (nonatomic, assign) PPCommonBodyPartsLevel ppRightArmFatLevel;

///左手脂肪标准
@property (nonatomic, assign) PPCommonBodyPartsLevel ppLeftArmFatLevel;

///躯干脂肪标准
@property (nonatomic, assign) PPCommonBodyPartsLevel ppTrunkFatLevel;

///右脚脂肪标准
@property (nonatomic, assign) PPCommonBodyPartsLevel ppRightLegFatLevel;

///左脚脂肪标准
@property (nonatomic, assign) PPCommonBodyPartsLevel ppLeftLegFatLevel;

///上肢肌肉均衡
@property (nonatomic, assign) PPCommonEquilibriumLevel ppBalanceArmsLevel;

///下肢肌肉均衡
@property (nonatomic, assign) PPCommonEquilibriumLevel ppBalanceLegsLevel;

///肌肉-上下均衡度
@property (nonatomic, assign) PPCommonEquilibriumLevel ppBalanceArmLegLevel;

///上肢脂肪均衡
@property (nonatomic, assign) PPCommonEquilibriumLevel ppBalanceFatArmsLevel;

///下肢脂肪均衡
@property (nonatomic, assign) PPCommonEquilibriumLevel ppBalanceFatLegsLevel;

///脂肪-上下均衡度
@property (nonatomic, assign) PPCommonEquilibriumLevel ppBalanceFatArmLegLevel;



///骨骼肌质量指数
@property(nonatomic,assign) CGFloat                ppSmi;
@property (nonatomic,strong) NSArray<NSNumber *>* ppSmiList;

///腰臀比
@property(nonatomic,assign) CGFloat                ppWHR;
@property (nonatomic,strong) NSArray<NSNumber *>* ppWHRList;




#pragma mark - 闭目单脚功能
/// 闭目单脚站立时间
@property (nonatomic,assign) NSInteger           ppStandTime;




@property (nonatomic,strong) PPBodyDetailStandardArray *standardArray;

@property (nonatomic, strong) Bh2Body270 *body270;

@property (nonatomic, strong) Bh5Body270 *body5_270;

@property (nonatomic, strong) BhTwoLegs140 *bodyLegs140;

@property (nonatomic, strong) Bh4TwoArms140 *bodyArms140;

@property (nonatomic, strong) PPPeopleGeneral *bodyLegsD;

@property (nonatomic, assign) PPDeviceCalcuteType calcuteType;

@property (nonatomic, strong) Bh1TwoLegs140 *bh1BodyLegs140;

@property (nonatomic, strong) Bh3TwoLegs240 *bh1BodyLegs240;

@end




NS_ASSUME_NONNULL_END
