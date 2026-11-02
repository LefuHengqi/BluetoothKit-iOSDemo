//
//  PPBluetoothPeripheralHamburger.h
//  Alamofire
//
//  Created by 杨青山 on 2023/9/6.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import "PPBluetoothAdvDeviceModel.h"
#import "PPBluetooth180ADeviceModel.h"
#import "PPBluetoothInterface.h"
//#import "PPBluetoothDeviceSettingModel.h"
#import "PPScaleFormatTool.h"
#import "PPBluetoothCMDIce.h"
#import "PPBluetoothPeripheralIce.h"
#import "PPWifiInfoModel.h"
#import "PPBatteryInfoModel.h"
#import <PPBaseKit/PPBaseKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PPBluetoothPeripheralIce : NSObject

@property (nonatomic, weak) id<PPBluetoothServiceDelegate> serviceDelegate;

@property (nonatomic, weak) id<PPBluetoothCMDDataDelegate> cmdDelegate;

@property (nonatomic, weak) id<PPBluetoothScaleDataDelegate> scaleDataDelegate;

@property (nonatomic, strong) CBPeripheral *peripheral;

@property (nonatomic, strong) PPBluetoothAdvDeviceModel *deviceAdv;

@property (nonatomic, strong) PPBatteryInfoModel *batteryInfo;

@property (nonatomic, copy) void(^receiveHandler)(NSData* receiveData);

@property (nonatomic, copy) void(^receiveWifiListHandler)(NSData* receiveData);



- (instancetype)initWithPeripheral:(CBPeripheral *)peripheral  andDevice:(PPBluetoothAdvDeviceModel *)device;

- (void)discoverFFF0Service;

/// 获取电量
- (void)fetchDeviceBatteryInfoWithCompletion:(void(^)(PPBatteryInfoModel *batteryInfo))completion;

/// 获取历史数据
/// - Parameter callBack:
- (void)dataFetchHistoryDataWithHandler:(void(^)(NSArray <PPBluetoothScaleBaseModel *>* history, NSError* error))handler;

/// 删除历史数据
- (void)deleteDeviceHistoryData;

/// 保活指令 - 推荐首次连接成功后每10秒调用一次，可以保证设备不会主动断开连接
- (void)sendKeepAliveCode;

/// 同步设备时间
///  status 0 为成功 1为失败
- (void)syncTime:(void(^)(NSInteger status))handler;

/// 查询设备时间
- (void)queryDeviceTime:(void(^)(NSString* deviceTime))handler;

/// 恢复出厂设置
- (void)restoreFactoryWithHandler:(void(^)(void))handler;

/// 发现180A设备信息服务
- (void)discoverDeviceInfoService:(void(^)(PPBluetooth180ADeviceModel *deviceModel))deviceInfoResponseHandler;

/// 设置设备回显的体脂率
- (void)writeBodyFat:(int)bodyFat;

/// 设置单位
/// status 0 为成功 1为失败
- (void)changeUnit:(PPDeviceUnit)unit withHandler:(void(^)(NSInteger status))handler;

/// 进入婴儿模式
/// status 0 为成功 1为失败
- (void)enterBabyModeWithHandler:(void(^)(NSInteger status))handler;

/// 退出婴儿模式
/// status 0 为成功 1为失败
- (void)exitBabyModeWithHandler:(void(^)(NSInteger status))handler;

/// wifi ota
- (void)otaActionWithReciveHandler:(void(^)(int status))handler;

/// 搜索附近WiFi列表
- (void)dataFindSurroundDevice:(void(^)(NSArray <PPWifiInfoModel *>*devices, int status))handler;

/// 退出搜索WiFi列表
- (void)exitWifiQuery;

/// 设置DNS，即服务器域名
/// - Parameters:
///   - dns: 域名
///   - handler:
- (void)changeDNS:(NSString *)dns withReciveDataHandler:(void(^)(BOOL isSuccess))handler;

/// 修改设备SN
- (void)changeSN:(NSString*)sn withReciveHandler:(void(^)(BOOL isSuccess))handler;

/// 配网
/// - Parameters:
///   - model: name 和 pwd
///   - handler:
- (void)configNetWork:(PPWifiInfoModel *)model withHandler:(void(^)(BOOL isSuccess, NSString *sn, PPBluetoothAppleWifiConfigState configState))handler;

/// 配网
/// 此方法即将过期，使用 - (void)configNetWork:(PPWifiInfoModel *)model withHandler:(void(^)(BOOL isSuccess, NSString *sn, PPBluetoothAppleWifiConfigState configState))handler 代替
/// - Parameters:
///   - model: name 和 pwd
///   - handler:
- (void)dataConfigNetWork:(PPWifiInfoModel *)model withHandler:(void(^)(BOOL isSuccess, NSString *sn))handler API_DEPRECATED("Use - (void)configNetWork:(PPWifiInfoModel *)model withHandler:(void(^)(BOOL isSuccess, NSString *sn, PPBluetoothAppleWifiConfigState configState))handler instead", ios(1.0, API_TO_BE_DEPRECATED), visionos(1.0, API_TO_BE_DEPRECATED));

/// 退出配网
- (void)exitWifiConfig;

/// 删除wifi参数
/// - Parameter handler:
- (void)deleteWifiConfigWithHandler:(void(^)(BOOL isSuccess))handler;

/// 查询wifi参数
/// - Parameter handler:
- (void)queryWifiConfigWithHandler:(void (^)(PPWifiInfoModel * _Nullable model))handler;

/// 获取心率开关阻抗开关状态
///安全模式 0-失效，支持测脂。1-使能 不支持测脂
///心率禁用 0-失效 支持心率测试 1-使能 不支持心率测试
- (void)fetchHeartRateSwitchAndImpedanceSwitchState:(void(^)(NSInteger heartRateStatu, NSInteger impedanceStatu))handler;

/// 打开心率测量
/// - Parameter handler: 0设置成功 1设置失败
- (void)openHeartRateSwitch:(void(^)(NSInteger status))handler;

/// 关闭心率测量
/// - Parameter handler:  0设置成功 1设置失败
- (void)closeHeartRateSwitch:(void(^)(NSInteger status))handler;

/// 打开阻抗测量
/// - Parameter handler: 0设置成功 1设置失败
- (void)openImpedanceSwitch:(void(^)(NSInteger status))handler;

/// 关闭阻抗测量
/// - Parameter handler:  0设置成功 1设置失败
- (void)closeImpedanceSwitch:(void(^)(NSInteger status))handler;


/// 获取设备中日志
/// - Parameter filePath: 设备日志文件路径，该日志文件保存在沙盒中，如果文件保存到自己服务器后可以按此路径删除该文件
/// - Parameter progress 获取设备日志的进度
/// - Parameter isFailed  是否失败
- (void)dataSyncLog:(void(^)(CGFloat progress, NSString *filePath, BOOL isFailed))handler;

/// 获取设备中日志
/// - Parameter folderPath 需要存放设备日志的文件夹路径，如:  沙盒路径//Log/DeviceLog
///  handler
/// - Parameter filePath: 设备日志文件路径，该日志文件保存在 folderPath 路径下
/// - Parameter progress 获取设备日志的进度
/// - Parameter isFailed  是否失败
- (void)dataSyncLogWithLogFolder:(NSString *)folderPath handler:(void(^)(CGFloat progress, NSString *filePath, BOOL isFailed))handler;

- (void)openDFUServices;

@end

NS_ASSUME_NONNULL_END
