//
//  PPBluetoothCMDBorre.h
//  PPBluetoothKit
//
//  Created by 彭思远 on 2023/4/10.
//

#import <Foundation/Foundation.h>
#import "PPUserRecentBodyData.h"
#import "PPBluetoothDefine.h"
#import "PPBluetoothAdvDeviceModel.h"
#import "PPTorreSettingModel.h"
#import "PPTargetModel.h"
#import "PPUserBodyData.h"

NS_ASSUME_NONNULL_BEGIN

@interface PPBluetoothCMDBorre : NSObject

@property (nonatomic, assign) NSInteger mtu;

- (NSString *)subPackageWithStr:(NSString *)ss andFinalStr:(NSString *)logStr;

#pragma mark - fff1
- (NSString *)changeUnitCMD:(PPDeviceUnit)unit;

- (NSString *)syncTimeCMD:(PPTimeFormat) timeFormat;


#pragma mark - fff2

- (NSArray *)userInfo608:(PPTorreSettingModel *)userModel device:(PPBluetoothAdvDeviceModel *)deviceAdv;

//- (NSArray *)userInfo:(PPTorreSettingModel *)userModel;

- (NSArray *)memberByUserId:(NSString *)userId memberId:(NSString *)memberId;

- (NSArray *)memberByUserId:(NSString *)userId;


- (NSArray *)dfuSlice:(NSData *)sourceData size:(NSInteger)size;

+ (NSArray *)subCode:(NSString *)str byMtu:(NSInteger)mtu;

+ (NSArray *)subData:(NSData *)data byMtu:(NSInteger)mtu;

- (NSString *)colorModeWithLightEnable:(BOOL)lightEnable lightMode:(NSInteger)lightMode normalColor:(NSString *)normalColor gainColor:(NSString *)gainColor lossColor:(NSString *)lossColor;

- (NSArray *)bodyData7Days:(NSArray <PPUserRecentBodyData *> *)recentData type:(PPUserBodyDataType)type lastRecentBodyData:(PPUserRecentBodyData*)lastBodyData user:(PPTorreSettingModel *)userModel device:(PPBluetoothAdvDeviceModel *)device count:(int)count;

- (NSArray *)targetDataWithUser:(PPTorreSettingModel *)userModel targetList:(NSArray<PPTargetModel *> *)targetList;

- (NSArray *)bodyData7Days:(NSArray <PPUserBodyData *> *)recentData type:(PPUserBodyDataType)type lastWeightData:(PPUserBodyData*)lastWeightData user:(PPTorreSettingModel *)userModel advDevice:(PPBluetoothAdvDeviceModel *)advDevice;

@end

NS_ASSUME_NONNULL_END
