//
//  PPAnalysisResultModel.h
//  Pods
//
//  Created by lefu on 2024/8/30
//  


#import <Foundation/Foundation.h>
#import "PPScaleState.h"
#import "PPBluetoothScaleBaseModel.h"

@interface PPAnalysisResultModel : NSObject
@property (nonatomic, strong) PPScaleState *scaleState;
@property (nonatomic, strong) PPBluetoothScaleBaseModel *scaleBaseModel;

@end

