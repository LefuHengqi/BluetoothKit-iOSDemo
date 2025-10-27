//
//  PPBluetoothCMDDurian.h
//  PPBluetoothKit
//
//  Created by 彭思远 on 2023/4/3.
//

#import <Foundation/Foundation.h>
//#import "PPBluetoothDeviceSettingModel.h"
#import <PPBaseKit/PPBaseKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PPBluetoothCMDDurian : NSObject


+ (NSString *)syncInfoCmdWithSettingModel:(PPBluetoothDeviceSettingModel *)settingModel;

@end

NS_ASSUME_NONNULL_END
