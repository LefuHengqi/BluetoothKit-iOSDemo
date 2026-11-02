//
//  PPBluetoothCMDCoconut.h
//  PPBluetoothKit
//
//  Created by 彭思远 on 2023/4/3.
//

#import <Foundation/Foundation.h>
//#import "PPBluetoothDeviceSettingModel.h"
#import <PPBaseKit/PPBaseKit.h>
#import "PPSyncBodyModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface PPBluetoothCMDCoconut : NSObject

+ (NSString *)syncTimeCMD;

+ (NSString *)syncInfoCmdWithSettingModel:(PPBluetoothDeviceSettingModel *)settingModel;

+ (NSString *)syncBodyData:(PPSyncBodyModel *)model;

@end

NS_ASSUME_NONNULL_END
