//
//  PPKorreFoodInfo.h
//  Pods
//
//  Created by lefu on 2025/5/22
//  


#import <Foundation/Foundation.h>



@interface PPKorreFoodInfo : NSObject
@property (nonatomic, copy) NSString *foodName;          // 食物昵称
@property (nonatomic, assign) NSInteger foodNo;          // 食物编号
@property (nonatomic, copy) NSString *foodRemoteId;      // 食物云端ID
@property (nonatomic, assign) CGFloat foodWeight;        // 食物重量(g)
@property (nonatomic, assign) CGFloat calories;          // 卡路里
@property (nonatomic, assign) CGFloat protein;           // 蛋白质(g)
@property (nonatomic, assign) CGFloat totalFat;          // 总脂肪(g)
@property (nonatomic, assign) CGFloat saturatedFat;      // 饱和脂肪(g)
@property (nonatomic, assign) CGFloat transFat;          // 反式脂肪(g)
@property (nonatomic, assign) CGFloat totalCarbohydrates;// 总碳水化合物(g)
@property (nonatomic, assign) CGFloat dietaryFiber;      // 膳食纤维(g)
@property (nonatomic, assign) CGFloat sugars;            // 糖(g)
@property (nonatomic, assign) CGFloat cholesterol;       // 胆固醇(mg)
@property (nonatomic, assign) CGFloat sodium;            // 钠(mg)

@property (nonatomic, assign) NSInteger imageIndex; //食物头像编号

@property (nonatomic, assign) CGFloat calciumMg;          // 钙 (mg)
@property (nonatomic, assign) CGFloat vitaminAG;          // 维生素A (g)
@property (nonatomic, assign) CGFloat vitaminB1G;         // 维生素B1 (g)
@property (nonatomic, assign) CGFloat vitaminB2G;         // 维生素B2 (g)
@property (nonatomic, assign) CGFloat vitaminB6G;         // 维生素B6 (g)
@property (nonatomic, assign) CGFloat vitaminB12G;        // 维生素B12 (g)
@property (nonatomic, assign) CGFloat vitaminCG;          // 维生素C (g)
@property (nonatomic, assign) CGFloat vitaminDG;          // 维生素D (g)
@property (nonatomic, assign) CGFloat vitaminEG;          // 维生素E (g)
@property (nonatomic, assign) CGFloat niacinMg;           // 烟酸 (mg)
@property (nonatomic, assign) CGFloat phosphorusMg;       // 磷 (mg)
@property (nonatomic, assign) CGFloat potassiumMg;        // 钾 (mg)
@property (nonatomic, assign) CGFloat magnesiumMg;        // 镁 (mg)
@property (nonatomic, assign) CGFloat ironMg;             // 铁 (mg)
@property (nonatomic, assign) CGFloat zincMg;             // 锌 (mg)
@property (nonatomic, assign) CGFloat seleniumMg;         // 硒 (mg)
@property (nonatomic, assign) CGFloat copperMg;           // 铜 (mg)
@property (nonatomic, assign) CGFloat manganeseMg;        // 锰 (mg)


@end


