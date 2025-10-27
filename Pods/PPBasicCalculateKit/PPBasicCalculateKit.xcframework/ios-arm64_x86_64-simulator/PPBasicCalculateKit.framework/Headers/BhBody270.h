/*
 ____  ______  _____ _______   _    _ ______          _   _______ _    _
 |  _ \|  ____|/ ____|__   __| | |  | |  ____|   /\   | | |__   __| |  | |
 | |_) | |__  | (___    | |    | |__| | |__     /  \  | |    | |  | |__| |
 |  _ <|  __|  \___ \   | |    |  __  |  __|   / /\ \ | |    | |  |  __  |
 | |_) | |____ ____) |  | |    | |  | | |____ / ____ \| |____| |  | |  | |
 |____/|______|_____/   |_|    |_|  |_|______/_/    \_\______|_|  |_|  |_|

*/

        /*!
 @header BhBody270.h
 @abstract 悠健体成分算法库-应用于双频(20&100KHz)八电极体成分分析
 @author 悠健-陈挺 tony@e-besthealth.com
 @copyright Best Health Electronics INC.
 @date 2020/05/09
 */
#ifndef BhBody270_h
#define BhBody270_h

#import <Foundation/Foundation.h>
#include "BhBodyCompositionEnum.h"

#pragma mark - BhBody270
/*!
   @class 人體成分
   @abstract 人体成分类
   @discussion 人体的各项人体成分参数
*/
@interface BhBody270 : NSObject
/*
 *   __  .__   __. .______    __    __  .___________.
 *  |  | |  \ |  | |   _  \  |  |  |  | |           |
 *  |  | |   \|  | |  |_)  | |  |  |  | `---|  |----`
 *  |  | |  . `  | |   ___/  |  |  |  |     |  |
 *  |  | |  |\   | |  |      |  `--'  |     |  |
 *  |__| |__| \__| | _|       \______/      |__|
 *
 */
@property(nonatomic, assign) BhSexType bhSex;               //!< 性别,用于标准输出
@property(nonatomic, assign) unsigned int bhAge;            //!< 年龄(岁)  6 ~ 99岁 用于标准输出
@property(nonatomic, assign) unsigned int bhHeightCm;       //!< 身高(cm) 90 ~ 220cm
@property(nonatomic, assign) float bhWeightKg;              //!< 体重(kg) 10  ~ 200kg
@property(nonatomic, assign) unsigned int bhZ20KhzLeftArmEnCode;   //!< 20Khz左手阻抗加密值(秤端上传值) 范围0 ~ 0xFFFFFFFF
@property(nonatomic, assign) unsigned int bhZ20KhzRightArmEnCode;  //!< 20Khz右手阻抗加密值(秤端上传值) 范围0 ~ 0xFFFFFFFF
@property(nonatomic, assign) unsigned int bhZ20KhzLeftLegEnCode;   //!< 20Khz左脚阻抗加密值(秤端上传值) 范围0 ~ 0xFFFFFFFF
@property(nonatomic, assign) unsigned int bhZ20KhzRightLegEnCode;  //!< 20Khz右脚阻抗加密值(秤端上传值) 范围0 ~ 0xFFFFFFFF
@property(nonatomic, assign) unsigned int bhZ20KhzTrunkEnCode;     //!< 20Khz軀幹阻抗加密值(秤端上传值) 范围0 ~ 0xFFFFFFFF
@property(nonatomic, assign) unsigned int bhZ100KhzLeftArmEnCode;  //!< 100Khz左手阻抗加密值(秤端上传值) 范围0 ~ 0xFFFFFFFF
@property(nonatomic, assign) unsigned int bhZ100KhzRightArmEnCode; //!< 100Khz右手阻抗加密值(秤端上传值) 范围0 ~ 0xFFFFFFFF
@property(nonatomic, assign) unsigned int bhZ100KhzLeftLegEnCode;  //!< 100Khz左脚阻抗加密值(秤端上传值) 范围0 ~ 0xFFFFFFFF
@property(nonatomic, assign) unsigned int bhZ100KhzRightLegEnCode; //!< 100Khz右脚阻抗加密值(秤端上传值) 范围0 ~ 0xFFFFFFFF
@property(nonatomic, assign) unsigned int bhZ100KhzTrunkEnCode;    //!< 100Khz軀幹阻抗加密值(秤端上传值) 范围0 ~ 0xFFFFFFFF
/*     ______    __    __  .___________..______    __    __  .___________.
 *    /  __  \  |  |  |  | |           ||   _  \  |  |  |  | |           |
 *   |  |  |  | |  |  |  | `---|  |----`|  |_)  | |  |  |  | `---|  |----`
 *   |  |  |  | |  |  |  |     |  |     |   ___/  |  |  |  |     |  |
 *   |  `--'  | |  `--'  |     |  |     |  |      |  `--'  |     |  |
 *    \______/   \______/      |__|     | _|       \______/      |__|
 *
 */
// 基本输出参数
@property(nonatomic, readonly, copy) NSString *bhVersionTime;         //!< 版权客户日期版本，比如@BestHealth_xxx_20200428_V1.22";
@property(nonatomic, readonly, assign) float bhZ20KhzLeftArmDeCode;   //!< 20Khz左手阻抗值(Ω)  100 ~ 600 for debug 通常不显示
@property(nonatomic, readonly, assign) float bhZ20KhzRightArmDeCode;  //!< 20Khz右手阻抗值(Ω)  100 ~ 600 for debug 通常不显示
@property(nonatomic, readonly, assign) float bhZ20KhzLeftLegDeCode;   //!< 20Khz左脚阻抗值(Ω)  100 ~ 600 for debug 通常不显示
@property(nonatomic, readonly, assign) float bhZ20KhzRightLegDeCode;  //!< 20Khz右脚阻抗值(Ω)  100 ~ 600 for debug 通常不显示
@property(nonatomic, readonly, assign) float bhZ20KhzTrunkDeCode;     //!< 20Khz軀幹阻抗值(Ω)   10 ~ 100 for debug 通常不显示
@property(nonatomic, readonly, assign) float bhZ100KhzLeftArmDeCode;  //!< 100KHz左手阻抗值(Ω)  100 ~ 600 for debug 通常不显示
@property(nonatomic, readonly, assign) float bhZ100KhzRightArmDeCode; //!< 100KHz右手阻抗值(Ω)  100 ~ 600 for debug 通常不显示
@property(nonatomic, readonly, assign) float bhZ100KhzLeftLegDeCode;  //!< 100KHz左脚阻抗值(Ω)  100 ~ 600 for debug 通常不显示
@property(nonatomic, readonly, assign) float bhZ100KhzRightLegDeCode; //!< 100KHz右脚阻抗值(Ω)  100 ~ 600 for debug 通常不显示
@property(nonatomic, readonly, assign) float bhZ100KhzTrunkDeCode;    //!< 100KHz軀幹阻抗值(Ω)   10 ~ 100 for debug 通常不显示

// 全身体组成参数
@property(nonatomic, readonly, assign) float bhWaterKg;           //!< 水分量(Kg)
@property(nonatomic, readonly, assign) float bhMineralKg;         //!< 无机盐量(kg)
@property(nonatomic, readonly, assign) float bhBoneKg;            //!< 骨量(kg)
@property(nonatomic, readonly, assign) float bhBodyFatKg;         //!< 脂肪量(kg)
@property(nonatomic, readonly, assign) float bhProteinKg;         //!< 蛋白质量(Kg)
@property(nonatomic, readonly, assign) float bhBodyFatFreeMassKg; //!< 去脂体重(kg)
@property(nonatomic, readonly, assign) float bhMuscleKg;          //!< 肌肉量(kg)
@property(nonatomic, readonly, assign) float bhSkeletalMuscleKg;  //!< 骨骼肌量(Kg)
@property(nonatomic, readonly, assign) float bhWaterECWKg;        //!< 细胞外水量(Kg)
@property(nonatomic, readonly, assign) float bhWaterICWKg;        //!< 细胞内水量(Kg)
@property(nonatomic, readonly, assign) float bhCellMassKg;        //!< 身体细胞量(Kg)
@property(nonatomic, readonly, assign) float bhBodyFatSubCutKg;   //!< 皮下脂肪量(kg)

// 节段体组成参数
@property(nonatomic, readonly, assign) float bhBodyFatRateTrunk;    //!< 躯干脂肪率(%), 分辨率0.1
@property(nonatomic, readonly, assign) float bhBodyFatRateLeftLeg;  //!< 左脚脂肪率(%), 分辨率0.1
@property(nonatomic, readonly, assign) float bhBodyFatRateRightLeg; //!< 右脚脂肪率(%), 分辨率0.1
@property(nonatomic, readonly, assign) float bhBodyFatRateLeftArm;  //!< 左手脂肪率(%), 分辨率0.1
@property(nonatomic, readonly, assign) float bhBodyFatRateRightArm; //!< 右手脂肪率(%), 分辨率0.1
@property(nonatomic, readonly, assign) float bhBodyFatKgTrunk;      //!< 躯干脂肪量(kg), 分辨率0.1
@property(nonatomic, readonly, assign) float bhBodyFatKgLeftLeg;    //!< 左脚脂肪量(kg), 分辨率0.1
@property(nonatomic, readonly, assign) float bhBodyFatKgRightLeg;   //!< 右脚脂肪量(kg), 分辨率0.1
@property(nonatomic, readonly, assign) float bhBodyFatKgLeftArm;    //!< 左手脂肪量(kg), 分辨率0.1
@property(nonatomic, readonly, assign) float bhBodyFatKgRightArm;   //!< 右手脂肪量(kg), 分辨率0.1
@property(nonatomic, readonly, assign) float bhMuscleKgTrunk;       //!< 躯干肌肉量(kg), 分辨率0.1
@property(nonatomic, readonly, assign) float bhMuscleKgLeftLeg;     //!< 左脚肌肉量(kg), 分辨率0.1
@property(nonatomic, readonly, assign) float bhMuscleKgRightLeg;    //!< 右脚肌肉量(kg), 分辨率0.1
@property(nonatomic, readonly, assign) float bhMuscleKgLeftArm;     //!< 左手肌肉量(kg), 分辨率0.1
@property(nonatomic, readonly, assign) float bhMuscleKgRightArm;    //!< 右手肌肉量(kg), 分辨率0.1

// 评价建议
@property(nonatomic, readonly, assign) BhBodyType bhBodyType;         //!< 身體類型
@property(nonatomic, readonly, assign) unsigned int bhBMR;              //!< 基础代谢量 Kcal/day
@property(nonatomic, readonly, assign) unsigned int bhDCI;              //!< 建议卡路里摄入量 Kcal/day
@property(nonatomic, readonly, assign) unsigned int bhBodyScore;        //!< 身体得分
@property(nonatomic, readonly, assign) unsigned int bhBodyAge;          //!< 身体年龄
@property(nonatomic, readonly, assign) unsigned int bhVFAL;             //!< 内脏脂肪等级
@property(nonatomic, readonly, assign) float bhBMI;                     //!< 人体质量指数
@property(nonatomic, readonly, assign) float bhBodyFatRate;             //!< 脂肪率(%)
@property(nonatomic, readonly, assign) float bhWHR;                     //!< 腰臀比
@property(nonatomic, readonly, assign) float bhObesity;                 //!< 肥胖度(%)
@property(nonatomic, readonly, assign) float bhIdealWeightKg;           //!< 理想体重(kg)
@property(nonatomic, readonly, assign) float bhWeightKgCon;             //!< 体重控制(kg)
@property(nonatomic, readonly, assign) float bhMuscleKgCon;             //!< 肌肉控制(kg)
@property(nonatomic, readonly, assign) float bhBodyFatKgCon;            //!< 体脂控制(kg)
@property(nonatomic, readonly, assign) unsigned int bhWalking;          //!< 运动消耗-步行 Kcal
@property(nonatomic, readonly, assign) unsigned int bhGolf;             //!< 运动消耗-高爾夫 Kcal
@property(nonatomic, readonly, assign) unsigned int bhGateBall;         //!< 运动消耗-門球 Kcal
@property(nonatomic, readonly, assign) unsigned int bhTennis;           //!< 运动消耗-網球 Kcal
@property(nonatomic, readonly, assign) unsigned int bhBicycle;          //!< 运动消耗-自行車 Kcal
@property(nonatomic, readonly, assign) unsigned int bhBasketBall;       //!< 运动消耗-籃球 Kcal
@property(nonatomic, readonly, assign) unsigned int bhSquash;           //!< 运动消耗-壁球 Kcal
@property(nonatomic, readonly, assign) unsigned int bhRacketBall;       //!< 运动消耗-彈力球 Kcal
@property(nonatomic, readonly, assign) unsigned int bhTaekwondo;        //!< 运动消耗-跆拳道 Kcal
@property(nonatomic, readonly, assign) unsigned int bhOrientalFencing;  //!< 运动消耗-擊劍 Kcal
@property(nonatomic, readonly, assign) unsigned int bhMountainClimbing; //!< 运动消耗-爬山 Kcal
@property(nonatomic, readonly, assign) unsigned int bhSwim;             //!< 运动消耗-游泳 Kcal
@property(nonatomic, readonly, assign) unsigned int bhAerobic;          //!< 运动消耗-有氧操 Kcal
@property(nonatomic, readonly, assign) unsigned int bhJogging;          //!< 运动消耗-慢跑 Kcal
@property(nonatomic, readonly, assign) unsigned int bhFootball;         //!< 运动消耗-足球 Kcal
@property(nonatomic, readonly, assign) unsigned int bhRopeJumping;      //!< 运动消耗-跳繩 Kcal
@property(nonatomic, readonly, assign) unsigned int bhBadminton;        //!< 运动消耗-羽毛球 Kcal
@property(nonatomic, readonly, assign) unsigned int bhTableTennis;      //!< 运动消耗-乒乓球 Kcal

// 體成分標準
@property(nonatomic, readonly, assign) int bhWeightKgLevel;                 //!< 体重標準: 當前值 Level(0-瘦 1-标准 2-偏胖)
@property(nonatomic, readonly, copy) NSDictionary *bhWeightKgList;          //!< 重量(Kg)-标准字典,"Min"“Max”
@property(nonatomic, readonly, assign) int bhWaterKgLevel;                  //!< 水分標準: 當前值 Level(0-不足 1-标准 2-优秀)
@property(nonatomic, readonly, copy) NSDictionary *bhWaterKgList;           //!< 水分量(Kg)-标准字典 "Min"“Max”
@property(nonatomic, readonly, assign) int bhBodyFatFreeMassKgLevel;        //!< 去脂体重標準: 當前值 Level(0-不足 1-标准 2-优秀)
@property(nonatomic, readonly, copy) NSDictionary *bhBodyFatFreeMassKgList; //!< 去脂体重(kg)-标准字典 "Min"“Max”
@property(nonatomic, readonly, assign) int bhBodyFatKgLevel;                //!< 脂肪量標準: 當前值 Level(0-瘦 1-标准 2-偏胖)
@property(nonatomic, readonly, copy) NSDictionary *bhBodyFatKgList;         //!< 脂肪量(kg)-标准字典 "Min"“Max”
@property(nonatomic, readonly, assign) int bhProteinKgLevel;                //!< 蛋白质量標準: 當前值 Level(0-不足 1-标准 2-优秀)
@property(nonatomic, readonly, copy) NSDictionary *bhProteinKgList;         //!< 蛋白质量(kg)-标准字典 "Min"“Max”
@property(nonatomic, readonly, assign) int bhMuscleKgLevel;                 //!< 肌肉量標準: 當前值 Level(0-不足 1-标准 2-优秀)
@property(nonatomic, readonly, copy) NSDictionary *bhMuscleKgList;          //!< 肌肉量(kg)-标准字典 "Min"“Max”
@property(nonatomic, readonly, assign) int bhBoneKgLevel;                   //!< 骨量標準: 當前值 Level(0-不足 1-标准 2-优秀)
@property(nonatomic, readonly, copy) NSDictionary *bhBoneKgList;            //!< 骨量(kg)-标准字典 "Min"“Max”
@property(nonatomic, readonly, assign) int bhSkeletalMuscleKgLevel;         //!< 骨骼肌量標準: 當前值 Level(0-不足 1-标准 2-优秀)
@property(nonatomic, readonly, copy) NSDictionary *bhSkeletalMuscleKgList;  //!< 骨骼肌量(Kg)-标准字典 "Min"“Max”
@property(nonatomic, readonly, assign) int bhBodyFatSubCutRateLevel;        //!< 皮下脂肪率標準: 當前值 Level(0-不足 1-标准 2-偏高)
@property(nonatomic, readonly, copy) NSDictionary *bhBodyFatSubCutRateList; //!< 皮下脂肪率(%)-标准字典 "Min"“Max”
@property(nonatomic, readonly, assign) int bhCellMassKgLevel;               //!< 身体细胞量標準: 當前值 Level(0-不足 1-标准 2-优秀)
@property(nonatomic, readonly, copy) NSDictionary *bhCellMassKgList;        //!< 身体细胞量(Kg)-标准字典 "Min"“Max”
@property(nonatomic, readonly, assign) int bhWaterICWKgLevel;               //!< 细胞内水量標準: 當前值 Level(0-低 1-标准 2-高)
@property(nonatomic, readonly, copy) NSDictionary *bhWaterICWKgList;        //!< 细胞内水量(Kg)-标准字典 "Min"“Max”
@property(nonatomic, readonly, assign) int bhWaterECWKgLevel;               //!< 细胞外水量標準: 當前值 Level(0-低 1-标准 2-高)
@property(nonatomic, readonly, copy) NSDictionary *bhWaterECWKgList;        //!< 细胞外水量(Kg)-标准字典 "Min"“Max”
@property(nonatomic, readonly, assign) int bhBMILevel;                      //!< BMI標準: 當前值 Level(0-低 1-标准 2-高)
@property(nonatomic, readonly, copy) NSDictionary *bhBMIList;               //!< BMI-标准字典 "Min"“Max”
@property(nonatomic, readonly, assign) int bhBMRLevel;                      //!< 基础代谢Kcal標準: 當前值 Level(0-不足 1-标准 2-优秀)
@property(nonatomic, readonly, copy) NSDictionary *bhBMRList;               //!< 基础代谢Kcal-标准字典 "Min"“Max”
@property(nonatomic, readonly, assign) int bhVFALLevel;                     //!< 内脏脂肪等级標準: 當前值 Level(0-低 1-标准 2-高)
@property(nonatomic, readonly, copy) NSDictionary *bhVFALList;              //!< 内脏脂肪等级-标准字典 "Min"“Max”
@property(nonatomic, readonly, assign) int bhBodyFatRateLevel;              //!< 脂肪率標準: 當前值 Level(0-低 1-标准 2-高)
@property(nonatomic, readonly, copy) NSDictionary *bhBodyFatRateList;       //!< 脂肪率健康(%)-标准字典 "Min"“Max”
@property(nonatomic, readonly, assign) int bhWHRLevel;                      //!<  腰臀比 標準: 當前值 Level(0-低 1-标准 2-高)
@property(nonatomic, readonly, copy) NSDictionary *bhWHRList;               //!<  腰臀比-标准字典 "Min"“Max”
@property(nonatomic, readonly, assign) int bhObesityLevel;                  //!< 肥胖度 標準: 當前值 Level(0-低 1-标准 2-高)
@property(nonatomic, readonly, copy) NSDictionary *bhObesityList;           //!< 肥胖度(%)-标准字典 "Min"“Max”
@property(nonatomic, readonly, assign) int bhMineralKgLevel;                //!< 无机盐 標準: 當前值 Level(0-不足 1-标准 2-优秀)
@property(nonatomic, readonly, copy) NSDictionary *bhMineralKgList;         //!< 无机盐(Kg)-标准字典 "Min"“Max”
//
@property(nonatomic, readonly, assign) float bhMuscleRate;        //!< 肌肉率(%)
@property(nonatomic, readonly, assign) float bhBodyFatSubCutRate; //!< 皮下脂肪率(%)

- (BhErrorType)getBhBodyComposition;


@end

#endif /* BhBody270 */