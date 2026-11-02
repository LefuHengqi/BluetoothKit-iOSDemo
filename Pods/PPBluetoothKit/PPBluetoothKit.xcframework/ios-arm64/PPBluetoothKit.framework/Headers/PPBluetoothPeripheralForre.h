//
//  PPBluetoothPeripheralForre.h
//  PPBluetoothKit
//
//  Created by 彭思远 on 2023/4/10.
//

#import <Foundation/Foundation.h>
#import "PPBluetoothDefine.h"
#import "PPTorreSettingModel.h"
#import <CoreBluetooth/CoreBluetooth.h>
#import "PPBluetoothAdvDeviceModel.h"
#import "PPBluetooth180ADeviceModel.h"
#import "PPBluetoothInterface.h"
#import "PPTorreDFUPackageModel.h"
#import "PPTorreDFUDataModel.h"
#import "PPWifiInfoModel.h"
#import <PPBaseKit/PPBaseKit.h>


NS_ASSUME_NONNULL_BEGIN

@interface PPBluetoothPeripheralForre : NSObject

@property (nonatomic, weak) id<PPBluetoothServiceDelegate> serviceDelegate;

@property (nonatomic, weak) id<PPBluetoothScaleDataDelegate> scaleDataDelegate;

@property (nonatomic, strong) CBPeripheral *peripheral;

@property (nonatomic, strong) PPBluetoothAdvDeviceModel *deviceAdv;

@property (nonatomic, strong) PPBatteryInfoModel *batteryInfo;

- (instancetype)initWithPeripheral:(CBPeripheral *)peripheral  andDevice:(PPBluetoothAdvDeviceModel *)device;

- (void)discoverDeviceInfoService:(void(^)(PPBluetooth180ADeviceModel *deviceModel))deviceInfoResponseHandler;

- (void)discoverFFF0Service;


#pragma mark - code

/// 开启抱婴模式
/// - Parameters:
///   - step: 0/1 标识第几次上称
///   - weight: 上次上称时候的重量，step为0时传0
///   - handler: 0设置成功 1设置失败
- (void)codeEnableBabyModel:(NSInteger)step weight:(NSInteger)weight withHandler:(void(^)(NSInteger status))handler;

/// 退出抱婴模式
/// - Parameter handler: 0设置成功 1设置失败
- (void)codeExitBabyModel:(void(^)(NSInteger status))handler;


/// 保活指令 - 推荐首次连接成功后每10秒调用一次，可以保证设备不会主动断开连接
- (void)sendKeepAliveCode;


/// 开始测量 - 下发此指令后设备才会上报称重情况
/// - Parameter handler: 0设置成功 1设置失败
- (void)codeStartMeasure:(void(^)(NSInteger status))handler;

/// 停止测量
/// - Parameter handler: 0设置成功 1设置失败
- (void)codeStopMeasure:(void(^)(NSInteger status))handler;


/// 更新MTU - 推荐在设备连接成功后调用，更大的MTU可以加快与设备的指令交互速度。默认为20
/// - Parameter handler: 0设置成功 1设置失败
- (void)codeUpdateMTU:(void(^)(NSInteger status))handler;


/// 同步设备时间，支持设备时间格式（12/24小时制）
/// - Parameter handler: 0设置成功 1设置失败
- (void)codeSyncTimeWithTimeFormat:(PPTimeFormat)timeFormat handler:(void(^)(NSInteger status))handler;

/// 获取设备单位
/// - Parameter handler:
/// 0x00：单位kg
/// 0x01：单位lb
/// 0x02：单位斤
/// 0x03：单位st
/// 0x04：单位st:lb
- (void)codeFetchUnit:(void(^)(NSInteger status))handler;


/// 修改设备单位
/// - Parameters:
///   - unit: 单位
///   - handler:
///   0x00：设置成功
///   0x01：设置失败
- (void)codeChangeUnit:(PPDeviceUnit)unit withHandler:(void(^)(NSInteger status))handler;


/// 清除设备数据
/// - Parameters:
///   - cmd:
///         0x00：清除所有设备数据(用户信息、历史数据、配网数据、设置信息)
///         0x01：清除用户信息
///         0x02：清除历史数据
///         0x03：清除配网状态
///         0x04：清除设置信息
///   - handler:
///        0x00-成功
///        0x01-失败
- (void)codeClearDeviceData:(NSInteger)cmd withHandler:(void(^)(NSInteger status))handler;


/// 设置设备绑定状态
/// - Parameter handler:  0设置成功 1设置失败
- (void)codeSetBindingState:(void(^)(NSInteger status))handler;

/// 设置设备未绑定状态
/// - Parameter handler:  0设置成功 1设置失败
- (void)codeSetUnbindingState:(void(^)(NSInteger status))handler;

/// 获取设备绑定状态
/// - Parameter handler:
///0x00：设备未绑定
///0x01：设备已绑定
- (void)codeFetchBindingState:(void(^)(NSInteger status))handler;

- (void)codeFetchWifiConfig:(void(^)(NSInteger status))handler;

#pragma mark - 配网相关


/// 发现周围的可连接热点
/// - Parameter handler: 结果 - 一个数组对象包含了热点名称和强度
- (void)dataFindSurroundDevice:(void(^)(NSArray <PPWifiInfoModel *>*devices))handler;


/// 配置热点
/// - Parameters:
///   - model: 包含用于连接热点的信息
///   - handler: state 配网过程中的状态 errorCode 错误码
- (void)dataConfigNetWork:(PPWifiInfoModel *)model domain:(NSString *)domain withHandler:(void(^)(PPWIFIConfigState state,  NSData *_Nullable errorCode))handler;


/// 退出配网模式
/// - Parameter handler: 0设置成功 1设置失败
- (void)dataExitWifiConfig:(void(^)(NSInteger status))handler;


/// 获取设备当前配置热点的ssid
/// - Parameter handler: ssid名称
- (void)dataFetchConfigNetworkSSID:(void(^)(NSString *ssid))handler;

/// 获取 WIFI MAC 地址
/// - Parameter handler:
/// WIFI MAC 地址
/// 举例：MAC 地址：01:02:03:04:05:06
/// 备注：
/// MAC地址为 00:00:00:00:00:00时表明wifi mac获取不到
///
- (void)codeFetchWifiMac:(void(^)(NSString *wifiMac))handler;

#pragma mark - 日志


/// 获取设备中日志
/// - Parameter filePath: 设备日志文件路径，该日志文件保存在沙盒中，如果文件保存到自己服务器后可以按此路径删除该文件
/// - Parameter progress 获取设备日志的进度
/// - Parameter isFailed  是否失败
- (void)dataSyncLog:(void(^)(CGFloat progress, NSString *filePath, BOOL isFailed))handler;


#pragma mark - DFU


/// DFU升级开始
/// - Parameter handler: 切片大小
- (void)dataDFUStart:(void(^)(NSInteger size))handler;


/// 获取DFU状态
/// - Parameter handler: handler description
/// transferContinueStatus
///断点续传状态
///0-从上次的断点开始传输
///1-从头开始传输
///fileType
///上次断点DFU文件类型
///当断点续传状态等于0时此状态生效
///version
///上次断点DFU文件版本号-ANSSI码
///当断点续传状态等于0时此状态生效
///offset
///上次断点DFU文件已升级大小-文件OFFSET,APP根据此偏移继续下发升级数据，实现断点续传状态
///当断点续传状态等于0时此状态生效

- (void)dataDFUCheck:(void(^)(NSInteger transferContinueStatus, NSInteger fileType, NSString *version, NSInteger offset))handler;


/// DFU文件发送
/// - Parameters:
///   - packageModel: 包含DFU文件内容的对象
///   - size: 切片大小
///   - transferContinueStatus: 断点续传状态
///   - version: 当前DFU文件的云端版本号
///   - handler: 成功回调
- (void)dataDFUSend:(PPTorreDFUPackageModel *)packageModel
      maxPacketSize:(NSInteger)maxPacketSize
transferContinueStatus:(NSInteger)transferContinueStatus
      deviceVersion:(NSString *)version
            handler:(void(^)(CGFloat progress, BOOL isSuccess))handler;

/// 获取心率开关状态
/// - Parameter handler: 0心率测量打开 1心率测量关闭
- (void)codeFetchHeartRateSwitch:(void(^)(NSInteger status))handler;

/// 打开心率测量
/// - Parameter handler: 0设置成功 1设置失败
- (void)codeOpenHeartRateSwitch:(void(^)(NSInteger status))handler;

/// 关闭心率测量
/// - Parameter handler:  0设置成功 1设置失败
- (void)codeCloseHeartRateSwitch:(void(^)(NSInteger status))handler;

/// 获取阻抗开关状态
/// - Parameter handler: 0心率测量打开 1心率测量关闭
- (void)codeFetchImpedanceSwitch:(void(^)(NSInteger status))handler;

/// 打开阻抗测量
/// - Parameter handler: 0设置成功 1设置失败
- (void)codeOpenImpedanceSwitch:(void(^)(NSInteger status))handler;

/// 关闭阻抗测量
/// - Parameter handler:  0设置成功 1设置失败
- (void)codeCloseImpedanceSwitch:(void(^)(NSInteger status))handler;


/// 通过WIFI进行OTA - 调用此方法前请确保设备已经配网
/// - Parameter handler:
///        0x00-成功
///        0x01-设备已在升级中不能再次启动升级
///        0x02-设备低电量无法启动升级
- (void)codeOtaUpdateWithHandler:(void(^)(NSInteger status))handler;



/// 获取电量
- (void)fetchDeviceBatteryInfoWithCompletion:(void(^)(PPBatteryInfoModel *batteryInfo))completion;

@end

NS_ASSUME_NONNULL_END
