//
//  PPBluetoothCMDDorre.h
//  PPBluetoothKit
//
//  Created by 彭思远 on 2023/4/10.
//

#import <Foundation/Foundation.h>
#import "PPTorreSettingModel.h"
#import "PPBluetoothDefine.h"
#import "PPBluetoothAdvDeviceModel.h"
#import "PPUserBodyData.h"

NS_ASSUME_NONNULL_BEGIN

@interface PPBluetoothCMDDorre : NSObject

@property (nonatomic, assign) NSInteger mtu;

- (NSString *)subPackageWithStr:(NSString *)ss andFinalStr:(NSString *)logStr;

#pragma mark - fff1
- (NSString *)changeUnitCMD:(PPDeviceUnit)unit;

- (NSString *)syncTimeCMD:(PPTimeFormat) timeFormat;


#pragma mark - fff2
- (NSArray *)userInfo:(PPTorreSettingModel *)userModel advDevice:(PPBluetoothAdvDeviceModel *)advDevice;

- (NSArray *)memberByUserId:(NSString *)userId memberId:(NSString *)memberId;

- (NSArray *)memberByUserId:(NSString *)userId;


- (NSArray *)dfuSlice:(NSData *)sourceData size:(NSInteger)size;

+ (NSArray *)subCode:(NSString *)str byMtu:(NSInteger)mtu;

+ (NSArray *)subData:(NSData *)data byMtu:(NSInteger)mtu;


- (NSArray *)bodyData16Days:(NSArray <PPUserBodyData *> *)recentData type:(PPUserBodyDataType)type user:(PPTorreSettingModel *)userModel advDevice:(PPBluetoothAdvDeviceModel *)advDevice count:(int)count;

- (NSString *)convertDeviceUserName:(NSString *)userName;

@end

NS_ASSUME_NONNULL_END
