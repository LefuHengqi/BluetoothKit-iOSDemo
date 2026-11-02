//
//  PPBluetoothPrivacyManager.h
//  PPBluetoothKit
//
//  Created by  lefu on 2023/10/27.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface PPBluetoothPrivacyManager : NSObject

@property(nonatomic,strong) NSArray *deviceJsonArray;


+ (instancetype)sharedInstance;


@end

NS_ASSUME_NONNULL_END
