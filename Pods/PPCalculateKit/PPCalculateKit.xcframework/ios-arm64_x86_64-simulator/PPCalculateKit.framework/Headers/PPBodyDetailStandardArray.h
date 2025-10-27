//
//  PPBodyDetailStandardArray.h
//  PPBluetoothKit
//
//  Created by 彭思远 on 2023/6/20.
//

#import <Foundation/Foundation.h>
//#import "PPBodyFatModel.h"
#import "PPCalculateKit.h"

NS_ASSUME_NONNULL_BEGIN

// 测脂计算方式
typedef NS_ENUM(NSUInteger, PPBodyDetailStandardType){
    
    PPBodyDetailStandardType4 = 0, // 4电极方式计算理想体重
    PPBodyDetailStandardType8 = 1, // 8电极方式计算理想体重

};

@interface PPBodyDetailStandardArray : NSObject


+ (NSInteger)calculateCurrentStandardWithValue:(CGFloat)number andStandardArray:(NSArray *)array;


- initWithHeightCm:(NSInteger)heightCm
            gender:(PPDeviceGenderType)gender
               age:(NSInteger)age
            weight:(CGFloat)weight
       standardType:(PPBodyDetailStandardType)standardType;




#pragma mark - StandartArray
#pragma mark - 体重 【3段】【量】

- (NSArray *)fetchPPBodyParam_Weight_StandartArray_4;

- (NSArray *)fetchPPBodyParam_Weight_StandartArray_8:(NSDictionary *)dic;


#pragma mark - 体脂 【4电极5段 8电极3段】【量、率】

- (NSArray *)fetchPPBodyParam_BodyFat_StandartArray_4_D_typeWeight:(BOOL)isWeight;


- (NSArray *)fetchPPBodyParam_BodyFat_StandartArray_percent_4_A:(NSDictionary *)dic typeWeight:(BOOL)isWeight;


#pragma mark - 水分 【3段】【量、率】

- (NSArray *)fetchPPBodyParam_Water_StandartArray_4_D_typeWeight:(BOOL)isWeight;

- (NSArray *)fetchPPBodyParam_Water_StandartArray_percent_4_A:(NSDictionary *)dic typeWeight:(BOOL)isWeight;


#pragma mark -肌肉 【3段】【量、率】

- (NSArray *)fetchPPBodyParam_Mus_StandartArray_kg_4_D_typeWeight:(BOOL)isWeight;


- (NSArray *)fetchPPBodyParam_Mus_StandartArray_kg_4_A_:(NSDictionary *)dic typeWeight:(BOOL)isWeight;



#pragma mark - 骨量 【3段】【量】

- (NSArray *)fetchPPBodyParam_Bone_StandartArray_kg_4_D;

- (NSArray *)fetchPPBodyParam_Bone_StandartArray_kg_4_A:(NSDictionary *)dic;



#pragma mark - BMR 【4电极2段】【8电极3段】【kcal】

- (NSArray *)fetchPPBodyParam_BMR_StandartArray_kcal_4_D;

- (NSArray *)fetchPPBodyParam_BMR_StandartArray_kcal_4_A:(NSDictionary *)dic;


#pragma mark - BMI 【4电极4段】【8电极3段】

- (NSArray *)fetchPPBodyParam_BMI_StandartArray_4;

- (NSArray *)fetchPPBodyParam_BMI_StandartArray_8;


#pragma mark - 内脏脂肪等级 【3段】

- (NSArray *)fetchPPBodyParam_VisFat_StandartArray_4;



#pragma mark - 蛋白质 【3段】【量、率】

- (NSArray *)fetchPPBodyParam_Protein_StandartArray_4_D_typeWeight:(BOOL)isWeight;

- (NSArray *)fetchPPBodyParam_Protein_StandartArray_percent_4_A:(NSDictionary *)dic typeWeight:(BOOL)isWeight;


#pragma mark - 皮下脂肪 【3段】【量、率】
- (NSArray *)fetchPPBodyParam_BodySubcutaneousFat_StandartArray_4_D_typeWeight:(BOOL)isWeight;

- (NSArray *)fetchPPBodyParam_BodySubcutaneousFat_StandartArray_percent_4_A:(NSDictionary *)dic typeWeight:(BOOL)isWeight;


#pragma mark - 骨骼肌 【3段】【量、率】
- (NSArray *)fetchPPBodyParam_BodySkeletal_StandartArray_4_D_typeWeight:(BOOL)isWeight;

- (NSArray *)fetchPPBodyParam_BodySkeletal_StandartArray_kg_4_A:(NSDictionary *)dic typeWeight:(BOOL)isWeight;


#pragma mark - 心率
- (NSArray *)fetchPPBodyParam_heart_StandartArray;


#pragma mark - 身体年龄
- (NSArray *)fetchPPBodyParam_physicalAgeValue_StandartArray;

#pragma mark - 身体得分
- (NSArray *)fetchPPBodyParam_BodyScore_StandartArray;

#pragma mark - 8电极通用
- (NSArray *)fetchPPBodyParam_StandartArray_8:(NSDictionary *)dic;
@end

NS_ASSUME_NONNULL_END
