//
//  PPBluetoothAdvDeviceModel.h
//  PPBluetoothKit
//
//  Created by 彭思远 on 2023/4/1.
//

#import <Foundation/Foundation.h>
#import "PPBluetoothDefine.h"

NS_ASSUME_NONNULL_BEGIN

@interface PPBluetoothAdvDeviceModel : NSObject

@property (nonatomic, assign) NSInteger deviceSettingId;
@property (nonatomic, copy) NSString *deviceName;
@property (nonatomic, copy) NSString *deviceMac;
@property (nonatomic, copy) NSString *sign;
@property (nonatomic, assign) PPDeviceConnectType deviceConnectType;
@property (nonatomic, assign) PPDeviceType deviceType;
@property (nonatomic, assign) PPDeviceProtocolType deviceProtocolType;
@property (nonatomic, assign) PPDeviceCalcuteType deviceCalcuteType;
@property (nonatomic, assign) PPDeviceAccuracyType deviceAccuracyType;
@property (nonatomic, assign) PPDevicePowerType devicePowerType;
@property (nonatomic, assign) PPDeviceFuncType deviceFuncType;
@property (nonatomic, copy) NSString *deviceUnitList;
@property (nonatomic, assign) NSInteger devicePower;
@property (nonatomic, assign) NSInteger rssi;
@property (nonatomic, assign)NSInteger macAddressStart;
@property (nonatomic, assign)NSInteger advLength;
@property (nonatomic, copy) NSString *productModel;
@property (nonatomic, assign) PPStandardType standardType;
@property (nonatomic, assign) PPAvatarTypeType avatarType;
@property (nonatomic, assign) NSInteger sdkCode;
@property (nonatomic, assign) BOOL needAuth; // 是否需要鉴权
@property (nonatomic, assign) int httpType; // 0-http,1-https
@property (nonatomic, copy) NSString *customDeviceName; // 自定义名称
@property (nonatomic, copy) NSString *imgUrl; // 设备配置的图片
@property (nonatomic, assign) NSInteger brandId;
@property (nonatomic, strong) NSDictionary *advancedConfig;

@property (nonatomic, assign) PPDevicePeripheralType PeripheralType;


- (void)fillWithAdvertisementData:(NSDictionary<NSString *,id> *)advertisementData andRSSI:(NSNumber *)rssi;

- (NSInteger)getTypeCanvasHeight;
- (NSInteger)getTypeCanvasWidth;
- (NSInteger)getSelectUserOrderCode;
- (NSInteger)getBodyAgeTypeCode;
- (NSInteger)getSupportNicknameCode;
- (NSInteger)getSupportHistoryCode;
- (NSInteger)getHistoricalDaysCode;
- (NSInteger)getHistoricalTypeCode;
- (NSInteger)getSyncTargetCode;
- (NSInteger)getTypeLen;
- (NSInteger)getMaxFoodCount;


+ (PPBluetoothAdvDeviceModel*)filterDeviceTypeAdvModelByCBAdvDataManufacturerData:(NSData *)advData andDeivceName:(NSString *)name RSSI:(NSNumber *)RSSI;

@end

NS_ASSUME_NONNULL_END
