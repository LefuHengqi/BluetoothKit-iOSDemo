//
//  PPBatteryInfoModel.h
//  PPBluetoothKit
//
//  Created by 彭思远 on 2023/10/24.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface PPBatteryInfoModel : NSObject

@property (nonatomic, assign) NSInteger power;
@property (nonatomic, assign) NSInteger lumen;

@end

NS_ASSUME_NONNULL_END
