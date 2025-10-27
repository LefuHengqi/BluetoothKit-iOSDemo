//
//  PPKorreUserModel.h
//  PPBluetoothKit
//
//  Created by 彭思远 on 2023/4/10.
//

#import <Foundation/Foundation.h>
#import <PPBaseKit/PPBaseKit.h>


NS_ASSUME_NONNULL_BEGIN


@interface PPKorreUserModel : PPBluetoothDeviceSettingModel

@property (nonatomic, copy) NSString *userID;
@property (nonatomic, copy) NSString *memberID;
@property (nonatomic, assign) NSInteger targetIntake;    // 目标摄入量
@property (nonatomic, assign) NSInteger currentIntake;    // 当前摄入量
@property (nonatomic, assign) NSInteger syncCurrentIntake; // 0-维持当前摄入量, 1-设置当前摄入量


- (void)deleteMemberUnderAccount:(NSString *)userId;

- (void)userAccount:(NSString *)userId;

- (void)userAccount:(NSString *)userId memberId:(NSString *)memberId;

- (void)touristAccount;

- (void)defaultSettingAccount;


@end

NS_ASSUME_NONNULL_END
