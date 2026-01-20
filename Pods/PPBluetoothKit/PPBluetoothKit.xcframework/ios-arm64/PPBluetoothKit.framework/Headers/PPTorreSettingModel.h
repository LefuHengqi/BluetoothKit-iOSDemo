//
//  PPTorreSettingModel.h
//  PPBluetoothKit
//
//  Created by 彭思远 on 2023/4/10.
//

#import <Foundation/Foundation.h>
//#import "PPBluetoothDeviceSettingModel.h"
#import <PPBaseKit/PPBaseKit.h>


NS_ASSUME_NONNULL_BEGIN

@interface PPUserHistoryData : NSObject

@property (nonatomic, assign) CGFloat weightKg;
@property (nonatomic, assign) double timeStamp;

@end

@interface PPTorreSettingModel : PPBluetoothDeviceSettingModel

@property (nonatomic, copy) NSString *userID;
@property (nonatomic, copy) NSString *memberID;
@property (nonatomic, copy) NSString *userName;
@property (nonatomic, assign) NSInteger deviceHeaderIndex;
@property (nonatomic, assign) NSInteger birthYear;
@property (nonatomic, assign) NSInteger birthMonth;
@property (nonatomic, assign) NSInteger birthDay;

@property (nonatomic, assign) CGFloat targetWeight;
@property (nonatomic, assign) CGFloat idealWeight;

//local pIndex，Borre协议专用
@property (nonatomic, assign) NSInteger PIndex;

@property (nonatomic, assign) NSInteger timeStamp; // 时间戳，该用户最近一次称重时间，亚飞设备用户列表返回

@property (nonatomic, copy) NSArray <PPUserHistoryData *> *recentData;

- (void)deleteMemberUnderAccount:(NSString *)userId;

- (void)userAccount:(NSString *)userId;

- (void)userAccount:(NSString *)userId memberId:(NSString *)memberId;

- (void)touristAccount;

- (void)defaultSettingAccount;
@end

NS_ASSUME_NONNULL_END
