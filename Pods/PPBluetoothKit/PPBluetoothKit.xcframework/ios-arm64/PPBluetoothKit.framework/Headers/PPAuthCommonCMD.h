//
//  AKBluetoothCMDAnker.h
//  AnkerBluetoothKit
//
//  Created by lefu on 2023/9/6.
//

#import <Foundation/Foundation.h>



@interface PPAuthCommonCMD : NSObject


+ (NSString *)subPackageWithStr:(NSString *)ss andFinalStr:(NSString *)logStr;



+ (NSArray<NSData *> *)sendAuthDataWithMac:(NSString *)secrectKey uuid:(NSString *)uuidStr CMD:(Byte)cmd;

+ (NSString *)authAckWithData:(NSData *)data mac:(NSString *)mac;


+ (NSData *)Md5Data:(NSString *)input;

+ (NSArray<NSData *> *)getPackagesWithCMD:(Byte)cmd data:(NSData*)data;


@end


