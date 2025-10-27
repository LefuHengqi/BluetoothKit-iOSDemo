//
//  PPBodyDetailModel.h
//  PPBluetoothKit
//
//  Created by  lefu on 2023/6/12.
//

#import <Foundation/Foundation.h>
//#import "PPBodyFatModel.h"
#import "PPBodyDetailInfoModel.h"
#import <PPBaseKit/PPBaseKit.h>


NS_ASSUME_NONNULL_BEGIN


@interface PPBodyDetailModel : NSObject

@property (nonatomic,strong) PPBodyDetailInfoModel  *PPBodyParam_Weight;
@property (nonatomic,strong) PPBodyDetailInfoModel  *PPBodyParam_BodyFat;
@property (nonatomic,strong) PPBodyDetailInfoModel  *PPBodyParam_BMI;
@property (nonatomic,strong) PPBodyDetailInfoModel  *PPBodyParam_Mus;
@property (nonatomic,strong) PPBodyDetailInfoModel  *PPBodyParam_BMR;
@property (nonatomic,strong) PPBodyDetailInfoModel  *PPBodyParam_Water;
@property (nonatomic,strong) PPBodyDetailInfoModel  *PPBodyParam_heart;
@property (nonatomic,strong) PPBodyDetailInfoModel  *PPBodyParam_BodyFatKg;
@property (nonatomic,strong) PPBodyDetailInfoModel  *PPBodyParam_proteinPercentage;
@property (nonatomic,strong) PPBodyDetailInfoModel  *PPBodyParam_BodyLBW;
@property (nonatomic,strong) PPBodyDetailInfoModel  *PPBodyParam_BodySubcutaneousFat;
@property (nonatomic,strong) PPBodyDetailInfoModel  *PPBodyParam_BodySkeletal;
@property (nonatomic,strong) PPBodyDetailInfoModel  *PPBodyParam_VisFat;
@property (nonatomic,strong) PPBodyDetailInfoModel  *PPBodyParam_MusRate;
@property (nonatomic,strong) PPBodyDetailInfoModel  *PPBodyParam_MuscleControl;
@property (nonatomic,strong) PPBodyDetailInfoModel  *PPBodyParam_BodyControlLiang;
@property (nonatomic,strong) PPBodyDetailInfoModel  *PPBodyParam_Bodystandard;
@property (nonatomic,strong) PPBodyDetailInfoModel  *PPBodyParam_IdealWeight;
@property (nonatomic,strong) PPBodyDetailInfoModel  *PPBodyParam_BodyControl;
@property (nonatomic,strong) PPBodyDetailInfoModel  *PPBodyParam_Bone;
@property (nonatomic,strong) PPBodyDetailInfoModel  *PPBodyParam_BodyType;
@property (nonatomic,strong) PPBodyDetailInfoModel  *PPBodyParam_FatGrade;
@property (nonatomic,strong) PPBodyDetailInfoModel  *PPBodyParam_BodyHealth;
@property (nonatomic,strong) PPBodyDetailInfoModel  *PPBodyParam_physicalAgeValue;
@property (nonatomic,strong) PPBodyDetailInfoModel  *PPBodyParam_BodyScore;


@property (nonatomic,strong) PPBodyDetailInfoModel  *PPBodyParam_waterKg;
@property (nonatomic,strong) PPBodyDetailInfoModel  *PPBodyParam_proteinKg;
@property (nonatomic,strong) PPBodyDetailInfoModel  *PPBodyParam_bodyFatSubCutKg;
@property (nonatomic,strong) PPBodyDetailInfoModel  *PPBodyParam_cellMassKg;
@property (nonatomic,strong) PPBodyDetailInfoModel  *PPBodyParam_dCI;
@property (nonatomic,strong) PPBodyDetailInfoModel  *PPBodyParam_mineralKg;
@property (nonatomic,strong) PPBodyDetailInfoModel  *PPBodyParam_obesity;
@property (nonatomic,strong) PPBodyDetailInfoModel  *PPBodyParam_waterECWKg;
@property (nonatomic,strong) PPBodyDetailInfoModel  *PPBodyParam_waterICWKg;
@property (nonatomic,strong) PPBodyDetailInfoModel  *PPBodyParam_bodyFatKgLeftArm;
@property (nonatomic,strong) PPBodyDetailInfoModel  *PPBodyParam_bodyFatKgLeftLeg;
@property (nonatomic,strong) PPBodyDetailInfoModel  *PPBodyParam_bodyFatKgRightArm;
@property (nonatomic,strong) PPBodyDetailInfoModel  *PPBodyParam_bodyFatKgRightLeg;
@property (nonatomic,strong) PPBodyDetailInfoModel  *PPBodyParam_bodyFatKgTrunk;
@property (nonatomic,strong) PPBodyDetailInfoModel  *PPBodyParam_bodyFatRateLeftArm;
@property (nonatomic,strong) PPBodyDetailInfoModel  *PPBodyParam_bodyFatRateLeftLeg;
@property (nonatomic,strong) PPBodyDetailInfoModel  *PPBodyParam_bodyFatRateRightArm;
@property (nonatomic,strong) PPBodyDetailInfoModel  *PPBodyParam_bodyFatRateRightLeg;
@property (nonatomic,strong) PPBodyDetailInfoModel  *PPBodyParam_bodyFatRateTrunk;
@property (nonatomic,strong) PPBodyDetailInfoModel  *PPBodyParam_muscleKgLeftArm;
@property (nonatomic,strong) PPBodyDetailInfoModel  *PPBodyParam_muscleKgLeftLeg;
@property (nonatomic,strong) PPBodyDetailInfoModel  *PPBodyParam_muscleKgRightArm;
@property (nonatomic,strong) PPBodyDetailInfoModel  *PPBodyParam_muscleKgRightLeg;
@property (nonatomic,strong) PPBodyDetailInfoModel  *PPBodyParam_muscleKgTrunk;
@property (nonatomic,strong) PPBodyDetailInfoModel  *PPBodyParam_muscleRateLeftArm;
@property (nonatomic,strong) PPBodyDetailInfoModel  *PPBodyParam_muscleRateLeftLeg;
@property (nonatomic,strong) PPBodyDetailInfoModel  *PPBodyParam_muscleRateRightArm;
@property (nonatomic,strong) PPBodyDetailInfoModel  *PPBodyParam_muscleRateRightLeg;
@property (nonatomic,strong) PPBodyDetailInfoModel  *PPBodyParam_muscleRateTrunk;

@property (nonatomic,strong) PPBodyDetailInfoModel  *PPBodyParam_SkeletalMuscleKg;
@property (nonatomic,strong) PPBodyDetailInfoModel  *PPBodyParam_smi;
@property (nonatomic,strong) PPBodyDetailInfoModel  *PPBodyParam_WHR;

@property (nonatomic,strong) PPBodyDetailInfoModel  *PPBodyParam_FootLen;

/**
 "data": {
     "errorType": "PP_ERROR_TYPE_NONE",
     "lefuBodyData": [
         {
             "bodyParamName": "体重",
             "bodyParamKey": "ppWeightKg",
             "introduction": "体重body weight为裸体或穿着已知重量的工作衣，称量得到的身体重量。",
             "standardArray": [
                 52.8,
                 71.4
             ],
             "currentValue": 65.25,
             "currentStandard": 1,
             "standardTitleArray": [
                 "瘦",
                 "标准",
                 "偏胖"
             ],
             "standardTitle": "标准",
             "colorArray": [
                 "#F5A623",
                 "#14CCAD",
                 "#F43F31"
             ],
             "standColor": "#14CCAD",
             "standeEvaluation": "体重相当健康，记得三餐要按时哦~恭喜您~体重已经达到零设定的目标，注意保持哦！",
             "standSuggestion": "--",
             "unit": "kg",
             "sort": 0,
             "classification": "WEIGHT",
             "isStandard": 1
         },
     ]
 }
 */
@property (nonatomic,strong) NSDictionary *data;

- (instancetype)initWithBodyFatModel:(PPBodyFatModel*)fatModel;

@end

NS_ASSUME_NONNULL_END
