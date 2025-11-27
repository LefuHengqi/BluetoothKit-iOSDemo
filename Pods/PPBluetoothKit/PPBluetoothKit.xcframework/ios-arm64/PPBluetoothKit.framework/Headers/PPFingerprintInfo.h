//
//  PPFingerprintInfo.h
//  PPBluetoothKit
//
//  Created by lefu on 2025/11/17
//  


#import <Foundation/Foundation.h>


@interface PPFingerprintInfo : NSObject

@property(nonatomic, copy) NSString *memberID; // 成员ID
@property(nonatomic, assign) BOOL hasFingerprint; //是否录入指纹

@end

