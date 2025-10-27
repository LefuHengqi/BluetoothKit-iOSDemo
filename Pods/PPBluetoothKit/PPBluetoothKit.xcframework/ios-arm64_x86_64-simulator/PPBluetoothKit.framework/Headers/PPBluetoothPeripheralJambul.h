//
//  PPBluetoothPeripheralJambul.h
//  Alamofire
//
//  Created by 杨青山 on 2023/9/15.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import "PPBluetoothAdvDeviceModel.h"
#import "PPBluetoothDefine.h"
#import "PPBluetoothInterface.h"
#import "PPTorreSettingModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface PPBluetoothPeripheralJambul : NSObject

@property (nonatomic, weak) id<PPBluetoothUpdateStateDelegate> updateStateDelegate;

@property (nonatomic, weak) id<PPBluetoothScaleDataDelegate> scaleDataDelegate;

- (void)receivedDeviceData;

- (void)stopSearch;

- (instancetype)initWithDevice:(PPBluetoothAdvDeviceModel *)device;

//发送双向广播
-(void)sendCBPeripheralDataCurrentUnit:(PPDeviceUnit)unit scaleType:(NSString *)scaleType settingModel:(PPTorreSettingModel *)settingModel;
@end

NS_ASSUME_NONNULL_END
