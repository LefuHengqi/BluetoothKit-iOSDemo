//
//  PPBaseDefine.h
//  PPBluetoothKIt
//
//  Created by 彭思远 on 2023/3/27.
//

#ifndef PPBaseDefine_h
#define PPBaseDefine_h



// 测脂计算方式
typedef NS_ENUM(NSUInteger, PPDeviceCalcuteType){
    
    PPDeviceCalcuteTypeUnknow = 0, // 未知
    PPDeviceCalcuteTypeInScale, // 秤端计算
    PPDeviceCalcuteTypeDirect, // 直流算法
    PPDeviceCalcuteTypeAlternate, // 交流算法
    PPDeviceCalcuteTypeAlternate8, // 8电极交流算法 CF577 bhProduct = 1
    PPDeviceCalcuteTypeAlternateNormal,   //默认计算库直接用合泰返回的体脂率
    PPDeviceCalcuteTypeNeedNot, // 无需计算
    PPDeviceCalcuteTypeAlternate8_0, // 8电极算法CF597 bhProduct = 4
    PPDeviceCalcuteTypeAlternate8_1, // 8电极算法CF586 bhProduct = 3
    PPDeviceCalcuteTypeAlternate4_0, // 4电极交流(新)-跟随方案商，最新版本
    PPDeviceCalcuteTypeAlternate4_1, // 4电极双频-跟随方案商，最新版本
    PPDeviceCalcuteTypeAlternate8_2, // 8电极算法，bhProduct =7--CF610
    PPDeviceCalcuteTypeAlternate8_3, // 8电极算法，差异算法 bhProduct = 5
    PPDeviceCalcuteTypeAlternate8_4, // 8电极算法，bhProduct =6--CF597_N
    PPDeviceCalcuteTypeAlternate8_5, // 8电极算法，bhProduct =6--CF597 平滑算法
};



// 用户使用的单位
typedef NS_ENUM(NSUInteger, PPDeviceUnit) {
    
    PPUnitKG = 0,
    PPUnitLB = 1,
    PPUnitSTLB = 2,
    PPUnitJin = 3,
    PPUnitG = 4,
    PPUnitLBOZ = 5,
    PPUnitOZ = 6,
    PPUnitMLWater = 7,
    PPUnitMLMilk = 8,
    PPUnitFLOZWater = 9,
    PPUnitFLOZMilk = 10,
    PPUnitST = 11,
};

// 性别
typedef NS_ENUM(NSUInteger, PPDeviceGenderType) {
    
    PPDeviceGenderTypeFemale = 0, // 女性
    PPDeviceGenderTypeMale,   // 男性
};

// 标准
typedef NS_ENUM(NSUInteger, PPStandardType) {
    
    PPStandardTypeAsia = 0, // 亚洲标准
    PPStandardTypeWHO,   // WHO标准
};


#endif /* PPBaseDefine_h */
