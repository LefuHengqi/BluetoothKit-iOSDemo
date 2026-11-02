//
//  PPBluetoothCMDHamburger.h
//  Alamofire
//
//  Created by 杨青山 on 2023/9/6.
//

#import <Foundation/Foundation.h>
#import "PPBluetooth180ADeviceModel.h"
//#import "PPBluetoothDeviceSettingModel.h"
#import "PPBluetoothAdvDeviceModel.h"
#import <PPBaseKit/PPBaseKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PPBluetoothCMDIce : NSObject

/// 同步设备时间
/// - Parameter device180A:
+ (NSString *)cmdSyncTimeCMD;

/// 配网的命令
/// - Parameters:
///   - ssid: 名字
///   - password: 密码
+ (NSArray *)cmdConfigWifiCMDBySSID:(NSString *)ssid andPassword:(NSString *)password;

/// 修改服务器域名的命令
/// - Parameter dns: 域名
+ (NSArray *)cmdChangeDNS:(NSString *)dns;

/// 写 SN
/// APP通过蓝牙向模组发送0xFA,0x00+数据长度(1byte)+异或校验值(1byte)+SN。
///SN编码规则(共16位)
///SN码 S1 XX LF 8 07 01 00000
///描述 产品型号 产品颜色 生产厂商 生产年份 生产月份 生产批次号 产品流水号
/// - Parameter sn: 该功能尚未联调！！！！！
+ (NSString *)cmdChangeSN:(NSString *)sn;


//下发体脂率
+ (NSString *)cmdWirteBodyFat:(int)bodyFat;

//切换秤端的单位
+ (NSString*)cmdSyncUnit:(PPDeviceUnit)unit;


/// 进入抱婴模式
+ (NSString*)cmdEnterBabyMode;

/// 退出抱婴模式
+ (NSString*)cmdExitBabyMode;

+ (NSString *)subPackageWithStr:(NSString *)ss andFinalStr:(NSString *)logStr;
@end

NS_ASSUME_NONNULL_END
