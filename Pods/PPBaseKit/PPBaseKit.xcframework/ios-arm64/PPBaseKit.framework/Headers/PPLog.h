//
//  PPLog.h
//  PPScaleSDK
//
//  Created by 彭思远 on 2022/4/27.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 *  自定义Log，可配置开关（用于替换NSLog）
 */
#define PP_Log(format,...) PPCustomLog(__FUNCTION__,__LINE__,format,##__VA_ARGS__)



@interface PPLog : NSObject
@property(nonatomic,strong)NSMutableArray *PP_Log_MessagesArray;

/// 日志回调，设置后，能接收日志回调
/// 设置日志回调后，建议把 setLogEnable 设置为 NO，这样可以关闭控制台的日志输出
@property (nonatomic, copy) void(^logBlock)(NSString *logStr);

+ (instancetype)sharedInstance;

/**
 *  自定义Log
 *  @warning 外部可直接调用 KDS_Log
 *
 *  @param func         方法名
 *  @param lineNumber   行号
 *  @param format       Log内容
 *  @param ...          个数可变的Log参数
 */
void PPCustomLog(const char *func, int lineNumber, NSString *format, ...);


/**
 *  Log 开关输出 (默认打开)
 *  @param flag   YES: 控制台有日志打印 ， NO: 控制台不打印SDK日志
 */
+ (void)setLogEnable:(BOOL)flag;

/**
 *  是否开启了 Log 输出
 *
 *  @return Log 开关状态， YES: 控制台有日志打印 ，  NO: 控制台不打印SDK日志
 */
+ (BOOL)logEnable;


/**
 *  保存文件开关 (默认关闭)
 *
 *  注：如果 logEnable 设置为 NO ，则此功能失效，不会保存文件
 *  
 *  @param flag   YES: 保存日志文件 ， NO: 不保存日志文件
 */
+ (void)setSaveFileEnable:(BOOL)flag;

/**
 *  是否开启了保存日志文件
 *
 *  注：如果 logEnable 设置为 NO ，则此功能失效，不会保存文件
 *
 *  @return YES: 保存日志文件 ， NO: 不保存日志文件
 */
+ (BOOL)saveFileEnable;


+ (BOOL)logMessagesEnable;

+ (void)setLogMessagesEnable:(BOOL)flag;


+ (NSString *)getAppLogUUID;


@end

NS_ASSUME_NONNULL_END
