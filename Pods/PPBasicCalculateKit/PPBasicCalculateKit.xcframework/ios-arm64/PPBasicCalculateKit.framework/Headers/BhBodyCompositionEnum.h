//
//  BhBodyCompositionEnum.h
//  BH_BIA4Twolegs_IOS_Ver
//
//  Created by 陈挺 on 2020/5/9.
//  Copyright © 2020 BaoLei. All rights reserved.
//

#ifndef BhBodyCompositionEnum_h
#define BhBodyCompositionEnum_h

#import <Foundation/Foundation.h>

/*!
 @enum BHSexType
 @abstract 性别枚举
 @constant FEMALE 女性
 @constant MALE 男性
 */
typedef NS_ENUM(NSInteger, BhSexType){
    BH_SEX_TYPE_FEMALE,
    BH_SEX_TYPE_MALE
};

/*！
 @enum BhPeopleType
 @abstract 人员类型枚举
 @constant BH_PEOPLE_TYPE_NORMAL 普通人
 @constant BH_PEOPLE_TYPE_ATHLETE 运动员
 */
typedef NS_ENUM(NSInteger, BhPeopleType){
    BH_PEOPLE_TYPE_NORMAL,
    BH_PEOPLE_TYPE_ATHLETE
};

/*！
 @enum BHErrorType
 @abstract 算法返回错误类型枚举
 @constant BH_ERROR_TYPE_NONE 无错误,此時可以讀取所有參數結果
 @constant BH_ERROR_TYPE_AGE 年龄有误 6  ~ 99
 @constant BH_ERROR_TYPE_HEIGHT 身高有误 90 ~ 220cm
 @constant BH_ERROR_TYPE_WEIGHT 体重有误 10 ~ 200kg
 @constant BH_ERROR_TYPE_SEX 性別有误 0  ~ 1
 @constant BH_ERROR_TYPE_PEOPLE_TYPE 人員有误 0  ~ 1
 @constant BH_ERROR_TYPE_IMPEDANCE_TWO_LEGS 双脚阻抗有误 200Ω  ~ 1200Ω
 @constant BH_ERROR_TYPE_IMPEDANCE_TWO_ARMS 双手阻抗有误 200Ω  ~ 1200Ω
 @constant BH_ERROR_TYPE_IMPEDANCE_LEFT_BODY 全身阻抗有误 200Ω  ~ 1200Ω
 @constant BH_ERROR_TYPE_IMPEDANCE_LEFT_ARM 左手阻抗有误 100Ω  ~ 700Ω
 @constant BH_ERROR_TYPE_IMPEDANCE_RIGHT_ARM 右手阻抗有误 100Ω  ~ 700Ω
 @constant BH_ERROR_TYPE_IMPEDANCE_LEFT_LEG 左脚阻抗有误 100Ω  ~ 700Ω
 @constant BH_ERROR_TYPE_IMPEDANCE_RIGHT_LEG 右脚阻抗有误 100Ω  ~ 700Ω
 @constant BH_ERROR_TYPE_IMPEDANCE_TRUNK 躯干阻抗有误 5Ω  ~ 100Ω
 @constant BH_ERROR_TYPE_HOME  HOME类型有误 0  ~ 1
 @constant BH_ERROR_TYPE_PRODUCT  PRODUCT类型有误 0  ~ 1
 */
typedef NS_ENUM(NSInteger, BhErrorType) {
    BH_ERROR_TYPE_NONE = 0,
    BH_ERROR_TYPE_AGE = 1,
    BH_ERROR_TYPE_HEIGHT = 2,
    BH_ERROR_TYPE_WEIGHT = 3,
    BH_ERROR_TYPE_SEX = 4,
    BH_ERROR_TYPE_PEOPLE_TYPE = 5,
    BH_ERROR_TYPE_IMPEDANCE_TWO_LEGS = 6,
    BH_ERROR_TYPE_IMPEDANCE_TWO_ARMS = 7,
    BH_ERROR_TYPE_IMPEDANCE_LEFT_BODY = 8,
    BH_ERROR_TYPE_IMPEDANCE_LEFT_ARM = 9,
    BH_ERROR_TYPE_IMPEDANCE_RIGHT_ARM = 10,
    BH_ERROR_TYPE_IMPEDANCE_LEFT_LEG = 11,
    BH_ERROR_TYPE_IMPEDANCE_RIGHT_LEG = 12,
    BH_ERROR_TYPE_IMPEDANCE_TRUNK = 13,
    BH_ERROR_TYPE_HOME = 14,
    BH_ERROR_TYPE_PRODUCT = 15,
};

/*！
 @enum BHBodyType
 @abstract 身體類型
 @constant BH_BODY_TYPE_THIN            偏瘦型
 @constant BH_BODY_TYPE_THIN_MUSCLE     偏瘦肌肉型
 @constant BH_BODY_TYPE_MUSCULAR        肌肉发达型
 @constant BH_BODY_TYPE_OBESE_FAT       浮肿肥胖型
 @constant BH_BODY_TYPE_FAT_MUSCLE      偏胖肌肉型
 @constant BH_BODY_TYPE_MUSCLE_FAT      肌肉型偏胖
 @constant BH_BODY_TYPE_LACK_EXERCISE   缺乏运动型
 @constant BH_BODY_TYPE_STANDARD        标准型
 @constant BH_BODY_TYPE_STANDARD_MUSCLE 标准肌肉型
 */
typedef NS_ENUM(NSInteger, BhBodyType) {
    BH_BODY_TYPE_THIN = 1,
    BH_BODY_TYPE_THIN_MUSCLE = 2,
    BH_BODY_TYPE_MUSCULAR = 3,
    BH_BODY_TYPE_OBESE_FAT = 4,
    BH_BODY_TYPE_FAT_MUSCLE = 5,
    BH_BODY_TYPE_MUSCLE_FAT = 6,
    BH_BODY_TYPE_LACK_EXERCISE = 7,
    BH_BODY_TYPE_STANDARD = 8,
    BH_BODY_TYPE_STANDARD_MUSCLE = 9
};

#endif /* BhBodyCompositionEnum_h */
