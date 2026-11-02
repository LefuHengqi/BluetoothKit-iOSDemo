//
//  PPBluetoothHamburgerAnalysis.h
//  Alamofire
//
//  Created by 杨青山 on 2023/9/15.
//

#import <Foundation/Foundation.h>
#import "PPBluetoothScaleBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface PPBluetoothHamburgerAnalysis : NSObject
+ (PPBluetoothScaleBaseModel *)analysis11LengthData:(NSData *)receiveData;
@end

NS_ASSUME_NONNULL_END
