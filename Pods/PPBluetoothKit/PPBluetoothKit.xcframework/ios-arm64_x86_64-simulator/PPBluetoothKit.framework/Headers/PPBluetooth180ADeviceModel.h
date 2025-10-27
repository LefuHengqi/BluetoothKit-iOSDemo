//
//  PPBletooth180ADeviceModel.h
//  PPBluetoothKit
//
//  Created by 彭思远 on 2023/4/1.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface PPBluetooth180ADeviceModel : NSObject

@property (nonatomic, copy) NSString *manufacturerName;
@property (nonatomic, copy) NSString *modelNumber;
@property (nonatomic, copy) NSString *serialNumber;
@property (nonatomic, copy) NSString *hardwareRevision;
@property (nonatomic, copy) NSString *softwareRevision;
@property (nonatomic, copy) NSString *firmwareRevision;

@end

NS_ASSUME_NONNULL_END
