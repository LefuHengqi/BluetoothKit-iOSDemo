//
//  PPBluetoothPeripheralMorre.h
//  PPBluetoothKit
//
//  Created by 彭思远 on 2023/4/10.
//

#import <Foundation/Foundation.h>
#import "PPBluetoothDefine.h"
#import <CoreBluetooth/CoreBluetooth.h>
#import "PPBluetoothAdvDeviceModel.h"
#import "PPBluetooth180ADeviceModel.h"
#import "PPBluetoothInterface.h"
#import "PPTorreDFUPackageModel.h"
#import "PPTorreDFUDataModel.h"
#import "PPWifiInfoModel.h"
#import <PPBaseKit/PPBaseKit.h>


NS_ASSUME_NONNULL_BEGIN

@interface PPBluetoothPeripheralMorre : NSObject

@property (nonatomic, weak) id<PPBluetoothServiceDelegate> serviceDelegate;

@property (nonatomic, weak) id<PPBluetoothCoffeeScaleDataDelegate> scaleDataDelegate;


@property (nonatomic, strong) CBPeripheral *peripheral;

@property (nonatomic, strong) PPBluetoothAdvDeviceModel *deviceAdv;

@property (nonatomic, strong) PPBatteryInfoModel *batteryInfo;

- (instancetype)initWithPeripheral:(CBPeripheral *)peripheral  andDevice:(PPBluetoothAdvDeviceModel *)device;

- (void)discoverDeviceInfoService:(void(^)(PPBluetooth180ADeviceModel *deviceModel))deviceInfoResponseHandler;

- (void)discoverFFF0Service;


#pragma mark - code

/// 保活指令 - 推荐首次连接成功后每10秒调用一次，可以保证设备不会主动断开连接
- (void)sendKeepAliveCode;


/// 更新MTU - 推荐在设备连接成功后调用，更大的MTU可以加快与设备的指令交互速度。默认为20
/// - Parameter handler: 0设置成功 1设置失败
- (void)codeUpdateMTU:(void(^)(NSInteger status))handler;


/// 同步设备时间（默认 24 小时制）
/// - Parameter handler: 0设置成功 1设置失败
- (void)codeSyncTime:(void(^)(NSInteger status))handler;

/// 同步设备时间，支持设备时间格式（12/24小时制）
/// - Parameter handler: 0设置成功 1设置失败
- (void)codeSyncTimeWithTimeFormat:(PPTimeFormat)timeFormat handler:(void(^)(NSInteger status))handler;

/// 获取设备单位
/// - Parameter handler:
/// 0x00：kg
/// 0x01：lb
/// 0x02：斤
/// 0x03：st
/// 0x04：st:lb
/// 0x05：g
/// 0x06：lb:oz
/// 0x07：oz
/// 0x08：ml[water]
/// 0x09：ml[milk]
/// 0x0A：fl'oz[water]
/// 0x0B：fl'oz[milk]
- (void)codeFetchUnit:(void(^)(NSInteger status))handler;


/// 修改设备单位
/// - Parameters:
///   - unit: 单位
///   - handler:
///   0x00：设置成功
///   0x01：设置失败
- (void)codeChangeUnit:(PPDeviceUnit)currentUnit withHandler:(void(^)(NSInteger status))handler;


/// 通过WIFI进行OTA - 调用此方法前请确保设备已经配网
/// - Parameter handler:
///        0x00-成功
///        0x01-设备已在升级中不能再次启动升级
///        0x02-设备低电量无法启动升级
- (void)codeOtaUpdateWithHandler:(void(^)(NSInteger status))handler;

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



/// 获取设备配网状态
/// - Parameter handler:
///0x00：未配网（设备端恢复出厂或APP解除设备配网后状态）
///0x01：已配网（APP已配网状态）
- (void)codeFetchWifiConfig:(void(^)(NSInteger status))handler;

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


/// 获取 WIFI MAC 地址
/// - Parameter handler:
/// WIFI MAC 地址
/// 举例：MAC 地址：01:02:03:04:05:06
/// 备注：
/// MAC地址为 00:00:00:00:00:00时表明wifi mac获取不到
///
- (void)codeFetchWifiMac:(void(^)(NSString *wifiMac))handler;


/// 获取设备屏幕亮度
/// - Parameter handler: 0-100的数值用来表示屏幕亮度
- (void)codeFetchScreenLuminance:(void(^)(NSInteger status))handler;


/// 设置屏幕亮度
/// - Parameters:
///   - progress: 0-100
///   - handler: 0设置成功 1设置失败
- (void)codeSetScreenLuminance:(NSInteger)progress handler:(void(^)(NSInteger status))handler;



#pragma mark - 日志


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

/// 启动本地升级
///  status 0成功  1失败
- (void)startLocalUpdateWithHandle:(void(^)(NSInteger status))handler;

#pragma mark - 产线 Production line
/// 打开阻抗测试模式（产线使用）
/// - Parameter handler: 0设置成功 1设置失败
- (void)openImpedanceTestMode:(void(^)(NSInteger status))handler;

/// 关闭阻抗测试模式（产线使用）
/// - Parameter handler: 0设置成功 1设置失败
- (void)closeImpedanceTestMode:(void(^)(NSInteger status))handler;

/// 获取阻抗测试模式（产线使用）
/// - Parameter handler: 0打开 1关闭
- (void)fetchImpedanceTestMode:(void(^)(NSInteger status))handler;


/// 获取电量
- (void)fetchDeviceBatteryInfoWithCompletion:(void(^)(PPBatteryInfoModel *batteryInfo))completion;



/// 监听按键反馈
- (void)registerButtonFeedback:(void(^)(PPDeviceButtonType buttonType, PPDeviceButtonState buttonState))callBack;

/// 去皮/清零
///  status: 0-成功，1-失败
- (void)toZeroWithHandler:(void(^)(int status))handler;


- (void)startHandPourMode2Ratio:(CGFloat)ratio handler:(void (^)(NSInteger))handler ;

@end

NS_ASSUME_NONNULL_END

