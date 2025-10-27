//
//  PPBodyDetailInfoModel.h
//  PPBluetoothKit
//
//  Created by 彭思远 on 2023/6/15.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface PPBodyDetailInfoModel : NSObject

// 唯一键
@property (nonatomic,strong) NSString *bodyParamKey;

// 名称
@property (nonatomic,strong) NSString *bodyParamNameString;

// 对名称的详细说明
@property (nonatomic,strong) NSString *introductionString;

// 范围节点 [0,18.5,25,30,42]
@property (nonatomic,strong) NSArray *standardArray;

// 当前值 没有单位
@property (nonatomic,assign) CGFloat currentValue;

// 当前值String 没有单位
@property (nonatomic,strong) NSString *currentValueStr;

// 当前值对应的单位
@property (nonatomic,strong) NSString *unit;

// 当前值坐落的区间
@property (nonatomic,assign) NSInteger currentStandard;

// 对节点区间的描述 (瘦,普通,偏胖,肥胖)
@property (nonatomic,strong) NSArray<NSString *> *standardTitleArray;

// 节点的描述
@property (nonatomic,strong) NSString  *standardTitle;

// 节点区间的颜色 (#F5A623,#14CCAD,#F43F31,#C23227)
@property (nonatomic,strong) NSArray <NSString *> *colorArray;

// 节点的颜色
@property (nonatomic,strong) NSString  *standColor;

// 评价
@property (nonatomic,strong) NSString *standeValuation;

// 建议
@property (nonatomic,strong) NSString *standSuggestion;

// 需注意的区间 [1,2]
@property (nonatomic,strong) NSArray  *watchfulArray;



- (instancetype)initWithDic:(NSDictionary *)dic
                 andKeyName:(NSString *)key
              standardArray:(NSArray <NSNumber *>*)standardArray
               currentValue:(CGFloat)currentValue;

@end

NS_ASSUME_NONNULL_END
